/**************************************************************************************************
*
*  Class:   
*
*  @description : This class contains unit tests for validating behavior of PAPInformationProductController 
*  @author : A5E Consulting
*  @date : 10/10/2016
*
*************************************************************************************************/

@isTest 
public class TestPAPInformationProductController{
    
   
    //Loan_ReEngineering__c Custom Settings
    static {
        
        Loan_ReEngineering__c loanSettings = new Loan_ReEngineering__c();
        loanSettings.File_Formats__c = '.pdf,.jpeg,.jpg';
        loanSettings.File_Size__c = 2097152;
        insert loanSettings;         
    }
    
    //Test Various Scenarios   
    static testMethod void paymentTest(){
        //Dummy Attachment
        Attachment attInvalid = new Attachment();
        attInvalid.body = Blob.valueof('Invalid File');
        attInvalid.name = 'invalid.xyz';
        
        //Dummy Attachment
        Attachment attValid = new Attachment();
        attValid.body = Blob.valueof('Valid File');
        attValid.name = 'valid.pdf';
        
        //Test Application
        Product__c app = new Product__c();
        app.loan_type__c  = 'Affirm Financial MasterCard';
        insert app;
        
        ApexPages.currentPage().getParameters().put('id', app.id);
        
        //Credit Card App
        PAPInformationProductController papInfoCtrl = new PAPInformationProductController();
        
        papInfoCtrl = new PAPInformationProductController();
        papInfoCtrl.acceptTermsCondition = true;
        papInfoCtrl.productRec.PAP_Transit_Code__c = 'abc';
        papInfoCtrl.productRec.PAP_Account_Number__c = 'xyz';
        papInfoCtrl.productRec.PAP_Bank_Code__c = 'pqr';
        papInfoCtrl.updatePaymentMethod();
        
        //No File Attachment
        papInfoCtrl = new PAPInformationProductController();
        papInfoCtrl.acceptTermsCondition = true;
        papInfoCtrl.productRec.PAP_Transit_Code__c = '123';
        papInfoCtrl.productRec.PAP_Account_Number__c = '456';
        papInfoCtrl.productRec.PAP_Bank_Code__c = '789';
        papInfoCtrl.updatePaymentMethod();
        
        //Invalid File Attachment 
        papInfoCtrl = new PAPInformationProductController();
        papInfoCtrl.papSupportDocument = attInvalid;
        papInfoCtrl.acceptTermsCondition = true;
        papInfoCtrl.productRec.PAP_Transit_Code__c = '123';
        papInfoCtrl.productRec.PAP_Bank_Code__c = '456';
        papInfoCtrl.productRec.PAP_Account_Number__c = '789';        
        papInfoCtrl.updatePaymentMethod();
        
        //Terms Conditionas not accepted
        papInfoCtrl = new PAPInformationProductController();
        papInfoCtrl.papSupportDocument = attValid;
        papInfoCtrl.acceptTermsCondition = false;
        papInfoCtrl.productRec.PAP_Transit_Code__c = '123';
        papInfoCtrl.productRec.PAP_Bank_Code__c = '456';
        papInfoCtrl.productRec.PAP_Account_Number__c = '789';        
        papInfoCtrl.updatePaymentMethod();
        
        //All OK
        papInfoCtrl = new PAPInformationProductController();
        papInfoCtrl.papSupportDocument = attValid;
        papInfoCtrl.acceptTermsCondition = true;
        papInfoCtrl.productRec.PAP_Transit_Code__c = '123';
        papInfoCtrl.productRec.PAP_Bank_Code__c = '456';
        papInfoCtrl.productRec.PAP_Account_Number__c = '789';        
        papInfoCtrl.updatePaymentMethod();
        papInfoCtrl.navigatePrevious();
        
    }    
}