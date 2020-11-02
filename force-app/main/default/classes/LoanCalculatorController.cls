public with sharing class LoanCalculatorController{
    
    public List<Application__c> appList{get;set;}
    public string selectedLoanAmount{get;set;}
    public string selectedNumberMonth{get;set;}
    public string loanStartDateString{get;set;}
    public boolean interestRate{get;set;}
    public String maturityDateString{get;set;}
    Public Date loanStartDate {get;set;}
    public String firstPaymString{get;set;}
    public List<String> strdate {get;set;}
    public List<String> firstPaymentList{get;set;}
    public boolean showCalculatedResult{get;set;}
    public string firstPaymentString{get;set;}
    public string applicationId{get;set;}
    public dateTime dTime;
    public dateTime dTime1;
    public Decimal regularPaymentAmount{get;set;}
    Public Decimal firstPaymentAmount{get;set;}
    public Decimal totalPaymentAmount{get;set;}
    public boolean showError{get;set;}
    private set<String> holidaySet;
    public Boolean showSuccessMessage{get;set;}
    public Loan_ReEngineering__c loanSettings{get;set;}
    Public Date calMaturityDate{get;set;}
    public String errorMessage{get;set;}
    
    public LoanCalculatorController(){
        //to show messages
        showError = false;
        
        //initialize variables
        loanSettings = Loan_ReEngineering__c.getOrgDefaults();
        interestRate = true;
        showCalculatedResult = false;
        maturityDateString = '';
        Map<String,String> holDayMap = new Map<String,String>();
        holidaySet = new Set<String>();
        if(appList == null){
            appList = new List<Application__c>();
        }
        
        string activity = '';
        
        //get application record
        applicationId = ApexPages.currentPage().getParameters().get('id');
        appList = [Select id,Loan_Amount__c,Interest_Rate__c,Payment__c,Loan_Start_Date__c,Approved_Amount__c,createddate,
                   Authentication_Choice__c, Authentication_Result__c,  First_Payment_Date__c, Requested_Credit_Limit__c, 
                   Loan_Type__c, Decision__c, Application_Fullfillment_Status__c
                   FROM Application__C where id=:applicationId];
        
        if(appList !=null && appList.size() > 0){
            selectedLoanAmount = String.valueOf(appList[0].Loan_Amount__c);
        }
        
        /*
        
        //Validtion messages
        String appDecision = appList[0].Decision__c;
        String appFullfillmentStatus = appList[0].Application_Fullfillment_Status__c;
        if(appList[0].Loan_Type__c == 'Affirm Financial MasterCard'){
            errorMessage = 'This Application is for Credit Card, you cannot continue with Loan Calculator.';
            showError = true;
        }
        else if(!LoanUtility.getValidDecision().contains(appDecision)){
            showError = true;
            errorMessage = 'The Application Decision is '+ appDecision +', you cannot continue with Loan Calculator.';
        }
        else if(!LoanUtility.getAuthResult().contains(appList[0].Authentication_Result__c)){
            errorMessage = 'The Authentication is not completed for this Application, you cannot continue with Loan Calculator.';
            showError = true;
        }
        else if(appList[0].Approved_Amount__c == null || appList[0].Approved_Amount__c == 0){
            errorMessage = 'Lender Approved Amount is missing, you cannot continue with Loan Calculator.';
            showError = true;
        }
        else if(appList[0].Interest_Rate__c == null || appList[0].Interest_Rate__c == 0){
            errorMessage = 'Interest Rate is missing, you cannot continue with Loan Calculator.';
            showError = true;
        }
        else if('Approved for Funding' == appFullfillmentStatus  
                || 'Ready For Export' == appFullfillmentStatus 
                || 'Loan Document Executed' == appFullfillmentStatus){
                    
                    errorMessage = 'The Application is not in correct Fullfillment Status, you cannot continue with Loan Calculator';
                    showError = true;
                }else if('Completed' == appFullfillmentStatus){
                    errorMessage = 'The Application Fulfillment Status is Completed, you cannot continue with Loan Calculator.';
                    showError = true;
                }
        */
        
        //To calculate holidays from holiday object  
        if(!showError){
            List<Holiday> holidayList = [SELECT ActivityDate,Id,Name FROM Holiday];
            
            for(Holiday hol:holidayList){
                Datetime dt = DateTime.newInstance(hol.ActivityDate, Time.newInstance(0, 0, 0, 0));
                activity = String.valueOf(hol.ActivityDate);
                String[] splittedDate = activity.split('-');
                String newActivityDate = splittedDate[2]+'/'+splittedDate[0]+'/'+splittedDate[1];
                if(!holidaySet.contains(newActivityDate))
                    holidaySet.add(newActivityDate);
                holDayMap.put(newActivityDate,dt.format('EE'));
            }
        }
        
        //from Custom setting values
        integer startCount = Integer.valueOf(loanSettings.Starting_Day_for_Loan_Start_Date__c);
        integer lastCount = Integer.valueOf(loanSettings.Loan_Start_Days__c);
        
        
        //Calculate available loan start dates - Based on Application Creation Date - optimized2
        strdate = new List<String>();
        //integer startCount = 3;
        integer dayCnt = startCount;
        //integer lastCount = 22;
        dTime = system.now();
        
        boolean repaetLp = true;
        while(repaetLp){
            dTime = dTime.addDays(1);
            system.debug('Date :' + dTime);
            if(dTime.format('EE') == 'Sat' || dTime.format('EE') == 'Sun' || holidaySet.contains(dtime.format('MM/dd/yyyy'))){
                repaetLp = true;
            }else{
                repaetLp = false;
            }
        }
        system.debug('Date :' + dTime);
        if(appList != null && appList.size() > 0){
            while (startCount <= lastCount){
                dTime = dTime.addDays(1);                
                dayCnt++;
                if(dTime.format('EE') == 'Sat' || dTime.format('EE') == 'Sun' || holidaySet.contains(dtime.format('MM/dd/yyyy'))){
                    continue;
                }
                else{
                    if(startCount <= lastCount){
                        String finDate = dtime.format('MM/dd/yyyy');
                        strdate.add(finDate);
                        startCount ++;
                    }
                }
            }
        }
        
       
    }
    
    //Needed for Loan Amount dropdown
    public List<SelectOption> getLoanAmountList(){
        List<SelectOption> optnList = new List<SelectOption>();
        List<String> args = new String[]{'0','number','###,###,###.##'};
            if(appList != null && appList.size() > 0){
                integer count = integer.valueOf(appList[0].Approved_Amount__c);
                //selectedLoanAmount = String.valueOf(count);
                while(count >=500){
                    // system.debug('##debug'+count);
                    
                    String s = String.format(count.format(), args);
                    optnList.add(new SelectOption(String.valueOf(count),'$'+s)); 
                    if(count>500)
                        count = count - 500;
                    else if(count == 500)
                        break;   
                }
            }
        
        return optnList;
    }
    
    public pagereference navigateNext1(){
        try{
            if(appList !=null && appList.size() > 0){
                calulateMaturityDate();
                appList[0].Loan_Amount__c = Decimal.valueOf(selectedLoanAmount);
                appList[0].Number_of_Payments__c = Decimal.valueOf(selectedNumberMonth);
                // Date dat = Date.parse(loanStartDateString.split('-')[0]+'/'+loanStartDateString.split('-')[1]+'/'+loanStartDateString.split('-')[2]);
                //system.debug('list : ' + maturityDateString.split('-'));
                if(String.isNotEmpty(maturityDateString)){
                    appList[0].Maturity_Date__c = calMaturityDate;
                }
                if(String.isNotEmpty(loanStartDateString)){
                    appList[0].Loan_Start_Date__c =  date.newInstance(Integer.valueof(loanStartDateString.split('/')[2]),Integer.valueof(loanStartDateString.split('/')[0]) ,Integer.valueof( loanStartDateString.split('/')[1]));
                }
                
                if(String.isNotEmpty(firstPaymString)){
                    appList[0].First_Payment_Date__c =  date.newInstance(Integer.valueof(firstPaymString.split('/')[2]),Integer.valueof(firstPaymString.split('/')[0]) ,Integer.valueof( firstPaymString.split('/')[1]));
                    appList[0].Pay_Day__c = Integer.valueof( firstPaymString.split('/')[1]);
                }
                
                
                appList[0].Application_Fullfillment_Status__c = 'Loan Calculator Completed';
                appList[0].First_Payment_Amount__c = firstPaymentAmount;
                appList[0].Regular_Payment_Amount__c = regularPaymentAmount;
                appList[0].Total_of_Payment__c = totalPaymentAmount;
                appList[0].Disbursement__c = Decimal.valueOf(selectedLoanAmount);
                
                boolean flag = true;
                if(String.isEmpty(loanStartDateString)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter Loan Start Date'));
                    return null;
                }
                else if(String.isNotEmpty(loanStartDateString)){
                    for(String str:strdate){
                        if(str == loanStartDateString){
                            flag = false;
                            break;
                        }
                        else{
                            continue;
                        }   
                    }
                    if(flag){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter correct Start Date For Loan'));
                        return null;
                    }
                }
                
                if(String.isEmpty(firstPaymString) || !firstPaymentString.contains(firstPaymString) ){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter correct value for Payment Date'));
                    return null;
                }
                //ApplicationTriggerHandler.runApplicationLoadTrigger = false;
                update appList;
                //ApplicationTriggerHandler.runApplicationLoadTrigger = true;
                
                showSuccessMessage = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Loan Calculator Completed Sucssefully. Close window'));
                return ApexPages.currentPage();
            }
        }
        catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        
      
        return null;
    }
    
    public pagereference navigatePrevious(){
        //return new pagereference('/'+appList[0].Id);
        return null;
    }
    
    public void updateLoanStartDate(){
        //String param = ApexPages.currentPage().getParameters().get('startDate');
        // system.debug('#_________________________________#'+param);
        try{
            system.debug('loanStartDateString :'+loanStartDateString);
            firstPaymentList = new List<String>();
            integer countPayment = 7;
            for(integer i=6;i<60;i++){
                //dTime1 = DateTime.newInstance(loanStartDateString, Time.newInstance(0, 0, 0, 0));
                //Date dat = Date.parse(loanStartDateString.split('-')[0]+'/'+loanStartDateString.split('-')[1]+'/'+loanStartDateString.split('-')[2]);
                //Date dat = date.valueOf(loanStartDateString.split('-')[0]+'/'+loanStartDateString.split('-')[1]+'/'+loanStartDateString.split('-')[2]);
                date dat = date.newInstance(Integer.valueof(loanStartDateString.split('/')[2]),Integer.valueof(loanStartDateString.split('/')[0]) ,Integer.valueof( loanStartDateString.split('/')[1]));
                
                //System.debug('integer i :'+i);
                //System.debug('date dat :'+dat);
                dat = dat.addDays(i);
                //System.debug('date dat addDays :'+dat);
                if(dat.day() == 31){
                    continue;
                }
                else{
                    if(countPayment < 46){
                        String finDate1 = String.valueOf(dat);
                        //System.debug('finDate1 :'+finDate1);
                        firstPaymentList.add(finDate1.split('-')[1]+'/'+finDate1.split('-')[2]+'/'+finDate1.split('-')[0]);
                        countPayment ++;
                    }
                }
                //system.debug('##list'+firstPaymentList);
            }
            firstPaymentString = '[';
            integer counter = 1;
            for(String payString:firstPaymentList){
                system.debug('payString :'+payString);
                firstPaymentString += payString;
                if(counter != firstPaymentList.size()){
                    firstPaymentString +=',';
                }
                counter++;
            }
            firstPaymentString += ']';
            
            System.debug('firstPaymentString :'+firstPaymentString);
        }
        catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
            return;
        }
    }
    
    //Needed for Number of Payments Dropdown
    public List<SelectOption> getNumberOfMonthsList(){
        List<SelectOption> optnListMonth = new List<SelectOption>();
        
        if(selectedLoanAmount !='' && selectedLoanAmount !=null){
            integer count = integer.valueOf(selectedLoanAmount );
            //integer maxMonth = (count/100)+(count/500); 
            integer maxMonth = 60;
            selectedNumberMonth = String.valueOf((count/100)+(count/500));
            while(maxMonth  >=6){
                optnListMonth.add(new SelectOption(String.valueOf(maxMonth),String.valueOf(maxMonth)));
                if(maxMonth > 6 )
                    maxMonth = maxMonth - 6;
                else if(maxMonth == 6)
                    break;  
            }      
        }
        return optnListMonth;
    }
    
    public void calulateMaturityDate(){
        
        System.debug('\n\n ------------->>>>> Loan Start Date '+loanStartDateString);
        System.debug('\n\n ------------->>>>> Selected Number Month' + selectedNumberMonth);
        System.debug('\n\n ------------->>>>> payment' + firstPaymString);
        
        try{
            
            if(String.isNotEmpty(loanStartDateString) && String.isNotEmpty(selectedNumberMonth) && String.isNotEmpty(firstPaymString)){
                
                //For Calculation of Regular payment date 
                if(appList!=null && appList.size() > 0){
                    
                    Date loanStartDate = date.newInstance(Integer.valueof(loanStartDateString.split('/')[2]),Integer.valueof(loanStartDateString.split('/')[0]) ,Integer.valueof( loanStartDateString.split('/')[1]));
                    Date firstPaymentDate = date.newInstance(Integer.valueof(firstPaymString.split('/')[2]),Integer.valueof(firstPaymString.split('/')[0]) ,Integer.valueof( firstPaymString.split('/')[1]));
                    calMaturityDate = firstPaymentDate.addMonths((Integer.valueOf(selectedNumberMonth)) - 1);
                    //DateTime maturityDate = Date.newinstance(calMaturityDate.year(), calMaturityDate.month(), calMaturityDate.day());
                    
                    //Format Maturity Date 
                    maturityDateString = calMaturityDate.format();
                    // maturityDateString = maturityDateString.replace('/','-');
                    
                    Decimal interestRateDecimal = (appList[0].Interest_Rate__c) / 100.00;
                    Decimal interestRateVal = interestRateDecimal / 12.00;
                    Decimal powerRate = Math.pow(double.valueOf(1 + interestRateVal),-(Integer.valueOf(selectedNumberMonth)));
                    regularPaymentAmount = (decimal.valueOf(selectedLoanAmount)*(interestRateVal / (1 - powerRate)));
                    
                    
                    //Initialize First Payment Amount
                    firstPaymentAmount = 0.0;
                    Integer selectedLoanAmountInt = Integer.valueOf(selectedLoanAmount);
                    
                    Date p0 = firstPaymentDate.addMonths(-1); //The date one month prior to the first payment date
                    
                  
                    
                    // First Payment Amount Algorithm Start
                    // If we are within 1st month (period 0) before First Payment Date
                    //As per mark (LSD.compareTo(P0) >= 0)
                    System.debug('loanStartDate :'+loanStartDate);
                    System.debug('p0 :'+p0);
                    System.debug('firstPaymentDate :'+firstPaymentDate);
                    System.debug('loanStartDate.daysBetween(p0) :'+loanStartDate.daysBetween(p0));
                    System.debug('firstPaymentDate.daysBetween(p0) :'+firstPaymentDate.daysBetween(p0));
                    
                    
                    if(p0.daysBetween(loanStartDate) >= 0){ 
                        
                        Integer intd;
                        
                        // Calculate # of days not to accrue interest in P0, accommodating for periods that have 31 days in them
                        if((p0.daysBetween(firstPaymentDate)) == 31){ //PaymentCalculationTest.daysBetween(FPD,P0) == 31
                            // P0 has 31 days
                            intd = Math.max((p0.daysBetween(loanStartDate) - 1), 0);  //Math.max(daysBetween(LSD,P0) - 1, 0);
                        }
                        else{ 
                            // P0 has 30 or less days
                            intd = p0.daysBetween(loanStartDate);
                        }
                        
                        // FPA is Regular monthly payment, and subtract off the daily interest not accrued in current period (P0)
                        //FPA = RPA - ((LNA * (APR / 360)) * NOINTDAYS);
                        firstPaymentAmount = regularPaymentAmount.setScale(2) - ((selectedLoanAmountInt * (interestRateDecimal / 360)) * intd);                     
                    }
                    // If we are > 1st month (period 1) before First Payment Date
                    else{
                        
                        // FPA is Regular monthly payment, and add the daily interest accrued in P1 only 
                        // I.e. Daily interest accrued on 1st month’s interest amount
                        //FPA = RPA + ( (LNA + (APR / 12 * LNA)) * (APR / 360) * daysBetween(P0,LSD) );
                        firstPaymentAmount = regularPaymentAmount.setScale(2) + ((selectedLoanAmountInt + (interestRateDecimal / 12 * selectedLoanAmountInt)) * (interestRateDecimal / 360) * (loanStartDate.daysBetween(p0)));
                    }
                    // First Payment Amount Algorithm End
                    
                    //Round Down Regular Payment Amount to two decimal places
                    regularPaymentAmount = regularPaymentAmount.setScale(2);
                    
                    //Round Down First Payment Amount to two decimal places
                    firstPaymentAmount = firstPaymentAmount.setScale(2, System.RoundingMode.DOWN);
                    //firstPaymentAmount = firstPaymentAmount.setScale(2);
                    
                    //Total Payment Amount
                    totalPaymentAmount = (firstPaymentAmount  + (regularPaymentAmount  * (Integer.valueOf(selectedNumberMonth) - 1))).setScale(2);
                }
                
                else if(appList!=null && appList.size() > 0 && appList[0].Interest_Rate__c ==null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Interest Rate Is Blank, Please add interest rate for application');
                    ApexPages.addMessage(myMsg);
                    return;  
                }
            }
        }
        catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
            return;
        }
    }
}