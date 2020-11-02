/**
 *  @description Controller for UserVerification page, communicates with TransUnion via SOAP calls to generate questions for user verification
 *  @author      Jeremy Horan, Traction on Demand.
 *  @date        2015-12-21
 */
public with sharing class trac_UserVerificationController {
 /*   private TransUnionWS.ProcessResponse_element response;
    private String sessionId;
    private String externalId;
    public Application__c application {get;set;}

    public Application_Form_Settings__c AppFormSettings {get;set;}
    public List<QuestionWrapper> questions { get;set; }
    public String maidenName { get;set; }
    public Boolean firstQuestions { get;set; }
    public Boolean emailAuthError { get; set;}
    
    //BR 8.1: If customer is authenticated once, prevent the customer to attempt another authentication     
    public Boolean alreadyAuthenticated { get; set;}
            
    public String decision;    
    public String FAILED;
    public String PASSED;
    public String INCOMPLETE;
    
    private final String AUTH_COMPLETE_URL = '/apex/AuthComplete';
    private final String ERROR_PAGE_URL = '/apex/UserVerificationError';
    private final String DECISION_PARAM_ERROR = 'Error';
    
    public Long AnswerStartTimeMilli {get;set;}
    public Long AnswerEndTimeMilli {get;set;}
    
    private String AUTH_CHOICE_COMPLETED = 'Completed';
    private String AUTH_RESULT_PASSED = 'Passed';
    
    //Email Authentication updates - PassedNoFraud
    private String AUTH_RESULT_PASSED_NO_FRAUD = 'PassedNoFraud';
      
    
     // @description Wrapper class to hold questions and answers for TransUnion Authentication
     // @author      Jeremy Horan, Traction on Demand.
     //  @date        2015-12-23
     
    public class QuestionWrapper {
        public List<SelectOption> choices { get;set; }
        public String text { get;set; }
        public String answer { get;set; }
        public TransUnionIdAuthElements.Question question;
        public Decimal PercentOfTotalTimePermitted {get;set;}
        public Decimal TimePermitted {get{
            return Decimal.valueOf(question.TimePermitted);
        }}

        QuestionWrapper(TransUnionIdAuthElements.Question question) {
            this.question = question;
            choices = new List<SelectOption>();
            for (TransUnionIdAuthElements.Choice choice : question.Choice) {
                choices.add(new SelectOption(choice.Text, choice.Text));
            }
            text = question.Text;
        }       
    }
    
    public class ErrorMessageWrapper {
       
        public String errorMessage; 
        public String authenticationChoice;
                
        ErrorMessageWrapper(String errorMessage, String authenticationChoice) {
            this.errorMessage = errorMessage;
            this.authenticationChoice = authenticationChoice;
        }       
    }

    public trac_UserVerificationController() {
        String applicationId = ApexPages.currentPage().getParameters().get('id');
        AppFormSettings = Application_Form_Settings__c.getOrgDefaults();
        
        emailAuthError = false;
        alreadyAuthenticated = false;
        
        if (applicationId != null) {
            application = getApplicationById(applicationId);
        } else {
            String emailToken = ApexPages.currentPage().getParameters().get('et');
            
            if (emailToken != null) {
                application = getApplicationByEmailToken(emailToken);
            
                if (application != null) {
                    
                    // Check if email expired
                    if (Datetime.now() > application.Email_Authentication_Expiration_Date__c) {
                        // Expired (handle error case)
                        emailAuthError = true;
                    }
                    //BR 8.1: If customer is authenticated once, prevent the customer to attempt another authentication 
                    //Email Authentication updates - PassedNoFraud    
                    else if(application.Authentication_Choice__c == AUTH_CHOICE_COMPLETED || application.Authentication_Result__c == AUTH_RESULT_PASSED || application.Authentication_Result__c == AUTH_RESULT_PASSED_NO_FRAUD){
                        // Already Authenticated
                        alreadyAuthenticated = true;
                    }
                } else {
                    // Email token not recognized
                    emailAuthError = true;
                }
                
            } else {
                // Email token not recognized
                emailAuthError = true;
            }       
        }
    
        if (emailAuthError == false && alreadyAuthenticated == false) {
            firstQuestions = true;
            //fraud = application.Fraud_Alert__c == 'TRUE';
            //loanType = application.Loan_Type__c;
    
            FAILED = 'Failed';
            PASSED = 'Passed';
            INCOMPLETE = 'Incomplete';
    
        }
    }
        
    public PageReference sendAuthRequest() {
      
        if (emailAuthError == true || alreadyAuthenticated == true) {
            return null;
        }
        
        
        response = TransUnionWSUtil.sendAuthenticationRequest(application.Id);
        if (response == null) {
            return redirectToErrorPage(new ErrorMessageWrapper(TransUnionWSUtil.ERROR_MESSAGE_TECHNICAL_ISSUE, TransUnionWSUtil.AUTH_CHOICE_TECHNICAL_ISSUE));            
        }
        
        //Error message changes
        //Updated by A5E Consulting
        else{
          if (response.oIDAuthentication.Reply.Error != null) {
                return redirectToErrorPage(getErrorMessageFromTUResponse(response));                
            }
        }

        sessionId = response.oIDAuthentication.Reply.SessionId;
        externalId = response.oIDAuthentication.Reply.ExternalId;
        questions = setupQuestionWrapper(response.oIDAuthentication.Reply.Question);
        
        // Javascript on the page will overwrite this value, but we set it here as something
        // to fall back on just in case
        AnswerStartTimeMilli = DateTime.now().getTime();
        return null;
    }
    
    
     // @description SOAP call and data handling to send answers to TransUnion and get a response
     // @author      Jeremy Horan, Traction on Demand.
     //  @date        2015-12-23
     
    public PageReference sendAnswersRequest() {
        if (AnswerEndTimeMilli == null) {
            AnswerEndTimeMilli = DateTime.now().getTime();
        }
        TransUnionWS.ProcessResponse_element answerResponse;
        List<TransUnionIdAuthElements.Answer> answers = new List<TransUnionIdAuthElements.Answer>();

        if (questions != null) {
            Integer totalAnswerTimeSec = Integer.valueOf((AnswerEndTimeMilli - AnswerStartTimeMilli) / 1000);
            System.debug('totalAnswerTimeSec: ' + totalAnswerTimeSec);
            for (QuestionWrapper questionWrapper : questions) {
                TransUnionIdAuthElements.Answer answer = new TransUnionIdAuthElements.Answer();
                answer.QuestionId = questionWrapper.question.QuestionId;
                answer.Response = questionWrapper.answer;
                answer.ActualTime = String.valueOf(Integer.valueOf(totalAnswerTimeSec*questionWrapper.PercentOfTotalTimePermitted));
                System.debug(answer.ActualTime);
                answers.add(answer);
            }
        }
        
        if (answers.size() > 0) {
            answerResponse = TransUnionWSUtil.sendAnswersRequest(application, externalId, sessionId, answers);
        }

      
        
        //Error message changes
        //Updated by A5E Consulting
        if (answerResponse == null) {
            return redirectToErrorPage(new ErrorMessageWrapper(TransUnionWSUtil.ERROR_MESSAGE_TECHNICAL_ISSUE, TransUnionWSUtil.AUTH_CHOICE_TECHNICAL_ISSUE));
        }
        
        else{
            if (answerResponse.oIDAuthentication.Reply.Error != null) {
                return redirectToErrorPage(getErrorMessageFromTUResponse(answerResponse));
            }  
        }
        
        if (answerResponse.oIDAuthentication.Reply.Question != null) {
            questions = setupQuestionWrapper(answerResponse.oIDAuthentication.Reply.Question);
        } else if (answerResponse.oIDAuthentication.Reply.Confidence != null) {
            decision = answerResponse.oIDAuthentication.Reply.Confidence.Decision;
            if (application != null) {              
                // Map TransUnion decision over to our values
                if (decision == 'PASS') {
                    decision = PASSED;
                    application.Mothers_Maiden_Name__c = maidenName;
                    
                    //Email Authentication updates - PassedNoFraud
                    if (application.Fraud_Alert__c == 'True-N/A'){
                        decision = AUTH_RESULT_PASSED_NO_FRAUD;
                    }
                } else {
                    decision = FAILED;
                }
                
                application.Authentication_Result__c = decision;
                application.Authentication_Choice__c = 'Completed';
                
                //Automatic vs Manual Processed On Application Records
                if(String.isNotBlank(application.Initial_Decision__c) && 
                    String.isNotBlank(application.Initial_Application_Status__c) &&
                    String.isNotBlank(application.Application_Completed_From__c) && 
                    String.isNotBlank(application.Authentication_Result__c) &&
                    String.isNotBlank(application.Authentication_Choice__c) && 
                    (application.Initial_Decision__c.equalsIgnoreCase('Approved')) && 
                    (!application.Initial_Application_Status__c.equalsIgnoreCase('Manager Approval')) &&
                    application.Application_Completed_From__c.equalsIgnoreCase('External') &&
                    application.Authentication_Result__c.equalsIgnoreCase('Passed') &&
                    application.Authentication_Choice__c.equalsIgnoreCase('Completed') &&
                    String.isBlank(application.Email_Authentication_Status__c) &&
                    application.Email_Authentication_Sent_Date__c == null &&
                    ((application.Fraud_Alert__c == null) || (!application.Fraud_Alert__c.equalsIgnoreCase('TRUE'))) && 
                    Utilities.getUserProfile().equalsIgnoreCase('UserVerification Profile')){
                        application.Auto_Processed__c = true;
                }
                
                
                ApplicationTriggerHandler.runApplicationLoadTrigger = false;
                update application;
                ApplicationTriggerHandler.runApplicationLoadTrigger = true;

                Note answerResponseNote = new Note(
                    ParentId = application.Id, 
                    Title = 'Trans Union Answer Response',
                    Body = answerResponse.toString()
                );
                insert answerResponseNote;
                
                // Redirect to another page to do change queue
                // Note: work-around to avoid DML update then call-out exception
                PageReference pageRef = new PageReference(AUTH_COMPLETE_URL);
                pageRef.getParameters().put('id',application.Id);
                pageRef.setRedirect(true);
                return pageRef;
            }
        } else {
            return redirectToErrorPage(new ErrorMessageWrapper(TransUnionWSUtil.ERROR_MESSAGE_TECHNICAL_ISSUE, TransUnionWSUtil.AUTH_CHOICE_TECHNICAL_ISSUE));
        }

        firstQuestions = false;

        return null;
    }
    
    
     // @description Get wrapper objects for questions and answers from a list of questions
     // @author      Jeremy Horan, Traction on Demand.
     //  @date        2015-12-23
     
    private List<QuestionWrapper> setupQuestionWrapper(List<TransUnionIdAuthElements.Question> questionList) {
        Decimal totalTimePermitted = 0;
        List<QuestionWrapper> questionWrappers = new List<QuestionWrapper>();
        for (TransUnionIdAuthElements.Question question : questionList) {
            QuestionWrapper qw = new QuestionWrapper(question);
            questionWrappers.add(qw);

            totalTimePermitted += qw.TimePermitted;
        }

        for (QuestionWrapper qw : questionWrappers) {
            Integer timePermitted = Integer.valueOf(qw.question.TimePermitted);
            qw.PercentOfTotalTimePermitted = timePermitted / totalTimePermitted;
        }
        return questionWrappers;
    }
    
    //Error message changes
    //Updated by A5E Consulting
    public PageReference redirectToErrorPage(ErrorMessageWrapper errMsgWrapper) {
        System.debug('redirectToErrorPage errMsgWrapper :'+errMsgWrapper);
        System.debug('redirectToErrorPage errMsgWrapper authenticationChoice :'+errMsgWrapper.authenticationChoice);
        System.debug('redirectToErrorPage errMsgWrapper errorMessage :'+errMsgWrapper.errorMessage);
        try {
            application.Authentication_Result__c = INCOMPLETE;
            //application.Authentication_Choice__c = 'Error';
            application.Authentication_Choice__c = errMsgWrapper.authenticationChoice;
            
            ApplicationTriggerHandler.runApplicationLoadTrigger = false;
            update application;
            ApplicationTriggerHandler.runApplicationLoadTrigger = true;
            
        } catch (DmlException e) {

        }

        PageReference pageRef = new PageReference(ERROR_PAGE_URL);
        pageRef.getParameters().put('id',application.Id);
        
        if(!String.isBlank(errMsgWrapper.errorMessage)){
          pageRef.getParameters().put('errorMessage',errMsgWrapper.errorMessage);
        }
        
        pageRef.setRedirect(true);
        return pageRef;
    }

    
     // @description Gets Application with given Id if exists
     // @author      Jeremy Horan, Traction on Demand.
     //  @date        2015-12-30
     
    private Application__c getApplicationById(Id applicationId) {
        List<Application__c> applications = [SELECT Id, Mothers_Maiden_Name__c, Fraud_Alert__c, Loan_Type__c, Authentication_Choice__c, Authentication_Result__c, Initial_Decision__c, Initial_Application_Status__c,  Application_Completed_From__c, Email_Authentication_Status__c, Email_Authentication_Sent_Date__c FROM Application__c WHERE Id =: applicationId];
    
        return (applications.size() > 0) ? applications[0] : null;
    }
    
    
     // @description Gets Application with given email token if exists
     // @author      Ahsan Butt, Traction on Demand.
     //  @date        2016-01-10
     
    private Application__c getApplicationByEmailToken(String et) {
        List<Application__c> applications = [SELECT Id, Email_Authentication_Expiration_Date__c, Mothers_Maiden_Name__c, Fraud_Alert__c, Loan_Type__c, Authentication_Choice__c, Authentication_Result__c FROM Application__c WHERE Email_Auth_Token__c =: et];
    
        return (applications.size() > 0) ? applications[0] : null;
    }
    
    //Error message changes
    //Added by A5E Consulting
    //Returns Error Message and AUthentication Choice based on Transunion Response
    private static ErrorMessageWrapper getErrorMessageFromTUResponse(TransUnionWS.ProcessResponse_element tuResponse){
        
        Boolean erorCode20000 = false;
        Boolean erorCode20002 = false;
        Boolean erorCode20003 = false;
        Boolean erorCode20006 = false;
                        
        for (TransUnionIdAuthElements.Error err : tuResponse.oIDAuthentication.Reply.Error) {
            
            if(err.Code == '20000'){
              erorCode20000 = true;
            }
            
            else if(err.Code == '20002'){
              erorCode20002 = true;
            }
            
            else if(err.Code == '20003'){
              erorCode20003 = true;
            }
            
            else if(err.Code == '20006'){
              erorCode20006 = true;
            }  
        }
        
        String errorMessage;
        String authenticationChoice;
        if(erorCode20003 == true && erorCode20006 == true){
          errorMessage = TransUnionWSUtil.ERROR_MESSAGE_NO_BUREAU_HIT;
          authenticationChoice = TransUnionWSUtil.AUTH_CHOICE_NO_BUREAU_HIT;
        }   
        else if(erorCode20003 == true && erorCode20006 == false){
          errorMessage = TransUnionWSUtil.ERROR_MESSAGE_THIN_BUREAU_HIT;
          authenticationChoice = TransUnionWSUtil.AUTH_CHOICE_THIN_BUREAU_HIT;
        } 
        else if(erorCode20002 == true){
          errorMessage = TransUnionWSUtil.ERROR_MESSAGE_TOO_MANY_ATTEMPTS;
          authenticationChoice = TransUnionWSUtil.AUTH_CHOICE_TOO_MANY_ATTEMPTS;
        }
        else if(erorCode20000 == true){
          errorMessage = TransUnionWSUtil.ERROR_MESSAGE_SUBMITTED_EXAM_AGAIN;
          authenticationChoice = TransUnionWSUtil.AUTH_CHOICE_SUBMITTED_EXAM_AGAIN;
        }
        
        return (new ErrorMessageWrapper(errorMessage, authenticationChoice));      
    }*/
    
}