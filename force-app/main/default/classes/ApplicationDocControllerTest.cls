@isTest
public with sharing class ApplicationDocControllerTest {

    @TestSetup
    static void makeData(){   

        //Account wrapper
        TestRecordsFactory.TestAccountWrapper accntWrapper = new TestRecordsFactory.TestAccountWrapper();
        accntWrapper.firstName = 'first';
        accntWrapper.lastName = 'last';
        accntWrapper.email = 'testuser@testOrg.com';
        
        //account record
        Account accnt = TestRecordsFactory.createAccountRecordAndInsert(accntWrapper, true);
        
        //Applucation wrapper
        TestRecordsFactory.TestApplicationWrapper applnWrapper = new TestRecordsFactory.TestApplicationWrapper();
        applnWrapper.name = 'Mock App 1';
        applnWrapper.firstName = 'firstName1';
        applnWrapper.lastName = 'lastName1';
        applnWrapper.email = 'testuser1@testOrg.com';   

        //application record
        Application__c appln1 = TestRecordsFactory.createApplicationRecordAndInsert(applnWrapper, false);
        appln1.decision__c = 'Approved';
        appln1.Application_Status__c  = 'CC Creation';
        appln1.customer__c = accnt.id;
        appln1.Permanent_Address_Street_Name__c = 'Old Street';
        insert appln1;
    }

    static testMethod void testCase1(){

        User adminUSer = TestRecordsFactory.createAdminUser();     
        System.runAs(adminUSer) {
            Application__c application = [SELECT Id FROM Application__c LIMIT 1];

            PageReference pageRef = Page.ApplicationDoc;
            Test.setCurrentPage(pageRef);

            // Add parameters to page URL
            ApexPages.currentPage().getParameters().put('Id', application.Id);

            ApplicationDocController controller = new ApplicationDocController();
            controller.savePOCDoc();

            //check the pdf is created 
            System.assertEquals(1, [SELECT Count() FROM ContentDocumentLink WHERE LinkedEntityId =: application.Id]);
        }
    }
}