//Generated by wsdl2apex

public class TransUnionIdAuthElements {
    // to do remove comment
    public class CreditReportFlag {
        public String Value;
        private String[] Value_att_info = new String[]{'Value'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class Choice {
        public String Text;
        private String[] Text_att_info = new String[]{'Text'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class Address {
        public TransUnionIdAuthElements.ParsedAddr ParsedAddr;
        public TransUnionIdAuthElements.UnparsedAddr UnparsedAddr;
        public TransUnionIdAuthElements.Phone[] Phone;
        public String Country;
        public String Military;
        public String AddrType;
        public String County;
        public String City;
        public String StProv;
        public String ZipPostal;
        private String[] ParsedAddr_type_info = new String[]{'ParsedAddr','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] UnparsedAddr_type_info = new String[]{'UnparsedAddr','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] Phone_type_info = new String[]{'Phone','http://www.transunion.ca/WS/IDAuthentication',null,'0','-1','false'};
        private String[] Country_att_info = new String[]{'Country'};
        private String[] Military_att_info = new String[]{'Military'};
        private String[] AddrType_att_info = new String[]{'AddrType'};
        private String[] County_att_info = new String[]{'County'};
        private String[] City_att_info = new String[]{'City'};
        private String[] StProv_att_info = new String[]{'StProv'};
        private String[] ZipPostal_att_info = new String[]{'ZipPostal'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'ParsedAddr','UnparsedAddr','Phone'};
    }
    public class Customer {
        public TransUnionIdAuthElements.Name Name;
        public TransUnionIdAuthElements.PersonalInfo PersonalInfo;
        public TransUnionIdAuthElements.DriversLicense DriversLicense;
        public String CreditCard;
        public String SIN;
        public String BirthDate;
        public String PhoneNumber;
        public String HouseNumber;
        private String[] Name_type_info = new String[]{'Name','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] PersonalInfo_type_info = new String[]{'PersonalInfo','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] DriversLicense_type_info = new String[]{'DriversLicense','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] CreditCard_att_info = new String[]{'CreditCard'};
        private String[] SIN_att_info = new String[]{'SIN'};
        private String[] BirthDate_att_info = new String[]{'BirthDate'};
        private String[] PhoneNumber_att_info = new String[]{'PhoneNumber'};
        private String[] HouseNumber_att_info = new String[]{'HouseNumber'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Name','PersonalInfo','DriversLicense'};
    }
    public class PreviousResidence {
        public TransUnionIdAuthElements.Address Address;
        public String MthsAtAddr;
        public String Occupancy;
        private String[] Address_type_info = new String[]{'Address','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] MthsAtAddr_att_info = new String[]{'MthsAtAddr'};
        private String[] Occupancy_att_info = new String[]{'Occupancy'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Address'};
    }
    public class DoFinalUpdate {
        public String PaymentApprovalCode;
        public String SecondContactPhoneNumber;
        private String[] PaymentApprovalCode_type_info = new String[]{'PaymentApprovalCode','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] SecondContactPhoneNumber_type_info = new String[]{'SecondContactPhoneNumber','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'PaymentApprovalCode','SecondContactPhoneNumber'};
    }
    public class ArrayOfReport {
        public TransUnionIdAuthElements.Report[] Report;
        private String[] Report_type_info = new String[]{'Report','http://www.transunion.ca/WS/IDAuthentication',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Report'};
    }
    public class AdditionalDataRequest {
        public String Type_x;
        private String[] Type_x_att_info = new String[]{'Type'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class UserActivity {
        public String Code;
        public String Comments;
        private String[] Code_att_info = new String[]{'Code'};
        private String[] Comments_att_info = new String[]{'Comments'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class Process_element {
        public TransUnionIdAuthElements.IDAuthentication request;
        private String[] request_type_info = new String[]{'request','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class Reason {
        public String Code;
        public String Desc_x;
        private String[] Code_att_info = new String[]{'Code'};
        private String[] Desc_x_att_info = new String[]{'Desc'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class Name {
        public String Prefix;
        public String First;
        public String Middle;
        public String Last;
        public String Suffix;
        public String Full;
        public String Nickname;
        private String[] Prefix_att_info = new String[]{'Prefix'};
        private String[] First_att_info = new String[]{'First'};
        private String[] Middle_att_info = new String[]{'Middle'};
        private String[] Last_att_info = new String[]{'Last'};
        private String[] Suffix_att_info = new String[]{'Suffix'};
        private String[] Full_att_info = new String[]{'Full'};
        private String[] Nickname_att_info = new String[]{'Nickname'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class ParsedAddr {
        public String StNum;
        public String StName;
        public String StType;
        public String StDir;
        public String AptNum;
        public String RRNum;
        public String POBox;
        private String[] StNum_att_info = new String[]{'StNum'};
        private String[] StName_att_info = new String[]{'StName'};
        private String[] StType_att_info = new String[]{'StType'};
        private String[] StDir_att_info = new String[]{'StDir'};
        private String[] AptNum_att_info = new String[]{'AptNum'};
        private String[] RRNum_att_info = new String[]{'RRNum'};
        private String[] POBox_att_info = new String[]{'POBox'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class Result {
        public String Value;
        private String[] Value_att_info = new String[]{'Value'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class ProcessResponse_element {
        public TransUnionIdAuthElements.IDAuthentication ProcessResult;
        private String[] ProcessResult_type_info = new String[]{'ProcessResult','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'ProcessResult'};
    }
    public class Consumer {
        public TransUnionIdAuthElements.Customer Customer;
        public TransUnionIdAuthElements.Residence Residence;
        public TransUnionIdAuthElements.PreviousResidence PreviousResidence;
        public TransUnionIdAuthElements.Employer[] Employer;
        public String CreditCard;
        public TransUnionIdAuthElements.Employment Employment;
        private String[] Customer_type_info = new String[]{'Customer','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] Residence_type_info = new String[]{'Residence','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] PreviousResidence_type_info = new String[]{'PreviousResidence','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] Employer_type_info = new String[]{'Employer','http://www.transunion.ca/WS/IDAuthentication',null,'0','-1','false'};
        private String[] CreditCard_type_info = new String[]{'CreditCard','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] Employment_type_info = new String[]{'Employment','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Customer','Residence','PreviousResidence','Employer','CreditCard','Employment'};
    }
    public class ProcessCreditReport_element {
        public TransUnionIdAuthElements.TUIVRRequest request;
        private String[] request_type_info = new String[]{'request','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class Employment {
        public String Name;
        public String Occupation;
        private String[] Name_type_info = new String[]{'Name','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] Occupation_type_info = new String[]{'Occupation','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Name','Occupation'};
    }
    public class Confidence {
        public TransUnionIdAuthElements.Alert[] Alert;
        public String EarnedPoints;
        public String PossiblePoints;
        public String Score;
        public String Decision;
        private String[] Alert_type_info = new String[]{'Alert','http://www.transunion.ca/WS/IDAuthentication',null,'0','-1','false'};
        private String[] EarnedPoints_att_info = new String[]{'EarnedPoints'};
        private String[] PossiblePoints_att_info = new String[]{'PossiblePoints'};
        private String[] Score_att_info = new String[]{'Score'};
        private String[] Decision_att_info = new String[]{'Decision'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Alert'};
    }
    public class ArrayOfData {
        public TransUnionIdAuthElements.Data[] Data;
        private String[] Data_type_info = new String[]{'Data','http://www.transunion.ca/WS/IDAuthentication',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Data'};
    }
    public class Phone {
        public String PhType;
        public String CountryCd;
        public String Number_x;
        public String Extension;
        private String[] PhType_att_info = new String[]{'PhType'};
        private String[] CountryCd_att_info = new String[]{'CountryCd'};
        private String[] Number_x_att_info = new String[]{'Number'};
        private String[] Extension_att_info = new String[]{'Extension'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class TUIVRAddressReturn {
        public String AddressText;
        private String[] AddressText_att_info = new String[]{'AddressText'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class Question {
        public TransUnionIdAuthElements.Choice[] Choice;
        public String Type_x;
        public String TimePermitted;
        public String QuestionId;
        public String Text { get;set; }
        private String[] Choice_type_info = new String[]{'Choice','http://www.transunion.ca/WS/IDAuthentication',null,'0','-1','false'};
        private String[] Type_x_att_info = new String[]{'Type'};
        private String[] TimePermitted_att_info = new String[]{'TimePermitted'};
        private String[] QuestionId_att_info = new String[]{'QuestionId'};
        private String[] Text_att_info = new String[]{'Text'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Choice'};
    }
    public class DriversLicense {
        public String Number_x;
        public String State;
        public String ExpirationDate;
        private String[] Number_x_att_info = new String[]{'Number'};
        private String[] State_att_info = new String[]{'State'};
        private String[] ExpirationDate_att_info = new String[]{'ExpirationDate'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class TUIVRRequest {
        public TransUnionIdAuthElements.NewSession NewSession;
        public TransUnionIdAuthElements.DoFinalUpdate DoFinalUpdate;
        public TransUnionIdAuthElements.CreditReportFlag CreditReportFlag;
        public TransUnionIdAuthElements.Answers Answers;
        public String ExternalId;
        public String SessionId;
        public String MemberId;
        public String Password;
        private String[] NewSession_type_info = new String[]{'NewSession','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] DoFinalUpdate_type_info = new String[]{'DoFinalUpdate','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] CreditReportFlag_type_info = new String[]{'CreditReportFlag','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] Answers_type_info = new String[]{'Answers','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] ExternalId_att_info = new String[]{'ExternalId'};
        private String[] SessionId_att_info = new String[]{'SessionId'};
        private String[] MemberId_att_info = new String[]{'MemberId'};
        private String[] Password_att_info = new String[]{'Password'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'NewSession','DoFinalUpdate','CreditReportFlag','Answers'};
    }
    public class Business {
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class UserActivities {
        public TransUnionIdAuthElements.UserActivity[] UserActivity;
        public String SessionId;
        private String[] UserActivity_type_info = new String[]{'UserActivity','http://www.transunion.ca/WS/IDAuthentication',null,'0','-1','false'};
        private String[] SessionId_att_info = new String[]{'SessionId'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'UserActivity'};
    }
    public class ProcessFraudPotentialResponse_element {
        public TransUnionIdAuthElements.TUIVRReply ProcessFraudPotentialResult;
        private String[] ProcessFraudPotentialResult_type_info = new String[]{'ProcessFraudPotentialResult','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'ProcessFraudPotentialResult'};
    }
    public class NewSession {
        public TransUnionIdAuthElements.Subject Subject;
        public TransUnionIdAuthElements.ExcludeQuestionId[] ExcludeQuestionId;
        public TransUnionIdAuthElements.ExternalSourceSubjectData ExternalSourceSubjectData;
        public TransUnionIdAuthElements.AdditionalDataRequest[] AdditionalDataRequest;
        public String Language;
        public String Version;
        public String ProcessId;
        private String[] Subject_type_info = new String[]{'Subject','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] ExcludeQuestionId_type_info = new String[]{'ExcludeQuestionId','http://www.transunion.ca/WS/IDAuthentication',null,'0','-1','false'};
        private String[] ExternalSourceSubjectData_type_info = new String[]{'ExternalSourceSubjectData','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] AdditionalDataRequest_type_info = new String[]{'AdditionalDataRequest','http://www.transunion.ca/WS/IDAuthentication',null,'0','-1','false'};
        private String[] Language_att_info = new String[]{'Language'};
        private String[] Version_att_info = new String[]{'Version'};
        private String[] ProcessId_att_info = new String[]{'ProcessId'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Subject','ExcludeQuestionId','ExternalSourceSubjectData','AdditionalDataRequest'};
    }
    public class Answers {
        public TransUnionIdAuthElements.Answer[] Answer;
        public String SessionId;
        private String[] Answer_type_info = new String[]{'Answer','http://www.transunion.ca/WS/IDAuthentication',null,'0','-1','false'};
        private String[] SessionId_att_info = new String[]{'SessionId'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Answer'};
    }
    public class ProcessFraudPotential_element {
        public TransUnionIdAuthElements.TUIVRRequest request;
        private String[] request_type_info = new String[]{'request','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class Report {
        public TransUnionIdAuthElements.Reason[] Reason;
        public String QuestionId;
        public String CategoryName;
        public String ReportType;
        private String[] Reason_type_info = new String[]{'Reason','http://www.transunion.ca/WS/IDAuthentication',null,'0','-1','false'};
        private String[] QuestionId_att_info = new String[]{'QuestionId'};
        private String[] CategoryName_att_info = new String[]{'CategoryName'};
        private String[] ReportType_att_info = new String[]{'ReportType'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Reason'};
    }
    public class Employer {
        public TransUnionIdAuthElements.Address Address;
        public String Title;
        public String MthsEmployed;
        public String EmpName;
        public String Occupation;
        private String[] Address_type_info = new String[]{'Address','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] Title_att_info = new String[]{'Title'};
        private String[] MthsEmployed_att_info = new String[]{'MthsEmployed'};
        private String[] EmpName_att_info = new String[]{'EmpName'};
        private String[] Occupation_att_info = new String[]{'Occupation'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Address'};
    }
    public class TUIVRReply {
        public TransUnionIdAuthElements.Confidence Confidence;
        public TransUnionIdAuthElements.Question[] Question;
        public TransUnionIdAuthElements.Error[] Error;
        public TransUnionIdAuthElements.TUIVRAddressReturn Address;
        public TransUnionIdAuthElements.Result Result;
        public String SessionId;
        public String ExternalId;
        private String[] Confidence_type_info = new String[]{'Confidence','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] Question_type_info = new String[]{'Question','http://www.transunion.ca/WS/IDAuthentication',null,'0','-1','false'};
        private String[] Error_type_info = new String[]{'Error','http://www.transunion.ca/WS/IDAuthentication',null,'0','-1','false'};
        private String[] Address_type_info = new String[]{'Address','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] Result_type_info = new String[]{'Result','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] SessionId_att_info = new String[]{'SessionId'};
        private String[] ExternalId_att_info = new String[]{'ExternalId'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Confidence','Question','Error','Address','Result'};
    }
    public class UnparsedAddr {
        public String Line1;
        public String Line2;
        public String Line3;
        private String[] Line1_att_info = new String[]{'Line1'};
        private String[] Line2_att_info = new String[]{'Line2'};
        private String[] Line3_att_info = new String[]{'Line3'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class Request {
        public TransUnionIdAuthElements.NewSession NewSession;
        public TransUnionIdAuthElements.UserActivities UserActivities;
        public TransUnionIdAuthElements.Answers Answers;
        public String User_x;
        public String ReportDataReplyFlag;
        public String CorrelationId;
        public String MemberId;
        public String Password;
        public String ExternalId;
        private String[] NewSession_type_info = new String[]{'NewSession','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] UserActivities_type_info = new String[]{'UserActivities','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] Answers_type_info = new String[]{'Answers','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] User_x_att_info = new String[]{'User'};
        private String[] ReportDataReplyFlag_att_info = new String[]{'ReportDataReplyFlag'};
        private String[] CorrelationId_att_info = new String[]{'CorrelationId'};
        private String[] MemberId_att_info = new String[]{'MemberId'};
        private String[] Password_att_info = new String[]{'Password'};
        private String[] ExternalId_att_info = new String[]{'ExternalId'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'NewSession','UserActivities','Answers'};
    }
    public class Error {
        public String Code;
        public String Text;
        private String[] Code_att_info = new String[]{'Code'};
        private String[] Text_att_info = new String[]{'Text'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class Residence {
        public TransUnionIdAuthElements.Address Address;
        public String MthsAtAddr;
        public String Occupancy;
        private String[] Address_type_info = new String[]{'Address','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] MthsAtAddr_att_info = new String[]{'MthsAtAddr'};
        private String[] Occupancy_att_info = new String[]{'Occupancy'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Address'};
    }
    public class Data {
        public String Name;
        public String Value;
        private String[] Name_type_info = new String[]{'Name','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] Value_type_info = new String[]{'Value','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Name','Value'};
    }
    public class Subject {
        public TransUnionIdAuthElements.Business Business;
        public TransUnionIdAuthElements.Customer Customer;
        public TransUnionIdAuthElements.Consumer Consumer;
        private String[] Business_type_info = new String[]{'Business','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] Customer_type_info = new String[]{'Customer','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] Consumer_type_info = new String[]{'Consumer','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Business','Customer','Consumer'};
    }
    public class Answer {
        public String QuestionId;
        public String Response;
        public String ActualTime;
        private String[] QuestionId_att_info = new String[]{'QuestionId'};
        private String[] Response_att_info = new String[]{'Response'};
        private String[] ActualTime_att_info = new String[]{'ActualTime'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class ExcludeQuestionId {
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class PersonalInfo {
        public String Gender;
        public String BirthDate;
        public String Age;
        public String SIN;
        public String Race;
        public String Citizenship;
        public String Lang;
        public String EmailAddress;
        private String[] Gender_att_info = new String[]{'Gender'};
        private String[] BirthDate_att_info = new String[]{'BirthDate'};
        private String[] Age_att_info = new String[]{'Age'};
        private String[] SIN_att_info = new String[]{'SIN'};
        private String[] Race_att_info = new String[]{'Race'};
        private String[] Citizenship_att_info = new String[]{'Citizenship'};
        private String[] Lang_att_info = new String[]{'Lang'};
        private String[] EmailAddress_att_info = new String[]{'EmailAddress'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class ProcessCreditReportResponse_element {
        public TransUnionIdAuthElements.TUIVRReply ProcessCreditReportResult;
        private String[] ProcessCreditReportResult_type_info = new String[]{'ProcessCreditReportResult','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'ProcessCreditReportResult'};
    }
    public class Reply {
        public TransUnionIdAuthElements.Confidence Confidence;
        public TransUnionIdAuthElements.Question[] Question;
        public TransUnionIdAuthElements.Error[] Error;
        public TransUnionIdAuthElements.ExternalSourceSubjectData ExternalSourceSubjectData;
        public TransUnionIdAuthElements.ArrayOfReport IDReports;
        public String CorrelationId;
        public String CurrentAddressFromFile;
        public String FileNumber;
        public String ExternalId;
        public String SessionId;
        private String[] Confidence_type_info = new String[]{'Confidence','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] Question_type_info = new String[]{'Question','http://www.transunion.ca/WS/IDAuthentication',null,'0','-1','false'};
        private String[] Error_type_info = new String[]{'Error','http://www.transunion.ca/WS/IDAuthentication',null,'0','-1','false'};
        private String[] ExternalSourceSubjectData_type_info = new String[]{'ExternalSourceSubjectData','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] IDReports_type_info = new String[]{'IDReports','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] CorrelationId_att_info = new String[]{'CorrelationId'};
        private String[] CurrentAddressFromFile_att_info = new String[]{'CurrentAddressFromFile'};
        private String[] FileNumber_att_info = new String[]{'FileNumber'};
        private String[] ExternalId_att_info = new String[]{'ExternalId'};
        private String[] SessionId_att_info = new String[]{'SessionId'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Confidence','Question','Error','ExternalSourceSubjectData','IDReports'};
    }
    public class ExternalSourceSubjectData {
        public String Type_x;
        public String EncodingType;
        private String[] Type_x_att_info = new String[]{'Type'};
        private String[] EncodingType_att_info = new String[]{'EncodingType'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class Alert {
        public String Code;
        public String SubCode;
        public String Source;
        public String Text;
        public String Description;
        public String Severity;
        public String Action;
        private String[] Code_att_info = new String[]{'Code'};
        private String[] SubCode_att_info = new String[]{'SubCode'};
        private String[] Source_att_info = new String[]{'Source'};
        private String[] Text_att_info = new String[]{'Text'};
        private String[] Description_att_info = new String[]{'Description'};
        private String[] Severity_att_info = new String[]{'Severity'};
        private String[] Action_att_info = new String[]{'Action'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class IDAuthentication {
        public TransUnionIdAuthElements.Request Request;
        public TransUnionIdAuthElements.Reply Reply;
        public TransUnionIdAuthElements.ArrayOfData TUAdditionalData;
        public String Version;
        public String xmlns;
        private String[] Request_type_info = new String[]{'Request','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] Reply_type_info = new String[]{'Reply','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] TUAdditionalData_type_info = new String[]{'TUAdditionalData','http://www.transunion.ca/WS/IDAuthentication',null,'0','1','false'};
        private String[] Version_att_info = new String[]{'Version'};
        private String[] xmlns_att_info = new String[]{'xmlns'};
        private String[] apex_schema_type_info = new String[]{'http://www.transunion.ca/WS/IDAuthentication','true','false'};
        private String[] field_order_type_info = new String[]{'Request','Reply','TUAdditionalData'};
    } 
}