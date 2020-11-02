/**************************************************************************************************
*
*  Trigger:   
*
*  @description : This is a Trigger Handler Class for Product__c object 
*  @author : A5E Consulting
*  @date : 10/06/2016
* 
*************************************************************************************************/

public class ProductTriggerHandler{
    
    //Line Break
    public static String lBrk = '</br>';
    
    public static boolean runProductTrigger = true; 
    
    public static Loan_ReEngineering__c lrpSetting = Loan_ReEngineering__c.getOrgDefaults();
    
    //Handle before insert
    public static void handleBeforeInsert(List<Product__c> prodNew) {
        System.debug('handleBeforeInsert isCanaccedeAPIUser :'+isCanaccedeAPIUser());       
        System.debug('lrpSetting.Run_Product_Before_Trigger__c  :'+lrpSetting.Run_Product_Before_Trigger__c);
        if(lrpSetting.Run_Product_Before_Trigger__c == true){
            if(isCanaccedeAPIUser() || Test.isRunningTest()){
                for(Product__c prod : prodNew){
                    
                    //Format Phone Numbers
                    System.debug('prod.Phone_Home__c before :'+prod.Phone_Home__c);
                    System.debug('prod.Phone_Other__c before :'+prod.Phone_Other__c);            
                    System.debug('prod.Phone_Work__c before :'+prod.Phone_Work__c);    
                    prod.Phone_Home__c = Utilities.formatPhone(prod.Phone_Home__c);
                    prod.Phone_Other__c = Utilities.formatPhone(prod.Phone_Other__c);
                    prod.Phone_Work__c = Utilities.formatPhone(prod.Phone_Work__c);
                    System.debug('prod.Phone_Home__c after :'+prod.Phone_Home__c);
                    System.debug('prod.Phone_Other__c after :'+prod.Phone_Other__c);            
                    System.debug('prod.Phone_Work__c after :'+prod.Phone_Work__c);    
                    
                    //Correct Requested Close Date
                    System.debug('prod.Requested_Close_Date__c before :'+prod.Requested_Close_Date__c);
                    if(prod.Requested_Close_Date__c != null){
                        prod.Requested_Close_Date__c = Utilities.rectifyRequestedCloseDate(prod.Requested_Close_Date__c);
                    }
                    System.debug('prod.Requested_Close_Date__c after :'+prod.Requested_Close_Date__c);   
                    
                    //Deliquency cycle and Deliquency days
                    calculateDeliquency(prod, null);        
                }
            }
        }
    }
    
