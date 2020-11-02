/**************************************************************************************************
*
*  Class:   
*
*  @description : Apex Test Class for DeleteProductSnapshotBatch    
*  @author : A5E Consulting
*  @date : 02/03/2017   

*************************************************************************************************/
@isTest
public class TestDeleteProductSnapshotBatch{

    public Static testMethod void delPrdSnapBatch(){
    
        //create Product Snapshot Custom Setting Record    
        createProductSnapCS();
        
        //create Product record
        createProduct();
        
        //create Product Cycle History record
        createPrdCycHis();
       
        //execute DeleteProductSnapshotBatch
        Database.executeBatch(New DeleteProductSnapshotBatch(), 200);
    }
    
    //create Product Cycle History record
    public static void createPrdCycHis(){
        
        Product_Cycle_History__c prdSnap = New Product_Cycle_History__c();
        prdSnap.Available_Credit_Amount__c = 100;
        prdSnap.Current_Average_Daily_Balance__c = 100;
        prdSnap.Current_Balance__c = 100;
        prdSnap.Last_Payment_Amount__c = 100;
        prdSnap.Last_Statement_Credit_Interest_Amount__c = 100;
        prdSnap.Product__c = createProduct().Id;
        prdSnap.Iteration_Number__c = 2;
        insert prdSnap;
    }
    
    //create Product records
    public static Product__c createProduct(){
        
        Product__c app = new Product__c();
        app.customer__c = createAccount().id;
        app.Product_Status__c = 'New';
        app.Funding_Amount__c = 1000.00;
        app.Loan_Process_Type__c = 'Traditional';
        app.Funding_Status__c = 'Pending';
        app.Funding_Date__c = System.Today();
        app.Regular_Payment_Amount__c = 100.00;
        //app.SOR_Primary_Account_Number__c = '12345678912';
        app.PAP_Account_Number__c = '98745632';
        app.PAP_Transit_Code__c = '456';
        app.PAP_Bank_Code__c = '12';
        
        insert app;
        
        return app;
    }

    //create Product Snapshot Custom Setting Record
    public static Product_Snapshot_Settings__c createProductSnapCS(){
        
        Product_Snapshot_Settings__c prdSnap = New Product_Snapshot_Settings__c();
        prdSnap.Iteration_Limit__c = 1;
        prdSnap.Next_Iteration__c = 2;
        
        insert prdSnap;
        
        return prdSnap;
    }
    
    //create Customer
    private static Account createAccount(){
        Account acc = new Account();
        
        acc.Salutation = 'Mr.';
        acc.FirstName = 'Asad';
        acc.Middle_Name__pc = 'Full';
        acc.LastName = 'Person';
        
        acc.PersonMailingState = 'ON';
        acc.PersonBirthdate = Date.newInstance(1983, 12, 2);
        acc.Gender__pc = 'Male';
        acc.Marital_Status__pc = 'Single';
        
        acc.Employer_Province__pc = 'ON';
        acc.Number_of_Dependants__pc = '0';
        acc.Home_Owner__pc = 'Own';
        acc.PersonMailingState = 'ON';
        
        acc.PersonHomePhone = '1235551234';
        acc.PersonEmail = 'asad.fullperson@test.com';
        acc.SIN__pc = '123456789';
        acc.PersonMobilePhone = '5551231234';
        acc.Work_Phone__pc = '1112223333';
        
        acc.Communication_Preference__pc = 'Email';
        acc.Monthly_Home_Expense__pc = 2000;
        acc.Monthly_Expense__pc = 500;
        
        acc.PersonMailingStreet = '4 Glenora';
        acc.PersonMailingCity = 'Brampton';
        acc.PersonMailingPostalCode = 'L6Y4K5';
        
        acc.Employer_Name__pc = 'Paper Empire';
        acc.Employer_Phone__pc = '9991231234';
        acc.Employer_Street_Name__pc = 'Brick Lane';
        acc.Employer_Street_Number__pc = '4';
        acc.Employer_City__pc = 'Brampton';
        acc.Employer_Postal_Code__pc = 'L6Y4K4';
        acc.Occupation__pc = 'Manager';
        acc.Employment_Years__pc = 3;
        acc.Employment_Months__pc = 10;
        acc.Gross_Monthly_Income__pc = 5000;
        
        insert acc;
        
        return acc;
    }
}