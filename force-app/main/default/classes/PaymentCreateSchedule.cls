/**************************************************************************************************
 *
 *  Class:   
 *
 *  @description : This class will schedule the PaymentCreateBatch 
 *  @author : A5E Consulting
 *  @date : 02/27/2017
 * 
 *************************************************************************************************/
public class PaymentCreateSchedule implements Schedulable {
    
    //Execute Job Scheduled
    public void execute(SchedulableContext sc) {
          Database.executeBatch(New PaymentCreateBatch());
    }
    
    //Run from test class
    Public static void schedulerMethod() {

          string timeinterval = '24 00 * * * ?';    
          System.schedule('Apex-EveryDay',timeinterval, new PaymentCreateSchedule());    
    }  
}