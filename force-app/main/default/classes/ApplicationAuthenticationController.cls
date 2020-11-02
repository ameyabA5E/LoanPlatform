public with sharing class ApplicationAuthenticationController {

    public Application_Form_Settings__c appFormSettings {get;set;}
    public Application__c application {get;set;}
    public String applicationId {get;set;}
    public Boolean emailAuthPass {get;set;}
    
    public ApplicationAuthenticationController () {
        
        appFormSettings = Application_Form_Settings__c.getOrgDefaults(); 
        
        String emailToken = ApexPages.currentPage().getParameters().get('et');
        
        if (emailToken != null) {
            application = getApplicationByEmailToken(emailToken);
        
            if (application != null) {              
                emailAuthPass = true;               
            } 
            else {
                emailAuthPass = false;
            }
            
        } else {
            emailAuthPass = false;
        }           
    }
    
    //Gets Application with given email token if exists
    public Application__c getApplicationByEmailToken(String et) {
        List<Application__c> applications = [SELECT Id FROM Application__c WHERE Email_Auth_Token__c =: et];
    
        return (applications.size() > 0) ? applications[0] : null;
    }
    
    //Send email to initiate Email Authentication
    public void emailAuthenticateComplete(){
        if(emailAuthPass){
            application.Email_Authentication_Status__c = 'Applicant Authenticated';
            update application;
        }
    }
    
}