    //Handle before update
    public static void handleBeforeUpdate(List<Product__c> prodNew, Map<Id, Product__c> oldMap) {
        
        System.debug('handleBeforeUpdate isCanaccedeAPIUser :'+isCanaccedeAPIUser());
        if(!isCanaccedeAPIUser() || Test.isRunningTest()){
            
            //Profile prfl = [Select Name from Profile where Id =: userinfo.getProfileid()];
            String profileName = Utilities.getUserProfile();
            
            //Non editable fields when Funding Type is Automated
            Map<String, String> uneditableFundTypeAutomatiedMap = getProductFieldsets('Funding Type Automatic Uneditable Fields');
            Set<String> uneditableFundTypeAutomatiedFields = uneditableFundTypeAutomatiedMap.keySet();
            system.debug('uneditableFundTypeAutomatiedFields Size : ' + uneditableFundTypeAutomatiedFields.size());
            
            //Non editable fields when Funding Type is Released
            Map<String, String> uneditableFundTypeReleasedMap = getProductFieldsets('Funding Type Released Uneditable fields');
            Set<String> uneditableFundTypeReleasedFields = uneditableFundTypeReleasedMap.keySet();
            system.debug('uneditableFundTypeReleasedFields Size : ' + uneditableFundTypeReleasedFields.size());
            
            //Non editable fields when Funding Status is Funded
            Map<String, String> uneditableFundStatFundedMap = getProductFieldsets('Funding Status Funded Uneditable fields');
            Set<String> uneditableFundStatFundedFields = uneditableFundStatFundedMap.keySet();
            system.debug('uneditableFundStatFundedFields Size : ' + uneditableFundStatFundedFields.size());
            
            //Fields not Editable - Funding Status = Pending, Profile = Loan Admin
            Map<String, String> uneditablePendingLAMap = getProductFieldsets('Uneditable_Fields_Pending_Loan_Admin');
            Set<String> uneditablePendingLAFields = uneditablePendingLAMap.keySet();
            
            //Fields not Editable - Funding Status = Released, Profile = Loan Admin
            Map<String, String> uneditableReleasedLAMap = getProductFieldsets('Uneditable_Fields_Released_Loan_Admin');
            Set<String> uneditableReleasedLAFields = uneditableReleasedLAMap.keySet();
            
            //Fields not Editable - Funding Status = Funded, Profile = Loan Admin
            Map<String, String> uneditableFundedLAMap = getProductFieldsets('Uneditable_Fields_Funded_Loan_Admin');
            Set<String> uneditableFundedLAFields = uneditableFundedLAMap.keySet();
            
            //Fields not Editable - Funding Status = Funding Failed, Profile = Loan Admin
            Map<String, String> uneditableFundFailLAMap = getProductFieldsets('Uneditable_Fields_FundFalied_Loan_Admin');
            Set<String> uneditableFundFailLAFields = uneditableFundFailLAMap.keySet();
            
            //Fields not Editable - Funding Status = Pending, Profile = CFG Admin
            Map<String, String> uneditablePendingCFGAMap = getProductFieldsets('Uneditable_Fields_Pending_CFG_Admin');
            Set<String> uneditablePendingCFGAFields = uneditablePendingCFGAMap.keySet();
            
            //Fields not Editable - Funding Status = Released, Profile = CFG Admin
            Map<String, String> uneditableReleasedCFGAMap = getProductFieldsets('Uneditable_Fields_Released_CFG_Admin');
            Set<String> uneditableReleasedCFGAFields = uneditableReleasedCFGAMap.keySet();
            
            //Fields not Editable - Funding Status = Funded, Profile = CFG Admin
            Map<String, String> uneditableFundedCFGAMap = getProductFieldsets('Uneditable_Fields_Funded_CFG_Admin');
            Set<String> uneditableFundedCFGAFields = uneditableFundedCFGAMap.keySet();
            
            //Fields not Editable - Funding Status = Funding Failed, Profile = CFG Admin
            Map<String, String> uneditableFundFailCFGAMap = getProductFieldsets('Uneditable_Fields_FundFailed_CFG_Admin');
            Set<String> uneditableFundFailCFGAFields = uneditableFundFailCFGAMap.keySet();
            
            for(Product__c prod : prodNew){
                
                system.debug('in loop');
                //Validation Error message
                String valMsg = '';
                
                //Old Product values
                Product__c prodOld = oldMap.get(prod.id);
                
                if(lrpSetting.Run_Product_Validation_Trigger__c == true){
                    //to avoid changing fields after status is Released Batch
                    if('Released Batch' == prodOld.Funding_Status__c){
                        valMsg = valMsg + 'You cannot change Fields as Funding Status is \'Released Batch\''+  lBrk;
                    }
                    
                    /*system.debug('Funding type : ' + prodOld.Funding_Type__c);
                    if('Automated' == prodOld.Funding_Type__c){
                        
                        for(String uneditableFieldName : uneditableFundTypeAutomatiedFields){
                            system.debug('Field Name : ' + uneditableFieldName);
                            if(prod.get(uneditableFieldName) != prodOld.get(uneditableFieldName)){
                                 valMsg = valMsg + 'You cannot change :'+ uneditableFundTypeAutomatiedMap.get(uneditableFieldName) + ' as Funding Type is Automated' +  lBrk;    
                            }
                        }
                    }
                    
                    if('Released' == prodOld.Funding_Type__c){
                        for(String uneditableFieldName : uneditableFundTypeReleasedFields){
                            if(prod.get(uneditableFieldName) != prodOld.get(uneditableFieldName)){
                                 valMsg = valMsg + 'You cannot change :'+ uneditableFundTypeReleasedMap.get(uneditableFieldName) + ' as Funding Type is Released' +  lBrk;    
                            }
                        }
                    }
                    
                    system.debug('Funding status : ' + prodOld.Funding_Status__c);
                    if('Funded' == prodOld.Funding_Status__c){
                        for(String uneditableFieldName : uneditableFundStatFundedFields){
                            if(prod.get(uneditableFieldName) != prodOld.get(uneditableFieldName)){
                                 valMsg = valMsg + 'You cannot change :'+ uneditableFundStatFundedMap.get(uneditableFieldName) + ' as Funding Status is Funded' +  lBrk;    
                            }
                        }
                    }*/
                    
                    if(profileName == 'CFG - Loan Administrator'){
                        if('Pending' == prodOld.Funding_Status__c){
                            for(String uneditableFieldName : uneditablePendingLAFields){
                                if(prod.get(uneditableFieldName) != prodOld.get(uneditableFieldName)){
                                     valMsg = valMsg + 'You cannot change :'+ uneditablePendingLAMap.get(uneditableFieldName) + ' as Funding Status is Pending' +  lBrk;    
                                }
                            }
                        }
                        
                        if('Funded' == prodOld.Funding_Status__c){
                            for(String uneditableFieldName : uneditableFundedLAFields){
                                if(prod.get(uneditableFieldName) != prodOld.get(uneditableFieldName)){
                                     valMsg = valMsg + 'You cannot change :'+ uneditableFundedLAMap.get(uneditableFieldName) + ' as Funding Status is Funded' +  lBrk;    
                                }
                            }
                        }
                        
                        if('Funding Failed' == prodOld.Funding_Status__c){
                            for(String uneditableFieldName : uneditableFundFailLAFields){
                                if(prod.get(uneditableFieldName) != prodOld.get(uneditableFieldName)){
                                     valMsg = valMsg + 'You cannot change :'+ uneditableFundFailLAMap.get(uneditableFieldName) + ' as Funding Status is Funding Failed' +  lBrk;    
                                }
                            }
                        }
                        
                        if('Released' == prodOld.Funding_Status__c){
                            for(String uneditableFieldName : uneditableReleasedLAFields){
                                if(prod.get(uneditableFieldName) != prodOld.get(uneditableFieldName)){
                                     valMsg = valMsg + 'You cannot change :'+ uneditableReleasedLAMap.get(uneditableFieldName) + ' as Funding Status is Released' +  lBrk;    
                                }
                            }
                        }
                    }
                    
                    if(profileName == 'CFG - Application Admin'){
                        if('Pending' == prodOld.Funding_Status__c){
                            for(String uneditableFieldName : uneditablePendingCFGAFields){
                                if(prod.get(uneditableFieldName) != prodOld.get(uneditableFieldName)){
                                     valMsg = valMsg + 'You cannot change :'+ uneditablePendingCFGAMap.get(uneditableFieldName) + ' as Funding Status is Pending' +  lBrk;    
                                }
                            }
                        }
                        
                        if('Funded' == prodOld.Funding_Status__c){
                            for(String uneditableFieldName : uneditableFundedCFGAFields){
                                if(prod.get(uneditableFieldName) != prodOld.get(uneditableFieldName)){
                                     valMsg = valMsg + 'You cannot change :'+ uneditableFundedCFGAMap.get(uneditableFieldName) + ' as Funding Status is Funded' +  lBrk;    
                                }
                            }
                        }
                        
                        if('Funding Failed' == prodOld.Funding_Status__c){
                            for(String uneditableFieldName : uneditableFundFailCFGAFields){
                                if(prod.get(uneditableFieldName) != prodOld.get(uneditableFieldName)){
                                     valMsg = valMsg + 'You cannot change :'+ uneditableFundFailCFGAMap.get(uneditableFieldName) + ' as Funding Status is Funding Failed' +  lBrk;    
                                }
                            }
                        }
                        
                        if('Released' == prodOld.Funding_Status__c){
                            for(String uneditableFieldName : uneditableReleasedCFGAFields){
                                if(prod.get(uneditableFieldName) != prodOld.get(uneditableFieldName)){
                                     valMsg = valMsg + 'You cannot change :'+ uneditableReleasedCFGAMap.get(uneditableFieldName) + ' as Funding Status is Released' +  lBrk;    
                                }
                            }
                        }
                    }
                }
                //Final validation error message    
                if(String.isNotBlank(valMsg)){
                    valMsg = ' Check below Validation Messages' + lBrk + valMsg;
                    prod.addError(valMsg, false);
                }
            }
        }
        
        if (isCanaccedeAPIUser() || Test.isRunningTest()){
        System.debug('lrpSetting.Run_Product_Before_Trigger__c  :'+lrpSetting.Run_Product_Before_Trigger__c);
            if(lrpSetting.Run_Product_Before_Trigger__c == true){
                
                //As per Mark, update all the fields to null in Salesforce if corresponding field in Megasys/FDR csv file is blank.
                //Commenting the whole logic
                //All Product Fields
                /*
                Map<String, Schema.SObjectField> prdFieldsMap = Schema.SObjectType.Product__c.fields.getMap(); 
                Set<String> prdFields = prdFieldsMap.keySet();
                */
                
                //Nullify Product Fields
                /*            
                Map<String, String> nullifyFieldsMap = getProductFieldsets('Nullify Fields');
                Set<String> nullifyFields = nullifyFieldsMap.keySet();
                system.debug('nullifyFields Size : ' + nullifyFields.size());
                
                Set<String> nullifyFieldsLower = new Set<String>();
                if(nullifyFields!=null && nullifyFields.size() > 0){
                    for(String nullifyField : nullifyFields){
                        nullifyFieldsLower.add(nullifyField.toLowerCase());                 
                    }
                }
                */
                
                for(Product__c prod : prodNew){
                    
                    //Old Product values
                    Product__c prodOld = oldMap.get(prod.id);
                    
                    //Fields need to / not need to make null
                    /*
                    for(String prdField : prdFields){
                        System.debug('prdField :'+prdField);
                        System.debug('prod.get(prdField) :'+prod.get(prdField));
                        System.debug('prodOld.get(prdField) :'+prodOld.get(prdField));
                        if(prod.get(prdField) != prodOld.get(prdField)){
                            
                            if(prod.get(prdField) == null){
                                System.debug('nullifyFields.contains(prdField) :'+nullifyFields.contains(prdField));                         
                                if(!nullifyFieldsLower.contains(prdField.toLowerCase())){
                                    prod.put(prdField, prodOld.get(prdField));                                
                                    System.debug('prodOld.get(prdField) final :'+prodOld.get(prdField));
                                }
                            }       
                        }
                    }
                    */
                    
                    //Phone number formatting 
                    System.debug('prod.Phone_Home__c before :'+prod.Phone_Home__c);
                    System.debug('prod.Phone_Other__c before :'+prod.Phone_Other__c);            
                    System.debug('prod.Phone_Work__c before :'+prod.Phone_Work__c);
                    prod.Phone_Home__c = Utilities.formatPhone(prod.Phone_Home__c);
                    prod.Phone_Other__c = Utilities.formatPhone(prod.Phone_Other__c);
                    prod.Phone_Work__c = Utilities.formatPhone(prod.Phone_Work__c);
                    System.debug('prod.Phone_Home__c after :'+prod.Phone_Home__c);
                    System.debug('prod.Phone_Other__c after :'+prod.Phone_Other__c);            
                    System.debug('prod.Phone_Work__c after :'+prod.Phone_Work__c);    
                    
                    //Correct Requested Close Date, not needed for update
                    /*
                    System.debug('prod.Requested_Close_Date__c before :'+prod.Requested_Close_Date__c);
                    if(prod.Requested_Close_Date__c != null){
                        prod.Requested_Close_Date__c = Utilities.rectifyRequestedCloseDate(prod.Requested_Close_Date__c);
                    }
                    System.debug('prod.Requested_Close_Date__c after :'+prod.Requested_Close_Date__c);
                    */     
                    
                    //Deliquency cycle and Deliquency days
                    calculateDeliquency(prod, prodOld);  
                }
            }
        }
    }

