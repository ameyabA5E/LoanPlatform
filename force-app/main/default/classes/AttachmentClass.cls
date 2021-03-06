/**************************************************************************************************
*
*  Class:   
*
*  @description : This ControllerClass is used for displaying Document Names along with month & year of uploading.     
*  @author : A5E Consulting
*  @date : 10/03/2020

*************************************************************************************************/
public class AttachmentClass {
    public static List<ContentDocumentLink> ConDocLnk{set;get;}
    public static List<ContentDocument> ConDoc{set;get;}
    
    @AuraEnabled
    public  static  Map<id,ContentDocument> attachmap {set;get;} 

    @AuraEnabled
    public static List<AttachWrapper> getAttachment(Id parentId){
        //system.debug('Parent ID' + parentID);
        Set<Id> newset = new Set<ID>{parentId};
        ConDocLnk=[SELECT id,LinkedEntityId,ContentDocumentId,Visibility,ShareType FROM ContentDocumentLink WHERE LinkedEntityId IN :newset]; 
        //system.debug('ContentDocumentLinks are' + ConDocLnk);
         // Make a List of ContentDocument IDs
        List <Id> CDIdList = new List <Id> ();
        for (ContentDocumentLink nextCDL : ConDocLnk) 
        {      
            nextCDL.Visibility='AllUsers'; // File visibility is to All Users
            //nextCDL.ShareType='V';
            //update nextCDL;
            CDIdList.add(nextCDL.ContentDocumentId); 
        }   
       //system.debug('ContentDocumentIds are' + CDIdList);  
        ConDoc = [SELECT Id, Title, FileType,Description,CreatedDate,LastModifiedDate FROM ContentDocument WHERE Id IN :CDIdList order by createdDate desc];
        //system.debug('CDS are' + ConDoc);
        List<AttachWrapper> listWrapper = new List<AttachWrapper>();
        attachmap  = new Map<id,ContentDocument>();
        for(ContentDocument attach : ConDoc){
            AttachWrapper wrapRecord = new AttachWrapper(attach);
            listWrapper.add(wrapRecord);        
        }      
        return listWrapper;       
    }//fetching parent record    
    public class AttachWrapper{
        
        @AuraEnabled public string attachmentName{set;get;}
        @AuraEnabled public String docType{set;get;}
        @AuraEnabled public string month{set;get;}
        @AuraEnabled public string year {set;get;}
        @AuraEnabled public ContentDocument attachRecord {set;get;}
        @AuraEnabled public Id attachID{set;get;}      
        @AuraEnabled public string attachmentCreateddate{set;get;}
        @AuraEnabled public string attachmentLastmodifieddate{set;get;}
        
        public Attachwrapper(ContentDocument attach)
        {
            attachID = attach.id;
            attachmentName = attach.Title;
            //attachRecord = attach;
            List<String> descriptionList = new List<String>();
            if(!(String.isBlank(attach.description))){
                descriptionList = (attach.description).split(';');
                if(descriptionList.size() > 0){
                    docType = descriptionList[0];
                }
                if(descriptionList.size() > 1){
                    month = descriptionList[1];
                    year = descriptionList[2];
                }
            }
            attachmentCreateddate = (attach.CreatedDate).format();
            attachmentLastmodifieddate = (attach.LastModifiedDate).format();
            
        }
    } 
    
    @AuraEnabled
    public static List<String> getPickListValuesIntoList(){
        
        List<String> listDocumentType = new List<String>();
        List<Attachment_Document_Type__mdt> attachlistsetting = new List<Attachment_Document_Type__mdt>();
        attachlistsetting =[SELECT MasterLabel, Document_type__c FROM Attachment_Document_Type__mdt order by MasterLabel];
        for( Attachment_Document_Type__mdt alist : attachlistsetting ) {
            listDocumentType.add(alist.Document_type__c);
        }
        return listDocumentType;
    }// Getting Attachment Document List       
 @AuraEnabled
    public static List<String> monthList(){
        List<String> listDocumentType = new List<String>();
        listDocumentType.add('--None--');
        listDocumentType.add('Jan');
        listDocumentType.add('Feb');
        listDocumentType.add('Mar');
        listDocumentType.add('Apr');
        listDocumentType.add('May');
        listDocumentType.add('Jun');
        listDocumentType.add('Jul');
        listDocumentType.add('Aug');
        listDocumentType.add('Sep');
        listDocumentType.add('Oct');
        listDocumentType.add('Nov');
        listDocumentType.add('Dec');
        return listDocumentType;
        
    } // Setting Month list
@AuraEnabled
    public static List<String> yearList(){
        List<String> listDocumentType = new List<String>();
        listDocumentType.add('--None--');
        for(Integer i =  System.Today().year(); i >= 2000; i--){
            listDocumentType.add(String.valueOf(i));
        }
        //system.debug('List of Year : ' + listDocumentType);
        return listDocumentType;
    } // Setting Year list
}