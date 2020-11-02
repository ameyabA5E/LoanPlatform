/**************************************************************************************************
 *
 *  Class:   
 *
 *  @description : This class will schedule the VersaPay Funding Batch 
 *  @author : A5E Consulting
 *  @date : 12/14/2016
 * 
 *************************************************************************************************/
public class VersaPayFundingSchedule implements Schedulable {
// this class 
 public String fundingBatchId;
    
    public VersaPayFundingSchedule (String fundingBatchId){
        this.fundingBatchId = fundingBatchId;
    }
    
    public void execute(SchedulableContext sc) {
    }

    //Execute Job Scheduled
   // public void execute(SchedulableContext sc) {
   //       Database.executeBatch(New VersaPayFundingBatch(fundingBatchId), 1);
   // }
    
    //Run from test class
    Public static void schedulerMethod() {

          string timeinterval = '24 00 * * * ?';    
          System.schedule('Apex-EveryDay',timeinterval, new VersaPayFundingSchedule('TestFundingBatchId'));    
    }  
}