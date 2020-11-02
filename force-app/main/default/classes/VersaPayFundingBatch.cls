/**************************************************************************************************
*
*  Class:   
*
*  @description : Batch class that will process direct_credit transactions
*  @author : A5E Consulting
*  @date : 14/11/2016   

*************************************************************************************************/
global class VersaPayFundingBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
   // this class 
    public final String fundingBatchId;
    
    //constructor that pass funding batch record Id
    public VersaPayFundingBatch(String fundingBatchId){
        this.fundingBatchId = fundingBatchId;
    }
    
    //Query all the product records for Funding Batch record passed.
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        system.debug('Start Time :' + system.now());
        return Database.getQueryLocator([Select id, name, Disbursement_Amount__c, 
                                        Customer__r.PersonEmail, Customer__r.FirstName, Customer__r.LastName,
                                        PAP_Bank_Code__c, PAP_Transit_Code__c, PAP_Account_Number__c, First_Payment_Date__c, 
                                        Funding_Date__c, Funding_Source_Token__c 
                                        from Product__c
                                        WHERE Funding_Batch__c =: fundingBatchId 
                                        and Funding_Type__c = 'Automated'
                                        and Funding_Posted_To_VersaPay_On__c=null
                                         limit 50]);
    }
    
    //Use VersaPayWSUtil to send the request xml to VersaPay and update the Product record as per VersaPayResponse.
    global void execute(Database.BatchableContext BC, List<Product__c> prodList){
        System.debug('==='+prodList.size());
        system.debug('Batch Start Time :' + system.now());
        List<Product__c> productList = New List<Product__c>();
        List<API_Error__c> apiErrorList = New List<API_Error__c>();
        
        for(Product__c prod : prodList){
            
            API_Error__c apiError = New API_Error__c();
            
            //method that create direct_credit xml, parse reponse from the VersaPay    
            VersaPayWSUtil.VersaPayResponse resp = VersaPayWSUtil.createCreditRequest(prod, apiError);
            System.debug('resp ==='+resp );
            
            if(resp != null){
                
                if(String.isBlank(resp.errorMessage)){
                
                    if(String.isNotBlank(resp.versaPayTokenNumber)){
                        prod.VersaPay_Token_Number__c = resp.versaPayTokenNumber;
                    }
                    
                    if(String.isNotBlank(resp.versaPayFromFundToken)){
                        prod.VersaPay_From_Fund_Token__c = resp.versaPayFromFundToken;
                    }
                                        
                    if(String.isNotBlank(resp.versaPayToFundToken)){
                        prod.VersaPay_To_Fund_Token__c = resp.versaPayToFundToken;
                    }
                    
                    if(String.isNotBlank(resp.versaPayFromAccount)){
                        prod.VersaPay_From_Account__c = resp.versaPayFromAccount;
                    }
                    
                    if(String.isNotBlank(resp.versaPayToAccount)){
                        prod.VersaPay_To_Account__c = resp.versaPayToAccount;
                    }
                }   
            
                if(String.isNotBlank(resp.versaPayState)){
                    prod.VersaPay_State__c = resp.versaPayState;
                    
                    if(prod.VersaPay_State__c.equalsIgnoreCase('server_error') || prod.VersaPay_State__c.equalsIgnoreCase('unknown_error')){
                        prod.Funding_Status__c = 'Funding Failed';
                    }
                    
                    //if(String.isNotBlank(resp.errorDescription)){
                    prod.VersaPay_Funding_Error__c = resp.errorDescription;
                    //}
                }
                    
                prod.Last_State_Changed_Date__c = System.Now();
                prod.Funding_Posted_To_VersaPay_On__c = System.Now();
                
                productList.add(prod);
            }
            
            System.debug('apiError-Funding--'+apiError);
            if(apiError.Product__c != null){//apiError != null  
                System.debug('apiError Funding In: '+apiError);
                apiErrorList.add(apiError);
            }
        }
        
        //Update Product Records With VersaPay Responce
        if(productList.size() > 0){
            ProductTriggerHandler.runProductTrigger = false;
            update productList;  
            ProductTriggerHandler.runProductTrigger = true;
        }
        
        if(apiErrorList.size() >0){
            insert apiErrorList;
        }
        
        system.debug('Batch End Time :' + system.now());
    }
 
    
    global void finish(Database.BatchableContext BC){
        
        system.debug('End Time :' + system.now());
        
        List <Product__c> remaingCount = [Select id, name,Disbursement_Amount__c, 
                                        Customer__r.PersonEmail, Customer__r.FirstName, 
                                        Customer__r.LastName,PAP_Bank_Code__c, PAP_Transit_Code__c, 
                                        PAP_Account_Number__c, First_Payment_Date__c, 
                                        Funding_Date__c from Product__c
                                        WHERE Funding_Batch__c =: fundingBatchId 
                                        and Funding_Type__c = 'Automated' 
                                        and Funding_Posted_To_VersaPay_On__c=null];
       
        if(remaingCount!=null && remaingCount.size()>0){
            DateTime now  = DateTime.now();
            DateTime nextRunTime = now.addMinutes(2);
            String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year(); 
            System.schedule(VersaPayFundingSchedule.class.getName() + '-' + now.format(), cronString, new VersaPayFundingSchedule(fundingBatchId) );         //new VersaPayFundingSchedule(fundingBatchId)  
        }                            
    }
   
}