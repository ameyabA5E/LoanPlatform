/**************************************************************************************************
 *
 *  Class:   
 *
 *  @description : This class contains unit tests for validating behavior of DeleteCustomersController
 *  @author : A5E Consulting
 *  @date : 03/08/2016
 *
 *  Change History:
 *
 *  Developer       Date          Description
 *  ------------------------------------------------------------------------------------------------
 *
 *  A5E Consulting 03/08/2016     Initial Development
 
 *************************************************************************************************/
@isTest
public class TestDeleteCustomersController{
    
    static testmethod void testAuditLogCleaner(){   
        
        //Create Test Records        
        createCustomertWithNoApplicationNoProduct();
        createCustomertWithOneApplication(); 
        createCustomertWithOneProduct();
        createCustomertWithOneApplicationOneProduct();
                       
        //Records before cleanup
        List<Account> customersBefore = [Select id from Account];
        System.assertEquals(4,customersBefore.size());
        
        //Call Controller method
        DeleteCustomersController deleteCustomerCntrl = new DeleteCustomersController();
        deleteCustomerCntrl.deleteCustomers();
        
        //Verify Test results
        List<Account> customersAfter = [Select id from Account];
        System.assertEquals(3,customersAfter.size());        
    }
    
    
    public static void createCustomertWithOneApplication() { 
        Account acc = new Account(FirstName='Mark',LastName='Vanpee');
        insert acc;
        Application__c app = new Application__c(Name='AFITest1',Customer__C=acc.id);        
        insert app;

    }
    
    public static void createCustomertWithOneProduct() { 
        Account acc = new Account(FirstName='Akbar',LastName='Galmani');
        insert acc;        
        Product__c prod = new Product__c(Name='ProductTest1',Customer__C=acc.id);
        insert prod;
    }
    
    public static void createCustomertWithOneApplicationOneProduct() { 
        Account acc = new Account(FirstName='Ameya',LastName='Birje');
        insert acc;
        Application__c app = new Application__c(Name='AFITest2',Customer__C=acc.id);
        insert app;        
        Product__c prod = new Product__c(Name='ProductTest2',Customer__C=acc.id);
        insert prod;		
    }
    
    public static void createCustomertWithNoApplicationNoProduct() { 
        Account acc = new Account(FirstName='John',LastName='Sean');
        insert acc;     

    }   
}