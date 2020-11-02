/**************************************************************************************************
*
*  Class:   
*
*  @description : TestVersaPayWSUtil for Versapay
*  @author : A5E Consulting
*  @date : 11/21/2016   

*************************************************************************************************/
@isTest
public class TestVersaPayWSUtil{
    
    private static Loan_ReEngineering__c loanReCS;
    
    static testMethod void insertTestData(){
       
        //create a custom setting records
        createLRPCs();
        
        //create a product record that will be eligible for funding batch
        Product__c prod = createProduct('Automated');
        
        //create a Request XML for VersaPay direct_credit 
        VersaPayWSUtil.createCreditRequestXml(prod);
        
        //create a Request XML for VersaPay  direct_debit
        VersaPayWSUtil.createDebitRequestXml(prod, 100, System.Today());
        
        //methods that create requests
        VersaPayWSUtil.createRequestCredit();
        VersaPayWSUtil.createRequestDebit();
        
        //methods that create Authorization token
        VersaPayWSUtil.getAuthorizationHeaderCredit();
        VersaPayWSUtil.getAuthorizationHeaderDebit();
        
        VersaPayWSUtil.countAmountInCentsDebit(100,100,100,System.today());
        VersaPayWSUtil.countAmountInCentsDebit(null,null,null,null);
    }
    
    //create LRP custom setting records
    private static void createLRPCs(){
        
        loanReCS = New  Loan_ReEngineering__c();  
        loanReCS.Megasys_Account_Import_Code__c = 'Affirm Term Loan Import';
        loanReCS.Megasys_Client_Number__c = '420';
        loanReCS.Megasys_End_Point__c = 'https://omegasandbox.megasys.net/Client/WebServices/CustomerPortal.asmx';
        loanReCS.Megasys_Password__c = 'testPass';
        loanReCS.Megasys_User_Name__c = 'testUserName';
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
}