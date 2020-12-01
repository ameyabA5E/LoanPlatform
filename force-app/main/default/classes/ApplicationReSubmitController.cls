/**************************************************************************************************
*
*  Class:   
*
*  @description : This class is to call re-submit method
*  @author : A5E Consulting
*  @date : 07 Sept 2020   
*
*************************************************************************************************/
public with sharing class ApplicationReSubmitController{
    
    public Application__C application{get;set;}
    public Application_Form_Configuration__c afSettings{get;set;}
    public Boolean progressBar{get;set;}
    public string errorMessage{get;set;}
    
    public ApplicationReSubmitController(){
        
    }
    
    public ApplicationReSubmitController(ApexPages.StandardController controller) {
        String appID = ApexPages.currentPage().getParameters().get('id');
        
        system.debug(''+appID);
        
        progressBar = true;
        errorMessage = null;
        
        afSettings = Application_Form_Configuration__c.getOrgDefaults();
        
        application = new Application__C();
        application = [Select id, Name, Last_Name__c, First_Name__c, Birth_Date__c, SIN__C, 
                Permanent_Address_Street_Number__c, Permanent_Address_Street_Name__c, Permanent_Address_City__c, 
                Permanent_Address_PostalCode__c, Permanent_Address_Province__c, 
                       //Primary_Phone_Number__c, 
                Home_Phone__c, Cell_Phone__c, Work_Phone__c,
                Marital_Status__c, Home_Owner__c,
                Third_Party_Direction__c, Politically_Exposed_Foreign_Person__c,
                Employment_Years__c, Employment_Months__c, Gross_Monthly_Income__c, Employment_Status__c,
                CurrentBKCP__c, Number_of_Dependants__c,
                Housing_Costs__c, Monthly_Expenses__c,
                Webservice_Response__c
                From Application__c where id = : appID];
                
        system.debug(''+application);
    }
    
    public pageReference reSubmit(){
        
        DecisionEngineUtil.IntegrationResponse intResponse = new DecisionEngineUtil.IntegrationResponse();
        Boolean flagSIN = false;
        
        try{
            //submit to adjudication engine
            if(null != application.SIN__c && (application.SIN__c).startsWith('9')){
                flagSIN = true;
            }
            if(application.CurrentBKCP__c != 'None' && flagSIN == false){
                //commented on 25.11. Need to check
                //***intResponse = DecisionWS.submit(application, afSettings);
                
                Application.Webservice_Request__c = intResponse.request;
                Application.Webservice_Response__c = intResponse.response;
                Application.Adjudication_Response__c = intResponse.adjudicationResponse;
                Application.AML_Response__c = intResponse.amlResponse;
                
                system.debug('Attachment data' + intResponse.adjudicationFile);
                //Attach the adjudication and AML response to application
                if(String.isNotBlank(intResponse.adjudicationFile)){
                    
                    Attachment adjudicationAttach = new Attachment();
                    adjudicationAttach.Body = Blob.valueOf(intResponse.adjudicationFile);
                    adjudicationAttach.Name = 'Adjudication - Response.txt';
                    adjudicationAttach.ParentId = Application.ID;
                    insert adjudicationAttach;
                }
            }
        }
        catch(Exception e){
            //Application.Name = APP_NAME_INCOMPLETE_POWER_CURVE_ERR;
            Application.Application_Status_Last_Changed_Date__c = system.now();
            Application.Application_Status__c = 'Needs Review';
            system.debug(''+e);
        }        
        
        //Set all time stamps
        Application.Application_Status_Last_Changed_Date__c = system.now();
        Application.Decision_Timestamp__c = system.now();
        Application.Adjudication_Decision_Last_Changed_Date__c = system.now();
        Application.AML_Decision_Last_Changed_Date__c = system.now();
        Application.AML_Decision_Timestamp__c = System.now();
        
        //Fetch auto number field to populate on the records
        String ApplicationAutoNumberValue = [SELECT id, Application_Number_AutoNumber__c from Application__c where id =: application.id].Application_Number_AutoNumber__c;
        Application.Name = ApplicationAutoNumberValue;
        
        System.debug('intResponse  : '+ intResponse );
        //if current BKCP value is selected as None
        if(Application.CurrentBKCP__c == 'None'){
            
            //Application.Application_Status_Last_Changed_Date__c = system.now();
            Application.Application_Status__c = 'System Declined';
            Application.Decision_Summary__c = 'User is not currently or have not been in a bankruptcy or consumer proposal process within the last 7 years';
        }else if(flagSIN == true){
            //Application.Application_Status_Last_Changed_Date__c = system.now();
            Application.Application_Status__c = 'System Declined';
            Application.Decision_Summary__c = 'User is not permanent resident of Canada';
        }else if (null == intResponse || String.isBlank(Application.Webservice_Response__c)) {
            // due to exception returned null
            
            //Application.Application_Status_Last_Changed_Date__c = system.now();
            Application.Application_Status__c = 'Needs Review';
            Application.CSR_Manual_Review_Reason__c = 'System Not Reachable – Adjudication';
            Application.Decision__c = 'Needs Review';
            //Application.Decision_Timestamp__c = system.now();
            //Application.Adjudication_Decision_Last_Changed_Date__c = system.now();
        } 
        else {
            // Set decision-related fields on Application
            //Adjudication
            Application.Decision__c = intResponse.adjudicationStatus;
            //Application.Decision_Timestamp__c = system.now();//DateTime.valueof(intResponse.adjudicationDecisionTimestamp);
            //Application.Adjudication_Decision_Last_Changed_Date__c = system.now();//DateTime.valueof(intResponse.adjudicationDecisionTimestamp);
            Application.Decline_Reason__c = intResponse.declineReason;
            /*Application.Decline_Reason__c = declineReasonValue(intResponse.declineReason);
            if(String.isBlank(Application.Decline_Reason__c)){
                Application.Decline_Reason__c = intResponse.declineReason;
            }*/
            Application.Credit_Score__c = null==intResponse.creditScore?'':(''+intResponse.creditScore);
            Application.Bankruptcies__c = intResponse.totalNumberofBankrupcies;
            Application.Decision_Summary__c = intResponse.decisionSummary;
            Application.Lender_Approved_Amount__c = intResponse.approvedAmount;
            Application.Interest_Rate__c = intResponse.approvedInterestRate;
            
            //AML
            Application.AML_Decision__c = intResponse.amlStatus;
            /*if(String.isNotBlank(Application.AML_Decision__c)){
                Application.AML_Decision_Last_Changed_Date__c = system.now();
            }*/
            Application.Fraud_Flag__c = null;
            if(intResponse.fraudFlag == 'N'){
                Application.Fraud_Flag__c = 'No';
            }else if(intResponse.fraudFlag == 'Y'){
                Application.Fraud_Flag__c = 'Yes';
            }
            Application.AML_Decision_Summary__c = intResponse.amlSummary;
            //Application.AML_Decision_Timestamp__c = intResponse.amlTimestamp;
            Application.AML_Declined_Reason__c = intResponse.amlDeclineReason;
            Application.Unique_ID_AML__c = intResponse.amlUniqueNumber;
            
            Application.CSR_Manual_Review_Reason__c = intResponse.needsReviewReason;
            
            //Calculate application status
            if(Application.Decision__c == 'Approved' && Application.AML_Decision__c == 'Approved'){
                Application.Application_Status__c = 'System Approved';
                
            }
            else if(Application.Decision__c == 'Needs Review' || Application.AML_Decision__c == 'Needs Review'){
                Application.Application_Status__c = 'Needs Review';
                
                /*if(Application.Decision__c == 'Needs Review'){
                    Application.CSR_Manual_Review_Reason__c = 'System Not Reachable – Adjudication';
                    
                }else if(Application.AML_Decision__c == 'Needs Review'){
                    Application.CSR_Manual_Review_Reason__c = 'System Not Reachable - AML';
                    //Application.AML_Decision_Timestamp__c = System.now();
                }*/
            }
            else if(Application.Decision__c == 'Declined' || Application.AML_Decision__c == 'Declined'){
                Application.Application_Status__c = 'System Declined';
                
                /*if(Application.Decline_Reason__c == 'No Hit'){
                    Application.CSR_Manual_Review_Reason__c = 'No Hit – Adjudication';
                }else if(Application.AML_Declined_Reason__c == 'No Hit'){
                    Application.CSR_Manual_Review_Reason__c = 'No Hit – AML';
                }*/
            }else if(Application.Decision__c == 'Approved' && String.isBlank(Application.AML_Decision__c)){
                Application.Application_Status__c = 'Needs Review';
                
            }
            //Application.Application_Status_Last_Changed_Date__c = system.now();
            //Application.DSR_Score__c = (Application.Housing_Costs__c + Application.Monthly_Expenses__c) / Application.Gross_Monthly_Income__c;
            
        }
        //Calculate DSR Score
        Application.DSR_Score__c = ((Application.Housing_Costs__c + Application.Monthly_Expenses__c) / Application.Gross_Monthly_Income__c)*100;
        
        //Application.Application_Completed_Submitted__c = true;    
        
        try{
            update application;
            
        }catch(Exception e){
            system.debug('Exception : ' + e);
            if(e.getTypeName() == 'System.DmlException'){
                
                errorMessage = e.getDmlMessage(0);
            }else{
                errorMessage = e.getMessage();
            }
        }        
        
        progressBar = false;
        
        return null;
    }
    
    //to map decline reasons to readable values
    /*private string declineReasonValue(String reason){
        map<String, Adjudication_Reason_Mapping__c> reasonMappingMap = Adjudication_Reason_Mapping__c.getAll();
        
        Adjudication_Reason_Mapping__c reasonValue = reasonMappingMap.get(reason);
        if(null == reasonValue){
            return null;
        }else{
            return reasonValue.reason__c;
        }
    }*/
}