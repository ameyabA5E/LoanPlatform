/**************************************************************************************************
 *
 *  Class:   
 *
 *  @description : This class will schedule the PaymentProcessingBatch 
 *  @author : A5E Consulting
 *  @date : 02/27/2017
 * 
 *************************************************************************************************/
public class PaymentProcessingSchedule implements Schedulable {
    
    //Execute Job Scheduled
    public void execute(SchedulableContext sc) {
          Database.executeBatch(New PaymentProcessingBatch(), 1);
    }
    
    //Run from test class
    Public static void schedulerMethod() {

          string timeinterval = '24 00 * * * ?';    
          System.schedule('Apex-EveryDay',timeinterval, new PaymentProcessingSchedule ());    
    }  
}