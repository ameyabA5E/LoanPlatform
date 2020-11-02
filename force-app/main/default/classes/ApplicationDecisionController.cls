public with sharing class ApplicationDecisionController {
  //to do remove comment
    public Application_Form_Settings__c appFormSettings {get;set;}
    public Application__c application {get;set;}
    public String applicationId {get;set;}
    
    public ApplicationDecisionController() {
        
        appFormSettings = Application_Form_Settings__c.getOrgDefaults(); 
        applicationId = ApexPages.currentPage().getParameters().get('applnId');
        application = Utilities.getApplicationById(applicationId);
    
    }
    
    //Send email to initiate Email Authentication
    public void emailAuthenticateInitiate(){
        /*
        Datetime current = Datetime.now();
        String hashString = application.Id + current.formatGmt('yyyyMMddHHmmssSSS');
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        application.Email_Auth_Token__c = EncodingUtil.convertToHex(hash);
        application.Email_Authentication_Sent_Date__c = current;
        application.Email_Authentication_Status__c = 'Sent to Applicant';
        
        update application;
        */
    }
    
}