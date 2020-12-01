/**************************************************************************************************
*
*  Class:   DecisionWebService
*
*  @description : This class is integration layer for the Decision web service
*  @author : A5E Consulting
*  @date : 11/12/2020   
*
*************************************************************************************************/
public with sharing class DecisionWebService {
    public static Application__c getDecision(Application__c app){
        string jsonResponse = '{ "approvedAmount": 1456.00 ,'+
                                '"interestRate":1.24}';
            DecisionWrapper decision = (DecisionWrapper) System.JSON.deserialize(jsonResponse, DecisionWrapper.class);
            app.Approved_Amount__c = decision.approvedAmount;
            app.Interest_Rate__c = decision.interestRate;
        
        return app;
    }

    public class DecisionWrapper{
        public Decimal approvedAmount;
        public Decimal interestRate;
    }
}