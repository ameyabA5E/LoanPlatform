/**************************************************************************************************
*
*  Class:   
*
*  @description : This ControllerClass is used for attaching files with Document ame along with month & year of uploading.     
*  @author : A5E Consulting
*  @date : 10/03/2020

*************************************************************************************************/
public with sharing class FileUploadController {
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId, String documentType, String month, String year) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType, documentType, month, year);
        } else {
            appendToFile(fileId, base64Data);
        }        
        return Id.valueOf(fileId);
    }   
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType, String documentType, String month, String year) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion oAttachment = new ContentVersion();
       //oAttachment.ContentDocumentId = parentId;
        oAttachment.ContentLocation = 'S'; //Setting that location of file will be in salesforce
        oAttachment.VersionData = EncodingUtil.base64Decode(base64Data);
        oAttachment.Title = fileName;
        oAttachment.PathOnClient= 'test.pdf';
        if(documentType != '--None--'){
            oAttachment.Description = documentType + ';' + month + ';' + year;
        }else{          
        }
        insert oAttachment;
        // First get the content document Id from ContentVersion
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:oAttachment.Id].ContentDocumentId;
        //Create ContentDocumentLink
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = parentId; // you can use objectId,GroupId etc
        cDe.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        cDe.Visibility = 'AllUsers';
        insert cDe;
        return cDe.Id;
    }   //Saving Files

    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');    
        //Attachment a = [SELECT Id, Body FROM Attachment WHERE Id =: fileId];
      ContentVersion  conv = [SELECT Id, Title, ContentDocumentId,FileType,Description,CreatedDate,LastModifiedDate FROM ContentVersion WHERE ContentDocumentId =: fileId];
        String existingBody = EncodingUtil.base64Encode(conv.VersionData);    
        conv.VersionData = EncodingUtil.base64Decode(existingBody + base64Data);     
        update conv;
    }   
    @AuraEnabled //Fetching Document Names from Custom Setting 
    public static List<String> documentTypeList(){
        List<String> listDocumentType = new List<String>{'--None--'};
        List<Attachment_Document_Type__mdt> attachlistsetting = new List<Attachment_Document_Type__mdt>();
        attachlistsetting =[SELECT MasterLabel, Document_type__c FROM Attachment_Document_Type__mdt order by MasterLabel ASC];
        for( Attachment_Document_Type__mdt alist : attachlistsetting ) {
            listDocumentType.add(alist.Document_type__c);
        }
        listDocumentType.sort();
        return listDocumentType;      
    }   
    @AuraEnabled // Setting Months list 
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
    }  
     @AuraEnabled // Setting Year list
    public static List<String> yearList(){
        List<String> listDocumentType = new List<String>();
        listDocumentType.add('--None--');
        for(Integer i =  2030; i >= 2000; i--){
            listDocumentType.add(String.valueOf(i));
        }
        system.debug('List of Year : ' + listDocumentType);
        return listDocumentType; }
}