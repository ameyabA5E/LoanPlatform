/**************************************************************************************************
 *
 *  Class:   
 *
 *  @description : This is a controller class to display Customer Collections Data 
 *  @author : A5E Consulting
 *  @date : 12/27/2016
 *  
 *************************************************************************************************/
public class CustomerCollectionsController {
    
    public static String accntId{get;set;}
    public List<TaskWrapper> wrappedCustTasks {get;set;}
    public List<CollectionNoteWrapper> wrappedCustColctNotes {get;set;}
    public List<ProdWrapper> wrappedProducts {get;set;}
    public String urlForPage{get;set;}
    public String urlForNewActivity{get;set;}
    public static List<ID> listActivitiesRelatedID{get;set;}
    public Integer countActivitiesForThisWeek{get;set;}
    public static Collection_Custom_Setting__c collCustSett{get;set;}
    public List<collectionWrpper> collectionNoteWrapperList{get;set;}
    //testing fields
    Public static String dateFormat{get;set;}
    public static string localeName{get;set;}
    public Boolean showCount{get;set;}
    
    //Constructor
    public CustomerCollectionsController(ApexPages.StandardController controller) {
        
        accntId = ApexPages.currentPage().getParameters().get('id');
        wrappedCustTasks = new List<TaskWrapper>();
        wrappedCustColctNotes = new List<CollectionNoteWrapper>();
        wrappedProducts = new List<ProdWrapper>();
        listActivitiesRelatedID = new List<ID>();
        urlForPage = '';
        urlForNewActivity = '';
        List<ID> listProdID = new List<ID>();
        collCustSett = Collection_Custom_Setting__c.getOrgDefaults();
        collectionNoteWrapperList = new List<collectionWrpper>();
        listActivitiesRelatedID.add(accntId);
        dateFormat = '';
        //Products
        List<Product__c> custProds = [Select Id, Name, 
                                            Source_System__c, Interest_Rate__c, Current_Balance__c, Current_Balance_Effective_Date__c, 
                                            Credit_Limit__c, Card_Activated__c, Delinquency_Status_Formula__c, Delinquency_Status__c,
                                            Last_Delinquency_Date__c, Effective_Next_Payment_Date__c, Effective_Next_Payment_Amount__c, 
                                            Delinquency_Days__c, External_Status_Current__c, External_Status_Description__c,
                                            VersaPay_State__c, Last_Payment_Amount__c, Last_Payment_Date__c
                                            From Product__c 
                                            where Customer__c=:accntId 
                                            and Delinquency_Status_Formula__c = True
                                            ]; 
        system.debug(accntId);
                //system.debug('pp '+[SELECT Customer__c,Delinquency_Status_Formula__c FROM Product__c]);
        if(!custProds.isEmpty()){
            for(Product__c prd: custProds){
                wrappedProducts.add(new ProdWrapper(prd));
                listProdID.add(prd.id);
                listActivitiesRelatedID.add(prd.id);
                
            }
            for(ProdWrapper wrpProd : wrappedProducts){
                for(PTP_Information__c ptpInfo : wrpProd.listPTPInfo){
                    listActivitiesRelatedID.add(ptpInfo.id);
                }
                /*for(CollectionNoteWrapper wrpNte: wrpProd.wrappedCustColctNotes){
                    //wrappedCustColctNotes.add(new CollectionNoteWrapper(nte));
                    listActivitiesRelatedID.add(wrpNte.nte.id);
                }*/
            }
            
        }         
        
        List<Collection_Notes__c> custColctNotes = [Select Id, Title__c, Body__c, Type_of_Notes__c, 
                                                    Product__r.Name, Product__r.id, createdDate, createdBy.Name, 
                                                    lastModifiedDate, lastModifiedBy.Name 
                                                    from Collection_Notes__c
                                                    where Product__r.id in :listProdID
                                                    order by lastModifiedDate desc];
        
        if(!custColctNotes.isEmpty()){
            for(Collection_Notes__c nte: custColctNotes){
                wrappedCustColctNotes.add(new CollectionNoteWrapper(nte));
                listActivitiesRelatedID.add(nte.id);
            }            
        }
        
        // Collection wrapper list
        if(!custProds.isEmpty()){
            for(Product__c prd: custProds){
                List<CollectionNoteWrapper> wrappedCustColNotes = new List<CollectionNoteWrapper>();
                if(!custColctNotes.isEmpty()){
                    for(Collection_Notes__c nte: custColctNotes){
                        if(prd.id == nte.Product__r.id){
                            wrappedCustColNotes.add(new CollectionNoteWrapper(nte));
                            //listActivitiesRelatedID.add(nte.id);
                        }
                    }            
                }
                
                collectionNoteWrapperList.add(new collectionWrpper(prd, wrappedCustColNotes));
            }
        }
        
        //Tasks
        List<Task> custTasks = [Select Id, WhatId, Subject, Owner.Name, status,
                            Method_Of_Contact__c, Operational_Outcome__c, Legal_Followup__c, Best_Time_To_Call__c,
                            Description, LastModifiedBy.Name, LastModifiedBy.Id, LastModifiedDate, ActivityDate,
                            CallClassification1__c
                            /*//PTC Information
                            PTP1_Amount__c, PTP1_Method__c, PTP1_Date__c, PTP1_mate_with__c, 
                            PTP2_Amount__c, PTP2_Method__c, PTP2_Date__c, PTP2_mate_with__c, 
                            PTP3_Amount__c, PTP3_Method__c, PTP3_Date__c, PTP3_mate_with__c*/
                            From Task 
                            where WhatId in :listActivitiesRelatedID and isdeleted=false and 
                            (Type_of_Activity__c = 'Collection' or Subject like '%Collection%' or CallClassification1__c like '%Collection%') order by ActivityDate DESC All Rows];
        
        /******** Task Sorting STARTS added by Rakesh Muppiri**************/
        // Segregate tasks based on values in Due Date field and Status
        List<Task> hasDueDate = new List<Task>();
        List<Task> noDueDate = new List<Task>();
        List<Task> completedTask = new List<Task>();
        
        if(!custTasks.isEmpty()){
            for(Task tsk: custTasks){
                // Store Competed Tasks
                if(tsk.Status =='Completed'){
                    completedTask.add(tsk);
                }
                // Store Tasks where due date is not null
                else if(tsk.ActivityDate != null){
                    hasDueDate.add(tsk);
                }
                // Store Tasks with Due date as null
                else{
                    noDueDate.add(tsk);
                }
                //wrappedCustTasks.add(new TaskWrapper(tsk));     // Commented by Rakesh
            }            
        }
        
        // Add all Tasks the dont have Due date to list to follow the order
        hasDueDate.addAll(noDueDate);
        
        // Process Tasks that is not Completed
        for(Task tsk :hasDueDate){
            wrappedCustTasks.add(new TaskWrapper(tsk));
        }
        
        // Process Tasks whos status is completed
        for(Task tsk :completedTask){
            wrappedCustTasks.add(new TaskWrapper(tsk));
        }
        /******** Task Sorting ENDS added by Rakesh Muppiri**************/
        
        List<Task> countTask = [Select Id From Task where WhatId =: accntId and isdeleted=false and 
                            (Type_of_Activity__c = 'Collection' or Subject like '%Collection%' or CallClassification1__c like '%Collection%') and lastModifiedDate = LAST_n_DAYS:5 All Rows];
        countActivitiesForThisWeek = countTask.size();
        if(countTask.size() > 0){
            showCount = true;
        }else{
            showCount = false;
        }
                            
        //Notes
        /*List<Note> custColctNotes = [Select Id, Title, ParentId, IsPrivate  
                                            From Note
                                            where ParentId=:accntId and Title like '%collection%'];    
        if(!custColctNotes.isEmpty()){
            for(Note nte: custColctNotes){
                wrappedCustColctNotes.add(new NoteWrapper(nte));                                        
            }            
        }*/
        
        viewPageinNewWindow();
        newButton();                                                             
    } 
    
