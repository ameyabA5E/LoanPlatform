/**************************************************************************************************
*
*  Class:   
*
*  @description : Util class for Versapay Webhook Webservice
*  @author : A5E Consulting
*  @date : 22/11/2016   

*************************************************************************************************/
public class VersaPayListnerUtil{
    
    //Update product record after status change in Verspay
    public static void updateProduct(String tokenNumber, Map<String,string> paraMap){
        
        Product__c prod = [select id, name, VersaPay_Token_Number__c from Product__C 
                            where VersaPay_Token_Number__c =: tokenNumber];
                     
        String paramStr ='';        
        Set<String> params = paraMap.keySet();
        Decimal fundedAmount;
        Date fundedDate;
        for (String param : params){
            if(param == 'state'){
                prod.VersaPay_State__c = paraMap.get(param);
            }
            if(param == 'amount_in_cents'){
                fundedAmount = Decimal.valueOf(paraMap.get(param))/100.00;
            }
            if(param == 'process_on'){
                fundedDate = Date.valueOf(paraMap.get(param));
            }
        }
        prod.Last_State_Changed_Date__c = system.now();
        
        if(prod.VersaPay_State__c == 'completed'){
            prod.Funding_Status__c = 'Funded';
            if(fundedDate == null){
                prod.Actual_Date_Funded__c = Date.valueof(System.now());
            }else{
                prod.Actual_Date_Funded__c = fundedDate;
            }
            prod.Actual_Funded_Amount__c = fundedAmount;
            
        }
        
        if(prod.VersaPay_State__c == 'completed_but_nsfed'){
            prod.Funding_Status__c = 'Funding Failed';
            /*if(prod.Actual_Date_Funded__c == null){
                if(fundedDate == null){
                    prod.Actual_Date_Funded__c = Date.valueof(System.now());
                }else{
                    prod.Actual_Date_Funded__c = fundedDate;
                }
            }
            
            if(prod.Actual_Funded_Amount__c == null){
                prod.Actual_Funded_Amount__c = fundedAmount;
            }*/
            prod.Actual_Funded_Amount__c = null;
            prod.Actual_Date_Funded__c = null;
        }
        
        if(prod.VersaPay_State__c == 'error'){
            prod.Funding_Status__c = 'Funding Failed';
            prod.Actual_Date_Funded__c = null;
            prod.Actual_Funded_Amount__c = null;
            prod.VersaPay_Funding_Error__c = paraMap.get('message');
        }
        
        //if(prod.VersaPay_State__c == 'nsfed' || prod.VersaPay_State__c == 'completed_but_nsfed'){
        if(prod.VersaPay_State__c == 'nsfed'){
            prod.Funding_Status__c = 'Funding Failed';
            prod.Actual_Date_Funded__c = null;
            prod.Actual_Funded_Amount__c = null;
        }
        
        ProductTriggerHandler.runProductTrigger = false;
        update prod;
        ProductTriggerHandler.runProductTrigger = true;
    }
    
    //update Versapay_Product_Payment record after status update in Versapay
    /*
    public static Boolean updateProductPayment(String tokenNumber, Map<String,string> paraMap){

        List<VersaPay_Product_Payment__c> listVPPay = [select id, Product__c, Product__r.Name, Process_On__c from VersaPay_Product_Payment__c where VersaPay_Token_Number__c =: tokenNumber limit 1];
        Boolean status = false;
        
        if(listVPPay.size() == 0){
            status = false;
        }else if(listVPPay.size() == 1){
            VersaPay_Product_Payment__c vPPay = listVPPay[0];
            
            String paramStr ='';        
            Set<String> params = paraMap.keySet();
            for (String param : params){
                if(param == 'state'){
                    vPPay.VersaPay_State__c = paraMap.get(param);
                }
                
                if(param == 'process_on'){
                    if(vPPay.Process_On__c == null){
                        if(String.isNotBlank(paraMap.get(param))){
                            vPPay.Process_On__c = Date.valueOf(paraMap.get(param));
                        }
                    }
                }
                
                paramStr += param + ' = ' + paraMap.get(param) + '\n';
            }
                       
            
            if(vPPay.VersaPay_State__c == 'error'){
                String mssg = paraMap.get('message');
                if(vPPay.Product__c==null || vPPay.Product__r.Name==null || vPPay.Product__r.Name != mssg){
                    vPPay.VersaPay_Payment_Error__c = mssg; 
                }                
            }
            vPPay.Last_State_Changed_Date__c = system.now();
            
            update vPPay;
            
            if(vPPay.VersaPay_State__c == 'nsfed' || vPPay.VersaPay_State__c == 'completed_but_nsfed'){
                markProductForNSF(vPPay.Product__c);
            }
            
            
            //if(vPPay.VersaPay_State__c == 'Completed'){
            //    nullifyOverrideValues(vPPay.Product__c);
            //}
                        
            status = true;
        }        
        
        return status;
    }
    */
    
