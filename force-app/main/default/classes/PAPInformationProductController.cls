/**************************************************************************************************
 *
 *  Class:   
 *
 *  @description : This is a controller class to input PAP Information for Product record
 *  @author : A5E Consulting
 *  @date : 07/22/2016
 *
 *************************************************************************************************/
 
public with sharing class PAPInformationProductController{
    
    public Product__c productRec{get;set;}
    public Attachment papSupportDocument{get;set;}
    public List<Attachment> attList;
    public Boolean acceptTermsCondition{get;set;}
    
    public Boolean showError{get;set;}
    public String errorMessage{get;set;}
    public boolean showSuccessMessage{get;set;}
    
    public String acceptFormat{get;set;}
    public Integer acceptFileSize{get;set;}
    public Integer fileSize{get;set;}
    public string fileId{get;set;}
    
    public boolean displayPopup {get; set;} 
    
    public List<Attachment> lstAttachment {get;set;}
    
    public PAPInformationProductController(){
        
        //Custom Settings
        Loan_ReEngineering__c loanSettings = Loan_ReEngineering__c.getOrgDefaults();
        
        //To Display Message
        showError = false;
        showSuccessMessage = false;
        
        //Initialize TermsCondition Check bx
        acceptTermsCondition = false;     
        
        //List of PAP attachments
        attList = new List<Attachment>();
        lstAttachment  = new List<Attachment>();
        papSupportDocument = new Attachment();
                
        //File Validation
        acceptFormat = loanSettings.File_Formats__c;
        //fileSize = (Integer)loanSettings.File_Size__c;
        acceptFileSize = (Integer)loanSettings.File_Size__c;
        
        //Get Application ID
        Id prodId = ApexPages.currentPage().getParameters().get('id');
        productRec = [select id, name, Loan_Type__c, PAP_Transit_Code__c, PAP_Bank_Code__c, PAP_Account_Number__c, Application__c, Product_Type__c from Product__c where id =: prodId];
        
        //Attachment List from Product
        attList = [Select id, Name , ParentId , body  from Attachment where ParentId =: prodId and Name like 'PAP_%' ORDER BY CreatedDate DESC ];
        
        //Attachment List from Application
        List<Attachment> attAppList = new List<Attachment>();
        if(productRec.Application__c != null){
            attAppList = [Select id, Name , ParentId , body  from Attachment where ParentId =: productRec.Application__c and Name like 'PAP_%' ORDER BY CreatedDate DESC ];
            for(Attachment att : attAppList){
                attList.add(att);
            }
        }
        
        lstAttachment = attList ;
        if(attList != null && attList.size() > 0){          
            fileId = attList[0].id;            
        }
        
        if(('Affirm Financial Term Loan' != productRec.Loan_Type__c) && (String.isNotBlank(productRec.Product_Type__c) && !productRec.Product_Type__c.contains('Term Loan'))){
            errorMessage='This Application is not for Term Loan, cannot continue with PAP Information.';
            showError=true;
        }
    }
    
    public PageReference navigatePrevious() {
        PageReference pageRef = new PageReference('/' + ProductRec.id);
        return pageref;
    }
    
    public PageReference updatePaymentMethod(){
        
        PageReference pageRef;
        Loan_ReEngineering__c loanSettings = Loan_ReEngineering__c.getOrgDefaults();
        
        if(ProductRec.PAP_Transit_Code__c != null 
            && ProductRec.PAP_Bank_Code__c != null 
            && ProductRec.PAP_Account_Number__c != null 
            //&& papSupportDocument.body != null 
            && acceptTermsCondition == true){
                
                /*//PAP Fields needs to be numeric
                if((!ProductRec.PAP_Transit_Code__c.isNumeric()) || (!ProductRec.PAP_Bank_Code__c.isNumeric()) || (!ProductRec.PAP_Account_Number__c.isNumeric())){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter numbers only for PAP fields');
                    ApexPages.addMessage(myMsg);
                    papSupportDocument = new Attachment();
                    return null;
                }*/
                
                //PAP Transite Code needs to be numeric with exact length = 5
                if((!ProductRec.PAP_Transit_Code__c.isNumeric()) || (ProductRec.PAP_Transit_Code__c).length() < 5){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter 5 numbers only for PAP Transit Code field');
                    ApexPages.addMessage(myMsg);
                    papSupportDocument = new Attachment();
                    return null;
                }
                
                //PAP Account Number needs to be numeric with length between 7 to 12 numbers
                if((!ProductRec.PAP_Account_Number__c.isNumeric()) || ((ProductRec.PAP_Account_Number__c).length() < 7)){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter numbers only for PAP Account Number field and length should be between 7 to 12 numbers');
                    ApexPages.addMessage(myMsg);
                    papSupportDocument = new Attachment();
                    return null;
                }
                
                //PAP Bank Code needs to be numeric with exact length = 3
                if((!ProductRec.PAP_Bank_Code__c.isNumeric()) || (ProductRec.PAP_Bank_Code__c).length() < 3){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter 3 numbers only for PAP Bank Code field');
                    ApexPages.addMessage(myMsg);
                    papSupportDocument = new Attachment();
                    return null;
                }
                
                //PAP Document is required if not available already
                if(attList.size() == 0 && papSupportDocument.body == null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please upload the PAP Document');
                    ApexPages.addMessage(myMsg);
                    papSupportDocument = new Attachment();
                    return null;
                }
                
                //PAP file validation
                if(papSupportDocument.body != null){
                    
                    //File Extention
                    String extensionVal = papSupportDocument.Name.substringAfterLast('.').toLowerCase();
                    if(!acceptFormat.contains(extensionVal)){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please attach '+ acceptFormat +' files only');
                        ApexPages.addMessage(myMsg);
                        papSupportDocument = new Attachment();
                        return null;    
                    }   
                    
                    //File Size
                    if(fileSize > acceptFileSize){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'File size greater than accepted file size');
                        ApexPages.addMessage(myMsg);
                        papSupportDocument = new Attachment();
                        return null;                        
                    }
                }
                
                //Insert PAP DOcument
                if(papSupportDocument.body != null){
                    papSupportDocument.parentid = ProductRec.id;
                    papSupportDocument.name = 'PAP_' + papSupportDocument.name;
                    insert papSupportDocument;
                }               
                
                
                ProductRec.PAP_Information_Accepted__c = acceptTermsCondition;
                ProductRec.PAP_Information_Accepted_Date__c = system.now();
                
                /*loanSettings.Run_Product_Trigger__c = false;
                update loanSettings;
                update ProductRec;
                loanSettings.Run_Product_Trigger__c = true;
                update loanSettings;*/
                
                ProductTriggerHandler.runProductTrigger = false;
                update ProductRec;
                ProductTriggerHandler.runProductTrigger = true;
                
                papSupportDocument = new Attachment();
                showSuccessMessage = true;
                pageRef = ApexPages.currentPage();
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the information');
            ApexPages.addMessage(myMsg);
            
            papSupportDocument = new Attachment();
            return null;
        }
        
        acceptTermsCondition = false;
        return pageRef;
    }
    
}