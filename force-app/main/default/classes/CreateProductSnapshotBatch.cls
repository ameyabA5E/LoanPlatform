/**************************************************************************************************
*
*  Class:   
*
*  @description : Apex Class that fetch eligible Product and create Product Snapshot Records    
*  @author : A5E Consulting
*  @date : 01/30/2017   

*************************************************************************************************/
global Class CreateProductSnapshotBatch implements Database.Batchable<sObject>{
    
    public Product_Snapshot_Settings__c prodSnapSettings;
    
    //constructor
    public CreateProductSnapshotBatch(){
    
        //fetch Product Snapshot Settings record
        prodSnapSettings = Product_Snapshot_Settings__c.getOrgDefaults();
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator([Select Id, Name, Available_Credit_Amount__c, Last_Statement_Balance__c, Last_Statement_Credit_Interest_Amount__c, Card_Used_This_Month__c, 
                                        Late_Fee_Amount_Outstanding__c,NSF_Fee_Amount_Outstanding__c, Credit_Limit__c, Current_Average_Daily_Balance__c, Current_Balance__c, Payment_Amount__c, 
                                        Other_Fee_Amount_Outstanding__c, Last_Payment_Amount__c, External_Status_Current__c, Internal_Status__c,Last_Delinquency_Date__c, 
                                        Current_Balance_Effective_Date__c, Last_Payment_Date__c, Credit_Limit_Last_Changed_Date__c, Last_Statement_Date__c, Latest_NSFED_Date__c, 
                                        Payment_Due_Date__c, Delinquency_Cycles__c, Delinquency_Days__c, Product_Status__c, Source_System__c, Times_NSF__c,  
                                        LastModifiedById, LastModifiedDate, Credit_Limit_Last_Changed_Amount__c
                                        //From Product__c WHERE (Source_System__c ='FDR' OR Source_System__c = 'Megasys') AND Charged_Off_Date__c = null AND Closed_Date__c = null
                                        //From Product__c WHERE (Source_System__c ='FDR' and External_Status_Current__c = null and Closed_Date__c = null) or (Source_System__c = 'Megasys' and Internal_Status__c='Active' and Closed_Date__c = null)
                                        //From Product__c WHERE External_Status_Current__c !='Z' and (Source_System__c ='FDR' or Source_System__c = 'Megasys')
                                        From Product__c WHERE (Source_System__c ='FDR' and External_Status_Current__c !='Z' and Current_Balance__c != 0) or (Source_System__c = 'Megasys' and Internal_Status__c='Active' and Closed_Date__c = null)
                                        ]);
    }
    
    //create Product Snapshots Records
    global void execute(Database.BatchableContext BC, List<Product__c> prodList){
    
        List<Product_Cycle_History__c> prdSnapList = New List<Product_Cycle_History__c>();
        
        for(Product__c prd : prodList){
            
            Product_Cycle_History__c prdSnap = New Product_Cycle_History__c();
            
            prdSnap.Available_Credit_Amount__c = prd.Available_Credit_Amount__c;
            prdSnap.Card_Used_This_Month__c = prd.Card_Used_This_Month__c;
            prdSnap.Current_Average_Daily_Balance__c = prd.Current_Average_Daily_Balance__c;
            prdSnap.Current_Balance__c = prd.Current_Balance__c;
            prdSnap.Last_Payment_Amount__c = prd.Last_Payment_Amount__c;
            prdSnap.Last_Statement_Credit_Interest_Amount__c = prd.Last_Statement_Credit_Interest_Amount__c;
            prdSnap.Payment_Amount__c = prd.Payment_Amount__c;
            prdSnap.NSF_Fee_Amount_Outstanding__c = prd.NSF_Fee_Amount_Outstanding__c;
            prdSnap.Last_Statement_Balance__c = prd.Last_Statement_Balance__c;
            prdSnap.Late_Fee_Amount_Outstanding__c = prd.Late_Fee_Amount_Outstanding__c;
            prdSnap.Other_Fee_Amount_Outstanding__c = prd.Other_Fee_Amount_Outstanding__c;
            prdSnap.Payment_Amount__c = prd.Payment_Amount__c;
            prdSnap.Credit_Limit__c = prd.Credit_Limit__c;
            prdSnap.Credit_Limit_Last_Changed_Amount__c = prd.Credit_Limit_Last_Changed_Amount__c;
            prdSnap.Times_NSF__c = prd.Times_NSF__c;    
            
            prdSnap.External_Status_Current__c = prd.External_Status_Current__c;
            prdSnap.Internal_Status__c = prd.Internal_Status__c;
            //prdSnap.Last_Payment_Status__c = prd.Last_Payment_Status__c;
            prdSnap.Delinquency_Cycles__c = prd.Delinquency_Cycles__c;
            prdSnap.Delinquency_Days__c = prd.Delinquency_Days__c;
            prdSnap.Product_Status__c = prd.Product_Status__c;
            prdSnap.Source_System__c = prd.Source_System__c;
            
            prdSnap.Product_Last_Modified_By__c = prd.LastModifiedById;
            prdSnap.Product_Last_Modified_Date__c = prd.LastModifiedDate;
            prdSnap.Last_Statement_Date__c = prd.Last_Statement_Date__c;
            prdSnap.Latest_NSFED_Date__c = prd.Latest_NSFED_Date__c;
            prdSnap.Payment_Due_Date__c = prd.Payment_Due_Date__c;
            prdSnap.Last_Payment_Date__c = prd.Last_Payment_Date__c;
            prdSnap.Last_Delinquency_Date__c = prd.Last_Delinquency_Date__c;
            prdSnap.Credit_Limit_Last_Changed_Date__c = prd.Credit_Limit_Last_Changed_Date__c;
            prdSnap.Current_Balance_Effective_Date__c = prd.Current_Balance_Effective_Date__c;
            
            prdSnap.Product__c = prd.Id;
            prdSnap.Iteration_Number__c = prodSnapSettings.Next_Iteration__c;
             
            prdSnapList.add(prdSnap);
        }
        
        //insert Product Snapshot List records
        insert prdSnapList;
    }
    
    //Update the Product Snapshot Custom Setting Record
    global void finish(Database.BatchableContext BC){
        
        Decimal num ;
        if(prodSnapSettings.Iteration_Limit__c == prodSnapSettings.Next_Iteration__c){
            num = 1;
        }
        else{
            num = prodSnapSettings.Next_Iteration__c + 1;
        }
        prodSnapSettings.Next_Iteration__c = num;
        
        update prodSnapSettings; 
        
    }
}