/**************************************************************************************************
 *
 *  Class:   
 *
 *  @description : This is a testclass for PaymentProcessingSchedule.
 *  @author : A5E Consulting
 *  @date : 02/27/2016
 *  
 
 *************************************************************************************************/
 
@isTest
public class TestPaymentProcessingSchedule{
    
    public Static testMethod void testPaymentProcessingSchedule(){
        
        Database.executeBatch(New PaymentProcessingBatch());        
        PaymentProcessingSchedule job = new PaymentProcessingSchedule();        
        String sch = '0 0 23 * * ?'; 
        PaymentProcessingSchedule.schedulerMethod();
        system.schedule('Test', sch, job); 
    }
}