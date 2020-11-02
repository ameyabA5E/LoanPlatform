/**************************************************************************************************
*
*  Class:   
*
*  @description : TestVersaPayListnerUtil for Versapay
*  @author : A5E Consulting
*  @date : 07/12/2016   

*************************************************************************************************/
@isTest
public class TestVersaPayListnerUtil{
    
     //Loan_ReEngineering__c Custom Settings
   static {
        
        Loan_ReEngineering__c loanSettings = new Loan_ReEngineering__c();
        loanSettings.Webhook_Listener_URL__c = 'https://sb-affirmfinancial.cs22.force.com/services/apexrest/VersaPay';
        loanSettings.VersaPay_Signing_Key__c = 'xJ_hZrx1foK4JaDp8r5y';
        insert loanSettings;         
    }
    
    static testMethod void createPaymentTestMethod(){
        
        VersaPayListnerUtil.mapVersaPayState();
        
        Product__c prod = new Product__c();
        prod.name = '12345';
        //prod.VersaPay_Token_Number__c = '1IXL5IX3D2IM';
        prod.Source_System__c = 'Megasys';     
        insert prod;
        
        //VersaPay_Product_Payment__c vpPay = new VersaPay_Product_Payment__c();
        //vpPay.Product__c = prod.id;
        //vpPay.VersaPay_Token_Number__c = '1IXL5IX3D2IM';
        //insert vpPay;
                
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof('Blob[0]');
        
        req.addParameter('amount_in_cents', '9175');
        req.addParameter('created_by_user','yujpqgPa_vscKNcz8Gkf');
        req.addParameter('email', '');
        req.addParameter('to_account', 'Canaccede');
        req.addParameter('to_fund', 'VersaPay Balance');
        req.addParameter('message', '');
        req.addParameter('process_on', '');
        req.addParameter('signature', 'chLtBK7zl7wBg8QCSceORjAyPydfUSj%2FpMOgaxlLgUI%3D%0A');
        req.addParameter('state', 'nsfed');
        req.addParameter('type', 'transaction');
        req.addParameter('transaction_type', 'direct_debit');
        req.addParameter('token', '1IXL5IX3D2IM');
        req.addParameter('transaction_reference', '12345');
        //req.addParameter('unique_reference', '12345');
        req.addParameter('link_url ', '');
        req.addParameter('auto_withdraw ', 'false');
        req.addParameter('auto_withdrawal_token', '');
        req.addParameter('from_account', 'KIMBERLY POND');
        req.addParameter('from_fund_token', 'BA9V6XLJD8TP');
                    
        req.requestURI = '/VersaPay';  
        req.httpMethod = 'POST';
        req.resourcePath = '/services/apexrest/VersaPay/*';
        
        RestContext.request = req;
        RestContext.response = res;
        
        VersaPayListner.listenWebHook();
    }
    
    static testMethod void updateProductTestMethod(){
        
        Product__c prod = new Product__c();
        prod.name = '12345';
        prod.VersaPay_Token_Number__c = '1IXL5IX3D2IM';
        
        insert prod;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof('Blob[0]');
        
        req.addParameter('amount_in_cents', '9175');
        req.addParameter('created_by_user','yujpqgPa_vscKNcz8Gkf');
        req.addParameter('email', '');
        req.addParameter('to_account', 'Canaccede');
        req.addParameter('to_fund', 'VersaPay Balance');
        req.addParameter('message', '');
        req.addParameter('process_on', '2016-11-20');
        req.addParameter('signature', 'chLtBK7zl7wBg8QCSceORjAyPydfUSj%2FpMOgaxlLgUI%3D%0A');
        req.addParameter('state', 'completed');
        req.addParameter('type', 'transaction');
        req.addParameter('transaction_type', 'direct_credit');
        req.addParameter('token', '1IXL5IX3D2IM');
        req.addParameter('transaction_reference', '');
        req.addParameter('unique_reference', '');
        req.addParameter('link_url ', '');
        req.addParameter('auto_withdraw ', 'false');
        req.addParameter('auto_withdrawal_token', '');
        req.addParameter('from_account', 'KIMBERLY POND');
        req.addParameter('from_fund_token', 'BA9V6XLJD8TP');
                    
        req.requestURI = '/VersaPay';  
        req.httpMethod = 'POST';
        req.resourcePath = '/services/apexrest/VersaPay/*';
        
        RestContext.request = req;
        RestContext.response = res;
        
        VersaPayListner.listenWebHook();
    }
    
