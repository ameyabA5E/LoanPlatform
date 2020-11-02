/**************************************************************************************************
*
*  Class:   
*
*  @description : Utility Class that will send the Funding / Payment Setup transaction    
*  @author : A5E Consulting
*  @date : 14/11/2016   

*************************************************************************************************/
Public Class VersaPayWSUtil{
    
    // HTTP constants
    private static final Integer MAX_TIMEOUT = 60000;
    
    // Default error message
    private static final String UNEXP_ERROR_MESSAGE = 'An unexpected error has occurred';
    
    //Get Loan ReEngineering Custom Setting Record
    private static Loan_ReEngineering__c versaPayCS = Loan_ReEngineering__c.getOrgDefaults();
    
    // Encapsulates VersaPay decision response
    public class VersaPayResponse {
        
        //Unique identifier from VersaPay
        public String versaPayTokenNumber {get;set;}
        
        //Fund Tokens
        public String versaPayToFundToken {get;set;}
        public String versaPayFromFundToken {get;set;}
        
        //Account Information
        public String versaPayFromAccount {get;set;}
        public String versaPayToAccount {get;set;}
        
        //Transaction State
        public String versaPayState {get;set;}
        
        //In case of any error
        public String errorMessage {get;set;}
        
        //In case of any error Description      
        public String errorDescription {get;set;}
    }
    
    //method that call from the VersaPayFundingBatch 
    public static VersaPayResponse createCreditRequest(Product__c prod, API_Error__c apiError){
		
		/*
        HttpRequest req = createRequestCredit();
        
        //Create direct_credit request xml and set to Body
        req.setBody(createCreditRequestXml(prod));
        
        Http http = new Http();
        HTTPResponse resp= null;
        VersaPayResponse decResp = new VersaPayResponse();
        try{
            resp= http.send(req);
        
            if(resp.getStatusCode() == 201 || resp.getStatusCode() == 200){
                
                if(resp.getBody().contains('error')){
                    
                    //server Error
                    decResp.errorMessage = 'Server Error';
                    decResp.errorDescription = getDataFromXml(resp.getBody(), 'errors').replaceAll('(error|<|/|>|)', '');
                    decResp.versaPayState = 'server_error';
                    apiError = writeErrorRequest(apiError, prod,req,'VersaPay Funding', 'VersaPay Response', decResp.errorMessage);
                    writeErrorResponse(apiError, resp);
                    //insert apiError;
                    return decResp;    
                }
                else{                
                    //Parse VersaPay Response
                    return parseResponse(resp.getBody(), decResp);
                }
            }
            else{
                //server Error
                decResp.errorMessage = 'Server Error With Status Code = '+resp.getStatusCode();
                decResp.errorDescription = getDataFromXml(resp.getBody(), 'errors').replaceAll('(error|<|/|>|)', '');
                decResp.versaPayState = 'server_error';
                apiError = writeErrorRequest(apiError, prod,req,'VersaPay Funding', 'VersaPay Response', decResp.errorMessage);
                writeErrorResponse(apiError, resp);
                //insert apiError;
                return decResp;
            } 
        }
        catch(Exception exp){
            //Unknow Error
            decResp.errorMessage = 'Unknow Error: '+exp.getMessage();// With Status Code'+resp.getStatusCode();
            decResp.errorDescription = exp.getMessage();//getDataFromXml(resp.getBody(), 'errors').replaceAll('(error|<|/|>|)', '');
            decResp.versaPayState = 'unknown_error';
            apiError = writeErrorRequest(apiError, prod,req,'VersaPay Funding', 'VersaPay Response',decResp.errorMessage);
            writeErrorResponse(apiError, resp);
            //insert apiError;
            return decResp;
        }
        */
        VersaPayResponse decResp = new VersaPayResponse();
        
        decResp.versaPayTokenNumber = Utilities.getCreditToken();
        decResp.versaPayFromAccount = 'sample_from_account';
        decResp.versaPayToAccount = 'sample_to_account';
        decResp.versaPayFromFundToken = 'sample_from_fund_token';
        decResp.versaPayToFundToken = 'sample_to_fund_token';
        decResp.versapayState = 'In_Progress';
        return decResp;
    }
    
    //method that call from the VersaPayPaymentSetupBatch 
    public static VersaPayResponse createDebitRequest(Product__c prod, Decimal amountInCents, Date processOnDate, API_Error__c apiError){
        
        
        HttpRequest req = createRequestDebit();
        
        //Create direct_debit request xml and set to Body
        req.setBody(createDebitRequestXml(prod, amountInCents, processOnDate));
        
        Http http = new Http();
        HTTPResponse resp= null;
        VersaPayResponse decResp = new VersaPayResponse();
        try{
            resp= http.send(req);
            
            if(resp.getStatusCode() == 201 || resp.getStatusCode() == 200){
                
                if(resp.getBody().contains('Error')){
                    
                    //server Error
                    decResp.errorMessage = 'Server Error';
                    decResp.errorDescription = getDataFromXml(resp.getBody(), 'errors').replaceAll('(error|<|/|>|)', '');
                    decResp.versaPayState = 'server_error';
                    apiError = writeErrorRequest(apiError, prod,req,'VersaPay Payment', 'VersaPay Response', decResp.errorMessage);
                    writeErrorResponse(apiError, resp);
                    //insert apiError;
                    return decResp;    
                }
                else{                
                    //Parse VersaPay Response
                    return parseResponse(resp.getBody(), decResp);
                }
            }
            else{
                //server Error
                decResp.errorMessage = 'Server Error With Status Code = '+resp.getStatusCode();
                decResp.errorDescription = getDataFromXml(resp.getBody(), 'errors').replaceAll('(error|<|/|>|)', '');
                decResp.versaPayState = 'server_error';
                apiError = writeErrorRequest(apiError, prod,req,'VersaPay Payment', 'VersaPay Response', decResp.errorMessage);
                writeErrorResponse(apiError, resp);
                //insert apiError;
                return decResp;
            } 
        }
        catch(Exception exp){
            //Unknow Error
            decResp.errorMessage = 'Unknow Error: '+exp.getMessage();// With Status Code  = '+resp.getStatusCode();
            decResp.errorDescription = exp.getMessage();//getDataFromXml(resp.getBody(), 'errors').replaceAll('(error|<|/|>|)', '');
            decResp.versaPayState = 'unknown_error';
            apiError = writeErrorRequest(apiError, prod,req,'VersaPay Payment', 'VersaPay Response',decResp.errorMessage);
            writeErrorResponse(apiError, resp);
            //insert apiError;
            return decResp;
        }
    }
    
    //method that call from the VersaPayPaymentSetupBatch 
    public static VersaPayResponse createDebitRequestWithPayments(VersaPay_Product_Payment__c prodPay, API_Error__c apiError){  
    	
    	/*
        HttpRequest req = createRequestDebit();
        
        //Create direct_debit request xml and set to Body
        req.setBody(createDebitRequestXml(prodPay));
        
        Http http = new Http();
        HTTPResponse resp= null;
        VersaPayResponse decResp = new VersaPayResponse();
        try{
            resp= http.send(req);
            
            if(resp.getStatusCode() == 201 || resp.getStatusCode() == 200){
                
                if(resp.getBody().contains('Error')){
                    
                    //server Error
                    decResp.errorMessage = 'Server Error';
                    decResp.errorDescription = getDataFromXml(resp.getBody(), 'errors').replaceAll('(error|<|/|>|)', '');
                    decResp.versaPayState = 'server_error';
                    apiError = writeErrorRequest(apiError, prodPay, req, 'VersaPay Payment', 'VersaPay Response', decResp.errorMessage);
                    writeErrorResponse(apiError, resp);
                    //insert apiError;
                    return decResp;    
                }
                else{                
                    //Parse VersaPay Response
                    return parseResponse(resp.getBody(), decResp);
                }
            }
            else{
                //server Error
                decResp.errorMessage = 'Server Error With Status Code = '+resp.getStatusCode();
                decResp.errorDescription = getDataFromXml(resp.getBody(), 'errors').replaceAll('(error|<|/|>|)', '');
                decResp.versaPayState = 'server_error';
                apiError = writeErrorRequest(apiError, prodPay,req,'VersaPay Payment', 'VersaPay Response', decResp.errorMessage);
                writeErrorResponse(apiError, resp);
                //insert apiError;
                return decResp;
            } 
        }
        catch(Exception exp){
            //Unknow Error
            decResp.errorMessage = 'Unknow Error: '+exp.getMessage();// With Status Code  = '+resp.getStatusCode();
            decResp.errorDescription = exp.getMessage();//getDataFromXml(resp.getBody(), 'errors').replaceAll('(error|<|/|>|)', '');
            decResp.versaPayState = 'unknown_error';
            apiError = writeErrorRequest(apiError, prodPay,req,'VersaPay Payment', 'VersaPay Response',decResp.errorMessage);
            writeErrorResponse(apiError, resp);
            //insert apiError;
            return decResp;
        }
        */
        VersaPayResponse decResp = new VersaPayResponse();
        decResp.versaPayTokenNumber = Utilities.getDebitToken();
        decResp.versaPayFromAccount = 'sample_from_account';
        decResp.versaPayToAccount = 'sample_to_account';
        decResp.versaPayFromFundToken = 'sample_from_fund_token';
        decResp.versaPayToFundToken = 'sample_to_fund_token';
        decResp.versapayState = 'In_Progress';
        
        return decResp;
    }
    
    @TestVisible
    private static HttpRequest createRequestCredit(){
    
        HttpRequest req = new HttpRequest();
        req.setEndpoint(versaPayCS.VersaPay_End_Point__c); 
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('Connection', 'Keep-Alive');
        req.setTimeout(MAX_TIMEOUT);
        
        req.setHeader('Authorization', getAuthorizationHeaderCredit());
        return req;
    }
    
    @TestVisible
    private static HttpRequest createRequestDebit(){
    
        HttpRequest req = new HttpRequest();
        req.setEndpoint(versaPayCS.VersaPay_End_Point__c); 
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('Connection', 'Keep-Alive');
        req.setTimeout(MAX_TIMEOUT);
        
        req.setHeader('Authorization', getAuthorizationHeaderDebit());
        return req;
    }
    
    @TestVisible
    private static String getAuthorizationHeaderCredit(){
        
        //Basic Authentication
        String token = versaPayCS.VersaPay_Auth_Token_Credit__c;
        String key = versaPayCS.VersaPay_Auth_Key_Credit__c;
        Blob headerValue = Blob.valueOf(token + ':' + key);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        return authorizationHeader;
    }
    
    @TestVisible
    private static String getAuthorizationHeaderDebit(){
        
        //Basic Authentication
        String token = versaPayCS.VersaPay_Auth_Token_Debit__c;
        String key = versaPayCS.VersaPay_Auth_Key_Debit__c;
        Blob headerValue = Blob.valueOf(token + ':' + key);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        return authorizationHeader;
    }
    
    //create a Request XML for VersaPay direct_credit 
    @TestVisible
    private static String createCreditRequestXml(Product__c prod){
        
        String reqBody = '<transaction>';
            reqBody += '<transaction_type>' + 'direct_credit' + '</transaction_type>';
            reqBody += '<transaction_reference>' + checkIsBlank(prod.Name) + '</transaction_reference>';
            reqBody += '<amount_in_cents>' + countAmountInCentsCredit(prod.Disbursement_Amount__c) + '</amount_in_cents>';
            reqBody += '<email>' + checkIsBlank(prod.Customer__r.PersonEmail) + '</email>';
            
            //Funding Source Information
            if(String.isNotBlank(prod.Funding_Source_Token__c)){                
                reqBody += '<fund_token>' + prod.Funding_Source_Token__c + '</fund_token>';             
            }
                        
            //reqBody += '<message>' + checkIsBlank(prod.Name) + '</message>';
            reqBody += '<first_name>' + checkIsBlank(prod.Customer__r.FirstName) + '</first_name>';
            reqBody += '<last_name>' + checkIsBlank(prod.Customer__r.LastName) + '</last_name>';
            reqBody += '<institution_number>' + checkIsBlank(prod.PAP_Bank_Code__c) + '</institution_number>';
            reqBody += '<branch_number>' + checkIsBlank(prod.PAP_Transit_Code__c) + '</branch_number>';
            reqBody += '<account_number>' + checkIsBlank(prod.PAP_Account_Number__c) + '</account_number>';
            reqBody += '<memo>Affirm Financial TermLoan</memo>';
            reqBody += '<process_on>' + processOnCredit(prod.Funding_Date__c) + '</process_on>';
            reqBody += '</transaction>';
        System.debug('reqBody: '+reqBody);
        return reqBody;    
    }
    
    //create a Request XML for VersaPay  direct_debit
    @TestVisible
    private static String createDebitRequestXml(Product__c prod, Decimal amountInCents, Date processOnDate){
        
        String reqBody = '<transaction>';
            reqBody += '<transaction_type>' + 'direct_debit' + '</transaction_type>';
            reqBody += '<transaction_reference>' + checkIsBlank(prod.Name) + '</transaction_reference>';
            reqBody += '<amount_in_cents>' + amountInCents + '</amount_in_cents>';
            reqBody += '<email>' + checkIsBlank(prod.Customer__r.PersonEmail) + '</email>';
            
            //Funding Source Information
            if(String.isNotBlank(prod.Funding_Source_Token__c)){                
                reqBody += '<fund_token>' + prod.Funding_Source_Token__c + '</fund_token>';             
            }
            
            reqBody += '<message>' + checkIsBlank(prod.Name) + '</message>';
            reqBody += '<first_name>' + checkIsBlank(prod.Customer__r.FirstName) + '</first_name>';
            reqBody += '<last_name>' + checkIsBlank(prod.Customer__r.LastName) + '</last_name>';
            reqBody += '<institution_number>' + checkIsBlank(prod.PAP_Bank_Code__c) + '</institution_number>';
            reqBody += '<branch_number>' + checkIsBlank(prod.PAP_Transit_Code__c) + '</branch_number>';
            reqBody += '<account_number>' + checkIsBlank(prod.PAP_Account_Number__c) + '</account_number>';
            reqBody += '<memo>Affirm Financial TermLoan</memo>';
            reqBody += '<process_on>' + changeDateFormat(processOnDate) + '</process_on>';
            reqBody += '</transaction>';
        System.debug('reqBody: '+reqBody);
        return reqBody;    
    }
    
    //create a Request XML for VersaPay  direct_debit using Payment record
    @TestVisible
    private static String createDebitRequestXml(VersaPay_Product_Payment__c prodPay){
    	
    	System.debug('createDebitRequestXml prodPay.Process_On__c: '+ prodPay.Process_On__c);
    	System.debug('createDebitRequestXml prodPay.Product__r.Name: '+ prodPay.Product__r.Name);
    	System.debug('createDebitRequestXml prodPay.Name: '+ prodPay.Name);
    	System.debug('createDebitRequestXml prodPay.Id: '+ prodPay.Id);
        
        String reqBody = '<transaction>';
            reqBody += '<transaction_type>' + 'direct_debit' + '</transaction_type>';
            reqBody += '<transaction_reference>' + checkIsBlank(prodPay.Product__r.Name) + '</transaction_reference>';
            reqBody += '<amount_in_cents>' + (prodPay.Payment_Amount__c) * 100 + '</amount_in_cents>';
            reqBody += '<email>' + checkIsBlank(prodPay.Product__r.Customer__r.PersonEmail) + '</email>';
            
            //Funding Source Information
            if(String.isNotBlank(prodPay.Product__r.Funding_Source_Token__c)){                
                reqBody += '<fund_token>' + prodPay.Product__r.Funding_Source_Token__c + '</fund_token>';             
            }
            
            reqBody += '<message>' + checkIsBlank(prodPay.Product__r.Name) + '</message>';
            reqBody += '<first_name>' + checkIsBlank(prodPay.Product__r.Customer__r.FirstName) + '</first_name>';
            reqBody += '<last_name>' + checkIsBlank(prodPay.Product__r.Customer__r.LastName) + '</last_name>';
            reqBody += '<institution_number>' + checkIsBlank(prodPay.Product__r.PAP_Bank_Code__c) + '</institution_number>';
            reqBody += '<branch_number>' + checkIsBlank(prodPay.Product__r.PAP_Transit_Code__c) + '</branch_number>';
            reqBody += '<account_number>' + checkIsBlank(prodPay.Product__r.PAP_Account_Number__c) + '</account_number>';
            reqBody += '<memo>Affirm Financial TermLoan</memo>';
            
            reqBody += '<process_on>' + changedateFormat(prodPay.Process_On__c) + '</process_on>';
            reqBody += '</transaction>';
        System.debug('reqBody: '+reqBody);
        return reqBody;    
    }
    
    //parse XML response from the VersaPay
    @TestVisible
    private static VersaPayResponse parseResponse(String resBody, VersaPayResponse decResp){
        
        //variables for VersaPay direct_credit and direct_debit
        try{
          decResp.versaPayTokenNumber = getDataFromXml(resBody, 'token');
        }
        catch (Exception e) {
        }
        
        try{
          decResp.versaPayFromAccount = getDataFromXml(resBody, 'from_account');
        }
        catch (Exception e) {
        }
        
        try{
          decResp.versaPayToAccount = getDataFromXml(resBody, 'to_account');
        }
        catch (Exception e) {
        }
        
        try{
          decResp.versaPayFromFundToken = getDataFromXml(resBody, 'from_fund_token');
        }
        catch (Exception e) {
        }
        
        try{
          decResp.versaPayToFundToken = getDataFromXml(resBody, 'to_fund_token');
        }
        catch (Exception e) {
        }
                
        try{
          decResp.versapayState = getDataFromXml(resBody, 'state');
        }
        catch (Exception e) {
        }
        
        System.debug('decResp: '+decResp);        
        return decResp;
    }
    
    //return Amount in cents for direct_debit
    public static Decimal countAmountInCentsDebit(Decimal overPayAmt, Decimal nextPayAmt, Decimal firstPayAmt, Date firstPayDate){
        
        if(overPayAmt != null){
            return countAmountInCents(overPayAmt);
        }
        else{
            if(firstPayDate != null && firstPayAmt != null && firstPayDate == SYSTEM.TODAY()){
                return countAmountInCents(firstPayAmt);
            }
            else{
                if(nextPayAmt != null){
                    return countAmountInCents(nextPayAmt);
                }
                else{
                    return null;
                }
            }
        }
    }
    
    //fetch response value between two nodes.
    @TestVisible
    private static string getDataFromXml(string xmlStr, string tagName){
        
        string startTag = '<' + tagName + '>';
        string endTag = '</' + tagName + '>';
        
        string finalStr = '';
        
        if(xmlStr.contains(startTag)){          
            if(xmlStr.contains(endTag)) {               
                finalStr = xmlStr.substringBetween(startTag, endTag);                
            }
        }
        return finalStr;
    }
    
    //return Process On Date for direct_credit
    @TestVisible
    private static String processOnCredit(Date dt){
        if(dt != null){
            return changeDateFormat(dt);
        }
        else{
            return '';
        }
    }
    
    //check wheater it is null or not
    @TestVisible
    private static String checkIsBlank(String str){
        
        if(String.isBlank(str)){
            return '';
        }
        else{
            return str;
        }
    }
    
    //return Amount in cents for direct_credit
    @TestVisible
    private static Decimal countAmountInCentsCredit(Decimal dl){
        
            return countAmountInCents(dl);
    }
    
    //count amount in cents
    @TestVisible
    private static Decimal countAmountInCents(Decimal dl){
        if(dl != null){
            return (dl*100);
        }
        else{
            return null;
        }
    }
    
    //convert date to YYYY-MM-DD formate
    @TestVisible
    private static String changeDateFormat(Date dt){
        return (dt.year()+'-'+dt.month()+'-'+dt.day());
    }
    
    //description Populates VersaPay API Error record with request info
    @TestVisible
    private static API_Error__c writeErrorRequest(API_Error__c apiError, Product__c prod, HttpRequest req, String endpoint, String action, String error) {
        //API_Error__c apiError = new API_Error__c();
        apiError.Product__c = prod.Id;
        apiError.End_Point__c = endpoint;
        apiError.Action__c = action;
        apiError.Error__c = error;
        apiError.Request__c = 'Endpoint: ' + req.getEndpoint();
        apiError.Request__c += '\nMethod: ' + req.getMethod();
        apiError.Request__c += '\nHeaders:';
        apiError.Request__c += '\nConnection: ' + req.getHeader('Connection');
        apiError.Request__c += '\nContent-Type: ' + req.getHeader('Content-Type');
        //apiError.Request__c += '\nSOAPAction: ' + req.getHeader('SOAPAction');
        apiError.Request__c += '\nBody:\n' + req.getBody().replaceAll('&lt;','<');
        return apiError;
    }
    
    //description Populates VersaPay API Error record with request info for payments
    @TestVisible
    private static API_Error__c writeErrorRequest(API_Error__c apiError, VersaPay_Product_Payment__c prodPay, HttpRequest req, String endpoint, String action, String error) {
        //API_Error__c apiError = new API_Error__c();
        apiError.VersaPay_Product_Payment__c = prodPay.Id; // Map versaPay Id
        apiError.End_Point__c = endpoint;
        apiError.Action__c = action;
        apiError.Error__c = error;
        apiError.Request__c = 'Endpoint: ' + req.getEndpoint();
        apiError.Request__c += '\nMethod: ' + req.getMethod();
        apiError.Request__c += '\nHeaders:';
        apiError.Request__c += '\nConnection: ' + req.getHeader('Connection');
        apiError.Request__c += '\nContent-Type: ' + req.getHeader('Content-Type');
        //apiError.Request__c += '\nSOAPAction: ' + req.getHeader('SOAPAction');
        apiError.Request__c += '\nBody:\n' + req.getBody().replaceAll('&lt;','<');
        return apiError;
    }
    
    //description Populates MegaSys error object with response info
    @TestVisible
    private static void writeErrorResponse(API_Error__c apiError, HttpResponse resp) {
        if(resp!=null){        
            
            apiError.Response__c = 'Status Code: ' + resp.getStatusCode();
            apiError.Response__c += '\nStatus: ' + resp.getStatus();
            apiError.Response__c += '\nHeaders:';
            
            for (String h : resp.getHeaderKeys()) {
                if (String.isNotBlank(h)) {
                    apiError.Response__c += '\n' + h + ': ' + resp.getHeader(h);
                }
            }
            
            apiError.Response__c += '\nBody:\n';
            String respBody = resp.getBody();
            
            if (String.isNotBlank(respBody)){
                apiError.Response__c += respBody;
            }
        }
    }
    
    @TestVisible
    public static Date effectiveDateForPayment(Product__c prod){
        
        /* ((SP_Override_Payment_Date__c != null AND SP_Override_Payment_Date__c = TODAY)
        OR (SP_Override_Payment_Date__c = null AND SP_Next_Payment_Due_Date__c = TODAY)
        OR (SP_Override_Payment_Date__c = null AND SP_Next_Payment_Due_Date__c = null AND SP_First_Payment_Date__c = TODAY))*/
        
        Date effectiveDate = null;
        if(prod.SP_Override_Payment_Date__c != null && prod.SP_Override_Payment_Date__c == System.TODAY()){
            effectiveDate = prod.Override_Payment_Date__c;
        }else if((prod.SP_Override_Payment_Date__c == null && prod.SP_Next_Payment_Due_Date__c == System.TODAY())){
            effectiveDate = prod.Payment_Due_Date__c;
        }else if((prod.SP_Override_Payment_Date__c == null && prod.SP_Next_Payment_Due_Date__c == null && prod.SP_First_Payment_Date__c == System.TODAY())){
            effectiveDate = prod.First_Payment_Date__c;
        }
        
        return effectiveDate;
    }    
}