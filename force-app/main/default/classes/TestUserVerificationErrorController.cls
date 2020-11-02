/**************************************************************************************************
 *
 *  Class:   
 *
 *  @description : This class contains unit tests for validating behavior of trac_UserVerificationErrorController
 *  @author : A5E Consulting
 *  @date : 05/11/2016
 *
 *  Change History:
 *
 *  Developer       Date          Description
 *  ------------------------------------------------------------------------------------------------
 *
 *  A5E Consulting 05/11/2016     Class created
 *  A5E Consulting 05/11/2016     Test Methods added
 
 *************************************************************************************************/
//@isTest this class is private
public class TestUserVerificationErrorController {
    
   /* private static Application_Form_Settings__c afSettings;
    private static Application__c appln;
    
        
    static testMethod void testVerificationErrorController() {
        
        init();
        
        ApexPages.currentPage().getParameters().put('id', appln.Id);
        ApexPages.currentPage().getParameters().put('errorMessage', 'TechnicalIssue');
        
        Test.startTest();
            System.Test.setMock(HttpCalloutMock.class, PowerCurveTestUtilities.getMockAcceptResponse());
            trac_UserVerificationErrorController cntrl = new trac_UserVerificationErrorController();
        Test.stopTest();
        
    }    

    static void init() {
        
        afSettings = new Application_Form_Settings__c(
            Power_Curve_Web_Service_URL__c = PowerCurveTestUtilities.Power_Curve_Web_Service_URL,
            Power_Curve_Username__c = PowerCurveTestUtilities.Power_Curve_Username, 
            Power_Curve_Password__c = PowerCurveTestUtilities.Power_Curve_Password, 
            Site_Profile_Id__c = '00eK0000000MDqzIAG'
        );
        insert afSettings;
        
        insertTestData();
        initPageRef();
    }
    
    static void insertTestData() {
        
        Account p = new Account(
            FirstName = 'Rob',
            LastName = 'Johnson',
            PersonEmail = 'rj@test.com' 
        );
        insert p;
        
        appln = new Application__c(
            Customer__c = p.Id,
            Salutation__c = 'Mr.', 
            First_Name__c = 'Rob', 
            Last_Name__c = 'Johnson', 
            Gender__c = 'Male',
            SIN__c = '123456789',
            Requested_Credit_Limit__c = 4500,
            Birth_Date__c = Date.today().addYears(-25), 
            Current_BKCP__c = false, 
            Marital_Status__c = 'Single', 
            Home_Phone__c = '416-555-1234', 
            Work_Phone__c = '416-555-4567', 
            
            Permanent_Address_Street_Number__c = '123', 
            Permanent_Address_Street_Name__c = 'Current St.', 
            Permanent_Address_City__c = 'Toronto', 
            Permanent_Address_Province__c = 'ON', 
            Permanent_Address_PostalCode__c = 'A1A 1A1', 
            Years_At_Permanent_Address__c = 0, 
            Months_At_Permanent_Address__c = 6, 
            Home_Owner__c = 'Rent', 
            Housing_Costs__c = 1000,
            
            Previous_Address_Street_Number__c = '456', 
            Previous_Address_Street_Name__c = 'Previous St.', 
            Previous_Address_City__c = 'Toronto', 
            Previous_Address_Province__c = 'ON', 
            Previous_Address_PostalCode__c = 'P1P 1P1', 
            Years_At_Previous_Address__c = 5, 
            Months_At_Previous_Address__c = 8, 
            
            Employment_Status__c = 'Full-time', 
            Employer_Name__c = 'ACME Co.', 
            Employment_Years__c = 0, 
            Employment_Months__c = 8, 
            Gross_Monthly_Income__c = 3000, 
            Employer_Street_Number__c = '1212', 
            Employer_Street_Name__c = 'Main St.', 
            Employer_City__c = 'Toronto', 
            Employer_Province__c = 'ON', 
            Employer_PostalCode__c = 'M2M 2M2',
            Employer_Phone__c = '416-555-4567',
            
            Previous_Employer_Name__c = 'ABC Computers', 
            Previous_Employment_Years__c = 4, 
            Previous_Employment_Months__c = 6, 
            Previous_Gross_Monthly_Income__c = 2000, 
            Previous_Employer_Street_Number__c = '4545', 
            Previous_Employer_Street_Name__c = 'Front St.', 
            Previous_Employer_City__c = 'Toronto', 
            Previous_Employer_Province__c = 'ON', 
            Previous_Employer_PostalCode__c = 'F2F 2F2',
            Loan_Type__c = 'Affirm Financial MasterCard',
            Authentication_Result__c = 'Incomplete',
            Authentication_Choice__c = 'Error-TechnicalIssue'
        );
        insert appln;              
    }
    
    static void initPageRef() {
        PageReference pageRef = Page.UserVerificationError;
        Test.setCurrentPage(pageRef);
    }     */
}