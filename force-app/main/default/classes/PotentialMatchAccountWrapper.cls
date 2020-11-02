/**************************************************************************************************
 *
 *  Class:   
 *
 *  @description : This is a wrapper class is for Account records 
 *  @author : A5E Consulting
 *  @date : 03/30/2016
 *
 *  Change History:
 *
 *  Developer       Date          Description
 *  ------------------------------------------------------------------------------------------------
 *
 *  A5E Consulting 03/30/2016     Class created
 *  A5E Consulting 06/06/2016     Use formatDate method
 
 *************************************************************************************************/
public class PotentialMatchAccountWrapper {
   public Account accnt {get; set;}
    public Boolean selected {get;set;}
    public String accountLink {get;set;}
    public String birthdateStr {get;set;}
    
    public PotentialMatchAccountWrapper(Account accnt){
        this.accnt = accnt;
        this.selected = false; 
        this.accountLink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + accnt.Id;    
        
        if(accnt.PersonBirthdate != null){
            birthdateStr = PotentialMatchUtil.formatDate(accnt.PersonBirthdate);        
        }
        else{
            birthdateStr = '';
        }
    }
    
     
}