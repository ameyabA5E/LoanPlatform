/**************************************************************************************************
*
*  Class:   
*
*  @description :  Controller class for MegasysPaymentCSVRequest VF page.   
*  @author : A5E Consulting
*  @date : 17/11/2016   

*************************************************************************************************/
public Class MegasysPaymentController{

    public static Boolean messageFlag{get;set;}
    public static Boolean result{get;set;}
    public static Boolean sizeResult{get;set;}
    public MegasysPaymentController(){
        messageFlag=true;
    }
    
    //execute when Click on VFpage Button and create Export to MegaSys CSV File
    public static void runCSVJob(){
        
        messageFlag= false;
        result= false;
        //fetch All Eligible Versapay Product Payment Records
         List<VersaPay_Product_Payment__c> paymentSetupList = MegasysPaymentCSVUtil.fecthVersaPayProdPayment();
        
        if(paymentSetupList.size()!=0){
            sizeResult = false;
            //fetch All Eligible Versapay Product Payment Records
            String versaPayCSV = MegasysPaymentCSVUtil.createVersaPayCSV();
            
            //Create MegaSys Payment Update Record
            MegasysPaymentCSVUtil.createMegaSysPaymentRecord(versaPayCSV);
            
            //update Versapay Payment Setup records
            result = MegasysPaymentCSVUtil.updateVersaPayListRecords();
        }
        else{
            sizeResult = true;
        }
    }
}