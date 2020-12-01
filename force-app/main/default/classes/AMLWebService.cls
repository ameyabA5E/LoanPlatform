/**************************************************************************************************
*
*  Class:   AMLWebService
*
*  @description : This class is integration layer for the AML web service
*  @author : A5E Consulting
*  @date : 11/12/2020   
*
*************************************************************************************************/
public with sharing class AMLWebService extends AMLWebServiceUtil{
    
    public static string parseXMLStringIFSXMLRq(String IFSXMLRq){
        // FirstName+LastName+DOB+SIN
        string firstName, lastName, memberCode, password, response;

        Dom.Document doc = new Dom.Document();
        doc.load(IFSXMLRq);
        
        //load root element
        Dom.XMLNode drRoot = doc.getRootElement(); // IFSXMLRq
        //drRoot.getChildElement('Route',null).getText();
        //drRoot.getChildElement('UserReference',null).getText();
        memberCode = drRoot.getChildElement('MemberCode',null).getText();
        password = drRoot.getChildElement('Password',null).getText();
        //drRoot.getChildElement('PRODUCTCODE',null).getText();
        
        Dom.XMLNode AML = drRoot.getChildElement('AML',null);
        lastName = AML.getChildElement('LastName',null).getText();
        firstName = AML.getChildElement('FirstName',null).getText();

        // Dom.XMLNode Address = AML.getChildElement('Address',null);
        // Address.getChildElement('Civic',null).getText();
        // Address.getChildElement('Street',null).getText();
        // Address.getChildElement('City',null).getText();
        // Address.getChildElement('Postal',null).getText();
        // Address.getChildElement('Prov',null).getText();
        // Address.getChildElement('Telephone',null).getText();

        // AML.getChildElement('Telephone',null).getText();
        // drRoot.getChildElement('PI',null).getText();

        //firstname	lastname	password
        //Kelly	Jackson	XYZ@123
        if(firstName.equalsIgnoreCase('Kelly') && lastName.equalsIgnoreCase('Jackson') ){
           // Record found - AML fraud 
           response = declinedResponse;
        }
        else if(firstName.equalsIgnoreCase('Hasan') && lastName.equalsIgnoreCase('Mohammed') ){
            // Record found - No Fraud
            response = approveResponse;
        }
        else if(firstName.equalsIgnoreCase('Justin') && lastName.equalsIgnoreCase('Anzan') ){
             // No Record found - Need review
             response = reviewResponse;
        }
        else if(firstName.equalsIgnoreCase('Josalind') && lastName.equalsIgnoreCase('Yachi') ){
           // Record found - No Fraud
            response = approveResponse;
        }
        else if(firstName.equalsIgnoreCase('Makiko') && lastName.equalsIgnoreCase('Lavi') ){
            // Record found - AML fraud 
            response = declinedResponse;
        }
        // Declined
        else if(DecisionEngine.decision == DecisionEngine.DECLINE){
            response = declinedResponse;
        }
        // Review
        else if(DecisionEngine.decision == DecisionEngine.REVIEW){
            response = reviewResponse;
        }
        // Approved
        else if(DecisionEngine.decision == DecisionEngine.APPROVE){
            response = approveResponse;
        }

        response = response.replace('{!firstName}', firstName);
        response = response.replace('{!lastName}', lastName);
        response = response.replace('{!memberCode}', memberCode);
        return response;
    }

    // Declined
    static string declinedResponse='<?xml version="1.0" encoding="iso-8859-1"?><REL4Report><MemberCode>{!memberCode}</MemberCode><Date>20200929</Date><Time>073903</Time><Product>07000</Product><TU_FFR_Report><Hit>N</Hit><TransAlerts><TransAlert><Code>0</Code><Text>CLEAR</Text></TransAlert></TransAlerts><Messages><Message><Code>000000</Code></Message></Messages><TU_TTY_Report><![CDATA['+

                        'TRANS UNION OF CANADA                          '+
                    'Consumer Credit Report               Date:29Sep2020'+
                'ID Mismatch Alert      : Clear'+
                'High Risk Fraud Alert  : Clear'+
                'Unable to find a file for {!firstName} {!lastName}'+
                ']]></TU_TTY_Report></TU_FFR_Report></REL4Report>';

    static string reviewResponse = '<?xml version="1.0" encoding="iso-8859-1"?><REL4Report><UserReference>TEST</UserReference><MemberCode>{!memberCode}</MemberCode><Date>20200415</Date><Time>040249</Time><Product>07000</Product><TU_FFR_Report><Hit>N</Hit><TransAlerts><TransAlert><Code>0</Code><Text>CLEAR</Text></TransAlert></TransAlerts><Messages><Message><Code>000000</Code></Message></Messages><TU_TTY_Report><![CDATA['+

        ' \\n TEST                        TRANS UNION OF CANADA                          '+
        '\\n  Consumer Credit Report               Date:15Apr2020'+
        '\\n  ID Mismatch Alert      : Clear'+
        
        '\\n High Risk Fraud Alert  : Clear'+
        
        '\\n Unable to find a file for {!firstName} {!lastName}'+
        '\\n ]]></TU_TTY_Report></TU_FFR_Report></REL4Report>';
    static string approveResponse = '<?xml version="1.0" encoding="iso-8859-1"?><IFSXML><UniqueID>000000023398</UniqueID><AML><AMLBureau>T</AMLBureau><AMLDirserv></AMLDirserv><BureauHit>Y</BureauHit><LastName>{!lastName}</LastName><FirstName>{!firstName}</FirstName><MiddleName>Y</MiddleName><Civic>X</Civic><Street>Y</Street><Apt>Y</Apt><City>Y</City><Prov>Y</Prov><Postal>N</Postal><Telephone>M</Telephone><DOB>Y</DOB><SIN>M</SIN><FraudFlag>N</FraudFlag><AMLCivic>301</AMLCivic><AMLPostal>S4R1L2</AMLPostal></AML></IFSXML>';

    public Application__c getAML(Application__c app){
        string jsonResponse = '{"IFSXMLRq":"'+
                                    '<IFSXML>'+
                                        '<Route RouteType=\"Test\"></Route>'+
                                        '<UserReference>MyTest</UserReference>'+
                                        '<MemberCode>AB12345678</MemberCode>'+
                                        '<Password>ABCD</Password>'+
                                        '<PRODUCTCODE>12345</PRODUCTCODE>'+
                                        '<AML>'+
                                            '<LastName>BASTIAANSEN</LastName>'+
                                            '<FirstName>Greg</FirstName>'+
                                            '<Address>'+
                                                '<Civic>80</Civic>'+
                                                '<Street>MARINA DR</Street>'+
                                                '<City>THUNDER BAY</City>'+
                                                '<Postal>M2R3B7</Postal>'+
                                                '<Prov>ON</Prov>'+
                                                '<Telephone>2895214849</Telephone>'+
                                                '</Address>'+
                                            '<Telephone>2895214849</Telephone>'+
                                        '</AML>'+
                                        '<PI>'+
                                            '<DOB>19831231</DOB>'+
                                        '</PI>'+
                                    '</IFSXML>",'+
                                    '"homeOwnerInd":true,'+
                                    '"grossMonthlyIncomeAmount":5000.0,'+
                                    '"financialConditionCode":"CP",'+
                                    '"employmentTypeCode":"Full-time",'+
                                    '"dependentsCount":"1",'+
                                    '"birthDate":"1983-12-31"}';
        AMLResponse amlResponse = (AMLResponse) System.JSON.deserialize(jsonResponse, AMLResponse.class);
        string IFSXMLRq = amlResponse.IFSXMLRq;
        parseXMLStringIFSXMLRq(IFSXMLRq);
        return app;
    }

}