    //Stored  Field Name and Labels of Product__c FieldSet
    public static Map<String, String> fieldSetLabelNameMap = getProductFieldsets('Update Customer Fields');
    
    //Map Customer Id with list of FDR, Megasys Products, used to check if any existing product presence for Customer 
    public static Map<Id, List<Product__c>> customerWithOldProductsMap = new Map<Id, List<Product__c>>();   
    
    // This is used whle creating task to get info about Customer, and also used to update Customer Address field
    public static Map<Id, Account> existingCustomer; 

    //List of Customers which has Address field updates                                                      
    public static List<Account> customersToUpdate;    
    
    // List of customer Id's used to fetch related Customer data, also used to fetch existing Tasks related to this Customers                                    
    public static List<Id> customerIds = new List<Id>();                                                    
    
    // This gives exising active Task that has been created before for a Customer stating product updaes    
    public static Map<Id, Task> activeAddressChangedTask = new Map<Id, Task>();                         

    // Used to store all new Tasks creating to notify CSR about Customer address field changes        
    public static List<Task> tasksList;    
                                           
    // Group Id of CSR Role users, used to assign new Tasks
    // public static Id CSRGroupId = [SELECT Id FROM GROUP WHERE Name='CSR Role Users Group' LIMIT 1].Id;
    
