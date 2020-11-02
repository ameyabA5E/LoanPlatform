/**************************************************************************************************
*
*  Class:   
*
*  @description : VersaPay Funding/ Payment Mock Test
*  @author : A5E Consulting
*  @date : 12/07/2016   

*************************************************************************************************/
@isTest
global class VersaPayWSUtilReqMockTest implements HttpCalloutMock {
	
    private String calloutResponse;
    private Integer calloutStatusCode;
    public  VersaPayWSUtilReqMockTest(){}
    public VersaPayWSUtilReqMockTest(String resp, Integer sc) {
        calloutResponse = resp;
        calloutStatusCode = sc;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(calloutResponse);
        res.setStatusCode(calloutStatusCode);
        return res;
    }
    
    //direct_credit full response 
    public static String responseFullDirectCredit ='<transaction>'+
       		'<token>95E9DN4VXIA4</token>'+
            '<amount_in_cents type="integer">90000</amount_in_cents>'+
            '<message nil="true"/>'+
            '<link_url nil="true"/>'+
            '<type>transaction</type>'+
            '<transaction_type>direct_credit</transaction_type>'+
            '<email nil="true"/>'+
            '<state>new</state>'+
            '<transaction_reference>47651_Megasys</transaction_reference>'+
            '<unique_reference nil="true"/>'+
            '<from_account>Canaccede</from_account>'+
            '<to_account>INGEBORG APPEL</to_account>'+
            '<process_on type="date">2016-11-14</process_on>'+
            '<from_fund>TD Canada Trust</from_fund>'+
            '<to_fund_token>BA284MWF79TU</to_fund_token>'+
            '<created_by_user>yujpqgPa_vscKNcz8Gkf</created_by_user>'+
            '</transaction>';
    
    //direct_credit Error response 
    public static String   responseErrorDirectCrdDbt = '<errors>'+
    							    '<Error>A default bank account must be specified on the account in order to use transaction API. Please sign in to your versapay account and add a default bank account.</error>'+
                 					'</errors>';
        
	//null XML response 
    public static String responseNullDirectCrdDbt ='<transaction>'+
       		'<Stoken>95E9DN4VXIA4</token>'+
            '<Samount_in_cents type="integer"></amount_in_cents>'+
            '<Smessage nil="true"/>'+
            '<Slink_url nil="true"/>'+
            '<Stype>transaction</type>'+
            '<Stransaction_type></transaction_type>'+
            '<Semail nil="true"/>'+
            '<Sstate>new</state>'+
            '<Stransaction_reference></transaction_reference>'+
            '<Sunique_reference nil="true"/>'+
            '<Sfrom_account></from_account>'+
            '<Sto_account></to_account>'+
            '<Sprocess_on type="date"></process_on>'+
            '<Sfrom_fund></from_fund>'+
       		'<Sto_fund></to_fund>'+
            '<Sfrom_fund_token></from_fund_token>'+
            '<Sto_fund_token></to_fund_token>'+
            '<Screated_by_user></created_by_user>'+
            '</transaction>';
    
    //direct_debit full response 
    public static String responseFullDirectDebit ='<transaction>'+
       		'<token>95E9DN4VXIA4</token>'+
            '<amount_in_cents type="integer">90000</amount_in_cents>'+
            '<message nil="true"/>'+
            '<link_url nil="true"/>'+
            '<type>transaction</type>'+
            '<transaction_type>direct_debit</transaction_type>'+
            '<email nil="true"/>'+
            '<state>new</state>'+
            '<transaction_reference>47651_Megasys</transaction_reference>'+
            '<unique_reference nil="true"/>'+
            '<from_account>Canaccede</from_account>'+
            '<to_account>INGEBORG APPEL</to_account>'+
            '<process_on type="date">2016-11-14</process_on>'+
            '<to_fund>TD Canada Trust</to_fund>'+
            '<from_fund_token>BA284MWF79TU</from_fund_token>'+
            '<created_by_user>yujpqgPa_vscKNcz8Gkf</created_by_user>'+
            '</transaction>';
    
}