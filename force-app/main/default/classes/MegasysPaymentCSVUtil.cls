/**************************************************************************************************
*
*  Class:   
*
*  @description :  MegasysPaymentCSVUtil: Utility class for creating CSV file.   
*  @author : A5E Consulting
*  @date : 14/11/2016   

*************************************************************************************************/
public Class MegasysPaymentCSVUtil{
    
    private static final String VERSAPAY_STATE = 'Completed';
    static List<VersaPay_Product_Payment__c> paymentSetupList;
    
    //Get Loan ReEngineering Custom Setting Record
    private static Loan_ReEngineering__c megaSysCS = Loan_ReEngineering__c.getOrgDefaults();
    
    //fetch All Eligible Versapay Product Payment Records for MegaSys
    public static List<VersaPay_Product_Payment__c> fecthVersaPayProdPayment(){
       
        paymentSetupList = [SELECT Id, Name, Product__r.Name, Product__r.PAP_Account_Number__c, 
        							Process_On__c,Payment_Posted_To_VersaPay_On__c, createdDate, 
                         			VersaPay_Token_Number__c, Payment_Amount__c     
                         			From VersaPay_Product_Payment__c 
                         			WHERE VersaPay_State__c=:VERSAPAY_STATE AND Posted_To_MegaSys__c =false
                         			AND Product__C != null];
        System.debug('paymentSetupList=='+paymentSetupList);
        return paymentSetupList;                                                                   
    }
    
    //fetch All Eligible Versapay Product Payment Records
    public static String createVersaPayCSV(){
        
        String finalversaPayCSV = '';
        String codeValue = '';
        
        
        for(VersaPay_Product_Payment__c verProPay : paymentSetupList){
        	System.debug('verProPay=='+verProPay);
        	
        	String paymentDate='';
	        if (verProPay.Process_On__c != null){
	        	paymentDate = convertDateToString(verProPay.Process_On__c);
	        }
	        else if (verProPay.Payment_Posted_To_VersaPay_On__c != null){
	        	paymentDate = convertDateToString(verProPay.Payment_Posted_To_VersaPay_On__c);
	        }  
	        else{
	        	paymentDate = convertDateToString(verProPay.createdDate);
	        } 
	         
            String versaPayCSV = checkComma(verProPay.Product__r.Name) + ',' //checkComma(verProPay.Product__r.PAP_Account_Number__c) + ',' 
                          + checkComma(String.valueOf(verProPay.Payment_Amount__c)) +','
                          //+ checkComma(convertDateToString(verProPay.Payment_Posted_To_VersaPay_On__c)) +',' 
                          //+ checkComma((verProPay.Process_On__c.format())) +','
                          + checkComma(paymentDate) +','
                          + checkComma(verProPay.VersaPay_Token_Number__c) +',' 
                          + checkComma(megaSysCS.Megasys_Default_Fund_Code__c) +','
                          + '' +''
                          + '\n'; 
            
            if(String.isNotBlank(versaPayCSV)){
                finalversaPayCSV += versaPayCSV;
            }              
        }
        
        return finalversaPayCSV;
    
    }
    
    //Create MegaSys Payment Update Record
    public static void createMegaSysPaymentRecord(String versaPayCSV){
        
        //TCIRecord
        MegaSys_Payments__c megaSysJobRecord = new MegaSys_Payments__c();
        megaSysJobRecord.No_Of_Records_Processed__c = paymentSetupList.Size();
        insert megaSysJobRecord;
        
        //MegaSys CSV Attachment
        Attachment attch = new Attachment();
        attch.Body = Blob.valueOf(versaPayCSV);
        attch.Name = 'MegaSys-Payment-CSV-' + convertDateToString(system.Now()) + '.csv';
        attch.ParentId = megaSysJobRecord.ID ; 
        insert attch;
    }
    
    //update Versapay Payment Setup records and return result
    public static Boolean updateVersaPayListRecords(){
        
        List<VersaPay_Product_Payment__c> paymentSetupUpdateList = New List<VersaPay_Product_Payment__c>();
        for(VersaPay_Product_Payment__c prodPay : paymentSetupList){
            
            prodPay.MegaSys_Export_Date__c = System.Now();
            prodPay.Posted_To_MegaSys__c = true;    
            paymentSetupUpdateList.add(prodPay);
        }
        
        update paymentSetupUpdateList;
        return true;
    }
    
    //Convert Date to String
    @testvisible
    private static String convertDateToString(DateTime dt){
        if(dt != null){
            //Date dte = dt.Date();
            //return String.valueof(dte.month()+'/'+dte.day()+'/'+dte.year());
            return (dt.formatGMT('MM/dd/yyyy'));
        }
        else{
            return '';
        }
    }
    
    //if value contains comma',' , append quote in trailing and heading
    @testvisible
    private static String checkComma(String str){

        if(String.isNotBlank(str) && str.contains(',')){
                return +' \"'+str+'\" ';
        }
        else{
            return str;
        }
    }
}