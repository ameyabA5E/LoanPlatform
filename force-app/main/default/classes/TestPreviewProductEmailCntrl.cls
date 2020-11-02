/***************************************************
* Author         : A5E Consultancy
* Last Modified  : 27 Apr 2017
* Description    : Test class for PreviewProductEmailCntrl
* Methods        :
                   loadData() - Used to create necessary Object records in this test class
                   sendEmailtest() - Used to test sending Bill Email template to Customer
***************************************************/

@isTest (seeAllData = false)
public class TestPreviewProductEmailCntrl{
    // Setup Test Data for all test methods inside this class   
    @testsetup
    public static void loadData(){
         // Get Person Account Record Type Id
        String RecTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName(). get('Customer Salesforce').getRecordTypeId();
        
        // Create Person Account
        Account personAcc = new Account(
            RecordTypeID=RecTypeId,
            FirstName='Test FName',
            LastName='Test LName',
            PersonMailingStreet='test@yahoo.com',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail='test@yahoo.com',
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678' 
        );
        insert personAcc;
        
         // Create Person Account
        Account personAcc2 = new Account(
            RecordTypeID=RecTypeId,
            FirstName='Test FName',
            LastName='Test LName',
            PersonMailingStreet='test@yahoo.com',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678' 
        );
        insert personAcc2;
        
        // Create test user to avoid DML on setup, non-setup objects
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert u;
        
        // Create sample test email template
        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'Bill Plan Email Template';
        validEmailTemplate.DeveloperName = 'Bill_Plan_Email_Template';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.Body = '[$0.00]';
        validEmailTemplate.subject = 'test email';
        validEmailTemplate.HtmlValue = '[$0.00] {!Product__c.Name}';
        validEmailTemplate.FolderId = UserInfo.getUserId();

        // Run as other user context
        system.runAs(u){
            insert validEmailTemplate;
        }
        
        // Create Product record
        Product__c prod = new Product__c(Name = '12345', Customer__c = personAcc.Id, Payment_Amount__c = 10.00);
            insert prod;
    }
    
      // Method used to test email functionality
    public static testmethod void sendEmailtest(){
        Product__c prod = [SELECT Id FROM Product__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('Id', prod.Id);
        ApexPages.currentPage().getParameters().put('TemplateName', 'Bill Plan Email Template');
        PreviewProductEmailCntrl obj = new PreviewProductEmailCntrl();
        obj.createActivity();
    }
}