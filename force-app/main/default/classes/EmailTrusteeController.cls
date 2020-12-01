/**************************************************************************************************
*
*  Class:   EmailTrusteeController
*
*  @description : This is a controller class to send emails to trustee from Insolvency account page 
*  @author : A5E Consulting
*  @date : 10/06/2020

*************************************************************************************************/
global class EmailTrusteeController{
    
    // Variable to fetch data related to custom settings, exceptions
    public PoC_Package_Settings__c pocPackage{set;get;}
    public Boolean isSelectedAtt {set;get;}
    
    //Show validation message when total attachments size is exceeded
    public Application_Configuration_Settings__c config;// = Application_Config_Settings__c.getOrgDefaults();
    public Boolean attachSizeException{set;get;}
    public String attachSizeExceptionMessage{set;get;}
    
    global Boolean isAnyException {set;get;}
    public Id attachmentSelected{set;get;}
    public Application__c application {set;get;}
    public List<ApplicationAttachments> applicationAttachList{set;get;}
    public Boolean docException {set;get;}
    public Boolean accStatementError {set;get;}
    public Boolean isAmemdedClaim {set;get;}
    public Boolean isPocRequired {set;get;}
    public Boolean isActive {set;get;}

    // Variable that are used to store emails, email subject, body and footers
    public String toEmail{set;get;}
    public String subject {set;get;}
    public String htmlEmailheader {set;get;}
    public String htmlEmailfooter {set;get;}
    public String emailBody {set;get;}
    public String emailName {set;get;}
    
    // Stores all attachments that are selected by user
    public Set<Id> mySelectedAtt = new Set<Id>();
    
    //template lists for with or without header
    list<Id> insolTemplateWithHeaderList{get; set;}
    list<Id> insolTemplateWithoutHeaderList{get; set;}
    
    //template lists for mandatory attchments list
    list<Id> insolTemplateWithManAttachList{get; set;}
    
    // template related variables
    public List<selectOption> templates {set;get;}
    public Id selectedTemplate {set;get;}
    map<Id, EmailTemplate> emailTemplateMap = new map<Id, EmailTemplate>();
    
    // Controller to load initial values and insolvancy account details
    public EmailTrusteeController(){
        isAnyException  = false;
        isAmemdedClaim = false;
        isPocRequired = false;
        //Atachment Size limit check
        attachSizeException = false;
        //TrusteeOffice Active Check
        isActive = true;
        config = [SELECT Maximum_Email_Attachments_Size_Text__c, Maximum_Email_Attachments_Size__c,
                    Domain_Name__c FROM Application_Configuration_Settings__c FOR UPDATE];//update for lock issue
        
        attachSizeExceptionMessage = config.Maximum_Email_Attachments_Size_Text__c;
        
        application = [SELECT Id, Name,
        First_Name__c, Last_Name__c,Remaining_Balance__c,
                     Customer__c,
                     Customer__r.Communication_Preference__pc,
                     Customer__r.Fax, 
                     Customer__r.Name,
                     Customer__r.PersonEmail,
                     Customer__r.Active__c,
                     Loan_Type__c
                     FROM Application__c 
                     WHERE Id =: ApexPages.currentPage().getParameters().get('Id') FOR UPDATE]; 
        
        if(application.Customer__r.Communication_Preference__pc == 'Fax'){
            toEmail =  formatFaxAsEmail(application.Customer__r.Fax);                        
        }
        else{
            toEmail =  application.Customer__r.PersonEmail;
        }
        
        //checking if Application Customer is Active
        if(application.Customer__r.Active__c == 'No'){ 
           system.debug('Customer is not Active so email cannot be sent');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Customer is not Active so email cannot be sent')); 
            isActive=false;
        }
        applicationAttachList = new List<ApplicationAttachments>();
        
        Datetime now = Datetime.now();
        Integer offset = UserInfo.getTimezone().getOffset(now);
        
        // Read all attachments related to insolvacny account
        for (Attachment attchmt : [select Name, 
                                   Body, BodyLength,  
                                   Description,
                                   createdDate 
                                   from Attachment where ParentId =: application.Id 
                                   order by lastmodifieddate desc
                                  ]){
                                      
                                    ApplicationAttachments temp = new ApplicationAttachments();
                                      temp.attId = attchmt.Id;
                                      temp.selected =false;
                                      temp.fileName=attchmt.Name;
                                      temp.fileDesc=attchmt.Description;
                                      temp.fileCreatedDate = attchmt.createdDate.addSeconds(offset/1000);
                                      temp.displaySize = Utilities.fileSizeToString((attchmt.BodyLength));
                                      
                                      applicationAttachList.add(temp);
                                  }
        
        // Read custom settings to use hard code values in poc package
        pocPackage = (PoC_Package_Settings__c)PoC_Package_Settings__c.getInstance();
        
        loadEmailTemplates();
        emailTemplatechanged();
    } 
    
    //Loads template which names start with Insolvency
    public void loadEmailTemplates(){
        
        //Fetcth Id's List for With or Without Header
        string idWithHeaderList = pocPackage.Insolvency_Template_Header__c;
        insolTemplateWithHeaderList = idWithHeaderList.split(',');
        string idWithoutHeaderList = pocPackage.Insolvency_Template_WoHeader__c; 
        insolTemplateWithoutHeaderList = idWithoutHeaderList.split(',');
        
        //Fetcth Id's List for Attachment Required Email Templates
        String idWithMandAttchList = pocPackage.Attachment_Required_Email_Templates__c;
        insolTemplateWithManAttachList =  idWithMandAttchList.split(',');
        
        //Default Template
        selectedTemplate = insolTemplateWithoutHeaderList.get(0);
        
        templates = new List<selectOption>();
        //templates.add(new SelectOption('','--select--'));
        //for(EmailTemplate emailTemp : [SELECT Id, Name, HtmlValue, Body,Subject FROM EmailTemplate WHERE (Name LIKE 'Insolvency %' OR Name LIKE 'POC %') AND (NOT NAME LIKE '%Error%')])
        for(EmailTemplate emailTemp : [ SELECT Id, Name, HtmlValue, Body,Subject 
                                        FROM EmailTemplate 
                                        WHERE ( Id IN: insolTemplateWithHeaderList OR 
                                                Id IN: insolTemplateWithoutHeaderList 
                                                /*OR Id IN: insolTemplateWithManAttachList */
                                        )
                                    ]){
            emailTemplateMap.put(emailTemp.Id, emailTemp);            
            templates.add(new SelectOption(emailTemp.Id,emailTemp.Name));
        }
    }   
    
    //Load email template body, subject seelcted from drop down
    public void emailTemplatechanged(){
        if(emailTemplateMap.containsKey(selectedTemplate )){
            EmailTemplate emt = emailTemplateMap.get(selectedTemplate );
            subject = emt.subject;
            if(subject != null){
                // replace any merge fields
                if(subject.contains('{!Application__c.Name}')){
                    subject = subject.replace('{!Application__c.Name}', application.Name);    
                }
                if(subject.contains('{!Application__c.First_Name__c}')){
                    subject = subject.replace('{!Application__c.First_Name__c}', application.First_Name__c);    
                }
                if(subject.contains('{!Application__c.Last_Name__c}')){
                    subject = subject.replace('{!Application__c.Last_Name__c}', application.Last_Name__c);    
                }
            }
            emailBody = emt.body;
            emailName = emt.Name;
            // split header and footer from HTML email template
            String[] emailContent = emt.HTMLValue.split('<body>');
            system.debug('emailContent='+emailContent );
            
            //htmlEmailheader = emailContent[0];
            system.debug('htmlEmailheader ='+htmlEmailheader );
            
            //emailContent = emailContent[1].split('</body>');
            system.debug('emailContent ='+emailContent );
            
            //htmlEmailFooter = emailContent[1];           
            system.debug('htmlEmailFooter ='+htmlEmailFooter );
            
            // replace all merge fields that are in email template
            if (emailBody != null){
                
                if(emailBody.contains('{!Application__c.First_Name__c}')){
                    emailBody = emailBody.replace('{!Application__c.First_Name__c}', application.First_Name__c);    
                }
                if(emailBody.contains('{!Application__c.Last_Name__c}')){
                    emailBody = emailBody.replace('{!Application__c.Last_Name__c}', application.Last_Name__c);    
                }
                if(emailBody.contains('{!Application__c.Remaining_Balance__c}')){       
                    emailBody = emailBody.replace('{!Application__c.Remaining_Balance__c}', String.valueOf(application.Remaining_Balance__c));         
                }
                if(emailBody.contains('{!User.FirstName}')){       
                    emailBody = emailBody.replace('{!User.FirstName}', UserInfo.getFirstName());         
                }
                if(emailBody.contains('{!User.LastName}')){       
                    emailBody = emailBody.replace('{!User.LastName}', UserInfo.getFirstName());         
                }
            }  
            
            system.debug('insolTemplateWithHeaderList=='+insolTemplateWithHeaderList);
            if(insolTemplateWithHeaderList.contains(emt.Id)){
                //htmlEmailheader = htmlEmailheader.replace('{!pocPackage.CFG_Office_Name__c}', (pocPackage.CFG_Office_Name__c != null ? pocPackage.CFG_Office_Name__c : ''));
            }
        }
    }
    
    // Method implementes functionality to send email to trustee with selected attachments
    public PageReference sendEmail() {
        
        accStatementError = false;
        docException = false;
        attachSizeException = false;
        isPocRequired = false;
        isAmemdedClaim = false;
        
        //to check if NovaScotia trustee
        if(checkEligibleTrustee()){
            if(checkAttachmentForAccState()){
                accStatementError = true;
                return null;
            } 
        }  
        
        //send Email with selected attachments for header templates
        if(insolTemplateWithManAttachList.contains(selectedTemplate)){    
            if(checkAttachment()){
                docException = true;
                return null;
            }
        }
        
        //Atachment Size limit check
        Decimal totalFilesize = 0;
        Decimal maxAttachSize = config.Maximum_Email_Attachments_Size__c;
        for(Attachment selectedAtt: [SELECT Name, Body, BodyLength FROM Attachment WHERE Id IN : mySelectedAtt]){
            totalFilesize = totalFilesize + selectedAtt.BodyLength;
        }
        
        if(totalFilesize > maxAttachSize){
            attachSizeException = true;
            return null;
        } 
        else{
            attachSizeException = false;
        }       
        
        try{
            isAnyException  = false;
            
            // Use single email message feature of salesforce
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(toEmail.endsWith(';')){
                toEmail = toEmail.subString(0, toEmail.length()-1);
            }
            List<String> toEmails = new List<String>(toEmail.split(';'));
            
            // read email body from VF page and bind with format of new lines
            String emailBodyCustomized ='';
            if (emailBody != null){
                for(String s: emailBody.split('\n')){
                    emailBodyCustomized = emailBodyCustomized +s+'<br/>';
                }
            }
            mail.setToAddresses(toEmails);
            mail.setOrgWideEmailAddressId(pocPackage.Trustee_Email_Org_Wide_Address_Id__c);
            mail.setSubject(subject);
            if(htmlEmailheader == null){
                htmlEmailheader ='';
            }
            if(htmlEmailFooter == null){
                htmlEmailFooter ='';
            }
            
            String htmlBody = htmlEmailheader +'<body style="clear:both;">'+emailBodyCustomized +'</body>'+htmlEmailFooter ;
            mail.setHTMLBody(htmlBody );
            
            // Set activity tru to create activity once email is send
            mail.setSaveAsActivity(true);
            mail.setWhatId(application.Id);
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            
            // Attach files to email
            for(Attachment attObj : [SELECT Name, Body FROM Attachment WHERE Id IN : mySelectedAtt]){              
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(attObj .Name);
                efa.setBody(attObj.Body);
                fileAttachments.add(efa);                
            }
            
            mail.setFileAttachments(fileAttachments);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
          
            
            // Create Attachment against activity history on Insolvency Account
            List<Task> emailTask = [select id from Task where whatID =: application.Id ORDER BY CreatedDate DESC limit 1];
            System.debug('emailTask--'+emailTask);
            List<EmailMessage> emailmsg = [select Id, parentId from EmailMessage where activityId = : emailTask[0].Id];
            
            list<Attachment> emailMsgAttachments = new list<Attachment>();
            for(Attachment emailMsgAtt : [SELECT Name, Body, ParentId, Description FROM Attachment WHERE Id IN : mySelectedAtt]){
                Attachment emailAttachment = new Attachment();
                emailAttachment.body = emailMsgAtt.body;
                emailAttachment.Name = emailMsgAtt.Name;
                emailAttachment.Description = emailMsgAtt.Description;
                emailAttachment.ParentId = emailmsg[0].id; 
                emailAttachment.isPrivate = false; 
                emailMsgAttachments.add(emailAttachment);
            }         
            if(emailMsgAttachments.size()>0){
                insert emailMsgAttachments;
            } 
        }
        catch(Exception ex){ 
            system.debug('===='+ex.getMessage());
            isAnyException = true;
        }
        return null;
    }
    
    //Handles to store list of attachments selected by user
    public void attachmentSelected(){
        if(attachmentSelected != null){
            mySelectedAtt.add(attachmentSelected );
            attachmentSelected = null;
        }
    }
    
    //Handles to remove attachments un selected by user
    public void attachmentRemoved(){
        if(attachmentSelected != null){
            mySelectedAtt.remove(attachmentSelected );
            attachmentSelected = null;
        }
    }
    
    //Utility method to format Fax As Email Address
    private static string formatFaxAsEmail(String faxNo){
        String formattedFax = faxNo;
        if(String.isNotBlank(formattedFax)){
            formattedFax = formattedFax.replace('(', '').replace(')', '');
            formattedFax = formattedFax.replaceAll('-', '');
            formattedFax = formattedFax.replaceAll(' ', '');
            
            Application_Configuration_Settings__c acs = [SELECT Domain_Name__c FROM Application_Configuration_Settings__c FOR UPDATE];//update for lock issue
            formattedFax =  formattedFax + acs.Domain_Name__c;
        }  
        return formattedFax;
    }
    
    // Wrapper class used to frame attachments with checkboxes 
    public class ApplicationAttachments{
        public Boolean selected{set;get;}
        public Id attId{set;get;}
        public String filename{set;get;}
        public String fileDesc{set;get;}
        public DateTime fileCreatedDate {set;get;}
        public String displaySize {set;get;}
    }
    
    //Check if attachment selcted or not
    public boolean checkAttachment(){
        
        boolean error = true;
        list<Attachment> checkedAttchList = new list<Attachment>([select Name, Body, BodyLength, Description, createdDate from Attachment where ParentId =: application.Id and Id IN: mySelectedAtt]);               
        
        for(Attachment selectedAttach : checkedAttchList){
            
            if(selectedAttach.Description == 'PoC Document'){
                error = false;
                return error;
            }
        }
        
        return error;
    }  
    
    // Check the Attachment for Account Statement
    public boolean checkAttachmentForAccState(){
        
        System.debug('TestcheckAttachmentForAcc');
        Boolean trusteeCheckErrorForAttach = checkEligibleTrustee();
        boolean accountStateError = false;
        list<Attachment> checkedAttchList = new list<Attachment>([select Name, Body, BodyLength, Description, createdDate from Attachment where ParentId =: application.Id and Id IN: mySelectedAtt]);               
        System.debug('CheckedAttachList' + checkedAttchList);
        
        for(Attachment selectedAttach : checkedAttchList){
            System.debug('Test');
            if(selectedAttach.Description == 'Account Statement'){
                accountStateError = true;
                return accountStateError;
            }
        }
        return accountStateError;
        
    } 
    
    
    
    // Check the trustee 
    public boolean checkEligibleTrustee(){
        
        System.debug('TestCheckTrustee');
        List<String> trusteeCheckList = new List<String>();
        Boolean trusteeCheckError = false ;    
        //pocPackage = (PoC_Package_Settings__c)PoC_Package_Settings__c.getValues(insolvAcc.Client_Identifier__c);
        String idWithAccountStatement = pocPackage.Account_Statement_Not_Allowed__c;
        trusteeCheckList = idWithAccountStatement.split(',');
        
        for(String trusteeCheck: trusteeCheckList){
            if(application.Customer__c == trusteeCheck){
                trusteeCheckError = true;
                System.debug('TrusteeCheckError');
                return trusteeCheckError;
            }
        }
        System.debug('TrusteeCheckError1');
        return trusteeCheckError;
        
    }  
}