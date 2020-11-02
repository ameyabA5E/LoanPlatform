/**************************************************************************************************
*
*  Class:   
*
*  @description : This is a controller class to release Funding Batches
*  @author : A5E Consulting
*  @date : 06/22/2016
*
*  Change History:
*
*  Developer       Date          Description
*  ------------------------------------------------------------------------------------------------
*
*  A5E Consulting 06/22/2016     Class created * 
*************************************************************************************************/

public with sharing class FundingBatchController{
    public List<LoanUtility.ProductGroupWrapper> productWrapperGroup{get; set;}
    public List<LoanUtility.ProductListWrapper> listProductWrapper;
    public Boolean readableCheck{get;set;}
    public List<Product__c> listProd;
    public static Boolean saveAsText = false;
    public static Boolean selectAll{get;set;}
    
    //Summary fields
    public Integer noOfAccountsSelected{get;set;}
    public Decimal totalAutomatedFundingAmount{get;set;}
    public Decimal totalManualFundingAmount{get;set;}
    public String batchFundingStatus{get;set;}
    public String fundReleaseDate{get;set;}
    public String bankConfirmationNumber{get;set;}
    Loan_ReEngineering__c loanSettings;
    
    public FundingBatchController(){
        
    }
    
    public FundingBatchController(ApexPages.StandardController controller) {
        
        selectAll = true;
        String fundingBatchId = ApexPages.currentPage().getParameters().get('id');
        loanSettings = Loan_ReEngineering__c.getOrgDefaults();
        if (String.isNotBlank(fundingBatchId)) {
            readableCheck = false;
            
            List<Funding_Batch__c> fundingBatches = [select Id, Status__c, Total_Funding_Amount__c, Released_Date__c
                                                     from Funding_Batch__c where id=:fundingBatchId]; 
            if(!fundingBatches.isEmpty()){
                
                batchFundingStatus = fundingBatches.get(0).Status__c;
                fundReleaseDate = convertDateToString(fundingBatches.get(0).Released_Date__c.date());
                listProd = [select id, name, Product_Status__c, customer__r.name, customer__r.id, Funding_Amount__c, Loan_Process_Type__c,
                            Funding_Type__c, Funding_Status__c, Funding_Date__c, Regular_Payment_Amount__c, createdDate, //SOR_Account_Number__c,
                            Customer__r.LastName, Customer__r.FirstName, Customer__r.Customer_ID__c, Disbursement_Amount__c //, SOR_External_ID__c
                            from Product__c 
                            where Funding_Batch__c=:fundingBatches.get(0).Id 
                            order by Funding_Date__c desc];  
            } 
        }
        
        else{

            
            batchFundingStatus = 'Pending Review';
            readableCheck = true;
            listProd = [select id, name, Product_Status__c, customer__r.name, customer__r.id, Funding_Amount__c, Loan_Process_Type__c,
                        Funding_Type__c, Funding_Status__c, Funding_Date__c, First_Payment_Date__c, //SOR_Account_Number__c,
                        Regular_Payment_Amount__c, PAP_Account_Number__c, PAP_Transit_Code__c, PAP_Bank_Code__c,
                        Customer__r.LastName, Customer__r.FirstName, Customer__r.Middle_Name__pc, Customer__r.Customer_ID__c, Disbursement_Amount__c //, SOR_External_ID__c
                        from Product__c 
                        where Funding_Status__c = 'Pending'
                        and Funding_Batch__c = null
                        //and Funding_Type__c = 'Automated'
                        and Product_Status__c <> null and Funding_Amount__c <> null and Loan_Process_Type__c <> null and 
                        Funding_Type__c <> null and First_Payment_Date__c <> null
                        and Funding_Date__c <> null and Loan_Type__c='Affirm Financial Term Loan' AND Disbursement_Amount__c <> null
                        AND PAP_Account_Number__c <> null AND PAP_Transit_Code__c <> null AND PAP_Bank_Code__c <> null
                        order by Funding_Date__c desc];
            
            //}           
        }
        
        
        listProductWrapper = new List<LoanUtility.ProductListWrapper>();
        
        
        noOfAccountsSelected = 0;
        totalAutomatedFundingAmount = 0;
        totalManualFundingAmount = 0;
        bankConfirmationNumber = '';
        
        
        LoanUtility.ProductListWrapper prod;
        
        for(Product__c p : listprod){
            prod = new LoanUtility.ProductListWrapper();
            prod.product = p;
            listProductWrapper.add(prod);
        }
    }
    
    public PageReference reCalculate(){
        productWrapperGroup = new List<LoanUtility.ProductGroupWrapper>();
        
        LoanUtility.ProductGroupWrapper prodGroup;
        Boolean flag;
        noOfAccountsSelected = 0;
        totalAutomatedFundingAmount = 0;
        totalManualFundingAmount = 0;
        
        for(LoanUtility.ProductListWrapper plw : listProductWrapper){
            flag = false;
            for(LoanUtility.ProductGroupWrapper pgw : productWrapperGroup){
                if(convertDateToString(plw.product.Funding_Date__c) == pgw.groupDate){
                    pgw.productList.add(plw);
                    if(plw.check){
                        pgw.totalFundingAmount += plw.product.Disbursement_Amount__c;
                    }
                    flag = true;
                    break;
                }
            }
            if(!flag){
                prodGroup = new LoanUtility.ProductGroupWrapper();
                prodGroup.groupDate = convertDateToString(plw.product.Funding_Date__c);
                if(plw.check){
                    prodGroup.totalFundingAmount = plw.product.Disbursement_Amount__c;
                }
                prodGroup.productList.add(plw);
                productWrapperGroup.add(prodGroup);
            }
            
            if(plw.check){
                noOfAccountsSelected++;
                if(plw.product.Funding_Type__c == 'Manual'){
                    totalManualFundingAmount += plw.product.Disbursement_Amount__c;
                }else if(plw.product.Funding_Type__c == 'Automated'){
                    totalAutomatedFundingAmount += plw.product.Disbursement_Amount__c;
                }
            }
        }
        
        return null;
    }
    
    private String convertDateToString(DateTime d){
        return datetime.newInstance(d.year(), d.month(),d.day()).format('dd/MM/yyyy');
    }
    
    public PageReference releaseFund(){
        
        try{
            List<LoanUtility.ProductGroupWrapper> testProdWrp = new List<LoanUtility.ProductGroupWrapper>(productWrapperGroup);
            readableCheck = false;
            LoanUtility.ProductGroupWrapper groupProduct;
            productWrapperGroup = new List<LoanUtility.ProductGroupWrapper>();
            
            Funding_Batch__c fndBtch = new Funding_Batch__c();
            fndBtch.name = 'Funding Batch' + convertDateToString(system.now());
            fndBtch.Released_Date__c = system.now();
            fndBtch.Status__c = 'Released';
            
            //Update value on VF Page
            batchFundingStatus = 'Released';
            fundReleaseDate = convertDateToString(system.now());
            
            //Funding Amounts
            fndBtch.Total_Automated_Funding_Amount__c = totalAutomatedFundingAmount;
            fndBtch.Total_Manual_Funding_Amount__c = totalManualFundingAmount;
            fndBtch.Total_Funding_Amount__c = totalAutomatedFundingAmount + totalManualFundingAmount;
            
            insert fndBtch;
            
            system.debug('External Id for funding batch : ' + fndBtch.Funding_Batch_Number__c);
            List<Product__c> listProductToUpdate = new List<Product__c>();
            List<Product__c> listOfAutomatedProduct = new List<Product__c>();
            
            for(LoanUtility.ProductGroupWrapper pgw : testProdWrp){
                groupProduct = new LoanUtility.ProductGroupWrapper();
                listProductWrapper = new List<LoanUtility.ProductListWrapper>();
                for(LoanUtility.ProductListWrapper plw : pgw.productList){
                    if(plw.check == true){
                        listProductWrapper.add(plw);
                        /*if(plw.product.Funding_Type__c == 'Automated'){
                            listOfAutomatedProduct.add(plw.product);
                            plw.product.Funding_Status__c = 'Released Batch';
                        }
                        if(plw.product.Funding_Type__c == 'Manual'){
                            plw.product.Funding_Status__c = 'Funding Failed';
                        }*/
                        plw.product.Funding_Batch__c = fndBtch.id;
                        plw.product.Funding_Status__c = 'Funded';
                        plw.product.Actual_Date_Funded__c = system.today();
                        plw.product.Actual_Funded_Amount__c = plw.product.Disbursement_Amount__c;
                        
                        listProductToUpdate.add(plw.product);
                    }
                }
                groupProduct.groupDate = pgw.groupDate;
                groupProduct.totalFundingAmount = pgw.totalFundingAmount;
                groupProduct.productList = listProductWrapper;
                productWrapperGroup.add(groupProduct);
                
                
            }
            
            loanSettings.Run_Product_Trigger__c = false;
            update loanSettings;
            update listProductToUpdate;
            loanSettings.Run_Product_Trigger__c = true;
            update loanSettings;
            
            //FlatFileUtil.createFlatFile(listProductToUpdate, fndBtch.id, 'Credit');
            //FlatFileUtil.createFlatFile(listProductToUpdate, fndBtch.id, 'Debit');
            
            //Create a Funding CSV File with Attchment
            //CSVFundingFileUtil.createCSVFile(listOfAutomatedProduct, fndBtch.id, 'Credit');
            //Create a Payment CSV File with Attchment
            //CSVFundingFileUtil.createCSVFile(listProductToUpdate, fndBtch.id, 'Debit');            
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Batch Released successfully');
            ApexPages.addMessage(myMsg);
            
            //execute VersaPay Fuding Batch
            DataBase.executeBatch(New VersaPayFundingBatch(fndBtch.id), 1);
            
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Batch Release failed');
            ApexPages.addMessage(myMsg);
        }        
        
        //PageReference retPage = Page.FundingBatchView;
        //retPage.setRedirect(true);      
        return null;
    }
    
    public void selectAll(){
        
        List<LoanUtility.ProductGroupWrapper> testProdWrp = new List<LoanUtility.ProductGroupWrapper>(productWrapperGroup);
        LoanUtility.ProductGroupWrapper groupProduct;
        system.debug('Wrp group : ' + testProdWrp);
        system.debug('Wrp group : ' + productWrapperGroup);
        productWrapperGroup = new List<LoanUtility.ProductGroupWrapper>();
        List<Product__c> listProductToUpdate = new List<Product__c>();
        List<LoanUtility.ProductListWrapper> listProducts = new List<LoanUtility.ProductListWrapper>();
        listProductWrapper = new List<LoanUtility.ProductListWrapper>();
        
        if(selectAll == false){
            
            for(LoanUtility.ProductGroupWrapper pgw : testProdWrp){
                groupProduct = new LoanUtility.ProductGroupWrapper();
                listProducts = new List<LoanUtility.ProductListWrapper>();
                for(LoanUtility.ProductListWrapper plw : pgw.productList){
                    plw.check = false;   
                    listProductWrapper.add(plw);
                    listProducts.add(plw);
                }
                groupProduct.groupDate = pgw.groupDate;
                groupProduct.totalFundingAmount = pgw.totalFundingAmount;
                groupProduct.productList = listProducts;
                productWrapperGroup.add(groupProduct);
            }
        }
        if(selectAll == true){
            
            for(LoanUtility.ProductGroupWrapper pgw : testProdWrp){
                groupProduct = new LoanUtility.ProductGroupWrapper();
                listProducts = new List<LoanUtility.ProductListWrapper>();
                for(LoanUtility.ProductListWrapper plw : pgw.productList){
                    plw.check = true;   
                    listProductWrapper.add(plw);
                    listProducts.add(plw);
                }
                groupProduct.groupDate = pgw.groupDate;
                groupProduct.totalFundingAmount = pgw.totalFundingAmount;
                groupProduct.productList = listProducts;
                productWrapperGroup.add(groupProduct);
            }
            
        }
        system.debug('Wrp group : ' + testProdWrp);
        system.debug('Wrp group : ' + productWrapperGroup);
        reCalculate();
    }
}