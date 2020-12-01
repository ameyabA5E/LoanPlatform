/**************************************************************************************************
 *
 *  Class:    
 *
 *  @description : This is used for updating Verification fields on Application records. 
 *  @author : A5E Consulting
 *  @date : 11/11/2020
 
 *************************************************************************************************/

public without sharing class SendVerificationEmailController {

    public Boolean elgibleForEmail {get;set;}
    public String inelgibleReason {get;set;}  

    // Constants
    public String NO_EMAIL {get;set;}
    public String VERIFICATION_ALREADY_COMPLETED {get;set;}
    public String INVALID_APPLICATION_STATUS {get;set;}
    
    //More Constants
    public static final String VERIFICATION_STATUS_EMAIL_SENT_ANALYST = 'Manual Email Sent';
    public static final String VERIFICATION_STATUS_VERIFIED = 'Verified';
    public static final String APPLICATION_STATUS_SYSTEM_APPROVED = 'System Approved';
    public static final String APPLICATION_STATUS_ANALYST_APPROVED = 'Analyst Approved';
    
    //Application record
    public Application__c application;

    //Custom settings
    private Application_Form_Settings__c appFormSettings;   

    //Constructor
    public SendVerificationEmailController () {
    
        String applicationId = ApexPages.currentPage().getParameters().get('id');       
        
        application = Utilities.getApplicationById(applicationId); 
        
        //Get Custom Settings
        appFormSettings = Application_Form_Settings__c.getOrgDefaults();        
        elgibleForEmail = true;        
        
        // Set constants
        NO_EMAIL = 'No email';
        VERIFICATION_ALREADY_COMPLETED = 'Verification already completed';
        INVALID_APPLICATION_STATUS = 'Application Status is not valid';
                
        //Record Validation         
        // Missing email
        if (String.isBlank(application.Email_Address__c)) {            
            inelgibleReason = NO_EMAIL; 
            elgibleForEmail = false;            
        } 
        
        // Verification process already complete
        if (application.Verification_Status__c == VERIFICATION_STATUS_VERIFIED){
            inelgibleReason = VERIFICATION_ALREADY_COMPLETED;
            elgibleForEmail = false;
        }  
               
        //Application Status
         if (application.Application_Status__c != APPLICATION_STATUS_SYSTEM_APPROVED && application.Application_Status__c != APPLICATION_STATUS_ANALYST_APPROVED){
            inelgibleReason = INVALID_APPLICATION_STATUS;
            elgibleForEmail = false;
            system.debug('Application status is' +application.Application_Status__c);
        }             
    }    
    
    //Application to send verification email
    public void invokeEmail() {
    
        if (elgibleForEmail == True) {
        
            // Generate email auth token using MD5 hash of appId and current date-time
            Datetime current = Datetime.now();
            String hashString = application.Id + current.formatGmt('yyyyMMddHHmmssSSS');
            Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));            
            application.Verification_Auth_Token__c = EncodingUtil.convertToHex(hash);            
            // Update verification status          
            application.Verification_Sent_Date__c = current;
            application.Verification_Status__c = VERIFICATION_STATUS_EMAIL_SENT_ANALYST;   //Email Sent – Analyst
            application.Verification_Completion_Date__c = null;
            application.Verification_Expiration_Date__c = system.now().addDays(2);
            
            // Calculate expiration date
            Integer expiryDays = Integer.valueOf(appFormSettings.Verification_Expiration_Days__c);
            application.Verification_Expiration_Date__c = current.addDays(expiryDays);   
           
            //ApplicationTriggerHandler.runApplicationLoadTrigger = false;
            update application;
            //ApplicationTriggerHandler.runApplicationLoadTrigger = true;  
        }
    }
}