    static testMethod void updateProductPaymentTestMethod(){
        
        Product__c prod = new Product__c();
        prod.name = '12345';
        
        insert prod;
        
        VersaPay_Product_Payment__c vpPay = new VersaPay_Product_Payment__c();
        vpPay.Product__c = prod.id;
        vpPay.VersaPay_Token_Number__c = '1IXL5IX3D2IM';
        insert vpPay;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof('Blob[0]');
        
        req.addParameter('amount_in_cents', '9175');
        req.addParameter('created_by_user','yujpqgPa_vscKNcz8Gkf');
        req.addParameter('email', '');
        req.addParameter('to_account', 'Canaccede');
        req.addParameter('to_fund', 'VersaPay Balance');
        req.addParameter('message', '');
        req.addParameter('process_on', '2016-11-20');
        req.addParameter('signature', 'chLtBK7zl7wBg8QCSceORjAyPydfUSj%2FpMOgaxlLgUI%3D%0A');
        req.addParameter('state', 'nsfed');
        req.addParameter('type', 'transaction');
        req.addParameter('transaction_type', 'direct_debit');
        req.addParameter('token', '1IXL5IX3D2IM');
        req.addParameter('transaction_reference', '');
        req.addParameter('unique_reference', '');
        req.addParameter('link_url ', '');
        req.addParameter('auto_withdraw ', 'false');
        req.addParameter('auto_withdrawal_token', '');
        req.addParameter('from_account', 'KIMBERLY POND');
        req.addParameter('from_fund_token', 'BA9V6XLJD8TP');
                    
        req.requestURI = '/VersaPay';  
        req.httpMethod = 'POST';
        req.resourcePath = '/services/apexrest/VersaPay/*';
        
        RestContext.request = req;
        RestContext.response = res;
        
        VersaPayListner.listenWebHook();
    }
    
    static testMethod void updateProductPaymentWithAccountTestMethod(){
        
        Product__c prod = new Product__c();
        prod.name = '12345';        
        insert prod;
        
        VersaPay_Product_Payment__c vpPay = new VersaPay_Product_Payment__c();
        vpPay.Product__c = prod.id;
        insert vpPay;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof('Blob[0]');
        
        req.addParameter('amount_in_cents', '9175');
        req.addParameter('created_by_user','yujpqgPa_vscKNcz8Gkf');
        req.addParameter('email', '');
        req.addParameter('to_account', 'Canaccede');
        req.addParameter('to_fund', 'VersaPay Balance');
        req.addParameter('message', '');
        req.addParameter('process_on', '2016-11-20');
        req.addParameter('signature', 'chLtBK7zl7wBg8QCSceORjAyPydfUSj%2FpMOgaxlLgUI%3D%0A');
        req.addParameter('state', 'nsfed');
        req.addParameter('type', 'transaction');
        req.addParameter('transaction_type', 'direct_debit');
        req.addParameter('token', '1IXL5IX3D2IM');
        req.addParameter('transaction_reference', '12345');
        req.addParameter('unique_reference', '');
        req.addParameter('link_url ', '');
        req.addParameter('auto_withdraw ', 'false');
        req.addParameter('auto_withdrawal_token', '');
        req.addParameter('from_account', 'KIMBERLY POND');
        req.addParameter('from_fund_token', 'BA9V6XLJD8TP');
                    
        req.requestURI = '/VersaPay';  
        req.httpMethod = 'POST';
        req.resourcePath = '/services/apexrest/VersaPay/*';
        
        RestContext.request = req;
        RestContext.response = res;
        
        VersaPayListner.listenWebHook();
    }
    
