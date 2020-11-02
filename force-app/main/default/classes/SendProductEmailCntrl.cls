/***************************************************
* Author         : A5E Consultancy
* Last Modified  : 1 Apr 2017
* Description    : Provided user to choose & send email templates regarding Product
*
***************************************************/

public class SendProductEmailCntrl {
    
    // To change preview section visible 
    public Boolean displayPreviewEmail{set;get;}
    
    // Setting preview section to true
    public void previewEmail() {
        // There is no email template selected
        if(selectedTemplate == 'null' || selectedTemplate == null){
            displayPreviewEmail = false;  
        }else{
            displayPreviewEmail = true;

        }
    }

    
    // Custom Product Object
    Product__c prod{set;get;}
    public String selectedTemplate{set;get;}
    
    // Email validation check
    public Boolean invalidEmail {set;get;}
    public Id prodId{set;get;}
    
    // Constructor to read product Id from URL, Queries and validates email
    public SendProductEmailCntrl() {
        prodId = ApexPages.currentPage().getParameters().get('Id');
        prod = [SELECT Id, Customer__r.PersonContactID, Customer__r.PersonEmail FROM Product__c WHERE Id =: prodId];
        
        // If email is NULL set Error
        if(prod.Customer__r.PersonEmail == null){
            invalidEmail = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Email address is missing on Customer record'));
        }
    }
    
    // Loads Email Template Names from Custom Label Product Bill Email Templates
    public List<SelectOption> getEmailTemplates() {
        List<SelectOption> options = new List<SelectOption>(); 
        // Default value to --Select--
        options.add(new SelectOption('', '------Select-----'));
        for(String templateName : Label.Product_Bill_Email_Templates.split(',')){
            options.add(new SelectOption(templateName, templateName));
        }
        return options; 
    }
    
    
    // Sending Email to Customer regrading Product Plan bill
    public PageReference send(){
        if(selectedTemplate == 'null' || selectedTemplate == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select email template'));  
            return null;
        }
        List<Messaging.Singleemailmessage> listSingleEmailMessages = new List<Messaging.Singleemailmessage>();
        List<Messaging.SendEmailResult> listEmailResult = null;
        
        
        // Fetch Email template which has been selected on VF page Radio button                    
        EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name = : selectedTemplate];
        
        // Single Email instance to compose Email feature
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Set Recipient email Addresses, and reply to
        mail.setReplyTo('lending@affirmfinancial.ca');
        mail.setTemplateId(emailTemplate.Id);
        mail.setWhatId(prod.Id);
        mail.setTargetObjectId(prod.Customer__r.PersonContactID);
        mail.setSaveAsActivity(false);
        
        listSingleEmailMessages.add(mail);
        
        // Sending email
        if(listSingleEmailMessages.size() >0){
            listEmailResult = Messaging.sendEmail(listSingleEmailMessages); 
        }
        
        for(Messaging.SendEmailResult emailResult : listEmailResult){
            if(emailResult.isSuccess()){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.confirm,'Email sent successfully'));              

               // Creating Activity if Email sent successfully
               createActivity('Send Email - '+selectedTemplate);
            }
               
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.confirm,'Email not sent'));   
            }                                       
       }
       return null;
    }
    
    // Creating Activity
    public void createActivity(String activityName){
        
        Task activity = new Task( Subject = activityName,
                WhatId = prod.Id,
                OwnerId = UserInfo.getUserId(),
                Status='Completed');
        insert activity;
    }
}