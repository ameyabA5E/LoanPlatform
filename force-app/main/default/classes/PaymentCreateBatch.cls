/**************************************************************************************************
*
*  Class:  PaymentCreateBatch 
*
*  @description : Batch class that will process direct_debit transactions
*  author : A5E Consulting
*
*  @date : 27/02/2017   
*************************************************************************************************/

global class PaymentCreateBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    //Query all the product records for Payment Setup Batch record passed.
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator([Select id, name, /*SOR_External_ID__c,*/ Disbursement_Amount__c, 
                                        Customer__r.PersonEmail, Customer__r.FirstName, Customer__r.LastName,
                                        PAP_Bank_Code__c, PAP_Transit_Code__c, PAP_Account_Number__c, 
                                        Override_Payment_Date__c, First_Payment_Date__c, //Next_Payment_Date__c, 
                                        Override_Payment_Amount__c, First_Payment_Amount__c,//Next_Payment_Amount__c,
                                        SP_Override_Payment_Date__c, SP_Next_Payment_Due_Date__c, SP_First_Payment_Date__c,
                                        Payment_Amount__c, Payment_Due_Date__c,
                                        Funding_Source_Token__c 
                                        from Product__c 
                                        WHERE Hold_Payments__c = false
                                        AND (Funding_Status__c = 'Funded' OR Funding_Status__c = 'Manually Funded')
                                        AND Payment_Setup_Status__c = 'Automated' 
                                        //AND External_Status_Current__c = 'Active'
                                        AND Closed_Date__c = null
                                        AND Payment_Released_Date__c != TODAY 
                                        AND (Override_Payment_Amount__c != null OR Payment_Amount__c != null OR First_Payment_Amount__c != null)
                                        AND ((SP_Override_Payment_Date__c != null AND SP_Override_Payment_Date__c = TODAY)
                                            OR (SP_Override_Payment_Date__c = null AND SP_Next_Payment_Due_Date__c = TODAY)
                                            OR (SP_Override_Payment_Date__c = null AND SP_Next_Payment_Due_Date__c = null AND SP_First_Payment_Date__c = TODAY))]);
    }
    
    //Create PAyment Records in Salesforce
    global void execute(Database.BatchableContext BC, List<Product__c> prodList){
        
        // Used to store new VersaPayment records
        List<VersaPay_Product_Payment__c> prodPayList = New List<VersaPay_Product_Payment__c>();    
        
        // Used to update product with Payment_Released_Date__c
        List<Product__c> prdList = New List<Product__c>();    

        for(Product__c prod : prodList){
            
            //Create VersaPay Payment record
            VersaPay_Product_Payment__c prodPay = New VersaPay_Product_Payment__c();
            prodPay.Product__c = prod.Id;
            
            //Payment amount
            Decimal amountInCents = VersaPayWSUtil.countAmountInCentsDebit(prod.Override_Payment_Amount__c, prod.Payment_Amount__c, prod.First_Payment_Amount__c, prod.SP_First_Payment_Date__c);
            if(amountInCents != null){
                prodPay.Payment_Amount__c = amountInCents/100; 
            }
            
            //Get effective payment date
            prodPay.Process_On__c = VersaPayWSUtil.effectiveDateForPayment(prod);
            
            prodPayList.add(prodPay);
            
            //Update Product record 
            prod.Payment_Released_Date__c = (system.now()).date();
            prod.Override_Payment_Amount__c = null;
            prod.Override_Payment_Date__c = null;                    
                    
            prdList.add(prod);         
        }
        
        //Insert Payment Records
        if(prodPayList.size() >0){
            insert prodPayList;
            system.debug('New prodPay = '+prodPayList);
        }
        
        //Update Products - Ameya please confirm this update should happen here or in Payment Batch
        if(prdList.size() >0){
            ProductTriggerHandler.runProductTrigger = false;
            update prdList;
            ProductTriggerHandler.runProductTrigger = true;
        }  
    }
        
    global void finish(Database.BatchableContext BC){
        
        //Initiate Payment Processing batch
        Database.executeBatch(New PaymentProcessingBatch(), 1);                                  
    }       
}