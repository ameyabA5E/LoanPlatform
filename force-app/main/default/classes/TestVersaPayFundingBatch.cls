/**************************************************************************************************
*
*  Class:   
*
*  @description : VersaPay Funding Batch Test Class
*  @author : A5E Consulting
*  @date : 11/21/2016   

*************************************************************************************************/
@isTest
public class TestVersaPayFundingBatch{
    
    private static Loan_ReEngineering__c loanReCS;
    
    static testMethod void insertTestData(){
        
        //create LRP custom setting records
        createLRPCs();
        
        //create a product record that will be eligible for funding batch
        Product__c prod = createProduct('Automated');
        
        //create a funding batch record
        Funding_Batch__c batch = createFundingBatchRecord();
        
        //update product with Funding Batch record ID
        prod.Funding_Batch__c = batch.Id;
        update prod;
        
        //execute Funding Batch Class
        Database.executeBatch(new VersaPayFundingBatch(batch.Id), 1);
    }
    
    //parse direct_credit full response with 200 code
    static testMethod void responseFullDirectCredit(){
       insertTestData();
       Test.startTest();
       Test.setMock(HttpCalloutMock.class, new VersaPayWSUtilReqMockTest(VersaPayWSUtilReqMockTest.responseFullDirectCredit,200));
       Test.stopTest(); 
    }
    
    //parse direct_credit Error response with 401 code
    static testMethod void responseErrorDirectCredit(){
        insertTestData();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new VersaPayWSUtilReqMockTest(VersaPayWSUtilReqMockTest.responseErrorDirectCrdDbt,410));
        Test.stopTest();
    }

    //parse direct_credit Error response with 201 code
    static testMethod void responseErrorCodeDirectCredit(){
        insertTestData();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new VersaPayWSUtilReqMockTest(VersaPayWSUtilReqMockTest.responseErrorDirectCrdDbt,200));
        Test.stopTest();
    }    
    
    //parse direct_credit Null XML response with 412 code
    static testMethod void responseNullCrdDet(){
        insertTestData();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new VersaPayWSUtilReqMockTest(VersaPayWSUtilReqMockTest.responseNullDirectCrdDbt,412));
        Test.stopTest();
    } 
    //create LRP custom setting records
    private static void createLRPCs(){
        
        loanReCS = New  Loan_ReEngineering__c();  
        loanReCS.Request_Timeout__c=60000;
        //loanReCS.VersaPay_Auth_Key__c='SjlnsdjKJ';
        //loanReCS.VersaPay_Auth_Token__c='SGHJDKLDLKSL';
        loanReCS.VersaPay_Auth_Key_Credit__c='SjlnsdjKJ';
        loanReCS.VersaPay_Auth_Token_Credit__c='SGHJDKLDLKSL';
        loanReCS.VersaPay_Auth_Key_Debit__c='SjlnsdjKJ';
        loanReCS.VersaPay_Auth_Token_Debit__c='SGHJDKLDLKSL';
        loanReCS.VersaPay_End_Point__c='www.versapytest.com';
        loanReCS.VersaPay_Signing_Key__c='siging Key';
        
        insert loanReCS;
    }
    
    //create Account record
    private static Account createAccount(){
        Account p = new Account();
        
        p.Salutation = 'Mr.';
        p.FirstName = 'Asad';
        p.Middle_Name__pc = 'Full';
        p.LastName = 'Person';
        
        p.PersonMailingState = 'ON';
        p.PersonBirthdate = Date.newInstance(1983, 12, 2);
        p.Gender__pc = 'Male';
        p.Marital_Status__pc = 'Single';
        
        p.Employer_Province__pc = 'ON';
        p.Number_of_Dependants__pc = '0';
        p.Home_Owner__pc = 'Own';
        p.PersonMailingState = 'ON';
        
        p.PersonHomePhone = '1235551234';
        p.PersonEmail = 'asad.fullperson@test.com';
        p.SIN__pc = '123456789';
        p.PersonMobilePhone = '5551231234';
        p.Work_Phone__pc = '1112223333';
        
        p.Communication_Preference__pc = 'Email';
        p.Monthly_Home_Expense__pc = 2000;
        p.Monthly_Expense__pc = 500;
        
        p.PersonMailingStreet = '4 Glenora';
        p.PersonMailingCity = 'Brampton';
        p.PersonMailingPostalCode = 'L6Y4K5';
        
        p.Employer_Name__pc = 'Paper Empire';
        p.Employer_Phone__pc = '9991231234';
        p.Employer_Street_Name__pc = 'Brick Lane';
        p.Employer_Street_Number__pc = '4';
        p.Employer_City__pc = 'Brampton';
        p.Employer_Postal_Code__pc = 'L6Y4K4';
        p.Occupation__pc = 'Manager';
        p.Employment_Years__pc = 3;
        p.Employment_Months__pc = 10;
        p.Gross_Monthly_Income__pc = 5000;
        
        insert p;
        
        return p;
    }
    
    //create a product record that will be eligible for funding batch
    private static Product__c createProduct(string fundType){
        Product__c app = new Product__c();
        
        app.customer__c = createAccount().id;
        app.Product_Status__c = 'New';
        app.Funding_Amount__c = 1000.00;
        app.Loan_Process_Type__c = 'Traditional';
        app.Funding_Type__c = fundType;
        app.Funding_Status__c = 'Pending';
        app.Funding_Date__c = System.Today();
        app.Regular_Payment_Amount__c = 100.00;
        //app.SOR_Account_Number__c = '123456789120';
        //app.SOR_Primary_Account_Number__c = '4534535345345';
        app.PAP_Account_Number__c = '98745632';
        app.PAP_Transit_Code__c = '45';
        app.PAP_Bank_Code__c = '12';
        app.Loan_Type__c = 'Affirm Financial Term Loan';
        app.First_Payment_Date__c = system.today();
        app.Disbursement_Amount__c = 45;
        //app.SOR_External_ID__c = 'SFI123';
        app.Disbursement_Amount__c = 123;
        app.PAP_Bank_Code__c = '004';
        app.PAP_Transit_Code__c = '156';
        app.PAP_Account_Number__c = '123459';
        app.First_Payment_Date__c = System.today();
        insert app;
        return app;
    }
    
    //create a funding batch recordcreateFundingBatchRecord
    private static Funding_Batch__c createFundingBatchRecord(){
    
        Funding_Batch__c batch = New Funding_Batch__c();
        batch.Released_Date__c = System.today();
        batch.Status__c = 'Pending';
        batch.Total_Funding_Amount__c = 123;
        batch.Total_Automated_Funding_Amount__c = 123;
        insert batch;
        
        return batch;
    }
}