/**************************************************************************************************
 *
 *  Class:   
 *
 *  @description : This is a test class for insert Preferred Partner Rederral Code
 *  @author : A5E Consulting
 *  @date : 10/13/2016
 
 *************************************************************************************************/
@isTest
public class TestCSVPreferredPartnerController {
    
    static testMethod void testRedecide(){
        
        //create a csv file string
        String csvString = createCSVString();
        
        //insert csv file
        insertRecordsPrefferedPartner(csvString);
        
        //Upload witout CSV file 
        RecordsWithoutFile(csvString);
        
        //insert records without csv
        RecordsWithoutCSV(csvString);
    }
    
    //create a csv file string
    public static String createCSVString(){
        return 'BROKER FIRM,NDA ON FILE(Date),License (Date),Partner Category,Channel Partner code in PCoD (Syed),Preferred Partner Offer,Communication to Operational Team(s)(Syed),Phone Number,Email Address Notes\nLaking Financial,3/21/2015,NB (MI Group),Broker,MI-MLaking,,Y,1,3/27/2015,506-474-1070\nArvin Sodhi Mortgage Architects,3/31/2015,Mortgage Architects,Broker,SODHI,,Y,1,3/31/2015,204-230-9395';
    }
    
    //insert records without csv 
    private static void RecordsWithoutCSV(String csvString){
        
        CSVPreferredPartnerController i=new CSVPreferredPartnerController ();
        i.csvBody= Blob.valueOf(csvString);
        i.csvName = 'test.pdf';
        i.importCSVFile();
    }
    
    //Upload witout CSV file 
    private static void RecordsWithoutFile(String csvString){
        
        CSVPreferredPartnerController i=new CSVPreferredPartnerController ();
        i.csvBody= Blob.valueOf(csvString);
        i.csvName = '';
        i.importCSVFile();
    }
    
    //insert csv file
    private static void insertRecordsPrefferedPartner(String csvString){
        
        CSVPreferredPartnerController i=new CSVPreferredPartnerController ();
        i.csvBody= Blob.valueOf(csvString);
        i.csvName = 'test.csv';
        i.importCSVFile();
    }
}