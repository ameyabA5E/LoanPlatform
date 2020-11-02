/**************************************************************************************************
 *
 *  Class:   
 *
 *  @description : This is a testclass for PaymentCreateSchedule.
 *  @author : A5E Consulting
 *  @date : 02/27/2016
 *  
 
 *************************************************************************************************/
 
@isTest
public class TestPaymentCreateSchedule{
    
    public Static testMethod void testPaymentCreateSchedule(){
        
        Database.executeBatch(New PaymentCreateBatch());        
        PaymentCreateSchedule job = new PaymentCreateSchedule();        
        String sch = '0 0 23 * * ?'; 
        PaymentCreateSchedule.schedulerMethod();
        system.schedule('Test', sch, job); 
    }
}