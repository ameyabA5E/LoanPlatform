/***************************************************
* Author         : A5E Consultancy
* Last Modified  : 13 Apr 2017
* Description    : Provided user to preview & print email templates with product merge fields
*
***************************************************/
public class PreviewProductEmailCntrl{

    // To render HTML in vf page 
    public String htmlBody { get; set; }
    
    // To define how the page should display
    public String renderedAs{set;get;}
    Product__c prod;
    String templateName;
    
    // Constructor to read product through SOQL
    public PreviewProductEmailCntrl(){
        Id prodId = ApexPages.currentPage().getParameters().get('Id');
        templateName = ApexPages.currentPage().getParameters().get('TemplateName');
        renderedAs = ApexPages.currentPage().getParameters().get('renderedAs');
        
        // Queries product record and values
        prod = [SELECT First_Name__c, Minimum_Payment_Amount__c, Current_Balance__c, Name FROM Product__c WHERE Id =: prodId];
        
        // Queries Email template that selected by user
        htmlBody = [Select id,HtmlValue from EmailTemplate where Name =: TemplateName ].HTMLValue;
        
        // Mapping merge field to replace in HTML body
        Map<String, String> mapBodyParams = new Map<String, String>{
                                             '{!Product__c.First_Name__c}' => prod.First_Name__c,
                                             '{!Product__c.Minimum_Payment_Amount__c}' => '$'+String.valueOF(prod.Minimum_Payment_Amount__c),
                                             '{!Product__c.Current_Balance__c}' => '$'+String.valueOf(prod.Current_Balance__c),
                                             '{!Product__c.Name}' => prod.Name
                                             };
        // Replacing mere fields with product data
        for(String key : mapBodyParams.keySet()){
            htmlBody = htmlBody.replace(key, (mapBodyParams .get(key) == null) ? '' : mapBodyParams .get(key));
        }
    }
    
    // Creating Activity
    public void createActivity(){
        if(renderedAs != 'pdf' && templateName != null && templateName != ''){
        Task activity = new Task( Subject = 'Print Email - '+templateName,
                WhatId = prod.Id,
                OwnerId = UserInfo.getUserId(),
                Status='Completed');
        insert activity;
        }
    }
}