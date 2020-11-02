/**************************************************************************************************
*
*  Class    :  PaymentProcessingBatch 
*
*  @description : Batch class that will process direct_debit transactions
*  author : A5E Consulting
*
*  @date : 28/02/2017   

*************************************************************************************************/

global class PaymentProcessingBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    //Query all the product records for Payment Setup Batch record passed.
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator([SELECT Id,
                                                Name,
                                                Product__r.Name, 
                                                Product__r.Customer__r.PersonEmail, 
                                                Product__r.Funding_Source_Token__c,
                                                Product__r.Customer__r.LastName, 
                                                Product__r.PAP_Bank_Code__c, 
                                                Product__r.PAP_Transit_Code__c, 
                                                Product__r.PAP_Account_Number__c,
                                                Product__r.Customer__r.FirstName, 
                                                //VersaPay_Token_Number__c, 
                                                VersaPay_From_Fund_Token__c, 
                                                VersaPay_To_Fund_Token__c, 
                                                VersaPay_From_Account__c, 
                                                VersaPay_To_Account__c, 
                                                Process_On__c, 
                                                Payment_Amount__c, 
                                                Last_State_Changed_Date__c, 
                                                Payment_Posted_To_VersaPay_On__c, 
                                                VersaPay_State__c, 
                                                VersaPay_Payment_Error__c, 
                                                Product__c 
                                                FROM VersaPay_Product_Payment__c                                                  
                                                WHERE Createddate = Today 
                                                AND Payment_Posted_To_VersaPay_On__c=null 
                                                AND Process_On__c!=null  
                                                limit 5]);
    }
    
     //Use VersaPayWSUtil to send the request xml to VersaPay and Create n requests for n Term.
    global void execute(Database.BatchableContext BC, List<VersaPay_Product_Payment__c> prodPayList){
        
        List<Id> prodPayIds = new List<Id>(); // Stores all versa pay record Ids
        
        for(VersaPay_Product_Payment__c prodPay : prodPayList){
            prodPayIds.add(prodPay.Product__c);
        }
        
        // Get corresponding product of Versa Payment records
        List<Product__c> prodMap = [Select id,Name, Override_Payment_Amount__c, Override_Payment_Date__c, Payment_Released_Date__c
                                        from Product__c 
                                        WHERE Hold_Payments__c = false
                                        AND Id IN : prodPayIds];
                                        
        // Map is used to return product while processing VersaPay records
        Map<Id, Product__c> prodIdMap = new Map<Id, Product__c>(); 
        for(Product__c p : prodMap){
            prodIdMap.put(p.Id, p);
        }
        
        // Used to store Versa Payment records that needs to be update
        List<VersaPay_Product_Payment__c> prodPayListUpdate = New List<VersaPay_Product_Payment__c>();
        List<Product__c> prodUpdateList = New List<Product__c>();
        List<API_Error__c> apiErrorList = New List<API_Error__c>();
        
        
        for(VersaPay_Product_Payment__c prodPay: prodPayList){
            system.debug('prodPay ==='+prodPay);
            // Get corresponding product of this Versa payment record
            Product__c prod = prodIdMap.get(prodPay.Product__c);
            
            API_Error__c apiError = New API_Error__c();
            
            // Create debit request for versa payment
            VersaPayWSUtil.VersaPayResponse resp = VersaPayWSUtil.createDebitRequestWithPayments(prodPay, apiError);
            if(resp != null ){                
                
                if(String.isBlank(resp.errorMessage)){
                    
                    if(String.isNotBlank(resp.versaPayTokenNumber)){
                        prodPay.VersaPay_Token_Number__c = resp.versaPayTokenNumber;
                    }
                    
                    if(String.isNotBlank(resp.versaPayFromFundToken)){
                        prodPay.VersaPay_From_Fund_Token__c = resp.versaPayFromFundToken;
                    }
                                        
                    if(String.isNotBlank(resp.versaPayToFundToken)){
                        prodPay.VersaPay_To_Fund_Token__c = resp.versaPayToFundToken;
                    }
                    
                    if(String.isNotBlank(resp.versaPayFromAccount)){
                        prodPay.VersaPay_From_Account__c = resp.versaPayFromAccount;
                    }
                    
                    if(String.isNotBlank(resp.versaPayToAccount)){
                        prodPay.VersaPay_To_Account__c = resp.versaPayToAccount;
                    }
                }
                
                prodPay.Last_State_Changed_Date__c = System.Now();
                prodPay.Payment_Posted_To_VersaPay_On__c = System.Now();
                prodPay.VersaPay_State__c = resp.versaPayState;
                
                //Update if any error on creating debit request
                prodPay.VersaPay_Payment_Error__c = resp.errorDescription;
                prodPayListUpdate.add(prodPay);
            }
            
            if(apiError != null && String.isNotBlank(apiError.Response__c)){
                apiErrorList.add(apiError);
            }
            
            // Ameya - Please confirm is this update should happen here or in payment create batch class 
            //prod.Payment_Released_Date__c = (system.now()).date();
            //prodUpdateList.add(prod);
        }
        
        // Update VeraPayment
        if(prodPayListUpdate.size() >0){
            update prodPayListUpdate;
        }
        
        // Update product with Payment_Released_Date__c as TODAY -- confirm based on line 127
        if(prodUpdateList.size() >0){
            ProductTriggerHandler.runProductTrigger = false;
            update prodUpdateList;
            ProductTriggerHandler.runProductTrigger = true;
        }       
        
        for(API_Error__c api : apiErrorList){
            for(VersaPay_Product_Payment__c proPayset : prodPayList){
                System.debug('ID: '+api.Product__c +'='+ proPayset.Product__c);
                if(api.Product__c == proPayset.Product__c){
                    api.VersaPay_Product_Payment__c = proPayset.ID;
                }
            }
        }
        
        if(apiErrorList.size() >0){
            insert apiErrorList;
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
        system.debug('End Time :' + system.now());
        Integer remainingCount = [SELECT COUNT() FROM VersaPay_Product_Payment__c WHERE Createddate = Today AND Payment_Posted_To_VersaPay_On__c =null AND Process_On__c!=null];
       
        if(remainingCount >0){
            DateTime now  = DateTime.now();
            DateTime nextRunTime = now.addMinutes(1);
            String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year(); 
            System.schedule(PaymentProcessingSchedule.class.getName() + '-' + now.format(), cronString, new PaymentProcessingSchedule());           
        }                            
    }
}