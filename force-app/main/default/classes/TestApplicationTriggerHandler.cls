/**************************************************************************************************
 *
 *  Class:   
 *
 *  @description : This class contains unit tests for validating behavior of ApplicationTriggerHandler
 *  @author : A5E Consulting
 *  @date : 04/14/2016
 *
 *  Change History:
 *
 *  Developer       Date          Description
 *  ------------------------------------------------------------------------------------------------
 *
 *  A5E Consulting 04/14/2016     Test Class created
 *  A5E Consulting 04/26/2016     Insert Test records
 *  A5E Consulting 04/26/2016     Test business methods  
 
 *************************************************************************************************/
//@isTest this class is private
public class TestApplicationTriggerHandler {

 /*   static testMethod void applicationTriggerHandlerTest() {
        
        List<Application__c> applnList = new List<Application__c>();
        Map<Id,Application__c> oldApplnMap = new Map<Id,Application__c>();
        
        ApplicationTriggerHandler.runApplicationLoadTrigger = false;
        
        insertCustomSettings();
        
        //Create Customer
        TestRecordsFactory.TestAccountWrapper accntWrapper = new TestRecordsFactory.TestAccountWrapper();
        accntWrapper.firstName = 'first';
        accntWrapper.lastName = 'last';
        accntWrapper.email = 'testuser@testOrg.com';
        Account accnt = TestRecordsFactory.createAccountRecordAndInsert(accntWrapper, true);
        
        //Mock Records
        //Mock New Record
        TestRecordsFactory.TestApplicationWrapper applnWrapper = new TestRecordsFactory.TestApplicationWrapper();
        applnWrapper.name = 'Mock App 1';
        applnWrapper.firstName = 'firstName1';
        applnWrapper.lastName = 'lastName1';
        applnWrapper.email = 'testuser1@testOrg.com';                
        Application__c appln1 = TestRecordsFactory.createApplicationRecordAndInsert(applnWrapper, true);
        appln1.decision__c = 'Approved';
        appln1.Application_Status__c  = 'CC Creation';
        appln1.customer__c = accnt.id;
        appln1.Permanent_Address_Street_Name__c = 'Old Street';
        appln1.Lender_Approved_Amount__c = 1200.00;
        upsert appln1;
        applnList.add(appln1);                
        //Mock Old Map 
        Application__c applnOld1 = TestRecordsFactory.createApplicationRecordAndInsert(applnWrapper, true);
        applnOld1.decision__c = 'Referred';
        applnOld1.Application_Status__c = 'Refer';
        applnOld1.Permanent_Address_Street_Name__c = 'New Street';
        applnOld1.Lender_Approved_Amount__c = 1500.00;
        oldApplnMap.put(appln1.Id, applnOld1);
        
        //Mock New Record
        applnWrapper = new TestRecordsFactory.TestApplicationWrapper();
        applnWrapper.name = 'Mock App 2';
        applnWrapper.firstName = 'firstName2';
        applnWrapper.lastName = 'lastName2';
        applnWrapper.email = 'testuser2@testOrg.com';                
        Application__c appln2 = TestRecordsFactory.createApplicationRecordAndInsert(applnWrapper, true);
        appln2.decision__c = 'Approved';
        appln2.Application_Status__c  = 'CC Creation';
        appln2.customer__c = accnt.id;
        upsert appln2;
        applnList.add(appln2);                
        //Mock Old Map 
        Application__c applnOld2 = TestRecordsFactory.createApplicationRecordAndInsert(applnWrapper, true);
        applnOld2.decision__c = 'Referred';
        applnOld2.Application_Status__c = 'Refer';
        oldApplnMap.put(appln2.Id, applnOld2);
        
        //Mock New Record
        applnWrapper = new TestRecordsFactory.TestApplicationWrapper();
        applnWrapper.name = 'Mock App 3';
        applnWrapper.firstName = 'firstName3';
        applnWrapper.lastName = 'lastName3';
        applnWrapper.email = 'testuser3@testOrg.com';                
        Application__c appln3 = TestRecordsFactory.createApplicationRecordAndInsert(applnWrapper, true);
        appln3.decision__c = 'Approved';
        appln3.Application_Status__c  = 'CC Creation';
        appln3.customer__c = accnt.id;
        upsert appln3;
        applnList.add(appln3);                
        //Mock Old Map 
        Application__c applnOld3 = TestRecordsFactory.createApplicationRecordAndInsert(applnWrapper, true);
        applnOld3.decision__c = 'Approved';
        applnOld3.Application_Status__c  = 'CC Creation';
        oldApplnMap.put(appln3.Id, applnOld3);
        
        //Mock New Record
        applnWrapper = new TestRecordsFactory.TestApplicationWrapper();
        applnWrapper.name = 'Mock App 4';
        applnWrapper.firstName = 'firstName4';
        applnWrapper.lastName = 'lastName4';
        applnWrapper.email = 'testuser4@testOrg.com';                
        Application__c appln4 = TestRecordsFactory.createApplicationRecordAndInsert(applnWrapper, true);
        appln4.decision__c = 'Approved';
        appln4.Application_Status__c  = 'CC Creation';
        appln4.customer__c = accnt.id;
        appln4.Permanent_Address_Street_Name__c = 'Old Street';
        appln4.Lender_Approved_Amount__c = 1200.00;
        upsert appln4;
        applnList.add(appln4);                
        //Mock Old Map 
        Application__c applnOld4 = TestRecordsFactory.createApplicationRecordAndInsert(applnWrapper, true);
        applnOld4.decision__c = 'Approved';
        applnOld4.Application_Status__c  = 'CC Creation';
        applnOld4.Permanent_Address_Street_Name__c = 'New Street';
        applnOld4.Lender_Approved_Amount__c = 1500.00;
        oldApplnMap.put(appln4.Id, applnOld4);
        
        //Mock New Record
        applnWrapper = new TestRecordsFactory.TestApplicationWrapper();
        applnWrapper.name = 'Mock App 5';
        applnWrapper.firstName = 'firstName5';
        applnWrapper.lastName = 'lastName5';
        applnWrapper.email = 'testuser5@testOrg.com';                
        Application__c appln5 = TestRecordsFactory.createApplicationRecordAndInsert(applnWrapper, true);
        appln5.decision__c = 'Completed';
        appln5.Application_Status__c  = 'Completed-CLI';
        appln5.customer__c = accnt.id;
        appln5.Permanent_Address_Street_Name__c = 'Old Street';
        appln5.Lender_Approved_Amount__c = 1200.00;
        upsert appln5;
        applnList.add(appln5);                
        
        //Mock test record
        //When Decision is Completed and Lender Approved Amount is null
        appln5.Lender_Approved_Amount__c = null;
        appln5.Decision__c = 'Completed';
        update appln5;  
        
        //Mock Old Map 
        Application__c applnOld5 = TestRecordsFactory.createApplicationRecordAndInsert(applnWrapper, true);
        applnOld5.decision__c = 'Referred';
        applnOld5.Application_Status__c  = 'Conditional';
        oldApplnMap.put(appln5.Id, applnOld5);
        
        //Run As CSR User
        User csrUser = TestRecordsFactory.getCSRUser();
        
        //Test the Method
        ApplicationTriggerHandler applnTrggrHandler = new ApplicationTriggerHandler();
        //Running Test as Complete User
        System.runAs(csrUser) {
            Test.startTest();
            System.Test.setMock(HttpCalloutMock.class, PowerCurveTestUtilities.getMockFullResponse());
            applnTrggrHandler.handleBeforeUpdate(applnList, oldApplnMap);
            applnTrggrHandler.handleAfterUpdate(applnList, oldApplnMap);
            Test.stopTest();  
        }
    }
        
    //Insert Custom Settings
    public static void insertCustomSettings() {
        Application_Form_Settings__c afSettings = new Application_Form_Settings__c(
            Power_Curve_Web_Service_URL__c = PowerCurveTestUtilities.Power_Curve_Web_Service_URL,
            Power_Curve_Username__c = PowerCurveTestUtilities.Power_Curve_Username, 
            Power_Curve_Password__c = PowerCurveTestUtilities.Power_Curve_Password, 
            Site_Profile_Id__c = '00eK0000000MDqzIAG'
        );
        insert afSettings;      
    }
    */
}