    public static Set<Id> customersLockedForUpdate ;             
    
    public static void handleAferInsertUpdate(List<Product__c> prodNew, Map<Id, Product__c> oldMap, Boolean isInsert) {
        
        if(lrpSetting.Load_Customer_Data__c == true){
            // User verification to update Customer Address Fields
            if(isCanaccedeAPIUser() || Test.isRunningTest()){
                
                customersLockedForUpdate = new Set<Id>();
                tasksList = new List<Task>();
                customersToUpdate = new List<Account>();
                
                //Process all new instance of Products in context
                for(Product__c prod : prodNew){
                    customerIds.add(prod.Customer__c);
                }
                existingCustomer = new Map<Id, Account>([SELECT Id, OwnerId, PersonMailingCity, PersonMailingStreet, PersonMailingPostalCode, PersonMailingState, PersonBirthdate, PersonHomePhone, Work_Phone__pc, PersonOtherPhone, Address_Last_Changed_Date__c, FirstName, LastName FROM Account WHERE Id IN : customerIds]);
                
                //Fetching all Active Tasks of Customers in current context
                for(Task tsk : [SELECT WhatId, Subject, Status FROM Task WHERE Subject = 'Address Changed' AND Status != 'Completed' AND WhatId IN : customerIds]){
                    activeAddressChangedTask.put(tsk.WhatId, tsk);
                }
                
                //Fetching all Active Products of Customers
                for(Product__c customerOldProduct : [SELECT First_Name__c, Last_Name__c, Customer__c FROM Product__c WHERE ((Source_System__c ='FDR' AND External_Status_Current__c = null AND Closed_Date__c = null) OR (Source_System__c = 'Megasys' AND Internal_Status__c='Active' AND Closed_Date__c = null)) AND Customer__c IN: customerIds]){
                    List<Product__c> tempProdList = new List<Product__c>();
                    if(customerWithOldProductsMap.containsKey(customerOldProduct.Customer__c)){
                        tempProdList = customerWithOldProductsMap.get(customerOldProduct.Customer__c);
                    }
                    tempProdList.add(customerOldProduct);
                    customerWithOldProductsMap.put(customerOldProduct.Customer__c, tempProdList);
                }
                
                for(Product__c prod : prodNew){
                    // If FDR or Megasys product is Active or Not
                    if(isActiveSORProduct(prod)){ 
                        
                        system.debug('Active verified');
                        if((isInsert) || (!isInsert && hasProductCustomerDataChanged(prod, oldMap.get(prod.Id)))){
                            
                            //If any existing Products, more than 1
                            if (getNumberOfActiveSORProducts(prod.Customer__c) > 1){ 
                                
                                // Address fields are changed
                                if(!hasActiveAddressChangedTask(prod)){ 
                                    system.debug('no active task ');
                                    
                                    // Address fields values from Product is different Customer Address fields values
                                    if(needtoUpdateCustomer(prod)){ 
                                        system.debug('accotun fields diff from prod verified');
                                        
                                        // Update Customer Address fields
                                        updateCustomerFromProduct(prod); 
                                        
                                        // Create Task for CSR Role users
                                        createAddressChangedTask(prod); 
                                        
                                    }   
                                } 
                            }
                            //Only one active SOR Products
                            else{ 
                                system.debug('has no exisinting prod verified');
                                if(needtoUpdateCustomer(prod)){                            
                                    updateCustomerFromProduct(prod);    
                                }                                                               
                            }
                        }
                    }
                }
                
                if(!customersToUpdate.isEmpty()){
                    // Updating Customers Address
                    update customersToUpdate;
                }   
                    
                if(!tasksList.isEmpty()){
                    // Inserting Tasks for CSR Role Group
                    insert tasksList;
                    system.debug('Task Created == '+tasksList);
                }           
            }
        }                   
    }