    //Task Wrapper 
    public class TaskWrapper {
        public Task tsk {get; set;}
        public String tskLink {get;set;}
        public String taskBody{get;set;}
    
        public TaskWrapper(Task tsk){
            this.tsk = tsk;
            this.tskLink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + tsk.Id;
            
            if(String.isNotBlank(tsk.Description)){
                if((tsk.Description).length() > 250){
                    this.taskBody = (tsk.Description).subString(0, 250) + '...';
                }else{
                    this.taskBody = tsk.Description;
                }
            }
            /*this.ptp1Date = dateToString(tsk.PTP1_Date__c);
            this.ptp2Date = dateToString(tsk.PTP2_Date__c);
            this.ptp3Date = dateToString(tsk.PTP3_Date__c);*/
        }
    } 
    
    /*//Note Wrapper
    public class NoteWrapper {
        public Note nte {get; set;}
        public String nteLink {get;set;}
        
        public NoteWrapper(Note nte){
            this.nte = nte;
            this.nteLink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + nte.Id;          
        }
    }*/
    
    public class CollectionNoteWrapper{
        public Collection_Notes__c nte{get;set;}
        public string strBody{get;set;}
        public String strLastModifiedDate{get;set;}
        
        public CollectionNoteWrapper(Collection_Notes__c nte){
            this.nte = nte;
            this.strBody ='';
            if(String.isNotBlank(nte.Body__c)){
                if((nte.Body__c).length() > 100){
                    this.strBody = (nte.body__c).subString(0, 100) + '...';
                }else{
                    this.strBody = nte.body__c;
                }
            }
            
            this.strLastModifiedDate = dateToString(nte.lastModifiedDate);
        }
        /* Commented By Rakesh, we have already implemented this function at parent class leve, so below below will never used
        public String newCollectionButton(String prodName, String prodID){
            pageReference pgRef = new pageReference('/' + collCustSett.Collection_Notes_ID_Initial__c + '/e?' + collCustSett.Collection_Product_Field_ID__c + '=' + prodName + '&' + collCustSett.Collection_Product_Field_ID__c + '_lkid=' + prodID + '&retURL=' + accntid);
            pgRef.setRedirect(true);
            return pgRef.getUrl();
        }
        */
    }
    
