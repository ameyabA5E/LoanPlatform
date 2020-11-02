/**************************************************************************************************
 *
 *  Class:   
 *
 *  @description : This class contains unit tests for validating behavior of ProductTriggerHandler
 *  @author : A5E Consulting
 *  @date : 10/14/2016
 * 
 *************************************************************************************************/
@isTest 
private class TestProductTriggerHandler {
    
    //Initialize Custom Settings
    static {
        
        Loan_ReEngineering__c loanSettings = new Loan_ReEngineering__c();
        loanSettings.Run_Product_Validation_Trigger__c = true;
        loanSettings.Run_Product_Trigger__c = true;
        loanSettings.Run_Product_Before_Trigger__c = true;
        loanSettings.Load_Customer_Data__c = true;
        loanSettings.Canaccede_API_User__c = 'abc@xyz.com';
        insert loanSettings;         
    }
    
    //Test Before Update
    static testMethod void productBeforeUpdateTest(){
        
        Product__c prod = new Product__c();
        
        prod.name = '12345';
        prod.Payment_Setup_Status__c = 'Automated';
        prod.Funding_Status__c = 'Pending';
        prod.Funding_Type__c = 'Automated';
        prod.Disbursement_Amount__c = 2000.00;
        
        insert prod;
        
        Product__c prod1 = new Product__c();
        prod1.Payment_Setup_Status__c = 'Automated';
        prod1.Funding_Status__c = 'Pending';
        prod1.Funding_Type__c = 'Automated';
        prod1.Disbursement_Amount__c = 1000.00;
        
        insert prod1;
        
        List<Product__c> prodList = new List<Product__c>();
        prodList.add(prod);
        
        prod.Disbursement_Amount__c = 1000.00;
        update prod;
        
        Map<ID, Product__c> prodMap = new Map<ID, Product__c>();
        prodMap.put(prod.id, prod);
        
        ProductTriggerHandler.handleBeforeUpdate(prodList, prodMap);
        update prod;        
    }
    
    //Test Before Insert
    static testMethod void productBeforeInsertTest(){
        
        Id recordTypeId = Utilities.getProductRecordType('Megasys');
        
        List<Product__c> prodList = new List<Product__c>();
        Product__c prod = new Product__c();        
        prod.name = 'Prod1';
        prod.recordTypeId = recordTypeId;
        prod.Phone_Home__c = '12345678999';
        prod.Phone_Other__c = '8974563214';
        prod.Phone_Work__c = '27896541236';
        prod.Requested_Close_Date__c = null;
        prod.Closed_Date__c = null;
        prod.Payment_Due_Date__c = System.Today().addDays(-10);
        prod.Internal_Status__c = 'Active';
        prodList.add(prod);
        
        prod = new Product__c();        
        prod.name = 'Prod2';
        prod.recordTypeId = recordTypeId;
        prod.Phone_Home__c = '12345678999';
        prod.Phone_Other__c = '8974563214';
        prod.Phone_Work__c = '27896541236';
        prod.Requested_Close_Date__c = null;
        prod.Closed_Date__c = null;
        prod.Payment_Due_Date__c = System.Today().addDays(-190);
        prod.Internal_Status__c = 'Active';
        prodList.add(prod);
        
        prod = new Product__c();        
        prod.name = 'Prod2';
        prod.recordTypeId = recordTypeId;
        prod.Phone_Home__c = '12345678999';
        prod.Phone_Other__c = '8974563214';
        prod.Phone_Work__c = '27896541236';
        prod.Requested_Close_Date__c = null;
        prod.Closed_Date__c = null;
        prod.Payment_Due_Date__c = System.Today().addDays(20);
        prod.Internal_Status__c = 'Active';
        prodList.add(prod);
        
        prod = new Product__c();        
        prod.name = 'Prod3';
        prod.recordTypeId = recordTypeId;
        prod.Phone_Home__c = '12345678999';
        prod.Phone_Other__c = '8974563214';
        prod.Phone_Work__c = '27896541236';
        prod.Requested_Close_Date__c = null;
        prod.Closed_Date__c = System.Today().addDays(-50);
        prod.Payment_Due_Date__c = System.Today().addDays(-190);
        prod.Internal_Status__c = 'Active';
        prodList.add(prod);
        
        prod = new Product__c();
        prod.recordTypeId = recordTypeId;
        prod.name = 'Prod4';
        prod.Phone_Home__c = '55345678999';
        prod.Phone_Other__c = '8774563214';
        prod.Phone_Work__c = null;
        prod.Requested_Close_Date__c = System.Today();
        prodList.add(prod);

        prod = new Product__c();
        prod.recordTypeId = recordTypeId;
        prod.name = 'Prod5';
        prod.Phone_Home__c = null;
        prod.Phone_Other__c = null;
        prod.Phone_Work__c = null;
        prod.Requested_Close_Date__c = System.Today().addYears(-50);
        prodList.add(prod);
        
        ProductTriggerHandler.handleBeforeInsert(prodList);
    }
    
    //Test After Insert Update
    static testMethod void productAfterInsertUpdateTest(){
        Account customer = new Account(FirstName = 'FirstName', LastName = 'Last Name', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Salesforce').getRecordTypeId());
        insert customer;

        Account customer1 = new Account(FirstName = 'FirstName', LastName = 'Last Name', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Salesforce').getRecordTypeId());
        insert customer1;

        Product__c prod = new Product__c(First_Name__c = 'ProdFirstName', Last_Name__c = 'ProdLastName', Customer__c = customer.Id, Source_System__c ='FDR');

        List<Product__c> prodList = new List<Product__c>();
        prodList.add(prod);
        insert prodList;

        Map<ID, Product__c> prodMap = new Map<ID, Product__c>();
        prodMap.put(prod.id, prod);
        system.debug('calling 1 start'+prodList);
        ProductTriggerHandler.handleAferInsertUpdate(prodList, prodMap, true);
        system.debug('calling 1 end');
        Task tsk = new Task();
        tsk.WhatId = customer.Id;
        tsk.subject = 'Address Changes';
        tsk.OwnerId= UserInfo.getUserId();
        //insert tsk;
        
        Product__c prod1 = new Product__c(First_Name__c = 'ProdFirstName', Last_Name__c = 'ProdLastName', Customer__c = customer1.Id, Source_System__c ='FDR');
        insert prod1;
        prodList.add(prod1);
        prod.First_Name__c = 'changed';
        prod.Address_Last_Changed_Date__c = system.Today().addDays(-1);
        prod.Phone_Other__c = '123456';
        prod.Phone_Work__c = '123456';
        prod.Phone_Home__c = '123456';
        prod.Date_of_Birth__c = system.Today().addDays(-1);
        prod.State__c = 'CA';
        prod.Zip_Code__c = '123456';
        prod.City__c = 'NYC';
        prod.Address_Line1__c = 'Street 1';
        update prod;
        
        system.debug('calling 2 start'+prodList);
        ProductTriggerHandler.handleAferInsertUpdate(prodList, prodMap, true);
        system.debug('calling 2 end');
        prodMap.put(prod1.Id, prod);
        ProductTriggerHandler.handleAferInsertUpdate(prodList, prodMap, false);
    }
}