/**************************************************************************************************
*
*  Class:   
*
*  @description : Webservice for Versapay Webhook
*  @author : A5E Consulting
*  @date : 16/11/2016   

*************************************************************************************************/
@RestResource(urlMapping='/VersaPay/*')
global class VersaPayListner{
    
    //Webhook function
    @HttpPost
    global static string listenWebHook(){
    
        //Store Response
        RestRequest req = RestContext.request;
        Map<String,string> paramMap = req.params; 
        System.debug('paramMap :'+paramMap);
        
        //Parse the parameters
        String paramStr ='';        
        Set<String> params = paramMap.keySet();
        for (String param : params){
            paramStr += param + ' - ' + paramMap.get(param) +'\n';
        }
        
        String result = '';
        if(VersaPayListnerUtil.verifyAuthenticity(paramMap)){
            
            //Decision variables
            String transactionType = paramMap.get('transaction_type');
            String tokenNumber = paramMap.get('token');
            String prodAccountNumber = paramMap.get('transaction_reference');
            
            //Direct Credit Transaction - Funding transaction
            if(transactionType == 'direct_credit'){
                VersaPayListnerUtil.updateProduct(tokenNumber, paramMap);
            }else if(transactionType == 'direct_debit' || transactionType == 'request_money'){//Direct Debit Transaction - Payment transaction
                if(VersaPayListnerUtil.updateProductPayment(tokenNumber, prodAccountNumber, paramMap)){
                    
                }else{//Direct Debit Transaction - Manually created Payment transaction
                    VersaPayListnerUtil.createProductPayment(paramMap);
                }
            }
            result = 'Completed';
        }else{
            result = 'Sign is wrong';
        }     
        
        return null;
    }
}