    static testMethod void updateProductNSFEDTestMethod(){
        
        Product__c prod = new Product__c();
        prod.name = '12345';
        prod.VersaPay_Token_Number__c = '1IXL5IX3D2IM';
        
        insert prod;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof('Blob[0]');
        
        req.addParameter('amount_in_cents', '9175');
        req.addParameter('created_by_user','yujpqgPa_vscKNcz8Gkf');
        req.addParameter('email', '');
        req.addParameter('to_account', 'Canaccede');
        req.addParameter('to_fund', 'VersaPay Balance');
        req.addParameter('message', '');
        req.addParameter('process_on', '2016-11-20');
        req.addParameter('signature', 'chLtBK7zl7wBg8QCSceORjAyPydfUSj%2FpMOgaxlLgUI%3D%0A');
        req.addParameter('state', 'nsfed');
        req.addParameter('type', 'transaction');
        req.addParameter('transaction_type', 'direct_credit');
        req.addParameter('token', '1IXL5IX3D2IM');
        req.addParameter('transaction_reference', '');
        req.addParameter('unique_reference', '');
        req.addParameter('link_url ', '');
        req.addParameter('auto_withdraw ', 'false');
        req.addParameter('auto_withdrawal_token', '');
        req.addParameter('from_account', 'KIMBERLY POND');
        req.addParameter('from_fund_token', 'BA9V6XLJD8TP');
                    
        req.requestURI = '/VersaPay';  
        req.httpMethod = 'POST';
        req.resourcePath = '/services/apexrest/VersaPay/*';
        
        RestContext.request = req;
        RestContext.response = res;
        
        VersaPayListner.listenWebHook();
    }
    
    static testMethod void updateProductCompletedNSFEDTestMethod(){
        
        Product__c prod = new Product__c();
        prod.name = '12345';
        prod.VersaPay_Token_Number__c = '1IXL5IX3D2IM';
        
        insert prod;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof('Blob[0]');
        
        req.addParameter('amount_in_cents', '9175');
        req.addParameter('created_by_user','yujpqgPa_vscKNcz8Gkf');
        req.addParameter('email', '');
        req.addParameter('to_account', 'Canaccede');
        req.addParameter('to_fund', 'VersaPay Balance');
        req.addParameter('message', '');
        req.addParameter('process_on', '2016-11-20');
        req.addParameter('signature', 'chLtBK7zl7wBg8QCSceORjAyPydfUSj%2FpMOgaxlLgUI%3D%0A');
        req.addParameter('state', 'completed_but_nsfed');
        req.addParameter('type', 'transaction');
        req.addParameter('transaction_type', 'direct_credit');
        req.addParameter('token', '1IXL5IX3D2IM');
        req.addParameter('transaction_reference', '');
        req.addParameter('unique_reference', '');
        req.addParameter('link_url ', '');
        req.addParameter('auto_withdraw ', 'false');
        req.addParameter('auto_withdrawal_token', '');
        req.addParameter('from_account', 'KIMBERLY POND');
        req.addParameter('from_fund_token', 'BA9V6XLJD8TP');
                    
        req.requestURI = '/VersaPay';  
        req.httpMethod = 'POST';
        req.resourcePath = '/services/apexrest/VersaPay/*';
        
        RestContext.request = req;
        RestContext.response = res;
        
        VersaPayListner.listenWebHook();
    }
    
    static testMethod void updateProductErrorTestMethod(){
        
        Product__c prod = new Product__c();
        prod.name = '12345';
        prod.VersaPay_Token_Number__c = '1IXL5IX3D2IM';
        
        insert prod;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueof('Blob[0]');
        
        req.addParameter('amount_in_cents', '9175');
        req.addParameter('created_by_user','yujpqgPa_vscKNcz8Gkf');
        req.addParameter('email', '');
        req.addParameter('to_account', 'Canaccede');
        req.addParameter('to_fund', 'VersaPay Balance');
        req.addParameter('message', '');
        req.addParameter('process_on', '2016-11-20');
        req.addParameter('signature', 'chLtBK7zl7wBg8QCSceORjAyPydfUSj%2FpMOgaxlLgUI%3D%0A');
        req.addParameter('state', 'error');
        req.addParameter('type', 'transaction');
        req.addParameter('transaction_type', 'direct_credit');
        req.addParameter('token', '1IXL5IX3D2IM');
        req.addParameter('transaction_reference', '');
        req.addParameter('unique_reference', '');
        req.addParameter('link_url ', '');
        req.addParameter('auto_withdraw ', 'false');
        req.addParameter('auto_withdrawal_token', '');
        req.addParameter('from_account', 'KIMBERLY POND');
        req.addParameter('from_fund_token', 'BA9V6XLJD8TP');
                    
        req.requestURI = '/VersaPay';  
        req.httpMethod = 'POST';
        req.resourcePath = '/services/apexrest/VersaPay/*';
        
        RestContext.request = req;
        RestContext.response = res;
        
        VersaPayListner.listenWebHook();
    }
}