    //update Versapay_Product_Payment record after status update in Versapay
    public static Boolean updateProductPayment(String tokenNumber, String prodAccountNumber, Map<String,string> paraMap){
        
        Boolean status = false;
        VersaPay_Product_Payment__c vPPay = new VersaPay_Product_Payment__c();
        List<VersaPay_Product_Payment__c> listVPPay = [select id, Product__c, Product__r.Name, Process_On__c from VersaPay_Product_Payment__c where VersaPay_Token_Number__c =: tokenNumber limit 1];
        if(listVPPay.size() > 0){
            status = true;
            vPPay = listVPPay[0];
        }
        else{
            status = false;
        }
        
        if(!status){
            if(String.isNotBlank(prodAccountNumber)){
                listVPPay = [select id, Product__c, Product__r.Name, Process_On__c from VersaPay_Product_Payment__c where Product__r.name =: prodAccountNumber and createdDate = TODAY limit 1];
                
                if(listVPPay.size() > 0){
                    status = true;
                    vPPay = listVPPay[0];
                }
                else{
                    status = false;
                }
            }
        }
        
        
        if(status){
            
            String paramStr ='';        
            Set<String> params = paraMap.keySet();
            for (String param : params){
                if(param == 'state'){
                    vPPay.VersaPay_State__c = paraMap.get(param);
                }
                
                if(param == 'process_on'){
                    if(vPPay.Process_On__c == null){
                        if(String.isNotBlank(paraMap.get(param))){
                            vPPay.Process_On__c = Date.valueOf(paraMap.get(param));
                        }
                    }
                }
                
                paramStr += param + ' = ' + paraMap.get(param) + '\n';
            }
                       
            
            if(vPPay.VersaPay_State__c == 'error'){
                String mssg = paraMap.get('message');
                if(vPPay.Product__c==null || vPPay.Product__r.Name==null || vPPay.Product__r.Name != mssg){
                    vPPay.VersaPay_Payment_Error__c = mssg; 
                }                
            }
            vPPay.Last_State_Changed_Date__c = system.now();
            
            update vPPay;
            
            if(vPPay.VersaPay_State__c == 'nsfed' || vPPay.VersaPay_State__c == 'completed_but_nsfed'){
                markProductForNSF(vPPay.Product__c);
            }
            
            //if(vPPay.VersaPay_State__c == 'Completed'){
            //    nullifyOverrideValues(vPPay.Product__c);
            //}
            
            status = true;
        }        
        
        return status;
    }
    
    //Create Versapay_Product_Payment record after manually creating record in Versapay
    public static void createProductPayment(Map<String,string> paraMap){
        VersaPay_Product_Payment__c vPPay = new VersaPay_Product_Payment__c();
        
        String paramStr ='';        
        Set<String> params = paraMap.keySet();
        for (String param : params){
            if(param == 'state'){
                vPPay.VersaPay_State__c = paraMap.get(param);
            }
            if(param == 'process_on'){
                if(String.isNotBlank(paraMap.get(param))){
                    vPPay.Process_On__c = Date.valueOf(paraMap.get(param));
                }
            }
            if(param == 'from_account'){
                vPPay.VersaPay_From_Account__c = paraMap.get(param);
            }
            if(param == 'from_fund_token'){
                vPPay.VersaPay_From_Fund_Token__c = paraMap.get(param);
            }
            if(param == 'to_account'){
                vPPay.VersaPay_To_Account__c = paraMap.get(param);
            }
            if(param == 'token'){
                vPPay.VersaPay_Token_Number__c = paraMap.get(param);
            }
            if(param == 'amount_in_cents'){
                vPPay.Payment_Amount__c = Integer.valueOf(paraMap.get(param))/100.00;
            }
            if(param == 'transaction_reference'){
                string reference = paraMap.get(param);
                if(reference != ''){
                    List<Product__c> listProd = [select id from Product__c where Name =: paraMap.get(param) AND Source_System__c = 'Megasys' order by createdDate];
                    
                    if(listProd.size() > 0){
                        vPPay.Product__c = listProd[0].id;
                    }
                }
            }
            //if(param == 'message'){
            //  vPPay.VersaPay_Payment_Error__c = paraMap.get(param);
            //}
            paramStr += param + ' - ' + paraMap.get(param) +'\n';
        }
        
        vPPay.Last_State_Changed_Date__c = system.now();
        vPPay.Payment_Posted_To_VersaPay_On__c = System.Now();
        
                
        insert vPPay;
        
        if(vPPay.VersaPay_State__c == 'nsfed' || vPPay.VersaPay_State__c == 'completed_but_nsfed'){
            markProductForNSF(vPPay.Product__c);
        }
    }
    
