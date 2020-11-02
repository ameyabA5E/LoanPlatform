/**************************************************************************************************
*
*  Class:   
*
*  @description : Controller class for force decline page
*  @author : A5E Consulting
*  @date : 01/31/2017    

*************************************************************************************************/
public with sharing class ApplicationDeclineDecisionController {

    public Application_Form_Settings__c AppFormSettings {get;set;}
    
    public ApplicationDeclineDecisionController() {
        AppFormSettings = Application_Form_Settings__c.getOrgDefaults();
    }

}