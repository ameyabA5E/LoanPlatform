/**************************************************************************************************
 *
 *  Class:   
 *
 *  @description : This is a testclass.
 *  @author : A5E Consulting
 *  @date : 22/12/2016
 *  
 
 *************************************************************************************************/
 
@isTest
public class TestVersaPayFundingSchedule{

    public Static testMethod void versPayPaymentSetupJob(){
        
        
        Database.executeBatch(New VersaPayFundingBatch(''), 1);
        
        VersaPayFundingSchedule job=new VersaPayFundingSchedule('');
        
        String sch = '0 0 23 * * ?'; 
        VersaPayFundingSchedule.SchedulerMethod();
        system.schedule('Test', sch, job); 

    }
}