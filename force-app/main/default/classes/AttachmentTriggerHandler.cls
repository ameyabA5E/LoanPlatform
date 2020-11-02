/**************************************************************************************************
*
*  Trigger:   
*
*  @description : This is a Trigger Handler Class for Attachment object 
*  @author : A5E Consulting
*  @date : 10/06/2016
* 
*************************************************************************************************/

public class AttachmentTriggerHandler{
    
    //Handle Befor Delete
    public static void handleBeforeDelete(List<Attachment> oldList){
        
        Profile profileInfo = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() limit 1];
        if('System Administrator' != profileInfo.Name && 'CFG - Application Admin' != profileInfo.Name ){
            for(Attachment attach : oldList){
                if (attach.ParentId != null){
                    if(attach.ParentId.getSObjectType() == Application__C.sObjectType || 
                       attach.ParentId.getSObjectType() == Product__c.sObjectType ||
                       attach.ParentId.getSObjectType() == Funding_Batch__c.sObjectType ){
                           attach.ParentId.addError('You can not Delete an Attachment from Application, Product and Funding Batch Records');
                       }
                }
            }
        }
    }
    
    //Handle Befor Update
    public static void handleBeforeEdit(List<Attachment> newList){
        
        Profile profileInfo = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() limit 1];
        if('System Administrator' != profileInfo.Name && 'CFG - Application Admin' != profileInfo.Name ){
            for(Attachment attach : newList){
                if (attach.ParentId != null){
                    if(attach.ParentId.getSObjectType() == Funding_Batch__c.sObjectType ){
                           attach.ParentId.addError('You can not Edit an Attachment from Funding Batch Records');
                       }
                }
            }
        }
    }
}