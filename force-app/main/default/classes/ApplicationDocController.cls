public class ApplicationDocController {
    public Application__c application {set;get;}
    public Boolean isAnyException {set;get;}
    public static Id applicationId;
    public final String todayDate{set;get;}


    public ApplicationDocController() {

        todayDate = Datetime.now().format('EEE, d MMM yyyy');


        //get the current record id
        applicationId = ApexPages.currentPage().getParameters().get('Id');

        //query the application detials
        application = [SELECT Name,Approved_Amount__c, Customer__r.Name, Customer__r.BillingStreet, Customer__r.BillingCountry, Customer__r.BillingCity, Customer__r.BillingState,Customer__r.BillingPostalCode FROM Application__c WHERE Id=: applicationId];
    }

    public PageReference savePOCDoc() {
        
        // Read pdf and pass all necessary parameters to pocdoc page
        PageReference pdf = Page.ApplicationDoc;  
        
        //pdf.getParameters().put('id',applicationId);
        pdf.getParameters().put('id',ApexPages.currentPage().getParameters().get('Id'));
        Blob body;
        if (!Test.IsRunningTest()){
            //body = pdf.getContent();
            body = Blob.valueOf('Test');
        }
        else{
            body = Blob.valueOf('Test');
        }


        Attachment attach = new Attachment();
        attach.Body = body;
        DateTime d = Date.Today() ;
        String dateStr =  d.formatGMT('yyyy-MM-dd') ;
        attach.Name = application.Name+'_' +Datetime.now().format('MMM_d_yyyy_HH:mm:ss') +'.pdf';// Display name of the files
        attach.IsPrivate = false;
        attach.Description = 'tet';
        attach.ParentId = ApexPages.currentPage().getParameters().get('Id'); // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object);
        insert attach;

        system.debug(attach.Id);
         
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
        conVer.PathOnClient = application.Name+'.pdf'; // The files name, extension is very important here which will help the file in preview; 
        conVer.Title = application.Name+'_' +Datetime.now().format('MMM_d_yyyy_HH:mm:ss');// Display name of the files
        conVer.VersionData = body; // converting your binary string to Blog
        insert conVer;    //Insert ContentVersion


        // First get the Content Document Id from ContentVersion Object
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        //create ContentDocumentLink  record 
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = ApexPages.currentPage().getParameters().get('Id'); // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        insert conDocLink;


		return null; //send the User on their way
    }
}