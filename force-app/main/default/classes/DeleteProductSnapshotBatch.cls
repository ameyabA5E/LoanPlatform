/**************************************************************************************************
*
*  Class:   
*
*  @description : Apex Class that delete Product Cycle History Records based on Iteration number     
*  @author : A5E Consulting
*  @date : 01/30/2017   

*************************************************************************************************/
global Class DeleteProductSnapshotBatch implements Database.Batchable<sObject>{
    
    public Product_Snapshot_Settings__c prodSnapSettings;
    
    //constructor
    public DeleteProductSnapshotBatch(){
        
        //fetch Product Snapshot Settings record
        prodSnapSettings = Product_Snapshot_Settings__c.getOrgDefaults();
    }
    
    //fetch eligible Product Snapshots records
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator([Select Id, Name FROM Product_Cycle_History__c WHERE Iteration_Number__c =: prodSnapSettings.Next_Iteration__c ]);
    }
    
    //delete all the records returned by the query.
    global void execute(Database.BatchableContext BC, List<Product_Cycle_History__c> prodList){
    
        if(prodList.size() != 0){
            delete prodList;
        }
    }
    
    //initiate the CreateProductSnapshotBatch Job
    global void finish(Database.BatchableContext BC){
        
        Database.executeBatch(New CreateProductSnapshotBatch(), 200);
    }
}