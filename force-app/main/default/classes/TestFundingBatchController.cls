/**************************************************************************************************
*
*  Class:   
*
*  @description : This class contains unit tests for validating behavior of FundingBatchController 
*  @author : A5E Consulting
*  @date : 07/05/2016
*
*  Change History:
*
*  Developer       Date          Description
*  ------------------------------------------------------------------------------------------------
*
*  A5E Consulting 07/05/2016     Class created

*************************************************************************************************/
@isTest
public class TestFundingBatchController {
    
    static private Map<String, List<String>> streetAddressMap = new Map<String, List<String>>();
    
    static testmethod void testFundingBatchCntrl(){
        
        List<Product__c> listProd = new List<Product__c>();
        for(integer i = 0; i < 10; i++){
            listProd.add(createProduct('Automated'));
        }
        
        Funding_Batch__c fb = new Funding_Batch__c();
        fb.Name = 'Test Batch';
        fb.Released_Date__c = system.today();
        insert fb;
        
        
        
        Pagereference pg = Page.FundingBatchView;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('id',fb.id); 
        ApexPages.StandardController sc = new ApexPages.standardController(fb);
        FundingBatchController fbc = new FundingBatchController(sc);
        
        LoanUtility.ProductGroupWrapper prodWrapGrpObj = new LoanUtility.ProductGroupWrapper();
        List<LoanUtility.ProductGroupWrapper> prodWrapGrpObjList = new List<LoanUtility.ProductGroupWrapper>();
        prodWrapGrpObj.groupDate = '2016/09/30';
        prodWrapGrpObj.totalFundingAmount = 100;
        prodWrapGrpObjList.add(prodWrapGrpObj);
        
        fbc.reCalculate();
        fbc.productWrapperGroup = prodWrapGrpObjList;
        FundingBatchController.selectAll = true;
        fbc.selectAll();
        fbc.releaseFund();
    }
    
    static testmethod void testFundingBatchCntrl2(){
        
        List<Product__c> listProd = new List<Product__c>();
        for(integer i = 0; i < 10; i++){
            if(i/2 == 0)
                listProd.add(createProduct('Automated'));
            else
                listProd.add(createProduct('Manual'));
        }
        
        // List<LoanUtility.ProductGroupWrapper> productWrapperGroup 
        
        Funding_Batch__c fb = new Funding_Batch__c();
        ApexPages.StandardController sc = new ApexPages.standardController(fb);
        FundingBatchController fbc = new FundingBatchController(sc);
        fbc.reCalculate();
        FundingBatchController.selectAll = false;
        fbc.selectAll();
        
        fbc.releaseFund();
        
        ApexPages.currentPage().getParameters().put('id', fb.id);
        fbc = new FundingBatchController(sc);
        
    }
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
        
        // Set appropriate entry in Street address map (for later convenience)
        List<String> address = new List<String>();
        address.add('4');
        address.add('Glenora');
        streetAddressMap.put(p.PersonMailingStreet, address);
        
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
        
        insert app;
        return app;
    }
    
    }