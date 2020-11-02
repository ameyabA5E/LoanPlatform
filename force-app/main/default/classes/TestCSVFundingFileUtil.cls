/**************************************************************************************************
*
*  Class:   
*
*  @description : This class contains unit tests for validating behavior of CSVFileUtil
*  @author : A5E Consulting
*  @date : 06/16/2016
*
*  Change History:
*
*  Developer       Date          Description
*  ------------------------------------------------------------------------------------------------
*
*  A5E Consulting 06/16/2016     Class created
*************************************************************************************************/
@isTest 
public class TestCSVFundingFileUtil {
    
    static testmethod void testCreateCSVFile(){ 
        
        List<Product__c> listProd = createProduct('Automated');
        Funding_Batch__c batch = createFundingBatch();
        CSVFundingFileUtil.createCSVFile(listProd, batch.Id, 'Credit');
        CSVFundingFileUtil.createCSVFile(listProd, batch.Id, 'Debit'); 
        CSVFundingFileUtil.checkPAPNumber(2);    
    }
    
    //create Funding Batch Records
    private static Funding_Batch__c createFundingBatch(){
        
        Funding_Batch__c fb = new Funding_Batch__c();
        fb.Released_Date__c = System.now();
        fb.Status__c = 'Completed';
        insert fb;
        return fb;
    }
    //Create Product
    private static List<Product__c> createProduct(String fundType){
        
        List<Product__c> listProd = new List<Product__c>();
        
        Product__c app = new Product__c();
        app.customer__c = createAccount().id;
        app.Product_Status__c = 'New';
        app.Funding_Amount__c = 1000.00;
        app.Loan_Process_Type__c = 'Traditional';
        app.Funding_Type__c = fundType;
        app.Funding_Status__c = 'Pending';
        app.Funding_Date__c = System.Today();
        app.Regular_Payment_Amount__c = 100.00;
        //app.SOR_Primary_Account_Number__c = '12345678912';
        app.PAP_Account_Number__c = '98745632';
        app.PAP_Transit_Code__c = '456';
        app.PAP_Bank_Code__c = '12';
        
        insert app;
        listProd.add(app);
        return listProd;
    }
    
    //create Customer
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
    
}