    //Product Wrapper
    public class ProdWrapper {
        public Product__c prd {get; set;}
        public String prdLink {get;set;}
        public String lastDelDate{get;set;}
        public String nextPaymentDate {get;set;}
        public String curBalEffDate {get;set;}
        public List<PTP_Information__c> listPTPInfo{get;set;}
        //public List<Collection_Notes__c> listCollNotes{get;set;}
        //public List<CollectionNoteWrapper> wrappedCustColctNotes{get;set;}
        public String urlForNewPTP{get;set;}
        
        public ProdWrapper(Product__c prd){
            //wrappedCustColctNotes = new List<CollectionNoteWrapper>();
            
            this.prd = prd;
            this.prdLink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + prd.Id;
            this.lastDelDate = dateToString(prd.Last_Delinquency_Date__c);
            this.nextPaymentDate = dateToString(prd.Effective_Next_Payment_Date__c);
            this.curBalEffDate = dateToString(prd.Current_Balance_Effective_Date__c);
            
            listPTPInfo = [select id, name, PTP_Date__c, PTP_Mate__c, PTP_Amount__c, PTP_Method__C from PTP_Information__c where Product__r.id =: prd.id order by lastModifiedDate desc];
            /*List<Collection_Notes__c> listCollNotes = [Select Id, Title__c, Body__c, Type_of_Notes__c, Product__r.Name, lastModifiedDate, lastModifiedBy.Name from Collection_Notes__c
                                                where Product__r.id =: prd.id];
            
            if(!listCollNotes.isEmpty()){
            for(Collection_Notes__c nte: listCollNotes){
                    wrappedCustColctNotes.add(new CollectionNoteWrapper(nte));
                    //listActivitiesRelatedID.add(nte.id);
                }            
            }*/
            urlForNewPTP = newPTPButton(prd.Name, prd.id);
            //urlForNewCollectionNote = newCollectionButton(prd.Name, prd.id);
        }
        
