/**************************************************************************************************
 *
 *  Class:   
 *
 *  @description : This class is responsible for cleaning of Customer records 
 *  @author : A5E Consulting
 *  @date : 02/24/2016
 *
 *  Change History:
 *
 *  Developer       Date          Description
 *  ------------------------------------------------------------------------------------------------
 *
 *  A5E Consulting 02/24/2016     Initial Development
 
 *************************************************************************************************/
public class DeleteCustomersController {
	
    // Get Set methods for message Flag 
    public Boolean messageFlag{ get; set ; }

    public DeleteCustomersController (){
    	messageFlag = false;
    }
	
	// Delete the Customers which don't have APPLICATION & PRODUCT                                     
    public void deleteCustomers(){
    	
    	List<Account> CustomersList= new List<Account>();    
        
        try{
            //Step for Retriving the Customers List usinfg SOQL &
          delete  [Select Id from Account where Id NOT In (Select Customer__c from Application__C) and id not in ( Select Customer__c from Product__c)];           
          messageFlag = true;          
        }
        catch(Exception e){
            messageFlag=false;
        } 
    }
}