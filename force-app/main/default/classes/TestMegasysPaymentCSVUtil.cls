/**************************************************************************************************
*
*  Class:   
*
*  @description : TestMegasysPaymentCSVUtil.
*  @author : A5E Consulting
*  @date : 11/23/2016   

*************************************************************************************************/
@isTest
public class TestMegasysPaymentCSVUtil{
    
    static testMethod void testMegaSysPaymentCsvUtil(){
         //create Vesapay Product records
        Product__c prod = createVersapayProduct();
        
        //create VersaPay Payment Setup Records
        createVersapayPaySet(prod);
        
        //fetch All Eligible Versapay Product Payment Records for MegaSys
        MegasysPaymentCSVUtil.fecthVersaPayProdPayment();
        
        //fetch All Eligible Versapay Product Payment Records
        String versaPayCSV = MegasysPaymentCSVUtil.createVersaPayCSV();
        
        //Create MegaSys Payment Update Record
        MegasysPaymentCSVUtil.createMegaSysPaymentRecord(versaPayCSV);
        
        //update Versapay Payment Setup records
        MegasysPaymentCSVUtil.updateVersaPayListRecords();
        
       //check null 
       MegasysPaymentCSVUtil.convertDateToString(null);
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
    //create Vesapay Product records
    private static Product__c createVersapayProduct(){
        
        Product__c app = new Product__c();
        
        app.customer__c = createAccount().id;
        app.Product_Status__c = 'New';
        app.Funding_Amount__c = 1000.00;
        app.Loan_Process_Type__c = 'Traditional';
        app.Funding_Type__c = 'Automated';
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
        
        insert app;
        return app;
    }
    
    //create VersaPay Payment Setup Records
    private static void createVersapayPaySet(Product__c prod){
        
        VersaPay_Product_Payment__c vpp = New VersaPay_Product_Payment__c();
        vpp.Payment_Amount__c = 1000;
        vpp.Last_State_Changed_Date__c = System.Now();
        vpp.MegaSys_Export_Date__c = System.today();
        vpp.Payment_Posted_To_VersaPay_On__c = System.today();
        vpp.Posted_To_MegaSys__c = false;
        vpp.Product__c = prod.Id;
        vpp.VersaPay_State__c = 'Completed';
        vpp.VersaPay_To_Account__c = 'FKJHKJSHEOH';
        vpp.Process_On__c = System.Today();
        vpp.VersaPay_Token_Number__c = '454446';
        insert vpp;
    }
}