        public String newPTPButton(String prodName, String prodID){
            //https://cs22.salesforce.com/a19/e?CF00N17000001GApG=21461&CF00N17000001GApG_lkid=a0Dj000000092Ev&retURL=%2Fa0Dj000000092Ev
            pageReference pgRef = new pageReference('/' + collCustSett.PTP_ID_Initials__c +'/e?' + collCustSett.PTP_Product_Field_ID__c + '=' + prodName + '&' + collCustSett.PTP_Product_Field_ID__c + '_lkid=' + prodID + '&retURL=' + accntid);
            pgRef.setRedirect(true);
            return pgRef.getUrl();
        }
        
    }
    
    // Collections wrapper class used to 
    public class collectionWrpper{
        public Product__C prodID{get;set;}
        public list<CollectionNoteWrapper> listColNteWrp{get;set;}
        public String urlForNewCollectionNote{get;set;}
        
        public collectionWrpper(Product__C prdId, list<CollectionNoteWrapper> listNte){
            this.prodId = prdId;
            this.listColNteWrp = New List<CollectionNoteWrapper>(listNte);
            this.urlForNewCollectionNote = newCollectionButton(prdID.name, prdId.id);
        }
        
        public String newCollectionButton(String prodName, String prodID){
            //https://cs22.salesforce.com/a19/e?CF00N17000001GApG=21461&CF00N17000001GApG_lkid=a0Dj000000092Ev&retURL=%2Fa0Dj000000092Ev
            pageReference pgRef = new pageReference('/' + collCustSett.Collection_Notes_ID_Initial__c +'/e?' + collCustSett.Collection_Product_Field_ID__c + '=' + prodName + '&' + collCustSett.PTP_Product_Field_ID__c + '_lkid=' + prodID + '&retURL=' + accntid);
            pgRef.setRedirect(true);
            return pgRef.getUrl();
        }
    }
    
    private static String dateToString(DateTime dt){
        
        Map<String, String> mappedValues = new Map<String, String>();
        mappedValues = CustomerCollectionsController.MapValues(); 
        String user_locale = UserInfo.getLocale();
        String datetime_format = 'M/d/yyyy h:mm a';
        if (mappedValues.containsKey(user_locale)) {
            datetime_format = mappedValues.get(user_locale);
        }
        
        dateFormat = datetime_format;
        localeName = UserInfo.getLocale();
        if(dt !=null){
            //System.debug('Date: '+dt.format('MM/dd/yyyy'));
            //return dt.format('MM/dd/yyyy');
            //Datetime dt = DateTime.newInstance(dt, Time.newInstance(0, 0, 0, 0));
            
            //return DateTime.newInstance(dt.year(), dt.month(),dt.day()).format('MM/dd/yyyy');
            
            //return (dt.month()+ '/' + dt.day() + '/' + dt.year());
            
            return (dt.format(datetime_format));
            
        }
        else{
            return '';
        }    
    }
    
    public pageReference editAllNotes(){
        return null;
    }
    
    public pageReference editAllCommentsAndNotes(){
        return null;
    }
    
    // Updates tasks with the latest values given in the UI
    public pageReference saveTaskActivity(){
        
        List<ID> listTaskID = new List<ID>();
        for(TaskWrapper tskWrp : wrappedCustTasks){
            listTaskID.add(tskWrp.tsk.id);
        }
        
        List<Task> listTsk = [select id, Operational_Outcome__c, Legal_Followup__c, ActivityDate, CallClassification1__c from Task where id in : listTaskID];
        List<Task> listTskUpdate = new List<Task>();
        
        // Preparing wrapper class which is used to display under Tasks & Activity section on Collections page
        for(TaskWrapper tskWrp : wrappedCustTasks){
            for(Task tsk : listTsk){
                if(tsk.id == tskWrp.tsk.id){
                    tsk.Operational_Outcome__c = tskWrp.tsk.Operational_Outcome__c;
                    tsk.Legal_Followup__c = tskWrp.tsk.Legal_Followup__c;
                    tsk.ActivityDate = tskWrp.tsk.ActivityDate;
                    tsk.CallClassification1__c = tskWrp.tsk.CallClassification1__c;
                    listTskUpdate.add(tsk);
                }
            }
        }
        
        update listTskUpdate;
        return null;
    }
    
