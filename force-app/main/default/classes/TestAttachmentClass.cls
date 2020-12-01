/**************************************************************************************************
 *
 *  Class:   TestAttachmentClass
 *
 *  @description : This is a testclass.
 *  @author : A5E Consulting
 *  @date : 11/23/2020
 *  
 *************************************************************************************************/
@isTest
public class TestAttachmentClass {

    @isTest public static void testFileUploads()
    {
        TestRecordsFactory.TestAccountWrapper accntWrapper = new TestRecordsFactory.TestAccountWrapper();
        accntWrapper.firstName = 'first';
        accntWrapper.lastName = 'last';
        accntWrapper.email = 'testuser@testOrg.com';

        // Person Account
        Account accnt = TestRecordsFactory.createAccountRecordAndInsert(accntWrapper, false);
        accnt.Active__c = 'Yes';
        insert accnt;

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
        insert appln1;

        //contenVersion record creation
        String contentBody = 'This is a test string';
        ContentVersion contentVersion = TestRecordsFactory.createContentVersion(contentBody);
        contentVersion.Title = 'TestFile';
        contentVersion.PathOnClient= 'ionicLogo.png';
        insert contentVersion;

        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersion.Id].ContentDocumentId;
        ContentDocument contentDoc = new ContentDocument(Id = conDocId, Description = '01-01-2020');
        update contentDoc;
        //ContentDocumentLink record Creation
        ContentDocumentLink cDe = TestRecordsFactory.createContentDocumentLink(conDocId, appln1.Id);
        insert cDe;

        //Calling Apex methods
        AttachmentClass.getAttachment(appln1.id);
        AttachmentClass.getPickListValuesIntoList();
        AttachmentClass.monthList();
        AttachmentClass.yearList();
    }
}