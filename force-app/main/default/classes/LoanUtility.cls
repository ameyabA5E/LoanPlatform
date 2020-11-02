public with sharing class LoanUtility{
    
    public class ProductListWrapper{
        public boolean check{get;set;}
        public Product__c product{get;set;}
        
        public ProductListWrapper(){
            check = true;
            product = new Product__c();
        }
    }
    
    public class ProductGroupWrapper{
        public String groupDate{get;set;}
        public List<ProductListWrapper> productList{get;set;}
        public Decimal totalFundingAmount{get;set;}
        
        public ProductGroupWrapper(){
            productList = new List<ProductListWrapper>();
            totalFundingAmount = 0;
            groupDate = null;
        }
    }
    
    public static Set<String> getValidDecision(){
        Set<String> validDecisions = new Set<String>();
        
        validDecisions.add('Approved');
        validDecisions.add('Referred');
        
        return validDecisions;
    }
    
    public static Set<String> getAuthResult(){
        Set<String> authResults = new Set<String>();
        
        authResults.add('Passed');
        authResults.add('PassedNoFraud');
        
        return authResults;
    }
    public static Set<String> getValidLoanProcessTypes(){
        Set<String> validLoanProcess= new Set<String>();
        
        validLoanProcess.add('Traditional');
        return validLoanProcess;
    }
}