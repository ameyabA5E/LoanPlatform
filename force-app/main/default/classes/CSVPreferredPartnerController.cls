/**************************************************************************************************
 *
 *  Class:   
 *
 *  @description : This is a class for insert Preferred Partner Rederral Code
 *  @author : A5E Consulting
 *  @date : 10/13/2016
 
 *************************************************************************************************/
public class CSVPreferredPartnerController {

public Blob csvBody{get;set;}
public String csvName{get;set;}
public Integer fileSize{get;set;}
public String errorMessage{get;set;}

   public CSVPreferredPartnerController(){

   }
   
   //Exceute When Click on Import Preferred Partner Button
   public void importCSVFile(){
        
       String csvString;
       String[] csvLines = new String[]{};
        
       try{
           //Click On Button without CSV File    
           if(String.isBlank(csvName)){
               errorMessage = 'Please Choose CSV File.';    
           }
           //Only accept CSV File
           else if(!csvName.endsWith('.csv')){
               errorMessage = 'Please Upload CSV File Only.';    
           }
           //File must be less than 5 MB
           if(fileSize >= 1048576){
               errorMessage = 'The File Size must be less than 1MB.';
           }
           
           if(errorMessage ==null){
           
               //Duplicat Referral Code not allowed
               Set<Preferred_Partners__c> preferredPartners = new Set<Preferred_Partners__c>();
               
               csvString = csvBody.toString();
               csvLines = csvString.split('\n');    
               for(Integer i=1;i<csvLines.size();i++){
                   
                   String referellaCode, isPreferredPartner, tierType;
                   
                   try{
                       String[] csvData = csvLines[i].split(',');
                       referellaCode = csvData[4]; //Channel Partner code in PCoD
                       isPreferredPartner = csvData[6]; //Preferred Partner
                       tierType = csvData[7]; //Tier Type
                   }
                   catch(System.ListException exp){
                       System.debug('Exception During CSV Parsing: '+exp.getMessage());
                       continue;
                   }
                   
                   if((String.isNotBlank(isPreferredPartner)) && (isPreferredPartner.equalsIgnoreCase('Y') || isPreferredPartner.equalsIgnoreCase('YES'))){
                       Preferred_Partners__c preferredPartner = new Preferred_Partners__c();
                        
                       //Custom Setting Name Limit Work Around
                        if(referellaCode.length() > 38){
                        	//Incorrect interest rate for preferred partners - incidenet 44
                            preferredPartner.Name =  referellaCode.subString(0,38).toLowerCase();   
                        }
                        else{
                            //Incorrect interest rate for preferred partners - incidenet 44
                            preferredPartner.Name =  referellaCode.toLowerCase();
                        }              
                        
                        preferredPartner.Tier_Type__c =  tierType;
                        
                        preferredPartners.add(preferredPartner);
                   }
               }
               System.debug('preferredPartners: '+preferredPartners);
               //Delete existing records and insert upcoming records in Custom Setting
               if(preferredPartners.size() > 0){
                   delete [Select id from Preferred_Partners__c];
                   insert New List<Preferred_Partners__c>(preferredPartners);
               }
               //Success Message on VFPage
               ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM,+preferredPartners.size()+' Records are inserted sucessfully.'));
           }
           else{
               //Error Message on VFPage
               ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,errorMessage));
           }
           
       }
       catch (Exception exp){
           //Error Message on VFPage
           ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,exp.getMessage()));
       }
       csvBody = null;  
   }
}