    // Method updates PTP records with latest data given 
    public pageReference saveDelinquentProducts(){
        
        List<PTP_Information__c> listPTP = new List<PTP_Information__c>();
        
        for(ProdWrapper prdWrp : wrappedProducts){
            for(PTP_Information__c ptpInfo : prdWrp.listPTPInfo){
                listPTP.add(ptpInfo);
            }
            
        }
        
        // Updatin PTP
        update listPTP;
        
        return null;
    }
    
    // Method invokes when user clicks on Cancel
    public pageReference cancelButton(){
        
        // Commented by Rakesh Muppiri
        //pageReference pgRef = new pageReference('/apex/CustomerCollections?id=' + accntId);
        
        // Added by Rakesh Muppiri
        pageReference pgRef = new pageReference('/apex/CustomerCollections?id=' + ApexPages.currentPage().getParameters().get('id'));
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    // Method opens same collection page in a new window
    public void viewPageinNewWindow(){
        pageReference pgRef = new pageReference('/apex/CustomerCollections?id=' + accntId);
        pgRef.setRedirect(true);
        urlForPage = pgRef.getUrl();
        
    }
    
    // Method return a new page to create Task
    public void newButton(){
        //00T/e?who_id=0011700000ixVV3&what_id=0011700000ixVV3&retURL=%2F0011700000ixVV3
        pageReference pgRef = new pageReference('/00T/e?who_id=' + accntId + '&what_id=' + accntid + '&retURL=' + accntid);
        pgRef.setRedirect(true);
        urlForNewActivity = pgRef.getUrl();
    }
    
    private static Map<String, String> MapValues() {
        Map<String, String> locale_map = new Map<String, String>(); //holds the locale to timedate formats
        locale_map.put('ar', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_AE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_BH', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_JO', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_KW', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_LB', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_SA', 'dd/MM/yyyy hh:mm a');
        locale_map.put('bg_BG', 'yyyy-M-d H:mm');
        locale_map.put('ca', 'dd/MM/yyyy HH:mm');
        locale_map.put('ca_ES', 'dd/MM/yyyy HH:mm');
        locale_map.put('ca_ES_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('cs', 'd.M.yyyy H:mm');
        locale_map.put('cs_CZ', 'd.M.yyyy H:mm');
        locale_map.put('da', 'dd-MM-yyyy HH:mm');
        locale_map.put('da_DK', 'dd-MM-yyyy HH:mm');
        locale_map.put('de', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_AT', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_AT_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_DE', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_DE_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_LU', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_LU_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('el_GR', 'd/M/yyyy h:mm a');
        locale_map.put('en_AU', 'd/MM/yyyy HH:mm');
        locale_map.put('en_B', 'M/d/yyyy h:mm a');
        locale_map.put('en_BM', 'M/d/yyyy h:mm a');
        locale_map.put('en_CA', 'dd/MM/yyyy h:mm a');
        locale_map.put('en_GB', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_GH', 'M/d/yyyy h:mm a');
        locale_map.put('en_ID', 'M/d/yyyy h:mm a');
        locale_map.put('en_IE', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_IE_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_NZ', 'd/MM/yyyy HH:mm');
        locale_map.put('en_SG', 'M/d/yyyy h:mm a');
        locale_map.put('en_US', 'M/d/yyyy h:mm a');
        locale_map.put('en_ZA', 'yyyy/MM/dd hh:mm a');
        locale_map.put('es', 'd/MM/yyyy H:mm');
        locale_map.put('es_AR', 'dd/MM/yyyy HH:mm');
        locale_map.put('es_BO', 'dd-MM-yyyy hh:mm a');
        locale_map.put('es_CL', 'dd-MM-yyyy hh:mm a');
        locale_map.put('es_CO', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_CR', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_EC', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_ES', 'd/MM/yyyy H:mm');
        locale_map.put('es_ES_EURO', 'd/MM/yyyy H:mm');
        locale_map.put('es_GT', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_HN', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_MX', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_PE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_PR', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_PY', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_SV', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_UY', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_VE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('et_EE', 'd.MM.yyyy H:mm');
        locale_map.put('fi', 'd.M.yyyy H:mm');
        locale_map.put('fi_FI', 'd.M.yyyy H:mm');
        locale_map.put('fi_FI_EURO', 'd.M.yyyy H:mm');
        locale_map.put('fr', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_BE', 'd/MM/yyyy H:mm');
        locale_map.put('fr_CA', 'yyyy-MM-dd HH:mm');
        locale_map.put('fr_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('fr_FR', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_FR_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_LU', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_MC', 'dd/MM/yyyy HH:mm');
        locale_map.put('hr_HR', 'yyyy.MM.dd HH:mm');
        locale_map.put('hu', 'yyyy.MM.dd. H:mm');
        locale_map.put('hy_AM', 'M/d/yyyy h:mm a');
        locale_map.put('is_IS', 'd.M.yyyy HH:mm');
        locale_map.put('it', 'dd/MM/yyyy H.mm');
        locale_map.put('it_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('it_IT', 'dd/MM/yyyy H.mm');
        locale_map.put('iw', 'HH:mm dd/MM/yyyy');
        locale_map.put('iw_IL', 'HH:mm dd/MM/yyyy');
        locale_map.put('ja', 'yyyy/MM/dd H:mm');
        locale_map.put('ja_JP', 'yyyy/MM/dd H:mm');
        locale_map.put('kk_KZ', 'M/d/yyyy h:mm a');
        locale_map.put('km_KH', 'M/d/yyyy h:mm a');
        locale_map.put('ko', 'yyyy. M. d a h:mm');
        locale_map.put('ko_KR', 'yyyy. M. d a h:mm');
        locale_map.put('lt_LT', 'yyyy.M.d HH.mm');
        locale_map.put('lv_LV', 'yyyy.d.M HH:mm');
        locale_map.put('ms_MY', 'dd/MM/yyyy h:mm a');
        locale_map.put('nl', 'd-M-yyyy H:mm');
        locale_map.put('nl_BE', 'd/MM/yyyy H:mm');
        locale_map.put('nl_NL', 'd-M-yyyy H:mm');
        locale_map.put('nl_SR', 'd-M-yyyy H:mm');
        locale_map.put('no', 'dd.MM.yyyy HH:mm');
        locale_map.put('no_NO', 'dd.MM.yyyy HH:mm');
        locale_map.put('pl', 'yyyy-MM-dd HH:mm');
        locale_map.put('pt', 'dd-MM-yyyy H:mm');
        locale_map.put('pt_AO', 'dd-MM-yyyy H:mm');
        locale_map.put('pt_BR', 'dd/MM/yyyy HH:mm');
        locale_map.put('pt_PT', 'dd-MM-yyyy H:mm');
        locale_map.put('ro_RO', 'dd.MM.yyyy HH:mm');
        locale_map.put('ru', 'dd.MM.yyyy H:mm');
        locale_map.put('sk_SK', 'd.M.yyyy H:mm');
        locale_map.put('sl_SI', 'd.M.y H:mm');
        locale_map.put('sv', 'yyyy-MM-dd HH:mm');
        locale_map.put('sv_SE', 'yyyy-MM-dd HH:mm');
        locale_map.put('th', 'M/d/yyyy h:mm a');
        locale_map.put('th_TH', 'd/M/yyyy, H:mm ?.');
        locale_map.put('tr', 'dd.MM.yyyy HH:mm');
        locale_map.put('ur_PK', 'M/d/yyyy h:mm a');
        locale_map.put('vi_VN', 'HH:mm dd/MM/yyyy');
        locale_map.put('zh', 'yyyy-M-d ah:mm');
        locale_map.put('zh_CN', 'yyyy-M-d ah:mm');
        locale_map.put('zh_HK', 'yyyy-M-d ah:mm');
        locale_map.put('zh_TW', 'yyyy/M/d a h:mm');
        return locale_map; //return the map
    }
}