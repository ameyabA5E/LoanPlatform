@isTest
public with sharing class TestRecordsFactory {
    
    static RecordType personAccRecType;
    
    static{
        personAccRecType = [ select Id from RecordType where IsPersonType = true and SObjectType = 'Account' and DeveloperName = 'CustomerSalesforce'];
    }
    
    //Account Wrapper
    public class TestAccountWrapper {
        public String firstName;
        public String lastName;
        public String email;
        public String sin;  
        public Date birthDate;      
    }
    
    //Application Wrapper
    public class TestApplicationWrapper {
        public String name;
        public String firstName;
        public String lastName;
        public String email;
        public String sin; 
        public Date birthDate;
        public String manualReviewReason; 
        public Boolean needsManualReview;       
    }
    
    //Utility method to create Account record    
    public static Account createAccountRecordAndInsert(TestAccountWrapper accntWrapper, Boolean isInsert) {
        
        Account accnt = new Account(RecordTypeId = personAccRecType.Id);        
        accnt.FirstName = accntWrapper.firstName;
        accnt.LastName = accntWrapper.lastName;
        accnt.PersonEmail = accntWrapper.email;
        accnt.SIN__pc = accntWrapper.sin;  
        accnt.PersonBirthdate = accntWrapper.birthDate;
        
        if(isInsert == true){
            insert accnt;   
        }
        
        return accnt;   
    }    
    
    //Utility method to create Application record
    public static Application__c createApplicationRecordAndInsert(TestApplicationWrapper applntWrapper, Boolean isInsert) {
        
        Application__c appln = new Application__c();
        appln.name = applntWrapper.name;
        appln.First_Name__c = applntWrapper.firstName; 
        appln.Last_Name__c = applntWrapper.lastName;
        appln.Email_Address__c = applntWrapper.email;
        appln.SIN__c = applntWrapper.sin;
        appln.Loan_Type__c = 'Affirm Financial MasterCard';
        appln.Birth_Date__c = applntWrapper.birthDate;          
        appln.Manual_Review_Reason__c = applntWrapper.manualReviewReason; 
        
        if(applntWrapper.needsManualReview != null){
            appln.Needs_Manual_Review__c = applntWrapper.needsManualReview; 
        }        
        
        if(isInsert == true){
            insert appln;   
        }
        
        return appln;   
    } 
    
    //Insert Application_Form_Settings__c
    public static void initializePowerCurveMock() {
        Application_Form_Settings__c afSettings = new Application_Form_Settings__c(
            Power_Curve_Web_Service_URL__c = 'www.test.com',
            Power_Curve_Username__c = 'UserName', 
            Power_Curve_Password__c = 'PassWord', 
            Site_Profile_Id__c = '00eK0000000MDqzIAG'
        );
        insert afSettings;
    }
    
    //Utility method to create Attchment record
    public static void attchmentCreate(Application__c refreshApp){
        
        Attachment attach=new Attachment(); 
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob; 
        attach.parentId=refreshApp.Id; 
        attach.ContentType = 'application/msword'; 
        attach.IsPrivate = false; 
        attach.Description = 'Test'; 
        insert attach; 
    }  
    
    //Create TCI Job Setting Records
    public static void createTciCSRecords(){
        
        TCI_Job_Setting__c tcijobCS = New TCI_Job_Setting__c();
        tcijobCS.Account_ID_Prefix__c = 'PeoplesCA';
        tcijobCS.Agency_Name__c = 'AEOX'; 
        tcijobCS.Agency_Phone__c = '(226) 721-0671';
        tcijobCS.BT_Amount__c = 0;
        tcijobCS.Interest_Amount__c = 0; 
        tcijobCS.Original_Account_Number_Prefix__c = 'Powercurve';
        tcijobCS.Original_Creditor_Name__c = 'Wells Fargo.Affirm';
        tcijobCS.Pricing_Strategy_Default__c = 'OTB1';
        tcijobCS.Principal_Amount__c = 0;
        tcijobCS.Privacy_Policy__c = 'YES';
        tcijobCS.Skip_Delete_Days__c = 30;
        tcijobCS.Total_Due__c = 0;
        insert tcijobCS;
    }
    
    //Create CSR User
    public static User getCSRUser(){        
        User uzer = new User();
        uzer.Username = 'CSRTestUser@testOrg.com';
        uzer.FirstName = 'CSRTest';
        uzer.Lastname = 'TestUser';
        uzer.Email = 'CSRTestUser@testOrg.com';
        uzer.Alias = 'testals';
        uzer.TimeZoneSidKey = 'America/Los_Angeles';
        uzer.LocaleSidKey = 'en_US';
        uzer.EmailEncodingKey = 'UTF-8';
        uzer.LanguageLocaleKey = 'en_US';
        uzer.ProfileId = [SELECT Id FROM profile WHERE name='CFG - CSR'].Id;
        uzer.Phone='9161234456';
        uzer.Street='Some Street';
        uzer.City='Torranto';
        uzer.PostalCode='23456';
        uzer.Country = 'CAN';
        uzer.State = 'MA';
        uzer.isActive = true;        
        insert uzer;
        return uzer;       
    }
}