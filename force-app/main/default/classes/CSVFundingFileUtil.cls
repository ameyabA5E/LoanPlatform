/**************************************************************************************************
*
*  Class:   
*
*  @description : This is a utility class to create/read CSV files 
*  @author : A5E Consulting
*  A5E Consulting 08/23/2016     Class created
*************************************************************************************************/
public class CSVFundingFileUtil {
    
    //Header row
    public static final String csvHeader = 'first_name*,middle_name,last_name*,business_name,institution_number*,branch_number*,account_number*,transaction_type*,amount_in_cents*,transaction_reference,memo\n';
    
    public static void createCSVFile(List<Product__c> listProducts, Id fndBtchId, String transactionType){
        
        //Fetch Funding Batch Records
        Funding_Batch__c fndBatch= fetchFundingBatch(fndBtchId);
        System.debug('###'+listProducts);
        //Return String with records
        String finalStr = createStringFile(listProducts, transactionType);
        
        //Create Attchment for Payment and Funding
        if(String.isNotBlank(finalStr)){
            createAttchmentFile(transactionType, finalStr, fndBatch);
        }
    }
    
    //Return String with records
    private static String createStringFile(List<Product__c> listProducts, String transactionType){
        
        String finalStr = '';
        System.debug('###123'+listProducts);
        for(Product__c prod : listProducts){
            
            String recordStr;
            
            try{
                recordStr = replaceComma(prod.customer__r.firstName) +','
                    + replaceComma(prod.customer__r.middle_name__pc) +',' //Middle Name
                    + replaceComma(prod.customer__r.lastName) +','
                    + '' +',' //Business Name
                    + replaceComma(prod.PAP_Bank_Code__c) +','
                    + replaceComma(prod.PAP_Transit_Code__c) +','
                    + replaceComma(prod.PAP_Account_Number__c) +','
                    + creditDebitYN(transactionType) +','
                    + amountInCents(prod, transactionType)/*.)*/ +','
                    + replaceComma(prod.name) +','
                    + 'Affirm Financial TermLoan' +'\n';    
            }
            catch(Exception e){
                recordStr = '';
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Error while creating CSV file."'));
            }
            
            if(!String.isBlank(recordStr)){
                finalStr = finalStr + recordStr;
            }
        }
        
        if(!String.isBlank(finalStr)){
            finalStr = csvHeader + finalStr;            
        }
        
        return finalStr;
    }
    
    //Amount in Cents
    private static string amountInCents(Product__C prodT, String type){
        
        if(type.EqualsIgnoreCase('Credit')){
            return '' + (prodT.Disbursement_Amount__c *100);
        }else{
            return '' + (prodT.Funding_Amount__c * 100);
        }
    }
    
    //Credit and Debit 
    private static String creditDebitYN(String yn){
        
        if(yn.EqualsIgnoreCase('Credit')){
            //return 'Y';
            return 'direct_credit';
        }
        else{
            //return 'N';
            return 'direct_debit';
        }
    }
    
    //Fetch Funding Batch Records
    private static Funding_Batch__c fetchFundingBatch(String fndBtchId){
        
        return [select Id, Funding_Batch_Number__c, Released_Date__c, Total_Funding_Amount__c
                from Funding_Batch__c where Id =: fndBtchId];
    }
    
    //Create Attchment for Payment and Funding
    private static void createAttchmentFile(String transactionType, String finalStr, Funding_Batch__c fndBch){
        
        Attachment attachment = new Attachment();
        attachment.parentId = fndBch.Id;
        attachment.Body = Blob.valueOf(finalStr);
        if(transactionType == 'Credit'){
            attachment.Name = System.Now() + '- Funding File.csv';
        }
        if(transactionType == 'Debit'){
            attachment.Name = System.Now() + '- Payment File.csv';
        }
        
        try{
            insert attachment;              
        }
        catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Error while creating Attachment record file."'));
        }
    }
    
    //If number is null, return Blank
    @TestVisible
    private static String checkPAPNumber(Integer papNum){
        
        if(papNum == null){
            return '';
        }    
        else{
            return String.valueof(papNum);
        }
    }
    
    //Replace comma from String
    private static String replaceComma(String str){
        
        if(String.isNotBlank(str)){
            return (str.replaceAll(',',' '));
        }
        else{
            return '';
        }
    } 
}