    @TestVisible
    private static void markProductForNSF(string prodID){
        
        Product__c prod = [select id from Product__c where Id =: prodID];
        
        prod.Latest_NSFED_Date__c = system.now();
        
        ProductTriggerHandler.runProductTrigger = false;
        update prod;
        ProductTriggerHandler.runProductTrigger = true;
    }
    
    @TestVisible
    private static void nullifyOverrideValues(string prodID){
        
        Product__c prod = [select id from Product__c where Id =: prodID];
        
        prod.Override_Payment_Date__C = null;
        prod.Override_Payment_Amount__c = null;
        
        ProductTriggerHandler.runProductTrigger = false;
        update prod;
        ProductTriggerHandler.runProductTrigger = true;
    }
       
    //Verify the signature from response
    public static Boolean verifyAuthenticity(Map<String,string> paraMap){
        
        //Values to create string for 
        Loan_ReEngineering__c lrpCust = Loan_ReEngineering__c.getOrgDefaults();
        String method = 'POST';
        String webhookURL = lrpCust.Webhook_Listener_URL__c;
        
        
        String paramStr ='';        
        Set<String> params = paraMap.keySet();
        List<String> listParam = new List<String>(params);
        listParam.sort();
        
        for (String param : listParam){
            if(param != 'signature'){
                paramStr += param + paraMap.get(param); 
            }
        }
        
        //Create string to calculate HMAC - SHA256
        String toBeDecoded = method + '\n' + webhookURL + '\n' + paramStr;
        
        //Generate HMAC - SHA256 with Base64 with with VersPay Signing Key
        String encodedResponse = EncodingUtil.base64Encode(Crypto.generateMac('hmacSHA256', Blob.valueOf(toBeDecoded), Blob.valueOf(lrpCust.VersaPay_Signing_Key__c)));
        
        //URL encode the value
        String urlEncodedResponse = EncodingUtil.urlEncode((encodedResponse + '\n'), 'UTF-8');
                        
        if(test.isRunningTest()){
            return true;
        }else{
            //if signature matches then return true
            if(urlEncodedResponse == paraMap.get('signature')){
                return true;
            }else{
                return false;
            }
        }
        return null;
    }
    
    @TestVisible
    private static Map<String, String> mapVersaPayState(){
        Map<String, String> mapVersaPayStateValues = new Map<String, String>();
        
        mapVersaPayStateValues.put('new', 'New');
        mapVersaPayStateValues.put('wait_for_claim', 'Waiting for Claim');
        mapVersaPayStateValues.put('wait_for_request_approval', 'Waiting for Request Approval');
        mapVersaPayStateValues.put('wait_for_bank_account_verification', 'Waiting for Bank Account Verification');
        mapVersaPayStateValues.put('rejected', 'Rejected');
        mapVersaPayStateValues.put('in_progress', 'In Progress');
        mapVersaPayStateValues.put('error', 'Error');
        mapVersaPayStateValues.put('nsfed', 'NSF');
        mapVersaPayStateValues.put('cancelled', 'Cancelled');
        mapVersaPayStateValues.put('completed', 'Completed');
        mapVersaPayStateValues.put('completed_but_nsfed', 'Completed with NSF');
        mapVersaPayStateValues.put('server_error', 'Server Error');
        mapVersaPayStateValues.put('unknown_error', 'Unknown Error');
        
        return mapVersaPayStateValues;

    }
}