    // Validates if there is any existing Active Tasks for Customer
    public static Boolean hasActiveAddressChangedTask(Product__c currentProd){
        system.debug('---'+currentProd.Customer__c);
        system.debug('==='+activeAddressChangedTask);
        if(activeAddressChangedTask.containsKey(currentProd.Customer__c)){
            return true;
        }
        return false;
    }

    // Creating Tasks with Customer Name, to notify CSR's about address change
    public static void createAddressChangedTask(Product__c currentProd){
        Account customer = existingCustomer.get(currentProd.Customer__c);
        Task tsk = new Task();
        tsk.WhatId = currentProd.Customer__c;
        tsk.subject = 'Address Changed';
        tsk.OwnerId= UserInfo.getUserId();
        tsk.Description  = 'This customer was updated by ' + currentProd.Name + ' from ' + currentProd.Source_System__C + '.';
        tasksList.add(tsk);
    }

    //Updating Customer Address fields
    public static void updateCustomerFromProduct(Product__c currentProd){
        Account customer = existingCustomer.get(currentProd.Customer__c);
        customer.PersonMailingCity = currentProd.City__c;
        if(String.isBlank(currentProd.Address_Line2__c)){
            customer.PersonMailingStreet = currentProd.Address_Line1__c;
        }else{
            customer.PersonMailingStreet = currentProd.Address_Line1__c + ' ' + currentProd.Address_Line2__c;
        }
        customer.PersonMailingPostalCode = currentProd.Zip_Code__c;
        customer.PersonMailingState = currentProd.State__c;
        customer.PersonBirthdate = currentProd.Date_of_Birth__c;
        customer.PersonHomePhone = currentProd.Phone_Home__c;
        customer.Work_Phone__pc = currentProd.Phone_Work__c;
        customer.PersonOtherPhone = currentProd.Phone_Other__c;
        customer.FirstName = currentProd.First_Name__c;
        customer.LastName = currentProd.Last_Name__c;
        
        customer.Address_Last_Changed_Date__c = currentProd.Address_Last_Changed_Date__c;
        
        if(!customersLockedForUpdate.contains(currentProd.Customer__c)){
            customersToUpdate.add(customer);
        }
            
        customersLockedForUpdate.add(currentProd.Customer__c) ;
    }

