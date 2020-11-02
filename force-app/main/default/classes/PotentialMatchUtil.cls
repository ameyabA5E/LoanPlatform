public class PotentialMatchUtil {
   
    //Constants
    public static final String MANUAL_REVIEW_REASON_MULTIPLE_EXACT_MATCHES = 'Multiple Exact Matches';
    public static final String MANUAL_REVIEW_REASON_MULTIPLE_UNCERTAIN_MATCHES = 'Multiple Uncertain Matches';
    public static final String APP_NAME_MANUAL_REVIEW = 'Manual Review';    
           
    //Utility method for Exact Match List
    public static List<Account> getExactMatchList(Application__c appln){
      
      List<Account> dbAccnts = [select Id, SF_ID__c, FirstName, LastName, PersonEmail, PersonBirthdate, PersonMailingStreet, PersonMailingCity, PersonMailingState, PersonMailingPostalCode, PersonMailingCountry from Account 
                                 where IsPersonAccount = true and LastName = :appln.Last_Name__c and (
                                  (SIN__pc != null and SIN__pc = :appln.SIN__c) or 
                                  (PersonBirthdate != null and PersonBirthdate = :appln.Birth_Date__c and FirstName = :appln.First_Name__c)) 
                                  order by createdDate desc 
                                  ];
        return dbAccnts;    
    }
    
    //Utility method for Uncertain Match List
    public static List<Account> getUncertainMatchList(Application__c appln){
                
        String firstNameSearchTerm = appln.First_Name__c.subString(0,1) + '%';
        List<Account> dbAccnts = [select Id, SF_ID__c, FirstName, LastName, PersonEmail, PersonBirthdate, PersonMailingStreet, PersonMailingCity, PersonMailingState, PersonMailingPostalCode, PersonMailingCountry from Account  
                                  where IsPersonAccount = true and LastName = :appln.Last_Name__c and 
                                  (PersonEmail != null and PersonEmail = :appln.Email_Address__c and FirstName like :firstNameSearchTerm) 
                                  order by createdDate desc 
                                 ];
        return dbAccnts;               
    }
    
    public static String formatDate(Date d) {
        if (d == null) {
            return null;
        }
        return Datetime.newInstance(d.year(), d.month(), d.day()).format('MM-dd-yyyy');
    }          
}