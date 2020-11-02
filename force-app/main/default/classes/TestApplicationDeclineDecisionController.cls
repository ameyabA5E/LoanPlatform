/**************************************************************************************************
*
*  Class:   
*
*  @description : Test Class for ApplicationDeclineDecisionController
*  @author : A5E Consulting
*  @date : 01/31/2017   

*************************************************************************************************/

@isTest
private class TestApplicationDeclineDecisionController {
    
    static testMethod void applicationDeclineDecisionControllerTest() {
        Application_Form_Settings__c appFormSettings = Application_Form_Settings__c.getOrgDefaults();        
        ApplicationDeclineDecisionController cntrl = new ApplicationDeclineDecisionController();
    }
}