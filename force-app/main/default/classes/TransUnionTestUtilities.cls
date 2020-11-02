public with sharing class TransUnionTestUtilities {
   /* public static final String Trans_Union_Web_Service_URL = 'https://pcunittest.unittest.ca/Integration/IntegrationService';
    public static final String Trans_Union_Member_Id = 'AFIUnitTester';
    public static final String Trans_Union_Password = 'unittestpassword';
    public static final Integer Trans_Union_Request_Timeout = 100000;
    
    public static void initTransUnionSettings() {
        insert new TransUnionProvinceCodes__c(Name='AB', Province__c='Alberta', Province_Code__c='58');
        insert new TransUnionProvinceCodes__c(Name='BC', Province__c='British Columbia', Province_Code__c='59');
        insert new TransUnionProvinceCodes__c(Name='MB', Province__c='Manitoba', Province_Code__c='60');
        insert new TransUnionProvinceCodes__c(Name='NB', Province__c='New Brunswick', Province_Code__c='61');
        insert new TransUnionProvinceCodes__c(Name='NL', Province__c='Newfoundland', Province_Code__c='62');
        insert new TransUnionProvinceCodes__c(Name='NT', Province__c='Northwest Territories', Province_Code__c='63');
        insert new TransUnionProvinceCodes__c(Name='NS', Province__c='Nova Scotia', Province_Code__c='64');
        insert new TransUnionProvinceCodes__c(Name='NU', Province__c='Nunavut', Province_Code__c='65');
        insert new TransUnionProvinceCodes__c(Name='ON', Province__c='Ontario', Province_Code__c='66');
        insert new TransUnionProvinceCodes__c(Name='PE', Province__c='Prince Edward Island', Province_Code__c='67');
        insert new TransUnionProvinceCodes__c(Name='QC', Province__c='Quebec', Province_Code__c='68');
        insert new TransUnionProvinceCodes__c(Name='SK', Province__c='Saskatchewan', Province_Code__c='69');
        insert new TransUnionProvinceCodes__c(Name='YT', Province__c='Yukon', Province_Code__c='70');   
    }
    
    public class TransUnionAuthRequestMock implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {
            
            TransUnionWS.ProcessResponse_element responseElement = new TransUnionWS.ProcessResponse_element();
            responseElement.oIDAuthentication = new TransUnionIdAuthElements.IDAuthentication();
            responseElement.oIDAuthentication.Reply = new TransUnionIdAuthElements.Reply();
            responseElement.oIDAuthentication.Reply.SessionId = '414344';
            responseElement.oIDAuthentication.Reply.ExternalId = 'COMPANYTEST_20050712_121012_2799';
            
            // Create questions list
            List<TransUnionIdAuthElements.Question> questionList = new List<TransUnionIdAuthElements.Question>();
            
            // First question
            TransUnionIdAuthElements.Question firstQ = new TransUnionIdAuthElements.Question();
            firstQ.Text = 'WHAT ARE THE LAST FOUR (4) DIGITS OF YOUR SOCIAL INSURANCE NUMBER?'; 
            firstQ.TimePermitted = '25';
            List<TransUnionIdAuthElements.Choice> firstQChoices = new List<TransUnionIdAuthElements.Choice>();
            
            TransUnionIdAuthElements.Choice firstQChoiceOne = new TransUnionIdAuthElements.Choice();
            firstQChoiceOne.Text = '6711';
            firstQChoices.add(firstQChoiceOne);
            
            TransUnionIdAuthElements.Choice firstQChoiceTwo = new TransUnionIdAuthElements.Choice();
            firstQChoiceTwo.Text = '8735';
            firstQChoices.add(firstQChoiceTwo);
            
            TransUnionIdAuthElements.Choice firstQChoiceThree = new TransUnionIdAuthElements.Choice();
            firstQChoiceThree.Text = '6591';
            firstQChoices.add(firstQChoiceThree);
            
            TransUnionIdAuthElements.Choice firstQChoiceFour = new TransUnionIdAuthElements.Choice();
            firstQChoiceFour.Text = '0106';
            firstQChoices.add(firstQChoiceFour);
            
            TransUnionIdAuthElements.Choice firstQChoiceFive = new TransUnionIdAuthElements.Choice();
            firstQChoiceFive.Text = '1118';
            firstQChoices.add(firstQChoiceFive);
            
            firstQ.Choice = firstQchoices;
        
            // Second question
            TransUnionIdAuthElements.Question secondQ = new TransUnionIdAuthElements.Question();
            secondQ.Text = 'SELECT THE PROVINCE OR TERRITORY IN WHICH YOUR SOCIAL INSURANCE NUMBER WAS ISSUED.';    
            secondQ.TimePermitted = '25';
            List<TransUnionIdAuthElements.Choice> secondQChoices = new List<TransUnionIdAuthElements.Choice>();
            
            TransUnionIdAuthElements.Choice secondQChoiceOne = new TransUnionIdAuthElements.Choice();
            secondQChoiceOne.Text = 'QUEBEC';
            secondQChoices.add(secondQChoiceOne);
            
            TransUnionIdAuthElements.Choice secondQChoiceTwo = new TransUnionIdAuthElements.Choice();
            secondQChoiceTwo.Text = 'NEW BRUNSWICK, NEWFOUNDLAND, NOVA SCOTIA, OR PRINCE EDWARD ISLAND';
            secondQChoices.add(secondQChoiceTwo);
            
            TransUnionIdAuthElements.Choice secondQChoiceThree = new TransUnionIdAuthElements.Choice();
            secondQChoiceThree.Text = 'YUKON';
            secondQChoices.add(secondQChoiceThree);
            
            TransUnionIdAuthElements.Choice secondQChoiceFour = new TransUnionIdAuthElements.Choice();
            secondQChoiceFour.Text = 'SASKATCHEWAN';
            secondQChoices.add(secondQChoiceFour);
            
            TransUnionIdAuthElements.Choice secondQChoiceFive = new TransUnionIdAuthElements.Choice();
            secondQChoiceFive.Text = 'ALBERTA';
            secondQChoices.add(secondQChoiceFive);
            
            secondQ.Choice = secondQchoices;
            
            // Thirrd question
            TransUnionIdAuthElements.Question thirdQ = new TransUnionIdAuthElements.Question();
            thirdQ.Text = 'WITH WHICH CIBC BRANCH LOCATION DO YOU HAVE AN ACTIVE PERSONAL OR HOME EQUITY LINE OF CREDIT?';  
            thirdQ.TimePermitted = '25';
            List<TransUnionIdAuthElements.Choice> thirdQChoices = new List<TransUnionIdAuthElements.Choice>();
            
            TransUnionIdAuthElements.Choice thirdQChoiceOne = new TransUnionIdAuthElements.Choice();
            thirdQChoiceOne.Text = '403-1ST ST. W.  ';
            thirdQChoices.add(thirdQChoiceOne);
            
            TransUnionIdAuthElements.Choice thirdQChoiceTwo = new TransUnionIdAuthElements.Choice();
            thirdQChoiceTwo.Text = '4514 QUEEN STREET  ';
            thirdQChoices.add(thirdQChoiceTwo);
            
            TransUnionIdAuthElements.Choice thirdQChoiceThree = new TransUnionIdAuthElements.Choice();
            thirdQChoiceThree.Text = '7071 BAYERS RD.  ';
            thirdQChoices.add(thirdQChoiceThree);
            
            TransUnionIdAuthElements.Choice thirdQChoiceFour = new TransUnionIdAuthElements.Choice();
            thirdQChoiceFour.Text = '1142 SMYTHE STREET  ';
            thirdQChoices.add(thirdQChoiceFour);
            
            TransUnionIdAuthElements.Choice thirdQChoiceFive = new TransUnionIdAuthElements.Choice();
            thirdQChoiceFive.Text = 'NONE OF THE ABOVE';
            thirdQChoices.add(thirdQChoiceFive);
            
            thirdQ.Choice = thirdQchoices;
            
            questionList.add(firstQ);
            questionList.add(secondQ);
            questionList.add(thirdQ);
                
            // Attach questions
            responseElement.oIDAuthentication.Reply.Question = questionList;
            
            // Attach response
            response.put('response_x', responseElement);
        }
    }
    
    public static void verifyAuthResponse(List<trac_UserVerificationController.QuestionWrapper> questions) {
        System.assertEquals(3, questions.size());
        
        trac_UserVerificationController.QuestionWrapper firstQ = questions.get(0);
        System.assertEquals('25', firstQ.question.TimePermitted);
        System.assertEquals('WHAT ARE THE LAST FOUR (4) DIGITS OF YOUR SOCIAL INSURANCE NUMBER?', firstQ.text);
        System.assertEquals(5, firstQ.choices.size());
        System.assertEquals('6711', firstQ.choices.get(0).getValue());
        System.assertEquals('8735', firstQ.choices.get(1).getValue());
        System.assertEquals('6591', firstQ.choices.get(2).getValue());
        System.assertEquals('0106', firstQ.choices.get(3).getValue());
        System.assertEquals('1118', firstQ.choices.get(4).getValue());
        
        trac_UserVerificationController.QuestionWrapper secondQ = questions.get(1);
        System.assertEquals('25', secondQ.question.TimePermitted);
        System.assertEquals('SELECT THE PROVINCE OR TERRITORY IN WHICH YOUR SOCIAL INSURANCE NUMBER WAS ISSUED.', secondQ.text);
        System.assertEquals(5, secondQ.choices.size());
        System.assertEquals('QUEBEC', secondQ.choices.get(0).getValue());
        System.assertEquals('NEW BRUNSWICK, NEWFOUNDLAND, NOVA SCOTIA, OR PRINCE EDWARD ISLAND', secondQ.choices.get(1).getValue());
        System.assertEquals('YUKON', secondQ.choices.get(2).getValue());
        System.assertEquals('SASKATCHEWAN', secondQ.choices.get(3).getValue());
        System.assertEquals('ALBERTA', secondQ.choices.get(4).getValue());
        
        trac_UserVerificationController.QuestionWrapper thirdQ = questions.get(2);
        System.assertEquals('25', thirdQ.question.TimePermitted);
        System.assertEquals('WITH WHICH CIBC BRANCH LOCATION DO YOU HAVE AN ACTIVE PERSONAL OR HOME EQUITY LINE OF CREDIT?', thirdQ.text);
        System.assertEquals(5, thirdQ.choices.size());
        System.assertEquals('403-1ST ST. W.  ', thirdQ.choices.get(0).getValue());
        System.assertEquals('4514 QUEEN STREET  ', thirdQ.choices.get(1).getValue());
        System.assertEquals('7071 BAYERS RD.  ', thirdQ.choices.get(2).getValue());
        System.assertEquals('1142 SMYTHE STREET  ', thirdQ.choices.get(3).getValue());
        System.assertEquals('NONE OF THE ABOVE', thirdQ.choices.get(4).getValue());
    }
    
    public static void answerAuthQuestions(List<trac_UserVerificationController.QuestionWrapper> questions) {
        questions.get(0).answer = '1118';
        questions.get(1).answer = 'NEW BRUNSWICK, NEWFOUNDLAND, NOVA SCOTIA, OR PRINCE EDWARD ISLAND';
        questions.get(2).answer = 'NONE OF THE ABOVE';
    }

    public static void answerAuthQuestionsAllWrong(List<trac_UserVerificationController.QuestionWrapper> questions) {
        questions.get(0).answer = '6711';
        questions.get(1).answer = 'QUEBEC';
        questions.get(2).answer = '403-1ST ST. W.  ';
    }

    public static void answerAuthQuestionsOneWrong(List<trac_UserVerificationController.QuestionWrapper> questions) {
        questions.get(0).answer = '6711';
        questions.get(1).answer = 'NEW BRUNSWICK, NEWFOUNDLAND, NOVA SCOTIA, OR PRINCE EDWARD ISLAND';
        questions.get(2).answer = 'NONE OF THE ABOVE';
    }
    
    public static void answerAuthMoreQuestions(List<trac_UserVerificationController.QuestionWrapper> questions) {
        questions.get(0).answer = '13-24 MONTHS';
    }
    */
    public class TransUnionAnswersRequestMock  {
    // this class implements WebServiceMock
   /*     public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {
            
            TransUnionWS.ProcessResponse_element responseElement = new TransUnionWS.ProcessResponse_element();
            responseElement.oIDAuthentication = new TransUnionIdAuthElements.IDAuthentication();
            responseElement.oIDAuthentication.Reply = new TransUnionIdAuthElements.Reply();
            responseElement.oIDAuthentication.Reply.Confidence = new TransUnionIdAuthElements.Confidence();
            responseElement.oIDAuthentication.Reply.Confidence.Decision = 'PASS';
            
            // Attach response
            response.put('response_x', responseElement);
        }
    }
    
    public class TransUnionAnswersFailRequestMock implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {
            
            TransUnionWS.ProcessResponse_element responseElement = new TransUnionWS.ProcessResponse_element();
            responseElement.oIDAuthentication = new TransUnionIdAuthElements.IDAuthentication();
            responseElement.oIDAuthentication.Reply = new TransUnionIdAuthElements.Reply();
            responseElement.oIDAuthentication.Reply.Confidence = new TransUnionIdAuthElements.Confidence();
            responseElement.oIDAuthentication.Reply.Confidence.Decision = 'FAIL';
            
            // Attach response
            response.put('response_x', responseElement);
        }
    }
    
    public class TransUnionAnswersMoreQuestionsRequestMock implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {
            
            TransUnionWS.ProcessResponse_element responseElement = new TransUnionWS.ProcessResponse_element();
            responseElement.oIDAuthentication = new TransUnionIdAuthElements.IDAuthentication();
            responseElement.oIDAuthentication.Reply = new TransUnionIdAuthElements.Reply();
            
            // Create questions list
            List<TransUnionIdAuthElements.Question> questionList = new List<TransUnionIdAuthElements.Question>();
            
            // First question
            TransUnionIdAuthElements.Question firstQ = new TransUnionIdAuthElements.Question();
            firstQ.Text = 'WHEN DID YOU MOST RECENTLY REQUEST A COPY OF YOUR CREDIT REPORT FROM TRANSUNION FOR YOUR OWN PERSONAL USE?'; 
            firstQ.TimePermitted = '25';
            List<TransUnionIdAuthElements.Choice> firstQChoices = new List<TransUnionIdAuthElements.Choice>();
            
            TransUnionIdAuthElements.Choice firstQChoiceOne = new TransUnionIdAuthElements.Choice();
            firstQChoiceOne.Text = '13-24 MONTHS';
            firstQChoices.add(firstQChoiceOne);
            
            TransUnionIdAuthElements.Choice firstQChoiceTwo = new TransUnionIdAuthElements.Choice();
            firstQChoiceTwo.Text = '0-3 MONTHS';
            firstQChoices.add(firstQChoiceTwo);
            
            TransUnionIdAuthElements.Choice firstQChoiceThree = new TransUnionIdAuthElements.Choice();
            firstQChoiceThree.Text = '4-6 MONTHS';
            firstQChoices.add(firstQChoiceThree);
            
            TransUnionIdAuthElements.Choice firstQChoiceFour = new TransUnionIdAuthElements.Choice();
            firstQChoiceFour.Text = 'NONE OF THE ABOVE';
            firstQChoices.add(firstQChoiceFour);
            
            firstQ.Choice = firstQchoices;
            
            questionList.add(firstQ);
                
            // Attach questions
            responseElement.oIDAuthentication.Reply.Question = questionList;
            
            // Attach response
            response.put('response_x', responseElement);
        }
    }
    
    public class TransUnionExamSubmittedAgainRquestMock implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {
            
            TransUnionWS.ProcessResponse_element responseElement = new TransUnionWS.ProcessResponse_element();
            responseElement.oIDAuthentication = new TransUnionIdAuthElements.IDAuthentication();
            responseElement.oIDAuthentication.Reply = new TransUnionIdAuthElements.Reply();
            responseElement.oIDAuthentication.Reply.Error = new List<TransUnionIdAuthElements.Error>();
            
            TransUnionIdAuthElements.Error err = new TransUnionIdAuthElements.Error();
            err.Code = '20000';
            err.Text = 'Unexpected error.';
            
            responseElement.oIDAuthentication.Reply.Error.add(err);
            
            // Attach response
            response.put('response_x', responseElement);
        }
    }

    //Error message changes
    //Added by A5E Consulting
    public class TransUnionNoBureauHitRquestMock implements WebServiceMock {
        
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {
            
            TransUnionWS.ProcessResponse_element responseElement = new TransUnionWS.ProcessResponse_element();
            responseElement.oIDAuthentication = new TransUnionIdAuthElements.IDAuthentication();
            responseElement.oIDAuthentication.Reply = new TransUnionIdAuthElements.Reply();
            responseElement.oIDAuthentication.Reply.Error = new List<TransUnionIdAuthElements.Error>();
            
            TransUnionIdAuthElements.Error err = new TransUnionIdAuthElements.Error();
            err.Code = '20003';
            err.Text = 'Unable to create valid exam -- Insufficient number of questions';           
            responseElement.oIDAuthentication.Reply.Error.add(err);
            
            err = new TransUnionIdAuthElements.Error();
            err.Code = '20006';
            err.Text = 'Data retrieval error for TransUnion Canada Credit Report -- No-Hit returned by data source';            
            responseElement.oIDAuthentication.Reply.Error.add(err);
            
            // Attach response
            response.put('response_x', responseElement);
        }
    }
    
    //Error message changes
    //Added by A5E Consulting
    public class TransUnionThinBureauHitRquestMock implements WebServiceMock {
        
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {
            
            TransUnionWS.ProcessResponse_element responseElement = new TransUnionWS.ProcessResponse_element();
            responseElement.oIDAuthentication = new TransUnionIdAuthElements.IDAuthentication();
            responseElement.oIDAuthentication.Reply = new TransUnionIdAuthElements.Reply();
            responseElement.oIDAuthentication.Reply.Error = new List<TransUnionIdAuthElements.Error>();
            
            TransUnionIdAuthElements.Error err = new TransUnionIdAuthElements.Error();
            err.Code = '20003';
            err.Text = 'Unable to create valid exam -- Insufficient number of questions';           
            responseElement.oIDAuthentication.Reply.Error.add(err);
            
            // Attach response
            response.put('response_x', responseElement);
        }
    }   
    
    //Error message changes
    //Added by A5E Consulting
    public class TransUnionToManyAttemptsRquestMock implements WebServiceMock {
        
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {
            
            TransUnionWS.ProcessResponse_element responseElement = new TransUnionWS.ProcessResponse_element();
            responseElement.oIDAuthentication = new TransUnionIdAuthElements.IDAuthentication();
            responseElement.oIDAuthentication.Reply = new TransUnionIdAuthElements.Reply();
            responseElement.oIDAuthentication.Reply.Error = new List<TransUnionIdAuthElements.Error>();
            
            TransUnionIdAuthElements.Error err = new TransUnionIdAuthElements.Error();
            err.Code = '20002';
            err.Text = 'To Many Attempts';          
            responseElement.oIDAuthentication.Reply.Error.add(err);
            
            // Attach response
            response.put('response_x', responseElement);
        }
    }   
    
    //Error message changes
    //Added by A5E Consulting
    public class TransUnionOtherErrorRquestMock {
   // this class     implements WebServiceMock 
   /*     public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {
            
            TransUnionWS.ProcessResponse_element responseElement = new TransUnionWS.ProcessResponse_element();
            responseElement.oIDAuthentication = new TransUnionIdAuthElements.IDAuthentication();
            responseElement.oIDAuthentication.Reply = new TransUnionIdAuthElements.Reply();
            responseElement.oIDAuthentication.Reply.Error = new List<TransUnionIdAuthElements.Error>();
            
            TransUnionIdAuthElements.Error err = new TransUnionIdAuthElements.Error();
            err.Code = '12345';
            err.Text = 'Other Error';           
            responseElement.oIDAuthentication.Reply.Error.add(err);
            
            // Attach response
            response.put('response_x', responseElement);
        }
    } */ 
    } 
}