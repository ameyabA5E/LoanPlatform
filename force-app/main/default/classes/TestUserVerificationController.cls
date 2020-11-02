//@isTest
public class TestUserVerificationController {
 /*   private static Application_Form_Settings__c afSettings;
    private static Application__c app;
    private static Application__c appWithExpiredEmailToken;
    private static Application__c appWithValidEmailToken;
    private static Application__c appPassedNoFraud;
    
    
    
    // Test answer questions correctly the first time
    static testMethod void testAuthenticationPass() {
        init();

        // Test initial conditions
        ApexPages.currentPage().getParameters().put('id', app.Id);
                
        trac_UserVerificationController c = new trac_UserVerificationController();
        
        Application__c newApp = getApplicationById(app.Id);
        
        System.assertEquals(app.Id, newApp.Id); 
        
        // Send auth request
        Test.startTest();
        System.Test.setMock(WebServiceMock.class, new TransUnionTestUtilities.TransUnionAuthRequestMock());
        PageReference ref = c.sendAuthRequest();
        
        System.assertEquals(null, ref);
        
        // Verify questions set correctly
        TransUnionTestUtilities.verifyAuthResponse(c.Questions);
        
        // Answer questions
        TransUnionTestUtilities.answerAuthQuestions(c.Questions); // unnecessary for testing, but for completeness
        c.maidenName = 'maiden';
    
        // Send answers request
        System.Test.setMock(WebServiceMock.class, new TransUnionTestUtilities.TransUnionAnswersRequestMock());
        ref = c.sendAnswersRequest();
        Test.stopTest();
        
        // Verify page reference set to correct page
        System.assertEquals('/apex/AuthComplete?id=' + app.Id, ref.getUrl());
        
        // Verify fields set on application correctly
        newApp = getApplicationById(app.Id);
        System.assertEquals('Passed', newApp.Authentication_Result__c);
        System.assertEquals('Completed', newApp.Authentication_Choice__c);
        System.assertEquals('maiden', newApp.Mothers_Maiden_Name__c);
    }
    
    
    // Test PassedNoFraud
    static testMethod void testAuthenticationPassedNoFraud() {
        init();

        // Test initial conditions
        ApexPages.currentPage().getParameters().put('id', appPassedNoFraud.Id);
                
        trac_UserVerificationController c = new trac_UserVerificationController();
        
        Application__c newApp = getApplicationById(appPassedNoFraud.Id);
        
        System.assertEquals(appPassedNoFraud.Id, newApp.Id); 
        
        // Send auth request
        Test.startTest();
        System.Test.setMock(WebServiceMock.class, new TransUnionTestUtilities.TransUnionAuthRequestMock());
        PageReference ref = c.sendAuthRequest();
        
        System.assertEquals(null, ref);
        
        // Verify questions set correctly
        TransUnionTestUtilities.verifyAuthResponse(c.Questions);
        
        // Answer questions
        TransUnionTestUtilities.answerAuthQuestions(c.Questions); // unnecessary for testing, but for completeness
        c.maidenName = 'maiden';
    
        // Send answers request
        System.Test.setMock(WebServiceMock.class, new TransUnionTestUtilities.TransUnionAnswersRequestMock());
        ref = c.sendAnswersRequest();
        Test.stopTest();
        
        // Verify page reference set to correct page
        System.assertEquals('/apex/AuthComplete?id=' + appPassedNoFraud.Id, ref.getUrl());
        
        // Verify fields set on application correctly
        newApp = getApplicationById(appPassedNoFraud.Id);
        System.assertEquals('PassedNoFraud', newApp.Authentication_Result__c);
        System.assertEquals('Completed', newApp.Authentication_Choice__c);
        System.assertEquals('maiden', newApp.Mothers_Maiden_Name__c);
    }

    // Test answer questions completely wrong the first time
    static testMethod void testAuthenticationFail() {
        init();

        // Test initial conditions
        ApexPages.currentPage().getParameters().put('id', app.Id);
        
        trac_UserVerificationController c = new trac_UserVerificationController();
        
        Application__c newApp = getApplicationById(app.Id);
        
        System.assertEquals(app.Id, newApp.Id); 
        
        // Send auth request
        Test.startTest();
        System.Test.setMock(WebServiceMock.class, new TransUnionTestUtilities.TransUnionAuthRequestMock());
        PageReference ref = c.sendAuthRequest();
        
        System.assertEquals(null, ref);
        
        // Verify questions set correctly
        TransUnionTestUtilities.verifyAuthResponse(c.Questions);
        
        // Answer questions incorrectly
        TransUnionTestUtilities.answerAuthQuestionsAllWrong(c.Questions); // unnecessary for testing, but for completeness
        
        // Send answers request
        System.Test.setMock(WebServiceMock.class, new TransUnionTestUtilities.TransUnionAnswersFailRequestMock());
        ref = c.sendAnswersRequest();
        Test.stopTest();
 
        // Verify page reference set to correct page
        System.assertEquals('/apex/AuthComplete?id=' + app.Id, ref.getUrl());
        
        // Verify fields set on application correctly
        newApp = getApplicationById(app.Id);
        System.assertEquals('Failed', newApp.Authentication_Result__c);
        System.assertEquals('Completed', newApp.Authentication_Choice__c);
        System.assertEquals(null, newApp.Mothers_Maiden_Name__c);
    }

    // Test more questions case
    static testMethod void testMoreQuestions() {
        init();

        // Test initial conditions
        ApexPages.currentPage().getParameters().put('id', app.Id);
        
        trac_UserVerificationController c = new trac_UserVerificationController();
        
        Application__c newApp = getApplicationById(app.Id);
        
        System.assertEquals(app.Id, newApp.Id); 
        
        // Send auth request
        Test.startTest();
        System.Test.setMock(WebServiceMock.class, new TransUnionTestUtilities.TransUnionAuthRequestMock());
        PageReference ref = c.sendAuthRequest();
        
        System.assertEquals(null, ref);
        
        // Verify questions set correctly
        TransUnionTestUtilities.verifyAuthResponse(c.Questions);
        
        // Answer questions, one wrong
        TransUnionTestUtilities.answerAuthQuestionsOneWrong(c.Questions); // unnecessary for testing, but for completeness
        c.maidenName = 'maiden';
                
        // Send answers request, should return more questions
        System.Test.setMock(WebServiceMock.class, new TransUnionTestUtilities.TransUnionAnswersMoreQuestionsRequestMock());
        ref = c.sendAnswersRequest();
 
        // Answer question correctly
        TransUnionTestUtilities.answerAuthMoreQuestions(c.Questions); // also unnecessary
        
        // Send answers request again, should pass this time
        System.Test.setMock(WebServiceMock.class, new TransUnionTestUtilities.TransUnionAnswersRequestMock());
        ref = c.sendAnswersRequest();
        Test.stopTest();
 
        // Verify page reference set to correct page
        System.assertEquals('/apex/AuthComplete?id=' + app.Id, ref.getUrl());
        
        // Verify fields set on application correctly
        newApp = getApplicationById(app.Id);
        System.assertEquals('Passed', newApp.Authentication_Result__c);
        System.assertEquals('Completed', newApp.Authentication_Choice__c);
        System.assertEquals('maiden', newApp.Mothers_Maiden_Name__c);
    }

    //Test Exam Submitted Again error
    //Error message changes
    //Updated by A5E Consulting
    static testMethod void testExamSubmittedAgain() {
        init();

        // Test initial conditions
        ApexPages.currentPage().getParameters().put('id', app.Id);
        
        trac_UserVerificationController c = new trac_UserVerificationController();
        
        Application__c newApp = getApplicationById(app.Id);
        
        System.assertEquals(app.Id, newApp.Id); 
        
        // Send auth request with error response mock
        Test.startTest();
        System.Test.setMock(WebServiceMock.class, new TransUnionTestUtilities.TransUnionExamSubmittedAgainRquestMock());
        PageReference ref = c.sendAuthRequest();
        
        newApp = getApplicationById(app.Id);
        System.assertEquals('Incomplete', newApp.Authentication_Result__c);
        //System.assertEquals('Error', newApp.Authentication_Choice__c);
        System.assertEquals('Error-SubmittedExamAgain', newApp.Authentication_Choice__c);
            
    }
    
    //Test No Bureau Hit
    //Error message changes
    //Added by A5E Consulting
    static testMethod void testNoBureauHit() {
        init();

        // Test initial conditions
        ApexPages.currentPage().getParameters().put('id', app.Id);
        
        trac_UserVerificationController c = new trac_UserVerificationController();
        
        Application__c newApp = getApplicationById(app.Id);
        
        System.assertEquals(app.Id, newApp.Id); 
        
        // Send auth request with error response mock
        Test.startTest();
        System.Test.setMock(WebServiceMock.class, new TransUnionTestUtilities.TransUnionNoBureauHitRquestMock());
        PageReference ref = c.sendAuthRequest();
        
        newApp = getApplicationById(app.Id);
        System.assertEquals('Incomplete', newApp.Authentication_Result__c);
        System.assertEquals('Error-NoBureauHit', newApp.Authentication_Choice__c);             
    }
    
    //Test This Bureau Hit
    //Error message changes
    //Added by A5E Consulting
    static testMethod void testThinBureauHit() {
        init();

        // Test initial conditions
        ApexPages.currentPage().getParameters().put('id', app.Id);
        
        trac_UserVerificationController c = new trac_UserVerificationController();
        
        Application__c newApp = getApplicationById(app.Id);
        
        System.assertEquals(app.Id, newApp.Id); 
        
        // Send auth request with error response mock
        Test.startTest();
        System.Test.setMock(WebServiceMock.class, new TransUnionTestUtilities.TransUnionThinBureauHitRquestMock());
        PageReference ref = c.sendAuthRequest();
        
        newApp = getApplicationById(app.Id);
        System.assertEquals('Incomplete', newApp.Authentication_Result__c);
        System.assertEquals('Error-ThinBureauHit', newApp.Authentication_Choice__c);             
    }
    
    //Test To Many Attempts
    //Error message changes
    //Added by A5E Consulting
    static testMethod void testToManyAttempts() {
        init();

        // Test initial conditions
        ApexPages.currentPage().getParameters().put('id', app.Id);
        
        trac_UserVerificationController c = new trac_UserVerificationController();
        
        Application__c newApp = getApplicationById(app.Id);
        
        System.assertEquals(app.Id, newApp.Id); 
        
        // Send auth request with error response mock
        Test.startTest();
        System.Test.setMock(WebServiceMock.class, new TransUnionTestUtilities.TransUnionToManyAttemptsRquestMock());
        PageReference ref = c.sendAuthRequest();
        
        newApp = getApplicationById(app.Id);
        System.assertEquals('Incomplete', newApp.Authentication_Result__c);
        System.assertEquals('Error-TooManyAttempts', newApp.Authentication_Choice__c);             
    }
    
    //Test To Many Attempts
    //Error message changes
    //Added by A5E Consulting
    static testMethod void testOtherErrors() {
        init();

        // Test initial conditions
        ApexPages.currentPage().getParameters().put('id', app.Id);
        
        trac_UserVerificationController c = new trac_UserVerificationController();
        
        Application__c newApp = getApplicationById(app.Id);
        
        System.assertEquals(app.Id, newApp.Id); 
        
        // Send auth request with error response mock
        Test.startTest();
        System.Test.setMock(WebServiceMock.class, new TransUnionTestUtilities.TransUnionOtherErrorRquestMock());
        PageReference ref = c.sendAuthRequest();
        
        newApp = getApplicationById(app.Id);
        System.assertEquals('Incomplete', newApp.Authentication_Result__c);
        System.assertEquals('Error-TechnicalIssue', newApp.Authentication_Choice__c);             
    }

    // Test entry from email link
    static testMethod void testEmailAuthEntryPoint() {
        init();
        
        // Test erroneous token case
        ApexPages.currentPage().getParameters().put('et', '1234Invalid');
        trac_UserVerificationController c = new trac_UserVerificationController();
        
        System.assertEquals(true, c.emailAuthError);
        
        PageReference ref = c.sendAuthRequest();
        
        System.assertEquals(null, ref);
        
        // Test expired token case
        ApexPages.currentPage().getParameters().put('et', appWithExpiredEmailToken.Email_Auth_Token__c);
        c = new trac_UserVerificationController();
        
        System.assertEquals(true, c.emailAuthError);
        
        ref = c.sendAuthRequest();
        
        System.assertEquals(null, ref);
        
        // Test valid token case
        ApexPages.currentPage().getParameters().put('et', appWithValidEmailToken.Email_Auth_Token__c);
        c = new trac_UserVerificationController();
        
        System.assertEquals(false, c.emailAuthError);
        System.assertEquals(appWithValidEmailToken.Id, c.application.Id);       
    }
    
    private static void init() {
        afSettings = new Application_Form_Settings__c(
            Trans_Union_Web_Service_URL__c = TransUnionTestUtilities.Trans_Union_Web_Service_URL,
            Trans_Union_Member_Id__c = TransUnionTestUtilities.Trans_Union_Member_Id, 
            Trans_Union_Password__c = TransUnionTestUtilities.Trans_Union_Password,
            Request_Timeout__c =  TransUnionTestUtilities.Trans_Union_Request_Timeout,
            Site_Profile_Id__c = '00eK0000000MDqzIAG',
            Email_Authentication_Expiry_Days__c = 10
        );
        insert afSettings;
        
        TransUnionTestUtilities.initTransUnionSettings();
        insertTestData();
        initPageRef();
        
    }
    
    private static void initPageRef() {
        PageReference pageRef = Page.UserVerification;
        Test.setCurrentPage(pageRef);
    }
    
    private static void insertTestData() {
        app = new Application__c(
            Salutation__c = 'Mr.', 
            First_Name__c = 'Rob', 
            Last_Name__c = 'Johnson', 
            Gender__c = 'Male',
            SIN__c = '123456789',
            Requested_Credit_Limit__c = 4500,
            Birth_Date__c = Date.today().addYears(-25), 
            Current_BKCP__c = false, 
            Marital_Status__c = 'Single', 
            Home_Phone__c = '416-555-1234', 
            Work_Phone__c = '416-555-4567', 
            
            Permanent_Address_Street_Number__c = '123', 
            Permanent_Address_Street_Name__c = 'Current St.', 
            Permanent_Address_City__c = 'Toronto', 
            Permanent_Address_Province__c = 'ON', 
            Permanent_Address_PostalCode__c = 'A1A 1A1', 
            Years_At_Permanent_Address__c = 0, 
            Months_At_Permanent_Address__c = 6, 
            Home_Owner__c = 'Rent', 
            Housing_Costs__c = 1000,
            
            Previous_Address_Street_Number__c = '456', 
            Previous_Address_Street_Name__c = 'Previous St.', 
            Previous_Address_City__c = 'Toronto', 
            Previous_Address_Province__c = 'ON', 
            Previous_Address_PostalCode__c = 'P1P 1P1', 
            Years_At_Previous_Address__c = 5, 
            Months_At_Previous_Address__c = 8, 
            
            Employment_Status__c = 'Full-time', 
            Employer_Name__c = 'ACME Co.', 
            Employment_Years__c = 0, 
            Employment_Months__c = 8, 
            Gross_Monthly_Income__c = 3000, 
            Employer_Street_Number__c = '1212', 
            Employer_Street_Name__c = 'Main St.', 
            Employer_City__c = 'Toronto', 
            Employer_Province__c = 'ON', 
            Employer_PostalCode__c = 'M2M 2M2',
            Employer_Phone__c = '416-555-4567',
            
            Previous_Employer_Name__c = 'ABC Computers', 
            Previous_Employment_Years__c = 4, 
            Previous_Employment_Months__c = 6, 
            Previous_Gross_Monthly_Income__c = 2000, 
            Previous_Employer_Street_Number__c = '4545', 
            Previous_Employer_Street_Name__c = 'Front St.', 
            Previous_Employer_City__c = 'Toronto', 
            Previous_Employer_Province__c = 'ON', 
            Previous_Employer_PostalCode__c = 'F2F 2F2'
        );
        
        appPassedNoFraud = new Application__c(
            Salutation__c = 'Mr.', 
            First_Name__c = 'Rob', 
            Last_Name__c = 'Johnson', 
            Gender__c = 'Male',
            SIN__c = '123456789',
            Requested_Credit_Limit__c = 4500,
            Birth_Date__c = Date.today().addYears(-25), 
            Current_BKCP__c = false, 
            Marital_Status__c = 'Single', 
            Home_Phone__c = '416-555-1234', 
            Work_Phone__c = '416-555-4567', 
            Fraud_Alert__c = 'True-N/A',
            
            Permanent_Address_Street_Number__c = '123', 
            Permanent_Address_Street_Name__c = 'Current St.', 
            Permanent_Address_City__c = 'Toronto', 
            Permanent_Address_Province__c = 'ON', 
            Permanent_Address_PostalCode__c = 'A1A 1A1', 
            Years_At_Permanent_Address__c = 0, 
            Months_At_Permanent_Address__c = 6, 
            Home_Owner__c = 'Rent', 
            Housing_Costs__c = 1000,
            
            Previous_Address_Street_Number__c = '456', 
            Previous_Address_Street_Name__c = 'Previous St.', 
            Previous_Address_City__c = 'Toronto', 
            Previous_Address_Province__c = 'ON', 
            Previous_Address_PostalCode__c = 'P1P 1P1', 
            Years_At_Previous_Address__c = 5, 
            Months_At_Previous_Address__c = 8, 
            
            Employment_Status__c = 'Full-time', 
            Employer_Name__c = 'ACME Co.', 
            Employment_Years__c = 0, 
            Employment_Months__c = 8, 
            Gross_Monthly_Income__c = 3000, 
            Employer_Street_Number__c = '1212', 
            Employer_Street_Name__c = 'Main St.', 
            Employer_City__c = 'Toronto', 
            Employer_Province__c = 'ON', 
            Employer_PostalCode__c = 'M2M 2M2',
            Employer_Phone__c = '416-555-4567',
            
            Previous_Employer_Name__c = 'ABC Computers', 
            Previous_Employment_Years__c = 4, 
            Previous_Employment_Months__c = 6, 
            Previous_Gross_Monthly_Income__c = 2000, 
            Previous_Employer_Street_Number__c = '4545', 
            Previous_Employer_Street_Name__c = 'Front St.', 
            Previous_Employer_City__c = 'Toronto', 
            Previous_Employer_Province__c = 'ON', 
            Previous_Employer_PostalCode__c = 'F2F 2F2'
        );
        
        appWithExpiredEmailToken = new Application__c (
            Email_Authentication_Expiration_Date__c = Datetime.now().addDays(-5),
            Email_Auth_Token__c = 'abc1234'
        );
        
        appWithValidEmailToken = new Application__c (
            Email_Authentication_Expiration_Date__c = Datetime.now().addDays(5),
            Email_Auth_Token__c = 'zyx1234'
        );
        
        insert app;
        insert appWithExpiredEmailToken;
        insert appWithValidEmailToken;
        insert appPassedNoFraud;
    }

    private static Application__c getApplicationById(Id applicationId) {
        List<Application__c> applications = [
            SELECT Id, Authentication_Result__c, Authentication_Choice__c, Mothers_Maiden_Name__c
            FROM Application__c WHERE Id =: applicationId
        ];
    
        return (applications.size() > 0) ? applications[0] : null;
    } */
}