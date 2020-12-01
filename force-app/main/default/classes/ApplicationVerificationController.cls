/**************************************************************************************************
 *
 *  Class:    
 *
 *  @description : This is used for Application record Verification 
 *  @author : A5E Consulting
 *  @date : 11/11/2020
 
 *************************************************************************************************/
 
public without sharing class ApplicationVerificationController {
    
    //Variables
    public Boolean emailVerificationError {get;set;}
    public Boolean alreadyVerified {get;set;}
    public Boolean nullVerificationID {get;set;}
    
    //Application record
    public Application__c application {get;set;}
    
    //Constants
    public static final String VERIFICATION_STATUS_VERIFIED = 'Verified';
    public static final String VERIFICATION_ALREADY_COMPLETED = 'Verification already completed';
    
    //Constructor    
    public ApplicationVerificationController(){
        
        nullVerificationID = true;
        emailVerificationError = false;
        alreadyVerified = false;
               
    }  
    
    //Veirfying Application
    public void checkVerifyRequest() {
    
        String emailToken = ApexPages.currentPage().getParameters().get('vat');
        
        if (emailToken != null && emailToken != '') {
        
            nullVerificationID = false;
            
            application = getApplicationByVerificationToken(emailToken);
            
            if (application != null) { 
                // Verification process already complete    
                if(application.Verification_Status__c == VERIFICATION_STATUS_VERIFIED){
                    alreadyVerified = True; 
                }
                
                // Check if email expired
                else if (Datetime.now() > application.Verification_Expiration_Date__c) {
                    // Expired (handle error case)
                    emailVerificationError = true;
                }                    
                
            } 
            else {
                // Email token not recognized
                emailVerificationError = true;
            }
            
        } else {
            // Email token missing
            emailVerificationError = true;                        
        }
        //Display correct message
        if (emailVerificationError == false && alreadyVerified == false) {
        
            //Update application
            application.Verification_Status__c = VERIFICATION_STATUS_VERIFIED;
            application.Verification_Completion_Date__c = Datetime.now();
            
            try{
                //ApplicationTriggerHandler.runApplicationLoadTrigger = false;
                update application;
                //ApplicationTriggerHandler.runApplicationLoadTrigger = true;
                
                //alreadyVerified = true;
            }
            catch(Exception e){
                // Do Nothing
            }
        }
             
        //return null; 
        
    }  
    
    // Fetching Application with Verification Token
    public Application__c getApplicationByVerificationToken(String vat) { 
        List<Application__c> applications = [SELECT Id, Verification_Expiration_Date__c, Verification_Sent_Date__c, Verification_Status__c, Verification_Auth_Token__c FROM Application__c WHERE Verification_Auth_Token__c =: vat];
        
        return (applications.size() > 0) ? applications[0] : null;
    }
}