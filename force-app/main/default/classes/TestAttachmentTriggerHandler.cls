/**************************************************************************************************
 *
 *  Class:   
 *
 *  @description : This class contains unit tests for validating behavior of AttachmentTriggerHandler
 *  @author : A5E Consulting
 *  @date : 10/14/2016
 * 
 *************************************************************************************************/
@isTest 
Private class TestAttachmentTriggerHandler {
    
    static {
        
        Loan_ReEngineering__c loanSettings = new Loan_ReEngineering__c();
        loanSettings.Run_Product_Validation_Trigger__c = true;
        loanSettings.Run_Product_Trigger__c = true;
        loanSettings.Run_Attachment_Trigger__c = true;
        insert loanSettings;         
    }
    
    static testMethod void attachmentTest(){
        
        //Run As CSR User
        User csrUser = TestRecordsFactory.getCSRUser();
        
        Product__c prod = new Product__c();
        prod.name = '12345';
        prod.Payment_Setup_Status__c = 'Automated';
        prod.Funding_Status__c = 'Pending';
        prod.Funding_Type__c = 'Automated';
        prod.Disbursement_Amount__c = 2000.00;
        insert prod;
        
        //Delete Attachment
        Attachment attchDelete = new Attachment();
        attchDelete.body = Blob.valueof('Test Body Delete');
        attchDelete.name = 'AttchDelete.pdf';
        attchDelete.parentId = prod.Id;
        insert attchDelete;
        List<Attachment> deleteList = new List<Attachment>();
        deleteList.add(attchDelete);
        System.runAs(csrUser) {
            AttachmentTriggerHandler.handleBeforeDelete(deleteList);
        }
                
        //Edit Attachment
        Attachment attchEdit = new Attachment();
        attchEdit.body = Blob.valueof('Test Body Edit');
        attchEdit.name = 'AttchEdit.pdf';
        attchEdit.parentId = prod.Id;
        insert attchEdit;
        List<Attachment> editList = new List<Attachment>();
        editList.add(attchEdit);        
        System.runAs(csrUser) {
            AttachmentTriggerHandler.handleBeforeEdit(editList);
        }
        
        delete attchDelete;
        
    } 
}