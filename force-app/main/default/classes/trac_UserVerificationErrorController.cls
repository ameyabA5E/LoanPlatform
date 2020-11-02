public with sharing class trac_UserVerificationErrorController {
    //To do remove comment
  /*  public Application__c App {get;set;}
    public Application_Form_Settings__c AppFormSettings {get;set;}
  
    //Error message changes
    //Added by A5E Consulting
    public String noBureauHit {get;set;}
    public String thinBureauHit {get;set;}
    public String toManyAttempts {get;set;}
    public String submittedExamAgain {get;set;}
    public String technicalIssue {get;set;}
    public String errorMessage {get;set;}
        
    public trac_UserVerificationErrorController() {
        
        AppFormSettings = Application_Form_Settings__c.getOrgDefaults();
        String applicationId = ApexPages.currentPage().getParameters().get('id');
        
        // Updated By A5E Consulting PVT LTD
        // Appilcation Workflow and Data Sync
         
        App = Utilities.getApplicationById(applicationId);
        // App = getApplicationById(applicationId);
        
        System.debug('trac_UserVerificationErrorController applicationId :'+applicationId);
            
        //Error message changes
        //Updated by A5E Consulting
        noBureauHit = TransUnionWSUtil.ERROR_MESSAGE_NO_BUREAU_HIT;
        thinBureauHit = TransUnionWSUtil.ERROR_MESSAGE_THIN_BUREAU_HIT;
        toManyAttempts =  TransUnionWSUtil.ERROR_MESSAGE_TOO_MANY_ATTEMPTS;   
        submittedExamAgain = TransUnionWSUtil.ERROR_MESSAGE_SUBMITTED_EXAM_AGAIN;
        technicalIssue = TransUnionWSUtil.ERROR_MESSAGE_TECHNICAL_ISSUE;
        
        errorMessage = ApexPages.currentPage().getParameters().get('errorMessage');
    
        System.debug('trac_UserVerificationErrorController errorMessage :'+errorMessage);
        
        //Commented by A5E Consulting
        //Email Athentication Changes
        //PowerCurveWSUtil.Channel channel = Utilities.getChannelByProfile();
        //PowerCurveWSUtil.changeQueue(App.Customer__r.SF_ID__c, App, channel);       
        PowerCurveWSUtil.DecisionResponse response = PowerCurveWSUtil.changeQueue(App.Customer__r.SF_ID__c, App, Utilities.getChannelByProfile());
                
        if (response == null || String.isNotBlank(response.ErrorMessage)) {
            // Some Error
        
        } else {
            // Set decision-related fields on Application            
            //App.Decision__c = response.DecisionResult;
            //App.Application_Status__c = response.DecisionStatus;
            //App.Decision_Timestamp__c = response.DecisionTimestamp;   
            
            //Updated By A5E Consulting 
            //Appilcation Workflow and Data Sync
            Utilities.updateApplicationDecisionData(App, response, false);                      
        } 
    }
  
    public void updateApplication(){
        ApplicationTriggerHandler.runApplicationLoadTrigger = false;
        update App;
        ApplicationTriggerHandler.runApplicationLoadTrigger = true; 
    }

   */
}