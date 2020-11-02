/**************************************************************************************************
*
*  Class:   
*
*  @description : TestVersaPayListner for Versapay
*  @author : A5E Consulting
*  @date : 12/02/2016   

*************************************************************************************************/
@isTest
public class TestVersaPayListner{
    
    private static Loan_ReEngineering__c loanReCS;
    
    static testMethod void insertTestData(){
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Lead';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        RestContext.request = req;
        RestContext.response= res;
        
       
        
    }
    
}