    // Method that fetches the Customer record using customer record id
    public static Account getCustomerRecord(Id customerId){
        return existingCustomer.get(customerId);
    }

    // Verifying Product fields against Customer Address fields
    public static Boolean needtoUpdateCustomer(Product__c currentProd){
        Boolean needToUpdate = false;
        Account customer = getCustomerRecord(currentProd.Customer__c);
        if(customer.PersonMailingCity != currentProd.City__c){
            needToUpdate = true;
        }
        //else if((currentProd.Address_Line1__c != null && (customer.PersonMailingStreet).contains(currentProd.Address_Line1__c)) && (currentProd.Address_Line2__c != null && (customer.PersonMailingStreet).contains(currentProd.Address_Line2__c))){
        else if((String.isBlank(customer.PersonMailingStreet)&&((String.isNotBlank(currentProd.Address_Line1__c))||(String.isNotBlank(currentProd.Address_Line2__c)))) 
            || 
            (
                (String.isNotBlank(customer.PersonMailingStreet) && String.isNotBlank(currentProd.Address_Line1__c) && (!(customer.PersonMailingStreet).contains(currentProd.Address_Line1__c)))
                ||
                (String.isNotBlank(customer.PersonMailingStreet) && String.isNotBlank(currentProd.Address_Line2__c) && (!(customer.PersonMailingStreet).contains(currentProd.Address_Line2__c)))
            )
        ){
            needToUpdate = true;
        }
        else if(customer.PersonMailingPostalCode != currentProd.Zip_Code__c){
            needToUpdate = true;
        }
        else if(customer.PersonMailingState != currentProd.State__c){
            needToUpdate = true;
        }
        else if(customer.PersonBirthdate != currentProd.Date_of_Birth__c){
            needToUpdate = true;
        }
        else if(customer.PersonHomePhone != currentProd.Phone_Home__c){
            needToUpdate = true;
        }
        else if(customer.Work_Phone__pc != currentProd.Phone_Work__c){
            needToUpdate = true;
        }
        else if(customer.PersonOtherPhone != currentProd.Phone_Other__c){
            needToUpdate = true;
        }
        //else if(customer.Address_Last_Changed_Date__c != currentProd.Address_Last_Changed_Date__c){
            //needToUpdate = true;
        //} //TO DO Feild is not there under Account
        else if(customer.FirstName != currentProd.First_Name__c){
            needToUpdate = true;
        }
        else if(customer.LastName != currentProd.Last_Name__c){
            needToUpdate = true;
        }
        return needToUpdate;
    }

