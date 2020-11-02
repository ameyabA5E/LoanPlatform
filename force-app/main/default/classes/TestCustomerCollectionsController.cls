/**************************************************************************************************
*
*  Class:   TestCustomerCollectionsController
*
*  @Description : This class contains unit tests for validating behavior of CustomerCollectionsController 
*  @Author      : A5E Consulting
*  @Date        : 06/02/2017
*
*************************************************************************************************/
@isTest(seeAllData = false)
private class TestCustomerCollectionsController{    
    static testMethod void testCustomerCollection(){
        
        //Dummy Account
        Account personAcc = new Account(LastName = 'test pesrson account', RecordTypeId =Schema.SObjectType.account.getRecordTypeInfosByName().get('Customer Salesforce').getRecordTypeId() );
        insert personAcc;
        
        //Dummy Product
        Product__c prod = new Product__c(Name = 'test prod',
                                          Source_System__c = 'FDR',
                                          Interest_Rate__c = 38.995, 
                                          Current_Balance__c = 20000, 
                                          Current_Balance_Effective_Date__c = system.today().addDays(-2), 
                                          Credit_Limit__c = 1000, 
                                          Card_Activated__c = 'FALSE', 
                                          Delinquency_Status__c = 'Delin status',
                                          Last_Delinquency_Date__c = system.today().addDays(-1),
                                          Customer__c = personAcc.Id,
                                          Delinquency_Cycles__c = 2,
                                          PRIN_Number__c = 200
                                          );
        insert prod;
        
        //Dummy PTP Information
        PTP_Information__c ptp = new PTP_Information__c(PTP_Date__c = system.Today().addDays(4), PTP_Mate__c = true, PTP_Amount__c = 2000, PTP_Method__c = 'online', Product__c = prod.Id);
        insert ptp;
        
        //Dummy Task with Due Date, Description too long
        task tsk = new task(Subject = 'task', Type_of_Activity__c='Collection', WhatId = personAcc.Id, Method_Of_Contact__c= 'Mobile', Operational_Outcome__c='PTP - Promise to Pay', Legal_Followup__c ='Initial Call', Best_Time_To_Call__c='9', ActivityDate=system.today().addDays(2), Description = 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using Content here, content here, making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for  will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose injected humour and the like');
        insert tsk;
        //Dummy Task with Staus completed and has due date
        task tsk1 = new task(Status = 'Completed', Subject = 'task', Type_of_Activity__c='Collection', WhatId = personAcc.Id, Method_Of_Contact__c= 'Mobile', Operational_Outcome__c='PTP - Promise to Pay', Legal_Followup__c ='Initial Call', Best_Time_To_Call__c='9', ActivityDate=system.today().addDays(2), Description = 'test');
        insert tsk1;
        //Dummy Task without due date
        task tsk2 = new task( Subject = 'task', Type_of_Activity__c='Collection', WhatId = personAcc.Id, Method_Of_Contact__c= 'Mobile', Operational_Outcome__c='PTP - Promise to Pay', Legal_Followup__c ='Initial Call', Best_Time_To_Call__c='9');
        insert tsk2;
        
        //Dummy Collection
        Collection_Notes__c coll = new Collection_Notes__c(Title__c = 'test collection', Body__c = 'test body', Type_of_Notes__c = 'Collections', Product__c = prod.Id);
        insert coll;

        
        ApexPages.currentPage().getParameters().put('id', personAcc.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(personAcc);
        CustomerCollectionsController obj = new CustomerCollectionsController(sc);
        obj.editAllNotes();
        obj.editAllCommentsAndNotes();
        obj.saveTaskActivity();
        obj.cancelButton();
        obj.saveDelinquentProducts();
    }
}