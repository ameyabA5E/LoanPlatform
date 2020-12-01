/**************************************************************************************************
*
*  Class:   AdjudicationWebService
*
*  @description : This class is integration layer for the Adjudication web service
*  @author : A5E Consulting
*  @date : 11/12/2020   
*
*************************************************************************************************/
public with sharing class AdjudicationWebService {
    public static string getDecision(DecisionEngine.RequestPayload requestPayload){
         Decimal expenses =   requestPayload.monthlyRentPaymentAmount+
         requestPayload.totalOtherMonthlyExpensesAmount;
         
         string firstName, lastName, memberCode, response;
      /*
         Dom.Document doc = new Dom.Document();
         doc.load(requestPayload.IFSXMLRq);

         //load root element
         Dom.XMLNode drRoot = doc.getRootElement(); // IFSXMLRq
         memberCode = drRoot.getChildElement('MemberCode',null).getText();

         Dom.XMLNode AML = drRoot.getChildElement('AML',null);
         lastName = AML.getChildElement('LastName',null).getText();
         firstName = AML.getChildElement('FirstName',null).getText();
      */
        // Declined
        if(requestPayload.grossMonthlyIncomeAmount < expenses){
            DecisionEngine.decision = DecisionEngine.DECLINE;
            //response = declinedResponse;
            response = responseStringRej;
        }

        // Review
        if(requestPayload.grossMonthlyIncomeAmount == expenses){
            DecisionEngine.decision = DecisionEngine.REVIEW;
            //response = reviewResponse;
            response = responseString;
        }

        // Approved
        if(requestPayload.grossMonthlyIncomeAmount > expenses){
            DecisionEngine.decision = DecisionEngine.APPROVE;
            //response = approveResponse;
            response = responseString;
        }
        /*
        while(response.indexOf('{!firstName}') != -1){
         response = response.replace('{!firstName}', firstName);
        }
        while(response.indexOf('{!lastName}') != -1){
         response = response.replace('{!lastName}', lastName);
        }
        while(response.indexOf('{!memberCode}') != -1){
         response = response.replace('{!memberCode}', memberCode);
        }*/
       return response;
    }

    //declined
    static string responseString = '{"dPricing":[{"maximumCreditAmount":500.0,"interestRate":29.99}]}';
    static string responseStringRej = '{"dRejection":[{"reasonCode":"EMPLOYMENT_LENGTH_FAILED","diagnosticInfo":"6"}],"dPricing":[{"maximumCreditAmount":1000.0,"interestRate":34.99}]}';

    public class AdjudicationWrapper{
      public List<dPricingWrapper> dPricing;
    }

    public class dPricingWrapper{
      public Decimal maximumCreditAmount;
      public Decimal interestRate;
    }
    public class dRejectionWrapper{
      public string reasonCode;
      public string diagnosticInfo;
    }

    static string declinedResponse = '<?xml version="1.0" encoding="iso-8859-1"?><REL4Report><UserReference>TEST</UserReference><MemberCode>{!memberCode}</MemberCode><Date>20200415</Date><Time>040249</Time><Product>07000</Product><TU_FFR_Report><Hit>N</Hit><TransAlerts><TransAlert><Code>0</Code><Text>CLEAR</Text></TransAlert></TransAlerts><Messages><Message><Code>000000</Code></Message></Messages><TU_TTY_Report><![CDATA['+
        'TEST                        TRANS UNION OF CANADA'+
        'Consumer Credit Report               Date:15Apr2020'+
        'ID Mismatch Alert      : Clear'+
        'High Risk Fraud Alert  : Clear'+
        'Unable to find a file for {!firstName} {!lastName}'+
        ']]></TU_TTY_Report></TU_FFR_Report></REL4Report>';
    static string reviewResponse = '<?xml version="1.0" encoding="iso-8859-1"?><REL4Report><MemberCode>{!memberCode}</MemberCode><Date>20200922</Date><Time>075421</Time><Product>07000</Product><TU_FFR_Report><Hit>Y</Hit><OnFileDate>20141101</OnFileDate><Names><Name NameType="Primary"><LastName>{!lastName}</LastName><FirstName>{!firstName}</FirstName><MiddleName>DAN</MiddleName></Name></Names><PersonalInformation><SIN>000000000</SIN><DOB>19720202</DOB></PersonalInformation><TransAlerts><TransAlert><Code>601</Code><Text>#HK# CONSUMER FRAUD WARNINGS ON FILE</Text></TransAlert></TransAlerts><Addresses><Address AddrType="Personal"><Street>101 MONTGOMERY AVE</Street><City>SELKIRK</City><Prov>MB</Prov><Postal>R1A2N9</Postal><DateReported>20200613</DateReported></Address><Address AddrType="Personal"><Street>167 LOGAN AVE</Street><City>WINNIPEG</City><Prov>MB</Prov><Postal>R3B3H3</Postal><DateReported>20101101</DateReported></Address></Addresses><Telephones><Telephone PhoneType="Personal"><Number>2047858670</Number></Telephone></Telephones><Trades><Trade><MemberCode>BC</MemberCode><MemberName>CITI MASTERCARD</MemberName><Type>R</Type><Account>5208260000008965</Account><Joint>I</Joint><DateOpened>20140101</DateOpened><DateRevised>20200701</DateRevised><DateLastActivity>20200619</DateLastActivity><MOP>01</MOP><Balance>1200</Balance><HighCredit>3000</HighCredit><CreditLimit>0</CreditLimit><Frequency>M</Frequency><Payment>0</Payment><Narrative1>HC</Narrative1><PastDue>0</PastDue><PaymentPatternStartDate>20200619</PaymentPatternStartDate><PaymentPattern>111111111111111111111111111111111111111111111111</PaymentPattern><MonthsReviewed>84</MonthsReviewed><Plus30>0</Plus30><Plus60>0</Plus60><Plus90>0</Plus90></Trade></Trades><ConsumerStatements><ConsumerStatement><Type>02</Type><Text>POTENTIAL FRAUD VICTIM; BEFORE EXTENDING CREDIT VERIFY ALL A</Text></ConsumerStatement><ConsumerStatement><Type>02</Type><Text>PPLICANT INFORMATION. CONTACT CONSUMER FOR VERIFICATION AT H</Text></ConsumerStatement><ConsumerStatement><Type>02</Type><Text>OME: (204) 799-9999 DATED 12/2010  VICTIME POTENTIELLE DE FR</Text></ConsumerStatement><ConsumerStatement><Type>02</Type><Text>AUDE: NE PAS ACCORDER DE CREDIT SANS  VERIFIER TOUTES LES IN</Text></ConsumerStatement><ConsumerStatement><Type>02</Type><Text>FORMATIONS DU POSTULANT. DE PLUS, COMMUNIQUER AVEC LE CONSOM</Text></ConsumerStatement><ConsumerStatement><Type>02</Type><Text>MATEUR DIRECTEMENT A DOMICILE POUR VERIFICATION AU: (204) 79</Text></ConsumerStatement><ConsumerStatement><Type>02</Type><Text>9-9999 DATE 12/2010</Text></ConsumerStatement></ConsumerStatements><CreditSummary><ReportingPeriod>1</ReportingPeriod><NumberOfPublicRecords>000</NumberOfPublicRecords><NumberOfCollections>000</NumberOfCollections><NumberOfNegativeTrades>000</NumberOfNegativeTrades><NumberOfNegativeTradesHistorical>000</NumberOfNegativeTradesHistorical><NumberOfHistoricalNegative>000</NumberOfHistoricalNegative><NumberOfTrades>001</NumberOfTrades><NumberOfRevolvingTrades>001</NumberOfRevolvingTrades><NumberOfInstallmentTrades>000</NumberOfInstallmentTrades><NumberOfMortgageTrades>000</NumberOfMortgageTrades><NumberOfOpenTrades>000</NumberOfOpenTrades><NumberOfInquiries>000</NumberOfInquiries></CreditSummary><CreditSummaryDetails><CreditSummaryDetail><Type>R</Type><HighCredit>000000000</HighCredit><CreditLimit>000000000</CreditLimit><Balance>000001200</Balance><PastDue>000000000</PastDue><MonthlyPayment>000000000</MonthlyPayment><PercentageAvailable>000</PercentageAvailable></CreditSummaryDetail><CreditSummaryDetail><Type>I</Type><HighCredit>000000000</HighCredit><CreditLimit>000000000</CreditLimit><Balance>000000000</Balance><PastDue>000000000</PastDue><MonthlyPayment>000000000</MonthlyPayment></CreditSummaryDetail><CreditSummaryDetail><Type>M</Type><HighCredit>000000000</HighCredit><CreditLimit>000000000</CreditLimit><Balance>000000000</Balance><PastDue>000000000</PastDue><MonthlyPayment>000000000</MonthlyPayment></CreditSummaryDetail><CreditSummaryDetail><Type>O</Type><HighCredit>000000000</HighCredit><CreditLimit>000000000</CreditLimit><Balance>000000000</Balance><PastDue>000000000</PastDue><MonthlyPayment>000000000</MonthlyPayment><PercentageAvailable>000</PercentageAvailable></CreditSummaryDetail><CreditSummaryDetail><Type>T</Type><HighCredit>000000000</HighCredit><CreditLimit>000000000</CreditLimit><Balance>000001200</Balance><PastDue>000000000</PastDue><MonthlyPayment>000000000</MonthlyPayment></CreditSummaryDetail></CreditSummaryDetails><Messages><Message><Code>000255</Code><Text>CURRENT ADDRESS IS TELEMARKETING/ADVERTISING</Text></Message></Messages><ScoreProducts><ScoreProduct><Product>00093</Product><Score>821</Score><ScoreDerogatoryAlert>N</ScoreDerogatoryAlert><Factor1>14</Factor1><Factor2>3</Factor2><Factor3>19</Factor3><Factor4>0</Factor4><ScoreCard>07</ScoreCard></ScoreProduct></ScoreProducts><TU_TTY_Report><![CDATA['+
                            'TRANS UNION OF CANADA                          '+
                           'Consumer Credit Report               Date:22Sep2020'+
    ''+
            'Surname             Given Name(s)       Soc.Ins.No.   Birth'+
    'Subject   GELLER              {!firstName} {!lastName}                          02Feb1972'+
    ''+
    'On File   Last Inq           Current Residence    Telephone     Prev phone'+
    '01Nov2014 000000000                               2047858670                   '+
    ''+
    '-- Residence(s) ---------------------------------------------------------------'+
    'Street                        City           Prov Postal    Since     Cnfrm'+
    '101 MONTGOMERY AVE            SELKIRK        MB   R1A2N9    Jun2020   Sep2020'+
    '167 LOGAN AVE                 WINNIPEG       MB   R3B3H3    Nov2010   Sep2020'+
    ''+
    '-- File summary ---------------------------------------------------------------'+
    'Bankruptcies               0-0000000     Registered Items            0-0000000'+
    'Legal Items                0-0000000     Inquiries                   0-0000000'+
    'Collections                0-0000000     Collection Inquiries        0'+
    'Banking Closed For Cause   0-0000000     Inquiries within 6 Months   0'+
    ''+
    'Trade First Opened           Jan2014     Current Negative Trade      0'+
    'Trade Last Opened            Jan2014     Paid Trade                  0'+
    ''+
    'Type  Count HighCred   CredLimit  Balance    PastDue    Payment    Available'+
    'R        1  n/a        $0         $1,200     $0         $0         0%'+
    'O        0  $0         n/a        $0         $0         $0         n/a'+
    'I        0  $0         n/a        $0         $0         $0         n/a'+
    'M        0  $0         n/a        $0         $0         $0         n/a'+
    'Total    1  $0         $0         $1,200     $0         $0         n/a'+
    ''+
    'ID Mismatch Alert      : #HK# Consumer Fraud Warnings on File'+
    ''+
    'High Risk Fraud Alert  : Current Address is Telemarketing/Advertising'+
    ''+
    'CreditVision Risk Score: 821'+
    'Factors               :  14 Insufficient mortgage experience'+
    'Factors               :   3 Balance increase on revolving account'+
    'Factors               :  19 No bank installment account'+
    ''+
    '-- Trade ----------------------------------------------------------------------'+
                                                        'Payment Pattern'+
    'Reptd    Open    Last    H.Credit Balance  PastDue Terms    30/60/90/#M    MOP'+
    'BC  CITI MASTERCARD,4169472900                     111111111111111111111111'+
    'Jun2020  Jan2014 Jun2020 0        1200             M         0  0  0 84    R1'+
    '                                                                               '+
    ''+
    '-- Remarks --------------------------------------------------------------------'+
    'Date    Information'+
    '01Sep2020 #HK# POTENTIAL FRAUD VICTIM; BEFORE EXTENDING CREDIT VERIFY ALL'+
    '01Sep2020 #HK# APPLICANT INFORMATION. CONTACT CONSUMER FOR VERIFICATION AT'+
    '01Sep2020 #HK# HOME: (204) 799-9999 DATED 12/2010  VICTIME POTENTIELLE DE'+
    '01Sep2020 #HK# FRAUDE: NE PAS ACCORDER DE CREDIT SANS  VERIFIER TOUTES LES'+
    '01Sep2020 #HK# INFORMATIONS DU POSTULANT. DE PLUS, COMMUNIQUER AVEC LE'+
    '01Sep2020 #HK# CONSOMMATEUR DIRECTEMENT A DOMICILE POUR VERIFICATION AU: (204)'+
    '01Sep2020 #HK# 799-9999 DATE 12/2010'+
    ''+
    'This completes the file for RUDY GELLER'+
    ']]></TU_TTY_Report></TU_FFR_Report></REL4Report>';
    static string approveResponse = '<?xml version="1.0" encoding="iso-8859-1"?><REL4Report><MemberCode>{!memberCode}</MemberCode><Date>20200922</Date><Time>075639</Time><Product>07000</Product><TU_FFR_Report><Hit>Y</Hit><OnFileDate>20050608</OnFileDate><Names><Name NameType="Primary"><LastName>{!lastName}</LastName><FirstName>{!firstName}</FirstName></Name></Names><PersonalInformation><SIN>000000000</SIN><DOB>19660313</DOB></PersonalInformation><TransAlerts><TransAlert><Code>1</Code><Text>CURRENT INPUT ADDRESS DOES NOT MATCH FILE ADDRESS(ES)</Text></TransAlert></TransAlerts><Addresses><Address AddrType="Personal"><Street>301 MONTREAL ST</Street><City>REGINA</City><Prov>SK</Prov><Postal>S4R1L2</Postal><DateReported>20141101</DateReported></Address><Address AddrType="Personal"><Street>301 MONTREAL ST</Street><City>REGINA</City><Prov>SK</Prov><Postal>S4R1L2</Postal><DateReported>20141101</DateReported></Address><Address AddrType="Personal"><Street>301 MONTREAL ST</Street><City>REGINA</City><Prov>SK</Prov><Postal>S4R1L2</Postal><DateReported>20100620</DateReported></Address></Addresses><Telephones><Telephone PhoneType="Personal"><Number>3069496421</Number></Telephone></Telephones><Employments><Employment><EmpName>THE PIZZA PALACE</EmpName><DateHired>20120301</DateHired><DateSeparated>00000000</DateSeparated><DateVerified>00000000</DateVerified><Income>0</Income></Employment><Employment><EmpName>PIZZA PIZZA</EmpName><DateSeparated>00000000</DateSeparated><DateVerified>20200621</DateVerified><Income>0</Income></Employment></Employments><Bankruptcies><Bankruptcy><DateRevised>20200901</DateRevised><Reference>45673221</Reference><FilingNumber>45-67322145</FilingNumber><DateReported>20200412</DateReported><DateDischarged>00000000</DateDischarged><Assets>0</Assets><Liabilities>45000</Liabilities><Narrative>BK</Narrative><TrusteeName>ALICE LIDDELL</TrusteeName><TrusteeCompany>WONDERLAND UNLIMITED</TrusteeCompany><ThirdParty>9051113321</ThirdParty></Bankruptcy></Bankruptcies><Trades><Trade><MemberCode>BC</MemberCode><MemberName>CITI MASTERCARD</MemberName><Type>R</Type><Account>5177810000001811</Account><Joint>I</Joint><DateOpened>20100601</DateOpened><DateRevised>20200701</DateRevised><DateLastActivity>20190601</DateLastActivity><MOP>01</MOP><Balance>0</Balance><HighCredit>1000</HighCredit><CreditLimit>0</CreditLimit><Frequency>M</Frequency><Payment>0</Payment><Narrative1>HC</Narrative1><PastDue>0</PastDue><PaymentPatternStartDate>20190622</PaymentPatternStartDate><PaymentPattern>111111111111111111111111111111111111111111111111</PaymentPattern><MonthsReviewed>59</MonthsReviewed><Plus30>0</Plus30><Plus60>0</Plus60><Plus90>0</Plus90></Trade><Trade><MemberCode>DC</MemberCode><MemberName>SEARS</MemberName><Type>R</Type><Account>6281140000007897</Account><Joint>I</Joint><DateOpened>20200601</DateOpened><DateRevised>20200701</DateRevised><DateLastActivity>20200601</DateLastActivity><MOP>00</MOP><Balance>0</Balance><HighCredit>0</HighCredit><CreditLimit>1000</CreditLimit><Frequency>M</Frequency><Payment>0</Payment><PastDue>0</PastDue><PaymentPatternStartDate>20200623</PaymentPatternStartDate><MonthsReviewed>0</MonthsReviewed><Plus30>0</Plus30><Plus60>0</Plus60><Plus90>0</Plus90></Trade><Trade><MemberCode>BB</MemberCode><MemberName>ROYAL BANK OF CANADA</MemberName><Type>R</Type><Account>4510190000004139</Account><Joint>I</Joint><DateOpened>20140601</DateOpened><DateRevised>20180706</DateRevised><DateLastActivity>20180618</DateLastActivity><MOP>01</MOP><Balance>0</Balance><HighCredit>0</HighCredit><CreditLimit>0</CreditLimit><Frequency>M</Frequency><Payment>0</Payment><Narrative1>HC</Narrative1><PastDue>0</PastDue><PaymentPatternStartDate>20180618</PaymentPatternStartDate><PaymentPattern>111111111111111111111111111111111111111111111111</PaymentPattern><MonthsReviewed>48</MonthsReviewed><Plus30>0</Plus30><Plus60>0</Plus60><Plus90>0</Plus90></Trade><Trade><MemberCode>BC</MemberCode><MemberName>HSBC M/C</MemberName><Type>R</Type><Account>5193920000006655</Account><Joint>I</Joint><DateOpened>20150615</DateOpened><DateRevised>20180620</DateRevised><DateLastActivity>20180615</DateLastActivity><MOP>01</MOP><Balance>1000</Balance><HighCredit>3000</HighCredit><CreditLimit>0</CreditLimit><Frequency>M</Frequency><Payment>0</Payment><Narrative1>HC</Narrative1><PastDue>0</PastDue><PaymentPatternStartDate>20180615</PaymentPatternStartDate><PaymentPattern>111111111111111111111111111111111111</PaymentPattern><MonthsReviewed>36</MonthsReviewed><Plus30>0</Plus30><Plus60>0</Plus60><Plus90>0</Plus90></Trade><Trade><MemberCode>BB</MemberCode><Type>I</Type><Joint>I</Joint><DateOpened>00000000</DateOpened><DateRevised>20180620</DateRevised><DateLastActivity>20180615</DateLastActivity><MOP>01</MOP><Balance>200000</Balance><HighCredit>250000</HighCredit><CreditLimit>250000</CreditLimit><Frequency>M</Frequency><Payment>0</Payment><PastDue>0</PastDue><PaymentPatternStartDate>20180615</PaymentPatternStartDate><PaymentPattern>111111111111</PaymentPattern><MonthsReviewed>0</MonthsReviewed><Plus30>0</Plus30><Plus60>0</Plus60><Plus90>0</Plus90></Trade></Trades><CreditSummary><ReportingPeriod>1</ReportingPeriod><NumberOfPublicRecords>001</NumberOfPublicRecords><NumberOfCollections>000</NumberOfCollections><NumberOfNegativeTrades>000</NumberOfNegativeTrades><NumberOfNegativeTradesHistorical>000</NumberOfNegativeTradesHistorical><NumberOfHistoricalNegative>001</NumberOfHistoricalNegative><NumberOfTrades>004</NumberOfTrades><NumberOfRevolvingTrades>004</NumberOfRevolvingTrades><NumberOfInstallmentTrades>000</NumberOfInstallmentTrades><NumberOfMortgageTrades>001</NumberOfMortgageTrades><NumberOfOpenTrades>000</NumberOfOpenTrades><NumberOfInquiries>000</NumberOfInquiries></CreditSummary><CreditSummaryDetails><CreditSummaryDetail><Type>R</Type><HighCredit>000000000</HighCredit><CreditLimit>000000000</CreditLimit><Balance>000000000</Balance><PastDue>000000000</PastDue><MonthlyPayment>000000000</MonthlyPayment><PercentageAvailable>000</PercentageAvailable></CreditSummaryDetail><CreditSummaryDetail><Type>I</Type><HighCredit>000000000</HighCredit><CreditLimit>000000000</CreditLimit><Balance>000000000</Balance><PastDue>000000000</PastDue><MonthlyPayment>000000000</MonthlyPayment></CreditSummaryDetail><CreditSummaryDetail><Type>M</Type><HighCredit>000000000</HighCredit><CreditLimit>000000000</CreditLimit><Balance>000000000</Balance><PastDue>000000000</PastDue><MonthlyPayment>000000000</MonthlyPayment></CreditSummaryDetail><CreditSummaryDetail><Type>O</Type><HighCredit>000000000</HighCredit><CreditLimit>000000000</CreditLimit><Balance>000000000</Balance><PastDue>000000000</PastDue><MonthlyPayment>000000000</MonthlyPayment><PercentageAvailable>000</PercentageAvailable></CreditSummaryDetail><CreditSummaryDetail><Type>T</Type><HighCredit>000000000</HighCredit><CreditLimit>000000000</CreditLimit><Balance>000000000</Balance><PastDue>000000000</PastDue><MonthlyPayment>000000000</MonthlyPayment></CreditSummaryDetail></CreditSummaryDetails><Messages><Message><Code>000000</Code></Message></Messages><ScoreProducts><ScoreProduct><Product>00093</Product><Score>569</Score><ScoreDerogatoryAlert>A</ScoreDerogatoryAlert><Factor1>43</Factor1><Factor2>22</Factor2><Factor3>39</Factor3><Factor4>0</Factor4><ScoreCard>03</ScoreCard></ScoreProduct></ScoreProducts><TU_TTY_Report><![CDATA['+

                            'TRANS UNION OF CANADA                          '+
                            'Consumer Credit Report               Date:22Sep2020'+
                            ''+
                                      'Surname             Given Name(s)       Soc.Ins.No.   Birth'+
                            'Subject   {!firstName}            {!lastName}                             13Mar1966'+
                            ''+
                            'On File   Last Inq           Current Residence    Telephone     Prev phone'+
                            '08Jun2005 000000000                               3069496421    3069493661     '+
                            ''+
                            '-- Residence(s) ---------------------------------------------------------------'+
                            'Street                        City           Prov Postal    Since     Cnfrm'+
                            '301 MONTREAL ST               REGINA         SK   S4R1L2    Nov2014   Sep2020'+
                            '301 MONTREAL ST               REGINA         SK   S4R1L2    Nov2014   Sep2020'+
                            '301 MONTREAL ST               REGINA         SK   S4R1L2    Jun2010   Jun2018'+
                            ''+
                            '-- Employment(s) --------------------------------------------------------------'+
                            'Employers Name & Address                Occupation          Since     Cnfrm'+
                            'THE PIZZA PALACE, SK                                                  01Sep2020'+
                            'PIZZA PIZZA                                                 21Jun2020 01Sep2020'+
                            ''+
                            '-- File summary ---------------------------------------------------------------'+
                            'Bankruptcies               1-Apr2020     Registered Items            0-0000000'+
                            'Legal Items                0-0000000     Inquiries                   0-0000000'+
                            'Collections                0-0000000     Collection Inquiries        0'+
                            'Banking Closed For Cause   0-0000000     Inquiries within 6 Months   0'+
                            ''+
                            'Trade First Opened           Jun2010     Current Negative Trade      0'+
                            'Trade Last Opened            Jun2020     Paid Trade                  3'+
                            ''+
                            'Type  Count HighCred   CredLimit  Balance    PastDue    Payment    Available'+
                            'R        4  n/a        $0         $0         $0         $0         0%'+
                            'O        0  $0         n/a        $0         $0         $0         n/a'+
                            'I        1  $0         n/a        $0         $0         $0         n/a'+
                            'M        0  $0         n/a        $0         $0         $0         n/a'+
                            'Total    5  $0         $0         $0         $0         $0         n/a'+
                            ''+
                            'ID Mismatch Alert      : Current input address does not match file address(es)'+
                            ''+
                            'High Risk Fraud Alert  : Clear'+
                            ''+
                            'CreditVision Risk Score: 569'+
                             'Factors               :  43 Presence of bankruptcy delinquency or derogatory it'+
                             'Factors               :  22 No credit card account'+
                             'Factors               :  39 Presence of balance on credit card accounts'+
                            ''+
                            '-- Trade ----------------------------------------------------------------------'+
                                                                                  'Payment Pattern'+
                            'Reptd    Open    Last    H.Credit Balance  PastDue Terms    30/60/90/#M    MOP'+
                               'BC  CITI MASTERCARD,4169472900                     111111111111111111111111'+
                            'Jul2020  Jun2010 Jun2019 0        0        0       0/M       0  0  0 59    R1'+
                            '                                                                               '+
                            ''+
                               'DC  SEARS,8006868224'+
                            'Jun2020  Jun2020 Jun2020 1000     0        0       0/M       0  0  0  0    R0'+
                            '                                                                               '+
                            ''+
                               'BB  ROYAL BANK OF CANADA,6046653936                111111111111111111111111'+
                            'Jun2018  Jun2014 Jun2018 0        0        0       0/M       0  0  0 48    R1'+
                            '                                                                               '+
                            ''+
                               'BC  HSBC M/C,8664064722                            111111111111111111111111'+
                            'Jun2018  Jun2015 Jun2018 3000     1000     0       0/M       0  0  0 36    R1'+
                            '                                                                               '+
                            ''+
                            '-- Mortgages ------------------------------------------------------------------'+
                                                                                  'Payment Pattern'+
                            'Reptd    Open    Last    H.Credit Balance  PastDue Terms    30/60/90/#M    MOP'+
                               'BB  *Member information currently not available*   111111111111'+
                            'Jun2018          Jun2018 250000   200000   0       0/M       0  0  0       I1'+
                            '                                                                               '+
                            ''+
                            '-- Bankruptcy and Insolvency --------------------------------------------------'+
                            'Rvsd     Reptd     Trustee                        Assets  Liab'+
                            'Sep2020  12Apr2020 ALICE LIDDELL                  0       45000'+
                                             'WONDERLAND UNLIMITED'+
                                             '9051113321                       BANKRUPT'+
                                                                              '4567322145'+
                            ''+
                            'This completes the file for DANNY ROWLES'+
                            ']]></TU_TTY_Report></TU_FFR_Report></REL4Report>';
}