/**************************************************************************************************
*
*  Class:   DecisionEngine
*
*  @description : Get decision and other related data for an Application
*  @author : A5E Consulting
*  @date : 11/12/2020   
*
*************************************************************************************************/
public with sharing class DecisionEngine {
    
    // Below variable used to track the decison
    public static string decision;
    public static string APPROVE = 'Approve';
    public static string REVIEW = 'Review';
    public static string DECLINE = 'Decline';

    
    public static ResponseWrapper submit( Application__c app){
        string requestJSON = createJSONRequest(app);
        return getDecision(requestJSON);
    }
    public static string createJSONRequest( Application__c app){
        Application_Form_Configuration__c appConfigSetting = Application_Form_Configuration__c.getInstance();

        RequestPayload request = new RequestPayload();
        request.TUCANREL4 = getDecisionRequestXML(app, appConfigSetting);
        request.IFSXMLRq = getAMLRequestXML(app, appConfigSetting);
        request.monthlyRentPaymentAmount = app.Housing_Costs__c;
        request.totalOtherMonthlyExpensesAmount = app.Monthly_Expenses__c;
        request.grossMonthlyIncomeAmount = app.Gross_Monthly_Income__c;
        // request.birthDate = string.valueOf(app.Birth_Date__c);
        // request.employmentTypeCode = app.Employment_Status__c;
        // if(app.CurrentBKCP__c=='BK'){
        //     request.financialConditionCode = 'BK';
        // }else if(app.CurrentBKCP__c=='CP'){
        //     request.financialConditionCode = 'CP';
        // }
        // request.dependentsCount = app.Number_of_Dependants__c;
        // request.maritalStatusCode = app.Marital_Status__c;
        // if(app.Home_Owner__c=='Own Property'){
        //     request.homeOwnerInd = true;
        // }else if(app.Home_Owner__c=='Rent'){
        //     request.homeOwnerInd = false;
        // }
        // request.monthsEmployed = string.valueOf(app.Employment_Years__c * 12 + app.Employment_Months__c);
        // request.politicallyExposedInd = app.Politically_Exposed_Foreign_Person__c;
        // request.otherBeneficiaryInd = app.Third_Party_Direction__c;
        
         String returnJSONString = JSON.serialize(request);
        
        // System.debug('decisionRequestXML :');
        // System.debug(returnJSONString );
        
        return returnJSONString;

    }
    //  Send data over to decision engine API and parse responses Adjudication, AML, and TU
    public static ResponseWrapper getDecision(string requestJSON) {
        RequestPayload reqPayload = (RequestPayload) System.JSON.deserialize(requestJSON, RequestPayload.class);
        
        String adjResponse = AdjudicationWebService.getDecision(reqPayload);
        String creditResportService = CreditReportService.parseXMLStringTruncarel4(reqPayload.TUCANREL4);
        String IFSXMLRqResponse = AMLWebService.parseXMLStringIFSXMLRq(reqPayload.IFSXMLRq);
        ResponseWrapper obj = new ResponseWrapper();
        obj.adjudication = adjResponse;
        obj.creditReport = creditResportService;
        obj.IFSXMLRq = IFSXMLRqResponse;
        obj.request = requestJSON;

        System.debug('$$ adjudication '+adjResponse);
        System.debug('$$ TUResponse ='+creditResportService);
        System.debug('$$ IFSXMLRqResponse ='+IFSXMLRqResponse);
        //return json.serialize(obj);
        return obj;
    }

    public static String getDecisionRequestXML(Application__c app, Application_Form_Configuration__c appConfigSetting){
        
        DecisionEngineUtil.DecisionXMLRequest decisionXMLRequest = new DecisionEngineUtil.DecisionXMLRequest();
        decisionXMLRequest.fieldValues.put('MemberCode', appConfigSetting.Member_Code__c);
        DecisionEngineUtil.DecisionXMLRequest_Subject decisionSubjectXML = new DecisionEngineUtil.DecisionXMLRequest_Subject();
        decisionXMLRequest.fieldValues.put('Subject', decisionSubjectXML);
        DecisionEngineUtil.DecisionXMLRequest_SubjectName subjectNameXML = new DecisionEngineUtil.DecisionXMLRequest_SubjectName();
        decisionSubjectXML.fieldValues.put('Name', subjectNameXML);
        subjectNameXML.fieldValues.put('LastName', app.Last_Name__c);
        subjectNameXML.fieldValues.put('FirstName', app.First_Name__c);
        String BirthMonth = string.valueOf(app.Birth_Date__c.month()).leftPad(2, '0');
        String Birthday = string.valueOf(app.Birth_Date__c.day()).leftPad(2, '0');
        String Birthyear = string.valueOf(app.Birth_Date__c.year()); 
        String FinalBirthdate = Birthyear+BirthMonth+Birthday;
        
        decisionSubjectXML.fieldValues.put('DOB', FinalBirthdate);
        decisionSubjectXML.fieldValues.put('SIN', app.SIN__C);
        
        /*
        decisionXMLRequest.fieldValues.put('Route', 'RouteDest=' + afSettings.RouteDest__c + ':RouteType=' + afSettings.RouteType__c);
        decisionXMLRequest.fieldValues.put('UserReference', afSettings.UserReference__c);
        
        decisionXMLRequest.fieldValues.put('Password', afSettings.Password__c);
        decisionXMLRequest.fieldValues.put('Product', afSettings.Product__c);
        
        DecisionWSUtil.DecisionXMLRequest_TTY decisionTTYXML = new DecisionWSUtil.DecisionXMLRequest_TTY();
        decisionXMLRequest.fieldValues.put('TTY', decisionTTYXML);
        
        decisionTTYXML.fieldValues.put('FFR', afSettings.FFR__c);
        decisionTTYXML.fieldValues.put('Language', afSettings.Language__c);
        
       
        
        DecisionWSUtil.DecisionXMLRequest_SubjectAddress subjectAddressXML = new DecisionWSUtil.DecisionXMLRequest_SubjectAddress();
        decisionSubjectXML.fieldValues.put('Address', subjectAddressXML);
        
        subjectAddressXML.fieldValues.put('Civic', app.Permanent_Address_Street_Number__c);
        subjectAddressXML.fieldValues.put('Street', app.Permanent_Address_Street_Name__c);
        subjectAddressXML.fieldValues.put('City', app.Permanent_Address_City__c);
        subjectAddressXML.fieldValues.put('Postal', app.Permanent_Address_PostalCode__c);
        subjectAddressXML.fieldValues.put('Prov', app.Permanent_Address_Province__c);
        if(app.Primary_Phone_Number__c == 'Home Phone'){
            subjectAddressXML.fieldValues.put('Telephone', unformattedPhoneNumber(app.Home_Phone__c));
        }else if(app.Primary_Phone_Number__c == 'Mobile Phone'){
            subjectAddressXML.fieldValues.put('Telephone', unformattedPhoneNumber(app.Cell_Phone__c));
        }else if(app.Primary_Phone_Number__c == 'Work Phone'){
            subjectAddressXML.fieldValues.put('Telephone', unformattedPhoneNumber(app.Work_Phone__c));
        }
        
        DecisionWSUtil.DecisionXMLRequest_OptionalRequest decisionOptionRequestXML = new DecisionWSUtil.DecisionXMLRequest_OptionalRequest();
        decisionXMLRequest.fieldValues.put('OptionalRequest', decisionOptionRequestXML);
        
        decisionOptionRequestXML.fieldValues.put('OwningBureau', afSettings.Owning_Bureau__c);
        decisionOptionRequestXML.fieldValues.put('ErrorText', afSettings.Error_Text__c );
        decisionOptionRequestXML.fieldValues.put('TradeMop', afSettings.TradeMop__c);
        decisionOptionRequestXML.fieldValues.put('Summary', afSettings.Summary__c);
        */
        
        XmlStreamWriter w = new XmlStreamWriter();
        decisionXMLRequest.getXMLString(w);

        String decisionRequestXML = w.getXmlString();
        w.close();
        
        decisionRequestXML.replace('\"', '\\"');
        System.debug('decisionRequestXML :');
        System.debug(decisionRequestXML);
        
        return decisionRequestXML; 
    }
    
    private static String getAMLRequestXML(Application__c app, Application_Form_Configuration__c appConfigSetting){
        
        DecisionEngineUtil.AMLXMLRequest amlXMLRequest = new DecisionEngineUtil.AMLXMLRequest ();
        amlXMLRequest.fieldValues.put('MemberCode', appConfigSetting.AML_Member_Code__c   );
        amlXMLRequest.fieldValues.put('Password', appConfigSetting.AML_Password__c);
        DecisionEngineUtil.AMLXMLRequest_AML amlXMLRequest_AML = new DecisionEngineUtil.AMLXMLRequest_AML();
        amlXMLRequest.fieldValues.put('AML', amlXMLRequest_AML);
        amlXMLRequest_AML.fieldValues.put('LastName', app.Last_Name__c);
        amlXMLRequest_AML.fieldValues.put('FirstName', app.First_name__c);
        
        /*
        amlXMLRequest.fieldValues.put('Route', 'RouteType=' + afSettings.AML_Route_Type__c);
        amlXMLRequest.fieldValues.put('UserReference', afSettings.AML_User_Reference__c);
        amlXMLRequest.fieldValues.put('PRODUCTCODE', afSettings.AML_Product_Code__c);
        
        DecisionWSUtil.AMLXMLRequest_Address amlXMLRequest_Address = new DecisionWSUtil.AMLXMLRequest_Address();
        amlXMLRequest_AML.fieldValues.put('Address', amlXMLRequest_Address);
        amlXMLRequest_Address.fieldValues.put('Civic', app.Permanent_Address_Street_Number__c);
        amlXMLRequest_Address.fieldValues.put('Street', app.Permanent_Address_Street_Name__c);
        amlXMLRequest_Address.fieldValues.put('City', app.Permanent_Address_City__c);
        amlXMLRequest_Address.fieldValues.put('Postal', app.Permanent_Address_PostalCode__c);
        amlXMLRequest_Address.fieldValues.put('Prov', app.Permanent_Address_Province__c);
        if(app.Primary_Phone_Number__c == 'Home Phone'){
            amlXMLRequest_Address.fieldValues.put('Telephone', unformattedPhoneNumber(app.Home_Phone__c));
        }else if(app.Primary_Phone_Number__c == 'Mobile Phone'){
            amlXMLRequest_Address.fieldValues.put('Telephone', unformattedPhoneNumber(app.Cell_Phone__c));
        }else if(app.Primary_Phone_Number__c == 'Work Phone'){
            amlXMLRequest_Address.fieldValues.put('Telephone', unformattedPhoneNumber(app.Work_Phone__c));
        }
        
        if(app.Primary_Phone_Number__c == 'Home Phone'){
            amlXMLRequest_AML.fieldValues.put('Telephone', unformattedPhoneNumber(app.Home_Phone__c));
        }else if(app.Primary_Phone_Number__c == 'Mobile Phone'){
            amlXMLRequest_AML.fieldValues.put('Telephone', unformattedPhoneNumber(app.Cell_Phone__c));
        }else if(app.Primary_Phone_Number__c == 'Work Phone'){
            amlXMLRequest_AML.fieldValues.put('Telephone', unformattedPhoneNumber(app.Work_Phone__c));
        }
        
        DecisionWSUtil.AMLXMLRequest_PI amlXMLRequest_PI = new DecisionWSUtil.AMLXMLRequest_PI();
        amlXMLRequest.fieldValues.put('PI', amlXMLRequest_PI);
        
        String BirthMonth = string.valueOf(app.Birth_Date__c.month());
        String Birthday = string.valueOf(app.Birth_Date__c.day());
        String Birthyear = string.valueOf(app.Birth_Date__c.year()); 
        String FinalBirthdate = Birthyear+(BirthMonth.length()==1?('0'+BirthMonth):BirthMonth)+(Birthday.length()==1?('0'+Birthday):Birthday);
        amlXMLRequest_PI.fieldValues.put('DOB', FinalBirthdate);
        */

        XmlStreamWriter w = new XmlStreamWriter();
        amlXMLRequest.getXMLString(w);

        String decisionRequestXML = w.getXmlString();
        w.close();
        System.debug('decisionRequestXML :');
        System.debug(decisionRequestXML);
        
        return decisionRequestXML;   
    }


    public class ResponseWrapper{
        public string request;
        public string adjudication;
        public string creditReport;
        public string IFSXMLRq;
    }
    public class RequestPayload{
        public string TUCANREL4;
        public decimal totalOtherMonthlyExpensesAmount;
        public boolean politicallyExposedInd;
        public boolean otherBeneficiaryInd;
        public string monthsEmployed;
        public decimal monthlyRentPaymentAmount;
        public string maritalStatusCode;
        public string IFSXMLRq;
        public Boolean homeOwnerInd;
        public Decimal grossMonthlyIncomeAmount;
        public String financialConditionCode;
        public String employmentTypeCode;
        public String dependentsCount;
        public String birthDate;
    }
}