public class Utilities {
    public static final Set<String> APP_ACCEPTED_DECISIONS = new Set<String>{'Approved', 'Auto App', 'Completed', 'Appr OfferCd', 'Appr Not Dis'};
    
    private static final String APP_COMPLETED_FROM_INTERNAL = 'Internal';
    private static final String APP_COMPLETED_FROM_EXTERNAL = 'External';

    public static String getInternalOrExternal() {
        
        Application_Form_Settings__c appFormSettings = Application_Form_Settings__c.getOrgDefaults();
        Id siteProfileId = (Id)AppFormSettings.Site_Profile_Id__c;
        Id userVerificationSiteProfileId = (Id)AppFormSettings.User_Verification_Site_Profile_Id__c;

        Id pId = (Id)UserInfo.getProfileId();
        return (pId == siteProfileId || pId == userVerificationSiteProfileId)   ?   APP_COMPLETED_FROM_EXTERNAL : APP_COMPLETED_FROM_INTERNAL;
    }
    
    public static String getUserProfile (){
        return [Select Id, Name from Profile where Id=:Userinfo.getProfileId()].Name;
    }
    
    public static Application__c getApplicationById(Id applicationId) {
        
        Application__c appln = null;
        
        if(applicationId != null){
            
            appln = [SELECT Id,Name, Middle_Name__c,Email_Address__c,Permanent_Address_Street_Name__c,Years_At_Permanent_Address__c,
                                                Employment_Status__c,Employer_Street_Number__c,Previous_Employer_Street_Number__c,Previous_Employer_PostalCode__c,Mothers_Maiden_Name__c,
                                                Province__c,
                                                Previous_Address_Province__c,Requested_Credit_Limit__c,Interest_Rate__c,
                                                Credit_Score__c,
                                                SIN__c,Current_BKCP__c,Permanent_Address_Street_Number__c,Permanent_Address_PostalCode__c,Housing_Costs__c,Previous_Address_City__c,Months_At_Previous_Address__c,
                                                Employment_Years__c,Employer_Province__c,Previous_Employment_Years__c,Previous_Employer_Province__c,Offer_Code_Origination_System_Id__c,Fraud_Alert__c,
                                                Application_Completed_From__c,Birth_Date__c,Permanent_Address_Province__c,Home_Owner__c,Previous_Address_Street_Name__c,
                                                Years_At_Previous_Address__c,Occupation__c,Employer_City__c,Previous_Employment_Months__c,Previous_Employer_City__c,Offer_Code__c,Authentication_Choice__c,Monthly_Expenses__c,
                                                Customer__r.SF_ID__c,Customer__c,Last_Name__c,Communications_Preference__c,Permanent_Address_City__c,
                                                Months_At_Permanent_Address__c,Previous_Address_Street_Number__c,Previous_Address_PostalCode__c,Employer_Name__c,Employer_Street_Name__c,Previous_Employer_name__c,
                                                Previous_Employer_Street_Name__c,Previous_Gross_Monthly_Income__c,Authentication_Result__c,Number_of_Dependants__c,
                                                Gender__c,Marital_Status__c,Salutation__c,Home_Phone__c,First_Name__c,Cell_Phone__c,Work_Phone__c,Employment_Months__c,Employer_PostalCode__c,
                                                PcoD_Bankruptcy_State__c,Gross_Monthly_Income__c,Employer_Phone__c,
                                                Permanent_Address_Type__c, Current_Income_Interval__c,Previous_Income_Interval__c,Previous_Address_Type__c, Decision__c, Application_Status__c, Final_Status__c,  
                                                Preferred_language__c,Decision_Timestamp__c,Decision_Summary__c,DSR_Score__c,
                                                Employer_Address_Type__c, Previous_Employer_Address_Type__c,
                                                Referral_Id__c, Strategy_Tier__c, 
                                                Approved_Amount__c, Verification_Status__c,
                                                Initial_Application_Status__c, Initial_Decision__c, Loan_Type__c, AML_Decision__c 
                                                FROM Application__c WHERE Id =: applicationId];
           
            
        }        
        
        return appln; 
    }
    
    public static String getAppName(){
      
      //Sequence Number from Custom Settings
      Application_Form_Settings__c appFormSettings = Application_Form_Settings__c.getOrgDefaults();
      Integer seqNo = appFormSettings.App_Name_Seq__c.intvalue();
      appFormSettings.App_Name_Seq__c = appFormSettings.App_Name_Seq__c + 1;
      update appFormSettings;
      
      //Application Name
      String securedCardAppName = 'APP'+ seqNo;
      return securedCardAppName;
    }

    //Utility method to convert Attachment size from bytes to KB or MB or GB
    public static String fileSizeToString(Long value){
        
        //Representation of Attachment Size in KB,MB,GB 
        if (value < 1024){
            return string.valueOf(value) + ' Bytes';
        }            
        else if (value >= 1024 && value < (1024*1024)){
            //Convert Attachment Size from Bytes to KB
            Decimal kb = Decimal.valueOf(value);
            kb = kb.divide(1024,2);
            return string.valueOf(kb) + ' KB';
        }
        else if (value >= (1024*1024) && value < (1024*1024*1024)){
            //Convert Attachment Size from Bytes to MB
           Decimal mb = Decimal.valueOf(value);
           mb = mb.divide((1024*1024),2);
           return string.valueOf(mb) + ' MB';
        }
        else {
            //Convert Attachment Size from Bytes to GB
            Decimal gb = Decimal.valueOf(value);
            gb = gb.divide((1024*1024*1024),2);
             
            return string.valueOf(gb) + ' GB';
        }    
    }
        
 }