    //Return count of total Active FDR, Megasys Products using Customer record Id
    public static Integer getNumberOfActiveSORProducts(Id customerId){
        system.debug('Customer Id = '+customerId);
        system.debug('Customer old prod = '+customerWithOldProductsMap);
        return customerWithOldProductsMap.get(customerId).size();
    }

    // Checks against Old Address values and New Address values of Product
    public static Boolean hasProductCustomerDataChanged(Product__c newProd, Product__c oldProd){
        Boolean isChanged = false;
        for(String fieldName : fieldSetLabelNameMap.keySet()){
            if(newProd.get(fieldName) != oldProd.get(fieldName)){
                return true;
            }
        }
        return isChanged;
    }

    //Checkes whether the Product is Active or not using Product record
    public static Boolean isActiveSORProduct(Product__c prod){
        if((prod.Source_System__c =='FDR' && prod.External_Status_Current__c == null && prod.Closed_Date__c == null) || (prod.Source_System__c =='Megasys' && prod.Internal_Status__c=='Active' && prod.Closed_Date__c == null)){
            return true;
        }
        return false;
    }
    
    //Checkes whether the Megasys Product is Active or not
    public static Boolean isActiveMSProduct(Product__c prod){
        return (prod.Internal_Status__c == 'Active' && prod.Closed_Date__c == null);    
    }  
    
    //Deliquency cycle and Deliquency days
    public static void calculateDeliquency(Product__c prod, Product__c prodOld){
        
        System.debug('prod.recordTypeId :'+prod.recordTypeId);
        if(prod.recordTypeId != null){
            
            String recordTypeDevName = Utilities.getProdRecorTypeName(prod.recordTypeId);
            System.debug('recordTypeDevName :'+recordTypeDevName);
            
            if(String.isNotBlank(recordTypeDevName)){
                if(recordTypeDevName.equalsIgnoreCase('Loan_Account')){
                    System.debug('isActiveMSProduct(prod) :'+isActiveMSProduct(prod));
                    System.debug('prod.Payment_Due_Date__c :'+prod.Payment_Due_Date__c);
                    if(isActiveMSProduct(prod)){
                        if(prod.Payment_Due_Date__c !=null){
                            prod.Delinquency_Days__c = Utilities.getNumberOfDaysDelinquent(prod.Payment_Due_Date__c);
                            prod.Delinquency_Cycles__c = Utilities.getNumberOfCyclesDelinquent(prod.Delinquency_Days__c);
                        }
                        else{
                            if(prodOld != null){
                                prod.Delinquency_Days__c = prodOld.Delinquency_Days__c;
                                prod.Delinquency_Cycles__c = prodOld.Delinquency_Cycles__c; 
                            }                           
                        }                                   
                    }
                    else{
                        prod.Delinquency_Days__c = null;
                        prod.Delinquency_Cycles__c = null;                                  
                    }
                }
            }
        } 
    }
    
    // Validating current context user
    public static Boolean isCanaccedeAPIUser(){
        String uName = userInfo.getUserName();
        System.debug('uName :'+uName);
        if(uName.equalsIgnoreCase(lrpSetting.Canaccede_API_User__c)){
            return true;
        }
        return false;
    }

    //Returns all application object field sets 
    public static Map<String, String> getProductFieldsets(string fieldSetLabel){
        
        system.debug('In fieldset function');
        Map<String, String> fieldsNameLabel = new Map<String, String>();
        
        Map<String, Schema.FieldSet> productFieldsSets = Schema.SObjectType.Product__c.fieldSets.getMap();
        
        List<Schema.FieldSet> listProductFieldSets = productFieldsSets.values();
        
        system.debug('list of fields in fieldset' + listProductFieldSets);
        for(Schema.FieldSet productFieldSet : listProductFieldSets){
            
            system.debug('fieldSetLabel :' +fieldSetLabel );
            system.debug('productFieldSet.getLabel() : ' + productFieldSet.getLabel());
            if(fieldSetLabel == productFieldSet.getLabel()){
                
                for(Schema.FieldSetMember field : productFieldSet.getFields()) {    
                    fieldsNameLabel.put(field.getFieldPath(), field.getLabel());
                }               
                break;
            }
        }
        
        return fieldsNameLabel;    
    }
}