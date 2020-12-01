/**************************************************************************************************
 *
 *  Class:   TestEmailTrusteeController
 *
 *  @description : This class contains unit tests for send email trustee for Application and attachments
 *  @author : A5E Consulting
 *  @date : 11/22/2020
 * 
 *************************************************************************************************/

@isTest(seeAllData = false)
public class TestEmailTrusteeController {
    @testSetup 
     static void testData() {
        Application_Configuration_Settings__c appConfig = TestRecordsFactory.createApplicationMetadata();
        
        User adminUSer = TestRecordsFactory.createAdminUser();        
        
        TestRecordsFactory.TestAccountWrapper accntWrapper = new TestRecordsFactory.TestAccountWrapper();
        accntWrapper.firstName = 'first';
        accntWrapper.lastName = 'last';
        accntWrapper.email = 'testuser@testOrg.com';

        // Person Account
        Account accnt = TestRecordsFactory.createAccountRecordAndInsert(accntWrapper, false);
        accnt.Active__c = 'Yes';

        Account accntInvalid = TestRecordsFactory.createAccountRecordAndInsert(accntWrapper, false);
        accntInvalid.Active__c = 'No';
        accntInvalid.LastName = 'Invalid';
        accntInvalid.Communication_Preference__pc = 'Fax';
        accntInvalid.Fax='123-567';
        
        System.runAs(adminUSer){
            insert appConfig;
            insert accnt;
            insert accntInvalid;
        }

        TestRecordsFactory.TestApplicationWrapper applnWrapper = new TestRecordsFactory.TestApplicationWrapper();
        applnWrapper.name = 'Mock App 1';
        applnWrapper.firstName = 'firstName1';
        applnWrapper.lastName = 'lastName1';
        applnWrapper.email = 'testuser1@testOrg.com';                
        Application__c appln1 = TestRecordsFactory.createApplicationRecordAndInsert(applnWrapper, false);
        appln1.decision__c = 'Approved';
        appln1.Application_Status__c  = 'CC Creation';
        appln1.customer__c = accnt.id;
        appln1.Permanent_Address_Street_Name__c = 'Old Street';
        appln1.Customer__c = accnt.Id;
        
        System.runAs(adminUSer){
            insert appln1;
            TestRecordsFactory.attchmentCreate(appln1, 'description');
            EmailTemplate emailTemplateWithoutHeader = TestRecordsFactory.createEmailTemplateWithoutHeader();
            EmailTemplate emailTemplateWithHeader = TestRecordsFactory.createEmailTemplateWithHeader();
            insert emailTemplateWithHeader;
            EmailTemplate attRequiredEmailTemplate = TestRecordsFactory.createEmailTemplateWithHeader();
            attRequiredEmailTemplate.DeveloperName = 'AttRequired';
            insert attRequiredEmailTemplate;

            PoC_Package_Settings__c poc = TestRecordsFactory.createPOCSetting();
            poc.Insolvency_Template_Header__c = emailTemplateWithHeader.Id;
            poc.Insolvency_Template_WoHeader__c = emailTemplateWithoutHeader.Id;
            poc.Attachment_Required_Email_Templates__c = attRequiredEmailTemplate.Id;
            poc.Account_Statement_Not_Allowed__c = accntInvalid.Id;
            insert poc;
        }
     }

     static testMethod void sendEmailTestCheck(){
        Application__c appln = [SELECT Id FROM Application__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('Id', appln.Id);

        EmailTrusteeController obj = new EmailTrusteeController();
        obj.sendEmail();
     }

     static testMethod void testCheckEligibleTrustee(){
        Account acc = [SELECT Id FROM Account WHERE LastName = 'Invalid'];
        Application__c appln = [SELECT Id, Customer__c FROM Application__c LIMIT 1];
        appln.Customer__c = acc.Id;
        update appln;
        Attachment att = [SELECT Id, Description FROM Attachment WHERE ParentId =: appln.Id];
        ApexPages.currentPage().getParameters().put('Id', appln.Id);

        EmailTrusteeController obj = new EmailTrusteeController();
        obj.mySelectedAtt.add(att.Id);
        obj.sendEmail();

        att.Description = 'Account Statement';
        update att;
        obj.sendEmail();


     }

     static testMethod void testCheckEligibleTrustee1(){
        Account acc = [SELECT Id FROM Account WHERE LastName = 'Invalid'];
        Application__c appln = [SELECT Id, Customer__c FROM Application__c LIMIT 1];

        Attachment att = [SELECT Id, Description FROM Attachment WHERE ParentId =: appln.Id];
        ApexPages.currentPage().getParameters().put('Id', appln.Id);

        EmailTrusteeController obj = new EmailTrusteeController();
        

        Id  attRequired= [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'AttRequired' LIMIT 1].Id;
        obj.selectedTemplate = attRequired;
        obj.mySelectedAtt.add(att.Id);
        obj.sendEmail();

     }

     static testMethod void testCheckEligibleTrustee2(){
        Account acc = [SELECT Id FROM Account WHERE LastName = 'Invalid'];
        Application__c appln = [SELECT Id, Customer__c FROM Application__c LIMIT 1];

        Attachment att = [SELECT Id, Description FROM Attachment WHERE ParentId =: appln.Id];
        ApexPages.currentPage().getParameters().put('Id', appln.Id);

        EmailTrusteeController obj = new EmailTrusteeController();
        

        EmailTemplate  emailTemp = [SELECT Id FROM EmailTemplate WHERE DeveloperName != 'AttRequired' LIMIT 1];

        obj.selectedTemplate = emailTemp.Id;
        obj.toEmail = 'test@test.com;';
        obj.attachmentSelected = att.Id;
        obj.attachmentSelected();
        obj.mySelectedAtt.add(att.Id);
        obj.sendEmail();
        obj.attachmentRemoved();
        att.Description='PoC Document';
        update att;
        obj.sendEmail();
     }
     
}