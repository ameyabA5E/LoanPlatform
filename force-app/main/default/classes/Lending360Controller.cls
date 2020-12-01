public /*with sharing*/ class Lending360Controller{
    public Application_Form_Settings__c AppFormSettings {get;set;}
    public Account PersonAccount {get;set;}
    public Application__c Application {get;set;}

    public Boolean PersonAlreadyLoaded {get;set;}
    public Boolean PersonFoundViaQuery {get;set;}
    public Boolean PersonInserted {get;set;}

    public List<SelectOption> LoanTypeOptions {get;set;}
    public String SelLoanType {get;set;}
    public Boolean IsLoan {get;set;}

    public List<SelectOption> SalutationOptions {get;set;}
    public String SelSalutation {get;set;}

    public String FirstName {get;set;}
    public String MiddleName {get;set;}
    public String LastName {get;set;}

    public String PlaceholderFirstName {get;set;}
    public String PlaceholderMiddleName {get;set;}
    public String PlaceholderLastName {get;set;}

    public Integer BirthdateYear {get;set;}
    public Integer BirthdateMonth {get;set;}
    public Integer BirthdateDay {get;set;}

    public String PlaceholderBirthdateYear {get;set;}
    public String PlaceholderBirthdateMonth {get;set;}
    public String PlaceholderBirthdateDay {get;set;}

    public List<SelectOption> ProvinceOptions {get;set;}
    public String SelProvince {get;set;}
    
    public List<SelectOption> StateOptions {get;set;}
    public String SelState {get;set;}

    public List<SelectOption> CurrentBKCPOptions {get;set;}
    public String SelCurrentBKCP {get;set;}

    //public List<SelectOption> OfferCodeAvailOptions {get;set;}
    //public String SelOfferCodeAvail {get;set;}

    public List<SelectOption> AuthorizedCreditCheckOptions {get;set;}
    public String SelAuthorizedCreditCheck {get;set;}

    public List<SelectOption> GenderOptions {get;set;}
    public String SelGender {get;set;}

    public List<SelectOption> CommunicationsPreferenceOptions {get;set;}
    public String SelCommunicationsPreference {get;set;}

    public List<SelectOption> HowHeardAboutUsOptions {get;set;}
    public String SelHowHeardAboutUs {get;set;}

    public List<SelectOption> ReferralIdOptions {get;set;}
    
    //Incorrect interest rate for preferred partners - incidenet 44
    //public String SelReferralId {get;set;}

    public List<SelectOption> NumberOfDependantsOptions {get;set;}
    public String SelNumberOfDependants {get;set;}

    public List<SelectOption> MaritalStatusOptions {get;set;}
    public String SelMaritalStatus {get;set;}

    public List<SelectOption> PermanentProvinceOptions {get;set;}
    public String SelPermanentProvince {get;set;}
    public List<SelectOption> PermanentStateOptions {get;set;}
    public String SelPermanentState {get;set;}

    public List<SelectOption> PermanentRentOrOwnOptions {get;set;}
    public String SelPermanentRentOrOwn {get;set;}

    public List<SelectOption> PreviousProvinceOptions {get;set;}
    public String SelPreviousProvince {get;set;}

    public List<SelectOption> EmployerProvinceOptions {get;set;}
    public String SelEmployerProvince {get;set;}

    public List<SelectOption> PreviousEmployerProvinceOptions {get;set;}
    public String SelPreviousEmployerProvince {get;set;}

    public Boolean isConsumerLegalConsent {get;set;}

    public List<SelectOption> PoliticallyExposedForeignPersonOptions {get;set;}
    public String SelPoliticallyExposedForeignPerson {get;set;}

    public List<SelectOption> ThirdPartyDirectionOptions {get;set;}
    public String SelThirdPartyDirection {get;set;}

    // Offer Code related fields
    public Boolean isValidOfferCode {get;set;}
    public String nonCampaignMemberMessage {get;set;}

    // Disclosure URLs
    public String CreditCardDisclosureURL {get;set;}
    public String LoanDisclosureURL {get;set;}
    
    //Risk Based Pricing
    public String creditCardRentalDisclosureURL {get;set;}
    
    public String manitobaLoanDisclosureURL {get;set;}
    
    //Manitoba Disclosure changes
    //public Boolean isManitobaResident {get;set;}
    
    // Manitoba Updates
    public String mbCreditCardDisclosureURL {get;set;}
    public String mbCreditCardRentalDisclosureURL {get;set;}
    public String mbPreferredPartnerDisclosureURL {get;set;}
    
    //RBP -4 PILLARS -Exception Process
    public String preferredPartnerDisclosureURL {get;set;} 
    public Boolean isPreferredPartner {get;set;}   

    private RecordType personAccRecType;
    private String personAccSFID;
    private final String NONE_SEL_TEXT = '--None--';
    private final String PLEASE_SEL_TEXT = 'Please Select...';
    private final String YES_SEL_TEXT = 'Yes';
    private final String NO_SEL_TEXT = 'No';
    private final String RENT_SEL_TEXT = 'Rent';
    private final String OWN_SEL_TEXT = 'Own Property';
    private final String TRUE_TEXT = 'true';
    private final String FALSE_TEXT = 'false';
    private final String CREDIT_CARD = 'Lending360 Credit Card';
    private final String TERM_LOAN = 'Lending360 Term Loan';

    private Map<String, Integer> provinceToAgeOfMajorityMap;

    private final String APP_NAME_INCOMPLETE = 'Incomplete';
    
    // Error Messages
    // Step Zero messages
    private final String ERR_LOAN_TYPE = 'You must select a Loan Type.';
    private final String ERR_HOME_OWNER = 'Please specify if you are a Home Owner.';

    // Step One messages
    private final String ERR_AGE_OF_MAJORITY = 'You must be at the age of Majority before you may apply for Credit in this Province.';
    private final String ERR_HAS_ACCEPTED_DISCLOSURE_TERMS = 'You must accept the disclosure terms to proceed.';    
    private final String ERR_SALUTATION = 'You must provide a valid salutation.';
    private final String ERR_FIRST_NAME = 'You must provide a first name.';
    private final String ERR_MIDDLE_NAME = 'You must provide a middle name.';
    private final String ERR_LAST_NAME = 'You must provide a last name.';
    private final String ERR_PROVINCE = 'You must select a valid province.';
    private final String ERR_BIRTH_DATE = 'You must provide a valid birth date.';
    private final String ERR_SIN = 'Please provide a valid SIN.';
    private final String ERR_EMAIL_ADDRESS = 'Please provide a valid email address';
    private final String ERR_EMPLOYMENT_STATUS = 'You must provide a valid employment status.';
    private final String ERR_EMPLOYMENT_STATUS_UNQUALIFIED = 'Leanding360 cannot proceed due to your employment status.';
    private final String ERR_CURRENT_BKCP = 'You must answer the bankruptcy question.';
    private final String ERR_REQUESTED_CREDIT_LIMIT = 'You must provide how much you wish to borrow.';
    private final String ERR_AUTHORIZED_CREDIT_CHECK = 'Lending360  must be authorized to perform a credit check to proceed.';
    private final String ERR_INVALID_OFFER_CODE = 'Invalid offer code.';
    
    //Manitoba Updates
    private final String ERR_HAS_ACCEPTED_PERSONAL_CONSENT = 'Please accept the terms to proceed.';   

    // Step Two messages
    private final String ERR_GENDER = 'You must select a gender.';
    private final String ERR_HOME_PHONE = 'You must provide your home phone number.';
    private final String ERR_CELL_PHONE = 'Please provide a valid cell phone number.';
    private final String ERR_WORK_PHONE = 'You must provide your work phone number.';
    private final String ERR_COMMUNICATIONS_PREFERENCE = 'Please select a valid communications preference.';
    private final String ERR_HOW_HEARD_ABOUT_US = 'Please select a valid answer to how you heard about us.';
    private final String ERR_REFERRAL_ID = 'Please select a valid referral Id.';
    private final String ERR_NUMBER_OF_DEPENDANTS = 'You must select your number of dependants.';
    private final String ERR_MARITAL_STATUS = 'You must select a valid marital status';
    private final String ERR_PERMANENT_ADDRESS_STREET_NUMBER = 'You must provide your street number';
    private final String ERR_PERMANENT_ADDRESS_STREET_NAME = 'You must provide your street name';
    private final String ERR_PERMANENT_ADDRESS_CITY = 'You must provide the city you live in';
    private final String ERR_PERMANENT_ADDRESS_PROVINCE = 'You must provide the province you live in';
    //private final String ERR_PERMANENT_ADDRESS_POSTAL_CODE = 'You must provide a valid postal code';
    private final String ERR_HOW_LONG = 'You must provide how long you lived at your current address.';
    private final String ERR_PERMANENT_RENT_OR_OWN = 'You must answer whether you rent or own.';
    private final String ERR_HOUSING_COSTS = 'You must provide a valid amount for your housing costs';
    private final String ERR_MORTGAGE_WITH = 'Please specify who is your mortgage with.';
    private final String ERR_MONTHLY_EXPENSES = 'You must provide a valid amount for your monthly expenses';
    private final String ERR_PREVIOUS_ADDRESS_STREET_NUMBER = 'You must provide your previous street number';
    private final String ERR_PREVIOUS_ADDRESS_STREET_NAME = 'You must provide your previous street name';
    private final String ERR_PREVIOUS_ADDRESS_CITY = 'You must provide the previous city you lived in';
    private final String ERR_PREVIOUS_ADDRESS_PROVINCE = 'You must provide the previous province you lived in';
    //private final String ERR_PREVIOUS_ADDRESS_POSTAL_CODE = 'You must provide a valid previous postal code';
    private final String ERR_PREVIOUS_ADDRESS_HOW_LONG = 'You must provide how long you lived at your previous address.';
    private final String ERR_POSTALCODE_PROVINCE = 'Postal Code does not match selected province.';
    
    // Step Three messages
    private final String ERR_EMPLOYER_NAME = 'You must provide your employer name.';
    private final String ERR_EMPLOYER_PHONE = 'You must provide your employer phone number.';
    private final String ERR_EMPLOYER_STREET_NUMBER = 'You must provide your employer street number.';
    private final String ERR_EMPLOYER_STREET_NAME = 'You must provide your employer street name.';
    private final String ERR_EMPLOYER_CITY = 'You must provide your employer city.';
    private final String ERR_EMPLOYER_PROVINCE = 'You must provide your employer province.';
    //private final String ERR_EMPLOYER_POSTAL_CODE = 'You must provide your employer postal code.';
    private final String ERR_HOW_LONG_EMPLOYER = 'You must provide how long you worked at your previous employer.';
    private final String ERR_GROSS_MONTHLY_INCOME = 'You must provide your gross monthly income.';
    private final String ERR_PREVIOUS_EMPLOYER_NAME = 'You must provide your previous employer name.';
    private final String ERR_PREVIOUS_EMPLOYER_STREET_NUMBER = 'You must provide your previous employer street number.';
    private final String ERR_PREVIOUS_EMPLOYER_STREET_NAME = 'You must provide your previous employer street name.';
    private final String ERR_PREVIOUS_EMPLOYER_CITY = 'You must provide your previous employer city.';
    private final String ERR_PREVIOUS_EMPLOYER_PROVINCE = 'You must provide your previous employer province.';
    //private final String ERR_PREVIOUS_EMPLOYER_POSTAL_CODE = 'You must provide your previous employer postal code.';
    private final String ERR_HOW_LONG_PREVIOUS_EMPLOYER = 'You must provide how long you worked at your previous employer.';
    private final String ERR_PREVIOUS_GROSS_MONTHLY_INCOME = 'You must provide your previous gross monthly income.';

    // Step Four message
    private final String ERR_HOW_CONSUMER_LEGAL_CONSENT = 'Lending360 cannot proceed without your consent.';    
    private final String ERR_POLITICALLY_EXPOSED_FOREIGN_PERSON = 'You must answer the question regarding foreign politically relatives.';
    private final String ERR_THIRD_PARTY_DIRECTION = 'You must answer the question regarding third party direction.';
    private final String ERR_AFFRIM_SYSTEM_ERROR = 'System is unavailable currently. Please try again later or contact a representative.';
    
    //Risk Based Pricing
    private final String CC_HOME_OWNER_DISCLOSURE_STMT = 'Lending360 Credit Card - 29.99%';
    //private final String CC_RENTAL_DISCLOSURE_STMT = 'Lending360 Credit Card - 34.99%';
    private final String CC_RENTAL_DISCLOSURE_STMT = 'Lending360 Credit Card - 39.99%';
    private final String TL_DISCLOSURE_STMT = 'Lending360 Term Loan';  
    private final String MANITOBA_TL_DISCLOSURE_STMT = 'Lending360 Term Loan Manitoba Residents';
    private final String CC_PREFERRED_PARTNER_DISCLOSURE_STMT = 'Preferred Partner Disclosure Statement';
    
    //Manitoba Updates
    private final String MANITOBA_CC_HOME_OWNER_DISCLOSURE_STMT = 'Lending360 Credit Card Manitoba Residents - 29.99%';
    //private final String MANITOBA_CC_RENTAL_DISCLOSURE_STMT = 'Lending360 Credit Card Manitoba Residents - 34.99%';
    private final String MANITOBA_CC_RENTAL_DISCLOSURE_STMT = 'Lending360 Credit Card Manitoba Residents - 39.99%';
    private final String MANITOBA_CC_PREFERRED_PARTNER_DISCLOSURE_STMT = 'Preferred Partner Disclosure Statement - Manitoba Residents';      

    // Landing page
    private final String LANDING_PAGE = '/apex/ApplicationDecision';

    // Regexes for validation
    private final String REGEX_PHONE_NUMBER = '^\\(?([0-9]{3})\\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$';
    //private final String REGEX_EMAIL_ADDRESS = '^\\w+([\\.-]?\\w+)*@\\w+([\\.-]?\\w+)*(\\.\\w{2,3})+$';
    //private final String REGEX_POSTAL_CODE = '^[abceghjklmnprstvxyABCEGHJKLMNPRSTVXY]{1}\\d{1}[a-zA-Z]{1} *\\d{1}[a-zA-Z]{1}\\d{1}$';
    //private final String REGEX_CURRENCY= '^([0-9]+)(\\.[0-9][0-9])?$'; // no commas
    private final String REGEX_STREET_ADDRESS = '^(\\d+)?\\s+(.*?)$';
    
    //Risk Based Pricing
    public List<SelectOption> homeOwnerOptions {get;set;}
    public String selHomeOwnerOptions {get;set;}
    
    //to avoid Incomplete Application
    private Boolean avoidIncompleteApplication;

    public Lending360Controller() {
    
        //to avoid adjudicated application to be in incomplete application name
        avoidIncompleteApplication = false;
        
        personAccRecType = [
            select Id from RecordType where IsPersonType = true and SObjectType = 'Account' and DeveloperName = 'CustomerSalesforce'
        ];
        AppFormSettings = Application_Form_Settings__c.getOrgDefaults();

        Application = new Application__c();

        // Set disclosure URLs
        CreditCardDisclosureURL = AppFormSettings.Credit_Card_Disclosure_URL__c;
        LoanDisclosureURL = AppFormSettings.Loan_Disclosure_URL__c;
        
        //Risk Based Pricing
        creditCardRentalDisclosureURL = AppFormSettings.Credit_Card_Rental_Disclosure_URL__c;
        
        //Manitoba Disclosure changes
        manitobaLoanDisclosureURL = AppFormSettings.Manitoba_Loan_Disclosure_URL__c;
                
        //Manitoba Updates
        mbCreditCardDisclosureURL = AppFormSettings.MB_CC_Home_Owner_Disclosure_URL__c;
        mbCreditCardRentalDisclosureURL = AppFormSettings.MB_CC_Rental_Disclosure_URL__c;
        mbPreferredPartnerDisclosureURL = AppFormSettings.MB_CC_Preferred_Partner_Disclosure_URL__c;
                
        //RBP -4 Pillars
        preferredPartnerDisclosureURL  = AppFormSettings.Preferred_Partner_Disclosure_URL__c;
        isPreferredPartner = false;
        
        // Page needs access to placeholder values
        PlaceholderFirstName = 'First Name';
        PlaceholderMiddleName = 'Middle Name';
        PlaceholderLastName = 'Last Name';
        PlaceholderBirthdateYear = 'YYYY';
        PlaceholderBirthdateMonth = 'MM';
        PlaceholderBirthdateDay = 'DD';

        //LoanTypeOptions = getSelectOptions(Application__c.Loan_Type__c.getDescribe(), false, false);
        //System.debug('LoanTypeOptions: '+Application__c.Loan_Type__c.getDescribe());
        LoanTypeOptions = getEligibleProductOptions();
        IsLoan = false;

        // Build Salutation select list
        SalutationOptions = getSelectOptions(Contact.Salutation.getDescribe(), true, false);
        GenderOptions = getSelectOptions(Application__c.Gender__c.getDescribe(), false, true);

        // Build static Current BKCP select list
        CurrentBKCPOptions = getYesNoSelectOptions();

        // Build static Offer Code Available select list
        //OfferCodeAvailOptions = getYesNoSelectOptions();
        //SelOfferCodeAvail = NO_SEL_TEXT; // set default

        // Build static Authorized Credit Check select list
        AuthorizedCreditCheckOptions = getYesNoSelectOptions();

        // Build Communications Preference select list
        CommunicationsPreferenceOptions = getSelectOptions(Application__c.Communications_Preference__c.getDescribe(), false, true);

        // Build How Heard About Us select list
        HowHeardAboutUsOptions = getSelectOptions(Application__c.How_Did_You_Hear_About_Us__c.getDescribe(), false, true);

        // Build Referral Id select list
        ReferralIdOptions = getSelectOptions(Application__c.Referral_ID__c.getDescribe(), false, true);

        // Build Number of Dependants select list
        NumberOfDependantsOptions = getSelectOptions(Application__c.Number_of_Dependants__c.getDescribe(), false, true);

        // Build Number of Dependants select list
        MaritalStatusOptions = getSelectOptions(Application__c.Marital_Status__c.getDescribe(), false, true);
        
        
        // Build static Permanent Rent or Own select list
        PermanentRentOrOwnOptions = getPermanentRentOrOwnSelectOptions();
        
        //Risk Based Pricing
        //SelPermanentRentOrOwn = RENT_SEL_TEXT; // set default
                
        //Risk based pricing
        homeOwnerOptions = getYesNoSelectOptions();
        //selHomeOwnerOptions = NO_SEL_TEXT;
        
        // Build static Province select list
        ProvinceOptions = getStateSelectOptions();
        StateOptions = getStateSelectOptions();

        // Build static Permanent Province select list
        PermanentStateOptions = getStateSelectOptions();

        // Build static Previous Province select list
        //PreviousProvinceOptions = getProvinceSelectOptions();
        PreviousProvinceOptions = getStateSelectOptions();
        
        // Build static Employer Province select list
        //EmployerProvinceOptions = getProvinceSelectOptions();
        EmployerProvinceOptions = getStateSelectOptions();
        
        // Build static Previous Employer Province select list
        //PreviousEmployerProvinceOptions = getProvinceSelectOptions();
        PreviousEmployerProvinceOptions = getStateSelectOptions();
        
        // Build static Politically Exposed select list
        PoliticallyExposedForeignPersonOptions = getYesNoSelectOptions();
        SelPoliticallyExposedForeignPerson = NO_SEL_TEXT; // set default

        // Build static Third Party Direction select list
        ThirdPartyDirectionOptions = getYesNoSelectOptions();
        SelThirdPartyDirection = NO_SEL_TEXT; // set default

        // Create Province to Age Of Majority Map
        provinceToAgeOfMajorityMap = new Map<String, Integer>();
        provinceToAgeOfMajorityMap.put('AB', 18);
        provinceToAgeOfMajorityMap.put('BC', 19);
        provinceToAgeOfMajorityMap.put('MB', 18);
        provinceToAgeOfMajorityMap.put('NB', 18);
        provinceToAgeOfMajorityMap.put('NL', 19);
        provinceToAgeOfMajorityMap.put('NT', 19);
        provinceToAgeOfMajorityMap.put('NS', 19);
        provinceToAgeOfMajorityMap.put('NU', 19);
        provinceToAgeOfMajorityMap.put('ON', 18);
        provinceToAgeOfMajorityMap.put('PE', 18);
        //provinceToAgeOfMajorityMap.put('Quebec', 18); TODO: No Quebec?
        provinceToAgeOfMajorityMap.put('SK', 18);
        provinceToAgeOfMajorityMap.put('YT', 19);
        

        // Initialize variables related to Person Record state
        PersonAlreadyLoaded = false; 
        PersonFoundViaQuery = false;
        PersonInserted = false;

        // Load account, if id is passed
        List<Account> existingAccList = null;
        String accountId = ApexPages.currentPage().getParameters().get('id');
        if (accountId != null) {
            existingAccList = [
                Select Id, FirstName, Middle_Name__pc, LastName, SF_ID__c,
                    Salutation, PersonBirthdate, 
                    PersonHomePhone, PersonEmail, Gender__pc, 
                    SIN__pc, PersonMobilePhone, Work_Phone__pc, 
                    Communication_Preference__pc, Marital_Status__pc,
                    Number_of_Dependants__pc, Home_Owner__pc, Monthly_Home_Expense__pc,
                    Monthly_Expense__pc, PersonMailingStreet, PersonMailingCity, 
                    PersonMailingState, PersonMailingPostalCode,
                    Employer_Name__pc, Employer_Phone__pc,
                    Employer_Street_Name__pc, Employer_Street_Number__pc,
                    Employer_City__pc, Employer_Province__pc,
                    Employer_Postal_Code__pc, Occupation__pc, 
                    Employment_Years__pc, Employment_Months__pc, Gross_Monthly_Income__pc
                from Account where Id = :accountId 
            ];
        }

        if (existingAccList != null && !existingAccList.isEmpty()) {
            PersonAccount = existingAccList[0];
            //personAccSFID = PersonAccount.SF_ID__c; //ToDO Check
            PersonAlreadyLoaded = true;

            // Populate non-bound fields
            SelSalutation = PersonAccount.Salutation;
            FirstName = PersonAccount.FirstName;
            MiddleName = PersonAccount.Middle_Name__pc;
            LastName = PersonAccount.LastName;
            SelProvince = PersonAccount.PersonMailingState;
            
            if (PersonAccount.PersonBirthdate != null) {
                BirthdateYear = PersonAccount.PersonBirthdate.year();
                BirthdateMonth = PersonAccount.PersonBirthdate.month();
                BirthdateDay = PersonAccount.PersonBirthdate.day(); 
            }

            SelGender = PersonAccount.Gender__pc;
            SelMaritalStatus = PersonAccount.Marital_Status__pc;
            SelEmployerProvince = PersonAccount.Employer_Province__pc;
            SelNumberOfDependants = PersonAccount.Number_of_Dependants__pc;
            SelPermanentRentOrOwn = PersonAccount.Home_Owner__pc;
            SelPermanentState = PersonAccount.PersonMailingState;

            // Other PersonAccount fields
            Application.Home_Phone__c = PersonAccount.PersonHomePhone;
            Application.Email_Address__c = PersonAccount.PersonEmail;
            Application.SIN__c = PersonAccount.SIN__pc;
            Application.Cell_Phone__c = PersonAccount.PersonMobilePhone;
            Application.Work_Phone__c = PersonAccount.Work_Phone__pc;
            Application.Communications_Preference__c = PersonAccount.Communication_Preference__pc;
            Application.Housing_Costs__c = PersonAccount.Monthly_Home_Expense__pc;
            Application.Monthly_Expenses__c = PersonAccount.Monthly_Expense__pc;
            
            // PersonMailingStreet is a compound field (street # and name)
            if (PersonAccount.PersonMailingStreet != null) {
                Pattern streetPattern = Pattern.compile(REGEX_STREET_ADDRESS);
                Matcher streetMatcher = streetPattern.matcher(PersonAccount.PersonMailingStreet);

                if (streetMatcher.matches()) {
                    Application.Permanent_Address_Street_Number__c = streetMatcher.group(1);
                    Application.Permanent_Address_Street_Name__c = streetMatcher.group(2);
                } 
            }

            Application.Permanent_Address_City__c = PersonAccount.PersonMailingCity;
            Application.Permanent_Address_PostalCode__c = PersonAccount.PersonMailingPostalCode;
            

            Application.Employer_Name__c = PersonAccount.Employer_Name__pc;
            Application.Employer_Phone__c = PersonAccount.Employer_Phone__pc;
            Application.Employer_Street_Name__c = PersonAccount.Employer_Street_Name__pc;
            Application.Employer_Street_Number__c = PersonAccount.Employer_Street_Number__pc;
            Application.Employer_City__c = PersonAccount.Employer_City__pc;
            Application.Employer_PostalCode__c = PersonAccount.Employer_Postal_Code__pc;
            Application.Occupation__c = PersonAccount.Occupation__pc;
            Application.Employment_Years__c = PersonAccount.Employment_Years__pc;
            Application.Employment_Months__c = PersonAccount.Employment_Months__pc;
            Application.Gross_Monthly_Income__c = PersonAccount.Gross_Monthly_Income__pc;

        } else {
            PersonAlreadyLoaded = false;
            PersonAccount = new Account(RecordTypeId = personAccRecType.Id);
        }

        //String csTrackerId = ApexPages.currentPage().getParameters().get('csTrackId');
        //if (String.isNotBlank(csTrackerId)) {
        //   Application.Commission_Soup_Tracker_Id__c = csTrackerId;
        // }
         
        //Get All Tracking Code Records
        /*
        List<Tracking_Code__c> trackingCodeRecords = Tracking_Code__c.getAll().values();
        //System.debug('trackingCodeRecords size :'+trackingCodeRecords.size());
        
        //Create Map for Tracking Code Records
        Map<String, String> trackingCodeMap = new Map<String, String>();       
        for(Tracking_Code__c trackingCodeRecord : trackingCodeRecords){
            trackingCodeMap.put(trackingCodeRecord.Param_Name__c ,trackingCodeRecord.Param_Value__c);
            //System.debug('trackingCodeRecord.Param_Name__c :'+trackingCodeRecord.Param_Name__c);
            //System.debug('trackingCodeRecord.Param_Value__c :'+trackingCodeRecord.Param_Value__c);
        }
        
        //Set value for Client IP
        String clientIP = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('clientIP'));
        if (String.isNotBlank(clientIP)){
            Application.Client_IP__c = clientIP;
        }
        
        //Capture user's location via IP address - Set Geo City, Geo Province, Geo Country
        String geoCity = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('geoCity'));
        if (String.isNotBlank(geoCity)){
            Application.Geo_City__c = geoCity;
        }
        
        String geoProvince = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('geoProvince'));
        if (String.isNotBlank(geoProvince)){
            Application.Geo_Province__c = geoProvince;
        }
        
        String geoCountry = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('geoCountry'));
        if (String.isNotBlank(geoCountry)){
            Application.Geo_Country__c = geoCountry;
        }
        
        //Set value for csTrackerId
        String csTrackId = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('csTrackId'));
        if (String.isNotBlank(csTrackId)){
            Application.Commission_Soup_Tracker_Id__c = csTrackId;
        }
        
        //Set value for acquisitionCode
        String acquisitionCode = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('acquisitionCode'));
        System.debug('trackingCodeMap.getacquisitionCode'+ trackingCodeMap.get('acquisitionCode'));
        System.debug('acquisitionCode   :'+acquisitionCode);
        if (String.isNotBlank(acquisitionCode)){
            Application.acquisition_Code__c = acquisitionCode;
        }
        //System.debug('Application.acquisition_Code__c :'+Application.acquisition_Code__c);
       
        
        //Set value for offerCode
        
        String offerCode = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('offerCode'));
        if (String.isNotBlank(offerCode)){
            Application.Offer_Code__c = offerCode;   
            SelOfferCodeAvail = YES_SEL_TEXT; 
        }
        else{
            SelOfferCodeAvail = NO_SEL_TEXT;// set default
        }
        
        //Base64 encoded referral url
        String referralURL;
        String b64RefUrl = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('referralURL'));
        System.debug('b64RefUrl :'+b64RefUrl);
        if (String.isNotBlank(b64RefUrl)){
            try{
                Blob base64StringBlob = EncodingUtil.base64Decode(b64RefUrl);
                referralURL = base64StringBlob.toString();
                Application.Referral_URL__c = referralURL;
                System.debug('referralURL :'+referralURL);
             }
             catch(Exception exp){
                System.debug('referralURL Exp:'+exp);   
             }   
        }
                
        //CS Tracking update
        //Set Email Address
        String email = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('email'));
        if (String.isNotBlank(email)){
            Application.Email_Address__c = email;
        }
        
        //Set Last Name
        String lstName = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('lastName'));
        if (String.isNotBlank(lstName)){
            LastName = lstName;
        }
        
        //Set First Name
        String fstName = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('firstName'));
        if (String.isNotBlank(fstName)){
            FirstName = fstName;
        }
        
        //Set PO Box Number
        String poBoxNum = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('poBox'));
        if (String.isNotBlank(poBoxNum)){
            poBoxNum = replaceAmpersand(poBoxNum);
            Application.Permanent_Address_PO_Box__c = poBoxNum;
        }
        
        //Set Street Number
        String streetNum = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('streetNumber'));
        if (String.isNotBlank(streetNum)){
            streetNum = replaceAmpersand(streetNum);
            Application.Permanent_Address_Street_Number__c = streetNum;
        }
        
        //Set Street Name todo
        String stretName = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('streetName'));
        if (String.isNotBlank(stretName)){
            stretName = replaceAmpersand(stretName);
            Application.Permanent_Address_Street_Name__c = stretName;
        }
        
        //Set Unit Number
        String unitNum = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('unitNumber'));
        if (String.isNotBlank(unitNum)){
            unitNum = replaceAmpersand(unitNum);
            Application.Permanent_Address_Unit_Number__c = unitNum;
        }
        
        //Set City Name todo
        String cityName = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('city'));
        if (String.isNotBlank(cityName)){
            cityName = replaceAmpersand(cityName);
            Application.Permanent_Address_City__c = cityName;
        }
        
        //Set Province
        String StateName = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('province'));
        if (String.isNotBlank(StateName)){
            //provinceName = replaceAmpersand(provinceName);
            
            for(SelectOption s : PermanentStateOptions){
                if(s.getValue() == StateName)
                    SelPermanentState = s.getValue();
                    SelState = SelPermanentState; //s.getValue();
            }
            //PermanentProvinceOptions.setLabel(provinceName);
        }
        
        //Set Postal Code
        String postalCodeNum = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('postalCode'));
        if (String.isNotBlank(postalCodeNum)){
            Application.Permanent_Address_PostalCode__c = postalCodeNum;
        }
        
        //Set Home Phone Number
        String phoneNum = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('phoneNumber'));
        if (String.isNotBlank(phoneNum)){
            Application.Home_Phone__c = phoneNum;
        }
                
        //Set value for referralId
        String referralId = ApexPages.currentPage().getParameters().get(trackingCodeMap.get('referralId'));        
        if(String.isNotBlank(referralId)){
            Application.Referral_Id__c = referralId;
            
            //Incorrect interest rate for preferred partners - incidenet 44
            //SelReferralId = referralId;
            
            //RBP -4 Pillars -Exception Process, Check ReferralID exist in Custom Setting
            Preferred_Partners__c partnerExist;
            try{
                //Custom Setting Name Limit Work Around
                if(referralId.length() > 38){
                    //Incorrect interest rate for preferred partners - incidenet 44
                    partnerExist = Preferred_Partners__c.getValues((referralId.subString(0,38)).toLowerCase());    
                }
                else{
                    //Incorrect interest rate for preferred partners - incidenet 44
                    partnerExist = Preferred_Partners__c.getValues(referralId.toLowerCase());
                }
            }
            catch(Exception exp){
                System.debug('Error :'+exp);
            } 
            
            if(partnerExist != null){
                isPreferredPartner = true;
            }            
        }
        */
        
        //Manitoba Disclosure changes
        //isManitobaResident = false;
    }

    public PageReference saveStepZero() {
        
        if(avoidIncompleteApplication == true){
            return urlForDecisionPage();
        }
        
        Boolean noValidationErrors = validateStepZero();

        // Return if any validation errors exist
        if (noValidationErrors == false) {
            return null;
        }
        
        IsLoan = String.isNotBlank(Application.Loan_Type__c) && Application.Loan_Type__c.contains('Term Loan');
        
        
        //Manitoba Disclosure changes
        /*
        if(String.isNotBlank(SelProvince) && SelProvince.equalsIgnoreCase('MB')){
            isManitobaResident = true;
        }
        else{
            isManitobaResident = false;
        }
        */
        
        //Risk Based Pricing
        Application.Has_Accepted_Disclosure_Terms__c = false;
        
        //Manitoba Updates
        Application.Has_Accepted_Personal_Consent_Terms__c = false;
                
        return null;
    }

    public PageReference saveStepOne() {
                
        if(avoidIncompleteApplication == true){
            return urlForDecisionPage();
        }
        
        Boolean noValidationErrors = validateStepOne();

        // Return if any validation errors exist
        if (noValidationErrors == false) {
            return null;
        }
        
        // Query for existing customer, if not already loaded
        PersonFoundViaQuery = false;
        if (PersonAlreadyLoaded == false ) {
            
            //Updated by A5E Consulting
            //Ingest flow - Customer Matching Changes - comment this
            // Check if Person already exists:
            //   1. Exact match on Last Name and SIN
            //   2. Exact match on Last Name, Birthdate, and First Name
            //   3. Exact match on Last Name, Email, and first letter of First Name
            
            //Exact Match           
            List<Account> exactMatchList = PotentialMatchUtil.getExactMatchList(Application);   
            if (!exactMatchList.isEmpty()){
                
                if(exactMatchList.size() > 1){
                    Application.Needs_Manual_Review__c = true;
                    Application.Manual_Review_Reason__c = PotentialMatchUtil.MANUAL_REVIEW_REASON_MULTIPLE_EXACT_MATCHES;
                }  
                
                //Assign the Application to latest Account
                PersonFoundViaQuery = true;
                PersonAccount.Id = exactMatchList[0].Id; 
                //personAccSFID = exactMatchList[0].SF_ID__c;  //ToDo Check           
            } 
            else{
                //Uncertain Match
                List<Account> uncertainMatchList = PotentialMatchUtil.getUncertainMatchList(Application);
                
                if (!uncertainMatchList.isEmpty()){
                    Application.Needs_Manual_Review__c = true;
                    Application.Manual_Review_Reason__c = PotentialMatchUtil.MANUAL_REVIEW_REASON_MULTIPLE_UNCERTAIN_MATCHES;
                    
                    //Assign the Application to latest Account
                    PersonFoundViaQuery = true;
                    PersonAccount.Id = uncertainMatchList[0].Id; 
                    //personAccSFID = uncertainMatchList[0].SF_ID__c; //ToDO Check
                }               
            } 
        }

        // Offer code logic
        /*
        if (SelOfferCodeAvail == YES_SEL_TEXT) {
            // Query for promotional campaigns using offer code
            List<Campaign> existingCampaignList = [
                select Id, StartDate, EndDate, Public_Offer_Code__c, Offer_Code_Origination_System_Id__c,
                       Correct_Code_Non_Member_Warning__c, 
                       (select Contact.FirstName, Contact.LastName from CampaignMembers)
                from Campaign
                where Offer_Code__c = :Application.Offer_Code__c
            ];

            Campaign offer;
            if (!existingCampaignList.isEmpty()) {
                offer = existingCampaignList[0];

                // Check if offer has expired?
                Date startDate = offer.StartDate;
                Date endDate = offer.EndDate;
                Date now = Date.today();
                if (startDate != null && endDate != null) {
                    if (now >= startDate && now < endDate) {
                        isValidOfferCode = true;
                        
                        if (offer.Public_Offer_Code__c == false) {
                            // Loop over Campaign Members, check against PersonAccount 
                            // If no match, save Correct_Code_Non_Member_Warning__c
                            Boolean isCampaignMember = false;
                            for (CampaignMember m : offer.CampaignMembers) {
                                if (PersonAccount.FirstName == m.Contact.FirstName &&
                                    PersonAccount.LastName == m.Contact.LastName) {
                                    isCampaignMember = true;
                                }
                            }

                            isValidOfferCode = true;
                            if (isCampaignMember == false) {
                                // Set non member message to display later
                                nonCampaignMemberMessage = offer.Correct_Code_Non_Member_Warning__c;
                            }
                        }
                    } else {
                        // Campaign expired
                        isValidOfferCode = false;
                    }
                } else {
                    // Campaign start or end date missing
                    isValidOfferCode = false;   
                } 
            } else {
                // No campaign found
                isValidOfferCode = false;
            }

            if (isValidOfferCode == false) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_INVALID_OFFER_CODE));
                return null;
            } else {
                Application.Offer_Code_Origination_System_Id__c = offer.Offer_Code_Origination_System_Id__c;
            }
        } else {
            Application.Offer_Code__c = null;
            Application.Offer_Code_Origination_System_Id__c = null;
        }   
        */ 
        
        return null;        
    }

    public PageReference saveStepTwo() {
        
        if(avoidIncompleteApplication == true){
            return urlForDecisionPage();
        }
        
        Decimal CC_PREFERRED_PARTNER_INTEREST_RATE = AppFormSettings.CC_PREFERRED_PARTNER_INTEREST_RATE__c;//29.99  
        Decimal CC_HOME_OWNER_INTEREST_RATE = AppFormSettings.CC_HOME_OWNER_INTEREST_RATE__c;//29.99
        Decimal CC_RENTAL_INTEREST_RATE = AppFormSettings.CC_RENTAL_INTEREST_RATE__c;//34.99
        String CC_PREFERRED_PARTNER_INTEREST_RATE_CODE = AppFormSettings.CC_PREFERRED_PARTNER_INTEREST_RATE_CODE__c;//'OTB1'
        String CC_HOME_OWNER_INTEREST_RATE_CODE = AppFormSettings.CC_HOME_OWNER_INTEREST_RATE_CODE__c;//'OTB2'
        String  CC_RENTAL_INTEREST_RATE_CODE = AppFormSettings.CC_RENTAL_INTEREST_RATE_CODE__c; //'OTB3'
        
        //Risc Based Pricing
        if((String.isNotBlank(SelLoanType)) && (SelLoanType == CREDIT_CARD)){ 
                    
            if(!String.isBlank(selHomeOwnerOptions)){
                if(selHomeOwnerOptions == YES_SEL_TEXT){
                    SelPermanentRentOrOwn = OWN_SEL_TEXT;           
                }
                else if(selHomeOwnerOptions == NO_SEL_TEXT){
                    SelPermanentRentOrOwn = RENT_SEL_TEXT;
                }   
            } 
        } 
        
        // Validate variables, and if okay, bind any unbound variables to appropriate object fields
        Boolean noValidationErrors = validateStepTwo();

        // If no validation errors, and Person Account not already loaded upon initialization
        // and not found via query in Step One, and not already inserted (if re-doing Step Two) 
        // -- create Person Account based on input thus far
        if (noValidationErrors && PersonAlreadyLoaded == false && PersonFoundViaQuery == false && PersonInserted == false) {
            
            // Initialize record
            PersonAccount.Salutation = Application.Salutation__c;
            PersonAccount.FirstName = Application.First_Name__c;
            PersonAccount.Middle_Name__pc = Application.Middle_Name__c;
            PersonAccount.LastName = Application.Last_Name__c;
            PersonAccount.PersonBirthdate = Application.Birth_Date__c;
            PersonAccount.PersonMailingState = Application.Province__c;
            PersonAccount.PersonEmail = Application.Email_Address__c;
            PersonAccount.SIN__pc = Application.SIN__c;
            PersonAccount.Gender__pc = Application.Gender__c;
            PersonAccount.PersonHomePhone = Application.Home_Phone__c;
            PersonAccount.PersonMobilePhone = Application.Cell_Phone__c;
            PersonAccount.Work_Phone__pc = Application.Work_Phone__c;
            PersonAccount.Communication_Preference__pc = Application.Communications_Preference__c;
            PersonAccount.Number_of_Dependants__pc = Application.Number_of_Dependants__c;
            PersonAccount.Marital_Status__pc = Application.Marital_Status__c;
            PersonAccount.Home_Owner__pc = Application.Home_Owner__c;
            PersonAccount.Monthly_Home_Expense__pc = Application.Housing_Costs__c;
            PersonAccount.Monthly_Expense__pc = Application.Monthly_Expenses__c;
            PersonAccount.PersonMailingStreet = Application.Permanent_Address_Street_Number__c + 
                ' ' + Application.Permanent_Address_Street_Name__c;
            PersonAccount.PersonMailingCity = Application.Permanent_Address_City__c;
            PersonAccount.PersonMailingState = Application.Permanent_Address_Province__c;
            PersonAccount.PersonMailingPostalCode = Application.Permanent_Address_PostalCode__c;

            insert PersonAccount;

            // We need to retrieve the SF_ID__c field
            //ToDo Check
            /*
            Account temp = [select SF_ID__c from Account where Id =: PersonAccount.Id];
            personAccSFID = temp.SF_ID__c;
            */
            
            PersonInserted = true;     
        }

        // Set Internal or External
        Application.Application_Completed_From__c = Utilities.getInternalOrExternal();
        
        // Link Application to Person Account
        Application.Customer__c = PersonAccount.Id;
        Application.Name = Utilities.getAppName();
        Application.Disclosure_Statement_Presented__c = 'Sample statement';
        Application.Interest_Rate__c = 29.9;
        Application.Interest_Rate_Code__c = 'Sample Rate Code';         

        upsert application;
        return null;
    }

    public PageReference saveStepThree() {
        
        if(avoidIncompleteApplication == true){
            return urlForDecisionPage();
        }
        
        // Validate variables, and if okay, bind any unbound variables to appropriate object fields
        Boolean noValidationErrors = validateStepThree();

        update application;
        return null;
    }

    public PageReference saveStepFour() {
        
        if(avoidIncompleteApplication == true){
            return urlForDecisionPage();
        }
        
        Boolean noValidationErrors = validateStepZero() && validateStepOne() && validateStepTwo() && validateStepThree();

        // Consumer Legal Consent
        if (isConsumerLegalConsent == true) {
            Application.Consumer_Legal_Consent__c = TRUE_TEXT;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_HOW_CONSUMER_LEGAL_CONSENT));
            noValidationErrors = false;
        }

        // Politically Exposed Foreign Person
        if (String.isNotBlank(SelPoliticallyExposedForeignPerson) && 
            validateSelectValue(getYesNoSelectOptions(), SelPoliticallyExposedForeignPerson)) {
            Application.Politically_Exposed_Foreign_Person__c = SelPoliticallyExposedForeignPerson == YES_SEL_TEXT ? true : false;  
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_POLITICALLY_EXPOSED_FOREIGN_PERSON));
            noValidationErrors = false; 
        }

        // Third Party Direction
        if (String.isNotBlank(SelThirdPartyDirection) && 
            validateSelectValue(getYesNoSelectOptions(), SelThirdPartyDirection)) {
            Application.Third_Party_Direction__c = SelThirdPartyDirection == YES_SEL_TEXT ? true : false;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_THIRD_PARTY_DIRECTION));
            noValidationErrors = false; 
        }       

        // Return if validation errors
        if (noValidationErrors == false) {
            return null;
        }
        
        /*        
        Utilities.updateFixedApplicationData(application);
        */

        PageReference decisionPage = new PageReference(LANDING_PAGE);
        Map<String, String> params = decisionPage.getParameters();
        
        
        Application.Application_Completed_Submitted__c = true;    
        
        if((String.isBlank(selHomeOwnerOptions) || selHomeOwnerOptions == No_SEL_TEXT) && (String.isBlank(SelPermanentRentOrOwn) || SelPermanentRentOrOwn == RENT_SEL_TEXT)){
            Application.Mortgage_With__c = null;
        } 
        
        // Update Application
        if (Application.Marketing_Consent__c == true) {
            Application.Marketing_Consent_Date__c = Date.today();
        }    
        
        
        //Decision Making
        calculateApprovedAmount(Application);

        params.put('applnId', Application.Id);
        decisionPage.setRedirect(true);        
        
        return decisionPage;
    }
    
    private void calculateApprovedAmount(Application__c app){
      
      //Requested_Credit_Limit__c
      if(app.Requested_Credit_Limit__c < 5000){
        app.Decision__c = 'Approved';
        app.Application_Status__c = 'System Approved';
        app.Approved_Amount__c = app.Requested_Credit_Limit__c;
        
        //Email Authentication
          Datetime current = Datetime.now();
          String hashString = application.Id + current.formatGmt('yyyyMMddHHmmssSSS');
          Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));            
          application.Verification_Auth_Token__c = EncodingUtil.convertToHex(hash);
          application.Verification_Sent_Date__c = system.now();
          application.Verification_Status__c = 'Automated Email Sent';
          application.Verification_Expiration_Date__c = system.now().addDays(2);
      }
      else if(app.Requested_Credit_Limit__c >= 5000 && app.Requested_Credit_Limit__c < 25000){
        getDecisionBasedonRank(app);
      }
      else if(app.Requested_Credit_Limit__c >= 25000){
        app.Decision__c = 'Declined';
        app.Approved_Amount__c = 0;
        app.Application_Status__c = 'System Declined';
        app.Decline_Reason__c = 'Criteria Not Matched';
      }     
      
      app.Decision_Timestamp__c = System.now();
       
      update app;
    }
    
    private void getDecisionBasedonRank(Application__c app){
        
        Integer decisionRank = 0;
      
        //Salary Decision Rank
        Map <String, Integer> incomeMap = new Map <String, Integer>();
        incomeMap.put('A', 4);
        incomeMap.put('B', 3);
        incomeMap.put('C', 2);
        incomeMap.put('D', 1);
          
        String salaryRank = 'D';
        if(app.Gross_Monthly_Income__c != null){
            if(app.Gross_Monthly_Income__c <= 25000){
                salaryRank = 'D';
            }
            else if(app.Gross_Monthly_Income__c >= 25001 && app.Gross_Monthly_Income__c  <= 50000){
              salaryRank = 'C';
            }
            else if(app.Gross_Monthly_Income__c >= 50001 && app.Gross_Monthly_Income__c  <= 75000){
              salaryRank = 'B';
            }
            else if(app.Gross_Monthly_Income__c >= 75001){
              salaryRank = 'A';
            }
        
            Integer salaryDecisionRank = incomeMap.get(salaryRank);
            if(salaryDecisionRank != null){
                decisionRank = salaryDecisionRank + decisionRank;
            }
        } 
      
        //Dependents Decision Rank
        Map <String, Integer> dependentsMap = new Map <String, Integer>();
        dependentsMap.put('0', 4);
        dependentsMap.put('1', 3);
        dependentsMap.put('2', 2);
        dependentsMap.put('3', 1);
        dependentsMap.put('More', 1);
        
        Integer dependentsDecisionRank = dependentsMap.get(app.Number_of_Dependants__c);
        if(dependentsDecisionRank != null){
            decisionRank = dependentsDecisionRank + decisionRank;
        }
      
        //Emplyment Status Decision Rank
        Map <String, Integer> emplymentStatusMap = new Map <String, Integer>();
        emplymentStatusMap.put('Full-time', 4);
        emplymentStatusMap.put('Full-time', 3);
        emplymentStatusMap.put('Part-time', 2);
        emplymentStatusMap.put('Unemployed', 1);
        emplymentStatusMap.put('Retired', 1);
        Integer emplymentStatusDecisionRank = dependentsMap.get(app.Employment_Status__c);
        if(emplymentStatusDecisionRank != null){
            decisionRank = emplymentStatusDecisionRank + decisionRank;
        }
      
        //Home Ownership Decision Rank
        Map <String, Integer> homeOwnershipMap = new Map <String, Integer>();
        homeOwnershipMap.put('Own Property', 4);
        homeOwnershipMap.put('Rent', 1);
        Integer homeOwnershipDecisionRank = homeOwnershipMap.get(app.Employment_Status__c);
        if(homeOwnershipDecisionRank != null){
            decisionRank = homeOwnershipDecisionRank + decisionRank;
        }
    
        Decimal decisionRankPct = (decisionRank/4) * 100;
    
        app.Decision__c = 'Needs Review';
        if(decisionRankPct < 25){
            app.Decision__c = 'Declined';
            app.Approved_Amount__c = 0;
            app.Application_Status__c = 'System Declined';
            app.Decline_Reason__c = 'Application Rank Very Low';
        }
        else if(decisionRankPct >= 25 && app.Requested_Credit_Limit__c < 75){
            app.Decision__c = 'Needs Review';
            app.Application_Status__c = 'Needs Review';
        }
        else if(decisionRankPct >= 75){
            app.Decision__c = 'Approved';
            app.Application_Status__c = 'System Approved';
        }  
      
        app.Approved_Amount__c = (app.Requested_Credit_Limit__c * decisionRankPct) / 100;      
    }

    private Boolean validateStepZero() {
        Boolean noValidationErrors = true;

        if (String.isNotBlank(SelLoanType) && validateSelectValue(LoanTypeOptions, SelLoanType)) {
            Application.Loan_Type__c = SelLoanType;             
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_LOAN_TYPE));
            noValidationErrors = false;
        }
        
        //Risk Based Pricing
        if((String.isNotBlank(SelLoanType)) && (SelLoanType == CREDIT_CARD)){
            if(String.isBlank(selHomeOwnerOptions)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_HOME_OWNER));
                noValidationErrors = false;
            }
        }
        
        //Manitoba Disclosure changes
        // Province
        if (String.isNotBlank(SelState) && validateSelectValue(getStateSelectOptions(), SelState)) {
            Application.Province__c = SelState;              
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PROVINCE));
            noValidationErrors = false; 
        }
        
        return noValidationErrors;
    }
    
    private Boolean validateStepOne() {
        // For bound fields, only validate that a value is provided (if required)
        // For unbound fields, enforce field-specific constraints and then assign to appropriate object fields

        Boolean noValidationErrors = true;

        // Validate fields, and assign them  to appropriate object fields if unbound
        
        // Has Accepted Disclosure Terms
        if (Application.Has_Accepted_Disclosure_Terms__c != true) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_HAS_ACCEPTED_DISCLOSURE_TERMS));
            noValidationErrors = false;
        }
        
        // Manitoba Updates - Has accepted Personal Consent
        // Has Accepted Disclosure Terms
        /*
        if(isManitobaResident == true){
          if (Application.Has_Accepted_Personal_Consent_Terms__c != true) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_HAS_ACCEPTED_PERSONAL_CONSENT));
              noValidationErrors = false;
          }
        } 
        */               

        // Salutation
        if (String.isNotBlank(SelSalutation) && validateSelectValue(Contact.Salutation.getDescribe(), SelSalutation)) {
            Application.Salutation__c = SelSalutation;              
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_SALUTATION));
            noValidationErrors = false; 
        }

        // First Name
        if (String.isNotBlank(FirstName)) {
            Application.First_Name__c = FirstName.trim();
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_FIRST_NAME));
            noValidationErrors = false;     
        }

        // Middle Name (not required, just assign it if it's not blank)
        if (String.isNotBlank(MiddleName)) {
            Application.Middle_Name__c = MiddleName.trim();
        } 

        // Last Name
        if (String.isNotBlank(LastName)) {
            Application.Last_Name__c = LastName.trim();
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_LAST_NAME));
            noValidationErrors = false;     
        }

        // Birth date
        // Note: If user enters 2015 / 15 / 35 ... the date will
        // simply roll over. Thus we won't show an error in this case.
        if (BirthdateYear != null && BirthdateYear != 0 && 
            BirthdateMonth != null && BirthdateMonth != 0 &&
            BirthdateDay != null && BirthdateDay != 0) {
            try {
                Application.Birth_Date__c = Date.newInstance(BirthdateYear, BirthdateMonth, BirthdateDay);
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_BIRTH_DATE));
                noValidationErrors = false; 
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_BIRTH_DATE));
            noValidationErrors = false; 
        }

        // SIN (optional)
        // if entered, validate that it is all numbers
        // if (String.isNotBlank(Application.SIN__c) && 
        //     (Application.SIN__c.isNumeric() == false || Application.SIN__c.length() != 9)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_SIN));
        //    noValidationErrors = false; 
        //}

    
        // Employment status (required)
        if (String.isBlank(Application.Employment_Status__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_EMPLOYMENT_STATUS));
            noValidationErrors = false;     
        } else if (Application.Employment_Status__c == 'Unemployed' || Application.Employment_Status__c == 'Student') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_EMPLOYMENT_STATUS_UNQUALIFIED));
            noValidationErrors = false;     
        }

        // Current Bankruptcy
        /*
        if (String.isNotBlank(SelCurrentBKCP) && validateSelectValue(getYesNoSelectOptions(), SelCurrentBKCP)) {
            if (SelCurrentBKCP == YES_SEL_TEXT) {
                Application.Current_BKCP__c = true; 
            } else {
                Application.Current_BKCP__c = false;
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_CURRENT_BKCP));
            noValidationErrors = false;
        }
        */

        // Requested credit limit (required)
        if (Application.Requested_Credit_Limit__c == null || Application.Requested_Credit_Limit__c == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_REQUESTED_CREDIT_LIMIT));
            noValidationErrors = false;     
        }

        // Authorized credit check
        if (String.isNotBlank(SelAuthorizedCreditCheck) && SelAuthorizedCreditCheck == YES_SEL_TEXT) {
            Application.Authorized_Credit_Check__c = true;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_AUTHORIZED_CREDIT_CHECK));
            noValidationErrors = false;
        }
        
        // Validate Province + Age
       /* if (Application.Birth_Date__c != null && Application.Province__c != null) {
            Integer ageOfMajority = provinceToAgeOfMajorityMap.get(Application.Province__c);
            Date thresholdDate = Application.Birth_Date__c.addYears(ageOfMajority);

            if (Date.today() < thresholdDate) {
                // Return error message
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_AGE_OF_MAJORITY));
                novalidationErrors = false;
            }           
        }
        */
        
        return noValidationErrors;
    }

    private Boolean validateStepTwo() {
        Boolean noValidationErrors = true;
        // Gender
        if (String.isNotBlank(SelGender) && validateSelectValue(Application__c.Gender__c.getDescribe(), SelGender)) {
            Application.Gender__c = SelGender;              
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_GENDER));
            noValidationErrors = false;             
        }

        Pattern phonePattern = Pattern.compile(REGEX_PHONE_NUMBER);

        // Home Phone
        if (String.isBlank(Application.Home_Phone__c) || phonePattern.matcher(Application.Home_Phone__c).matches() == false) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_HOME_PHONE));
            noValidationErrors = false;   
        }

        // Cell Number (not required)
        if (String.isNotBlank(Application.Cell_Phone__c) && phonePattern.matcher(Application.Cell_Phone__c).matches() == false) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_CELL_PHONE));
            noValidationErrors = false;       
        }

        // Work Phone
        if (String.isBlank(Application.Work_Phone__c) || phonePattern.matcher(Application.Work_Phone__c).matches() == false) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_WORK_PHONE));
            noValidationErrors = false; 
        }

        // Communications Preference (not required)
        if (String.isNotBlank(SelCommunicationsPreference)) {
            if (validateSelectValue(Application__c.Communications_Preference__c.getDescribe(), SelCommunicationsPreference)) {
                Application.Communications_Preference__c = SelCommunicationsPreference; 
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_COMMUNICATIONS_PREFERENCE));
                noValidationErrors = false;  
                     
            }
        }  

        // How did you hear about us (not required)
        if (String.isNotBlank(SelHowHeardAboutUs)) { 
            if (validateSelectValue(Application__c.How_Did_You_Hear_About_Us__c.getDescribe(), SelHowHeardAboutUs)) {
                Application.How_Did_You_Hear_About_Us__c = SelHowHeardAboutUs;
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_HOW_HEARD_ABOUT_US));
                noValidationErrors = false;
            }
        } 
       

        // Number of Dependants
        if (String.isNotBlank(SelNumberOfDependants) && 
            validateSelectValue(Application__c.Number_of_Dependants__c.getDescribe(), SelNumberOfDependants)) {
            Application.Number_of_Dependants__c = SelNumberOfDependants;                
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_NUMBER_OF_DEPENDANTS));
            noValidationErrors = false;
        }

        // Marital Status
        if (String.isNotBlank(SelMaritalStatus) && 
            validateSelectValue(Application__c.Marital_Status__c.getDescribe(), SelMaritalStatus)) {
            Application.Marital_Status__c = SelMaritalStatus;               
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_MARITAL_STATUS));
            noValidationErrors = false; 
        }

        // Permanent Address Street Number
        if (String.isBlank(Application.Permanent_Address_Street_Number__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PERMANENT_ADDRESS_STREET_NUMBER));
            noValidationErrors = false;  
        }

        // Permanent Address Street Name
        if (String.isBlank(Application.Permanent_Address_Street_Name__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PERMANENT_ADDRESS_STREET_NAME));
            noValidationErrors = false; 
        }

        // Permanent Address City
        if (String.isBlank(Application.Permanent_Address_City__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PERMANENT_ADDRESS_CITY));
            noValidationErrors = false; 
        }

        // Permanent Address Province
        if (String.isNotBlank(SelPermanentState) && 
            validateSelectValue(getStateSelectOptions(), SelPermanentState)) {
            Application.Permanent_Address_Province__c = SelPermanentState;               
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PERMANENT_ADDRESS_PROVINCE));
            noValidationErrors = false; 
        }

        //Pattern postalCodePattern = Pattern.compile(REGEX_POSTAL_CODE);

        // Permanent Address Postal Code
        //if (String.isBlank(Application.Permanent_Address_PostalCode__c) || 
        //    postalCodePattern.matcher(Application.Permanent_Address_PostalCode__c).matches() == false) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PERMANENT_ADDRESS_POSTAL_CODE));
        //    noValidationErrors = false; 
        //}

        Boolean validatePreviousAddress = false;

        // Years and Months at Permanent Address
    
        if ((Application.Years_At_Permanent_Address__c == 0 && Application.Months_At_Permanent_Address__c == 0) || 
             Application.Years_At_Permanent_Address__c == null || Application.Months_At_Permanent_Address__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_HOW_LONG));
                noValidationErrors = false;      
        } else if (Application.Years_At_Permanent_Address__c < 2) {
            validatePreviousAddress = true;
        }
         
         // Permanent Rent or Own
        if (String.isNotBlank(SelPermanentRentOrOwn) && 
            validateSelectValue(getPermanentRentOrOwnSelectOptions(), SelPermanentRentOrOwn)) {
            Application.Home_Owner__c = SelPermanentRentOrOwn;              
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PERMANENT_RENT_OR_OWN));
            noValidationErrors = false; 
        }
        
        // Housing Costs
        if (Application.Housing_Costs__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_HOUSING_COSTS));
            noValidationErrors = false;   
        }
        
        //Risk Based Pricing
        if((SelLoanType != CREDIT_CARD) && (String.isNotBlank(SelPermanentRentOrOwn)) && (SelPermanentRentOrOwn == OWN_SEL_TEXT)){          
            if(Application.Housing_Costs__c != null && Application.Housing_Costs__c > 0){               
                if(String.isBlank(Application.Mortgage_With__c)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_MORTGAGE_WITH));
                    noValidationErrors = false;
                }               
            }
        }
        
        //Risk Based Pricing
        if((SelLoanType == CREDIT_CARD) && (String.isNotBlank(selHomeOwnerOptions)) && (selHomeOwnerOptions == YES_SEL_TEXT)){          
            if(Application.Housing_Costs__c != null && Application.Housing_Costs__c > 0){               
                if(String.isBlank(Application.Mortgage_With__c)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_MORTGAGE_WITH));
                    noValidationErrors = false;
                }               
            }
        }

        // Monthly Expenses
        if (Application.Monthly_Expenses__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_MONTHLY_EXPENSES));
            noValidationErrors = false;    
        }

        if (validatePreviousAddress) {
            
            // Previous Address Street Number
            if (String.isBlank(Application.Previous_Address_Street_Number__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PREVIOUS_ADDRESS_STREET_NUMBER));
                noValidationErrors = false;     
            }

            // Previous Address Street Name
            if (String.isBlank(Application.Previous_Address_Street_Name__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PREVIOUS_ADDRESS_STREET_NAME));
                noValidationErrors = false;     
            }

            // Previous Address City
            if (String.isBlank(Application.Previous_Address_City__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PREVIOUS_ADDRESS_CITY));
                noValidationErrors = false;     
            }

            // Previous Address Province
            if (String.isNotBlank(SelPreviousProvince) && 
                validateSelectValue(getStateSelectOptions(), SelPreviousProvince)) {
                Application.Previous_Address_Province__c = SelPreviousProvince;             
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PREVIOUS_ADDRESS_PROVINCE));
                noValidationErrors = false; 
            }

            // Previous Address Postal Code
            //if (String.isBlank(Application.Previous_Address_PostalCode__c) || 
            //    postalCodePattern.matcher(Application.Previous_Address_PostalCode__c).matches() == false) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PREVIOUS_ADDRESS_POSTAL_CODE));
            //    noValidationErrors = false;     
            //}

            // Years and Months at Previous Address
            if (Application.Years_At_Previous_Address__c == 0 && Application.Months_At_Previous_Address__c == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PREVIOUS_ADDRESS_HOW_LONG));
                noValidationErrors = false;         
            } 
        } else {
            // Clear out Previous address info as it was collected incidentally
            Application.Previous_Address_Street_Number__c = null;
            Application.Previous_Address_Street_Name__c = null;
            //Application.Previous_Address_Unit_Number__c = null;
            Application.Previous_Address_City__c = null;
            Application.Previous_Address_PostalCode__c = null;
            Application.Years_At_Previous_Address__c = null;
            Application.Months_At_Previous_Address__c = null;
        }
        
        //check whether postalcode valid or not as per province     
        //validatePostalCodeProvince(Application.Permanent_Address_PostalCode__c, Application.Permanent_Address_Province__c );        
        //validatePostalCodeProvince(Application.Previous_Address_PostalCode__c, Application.Previous_Address_Province__c );

        return noValidationErrors;
    }

    private Boolean validateStepThree() {
        Boolean noValidationErrors = true;

        // Employer Name
        if (String.isBlank(Application.Employer_Name__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_EMPLOYER_NAME));
            noValidationErrors = false;     
        }

        // Employer Phone
        Pattern phonePattern = Pattern.compile(REGEX_PHONE_NUMBER);
        if (String.isBlank(Application.Employer_Phone__c) || phonePattern.matcher(Application.Employer_Phone__c).matches() == false) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_EMPLOYER_PHONE));
            noValidationErrors = false;     
        }

        // Employer Street Number
        if (String.isBlank(Application.Employer_Street_Number__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_EMPLOYER_STREET_NUMBER));
            noValidationErrors = false;     
        }

        // Employer Street Name
        if (String.isBlank(Application.Employer_Street_Name__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_EMPLOYER_STREET_NAME));
            noValidationErrors = false;     
        }

        // Employer City
        if (String.isBlank(Application.Employer_City__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_EMPLOYER_CITY));
            noValidationErrors = false;     
        }

        // Employer Province
        if (String.isNotBlank(SelEmployerProvince) && 
            validateSelectValue(getStateSelectOptions(), SelEmployerProvince)) {
            Application.Employer_Province__c = SelEmployerProvince;             
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_EMPLOYER_PROVINCE));
            noValidationErrors = false; 
        }

        // Employer Postal Code
        //Pattern postalCodePattern = Pattern.compile(REGEX_POSTAL_CODE);

        //if (String.isBlank(Application.Employer_PostalCode__c) || 
        //    postalCodePattern.matcher(Application.Employer_PostalCode__c).matches() == false) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_EMPLOYER_POSTAL_CODE));
        //    noValidationErrors = false;     
        //}

        Boolean validatePreviousEmployer = false;

        // Years and Months at Employer
        if (Application.Employment_Years__c == null || Application.Employment_Months__c == null || 
            (Application.Employment_Years__c == 0 && Application.Employment_Months__c == 0)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_HOW_LONG_EMPLOYER));
            noValidationErrors = false;         
        } else if (Application.Employment_Years__c < 2) {
            validatePreviousEmployer = true;
        }

        // Gross Monthly Income
        if (Application.Gross_Monthly_Income__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_GROSS_MONTHLY_INCOME));
            noValidationErrors = false;         
        }

        if (validatePreviousEmployer) {
            // Previous Employer Name
            if (String.isBlank(Application.Previous_Employer_Name__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PREVIOUS_EMPLOYER_NAME));
                noValidationErrors = false;     
            }

            // Previous Employer Street Number
            if (String.isBlank(Application.Previous_Employer_Street_Number__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PREVIOUS_EMPLOYER_STREET_NUMBER));
                noValidationErrors = false;     
            }

            // Previous Employer Street Name
            if (String.isBlank(Application.Previous_Employer_Street_Name__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PREVIOUS_EMPLOYER_STREET_NAME));
                noValidationErrors = false;     
            }

            // Previous Employer City
            if (String.isBlank(Application.Previous_Employer_City__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PREVIOUS_EMPLOYER_CITY));
                noValidationErrors = false;     
            }

            // Previous Employer Province
            if (String.isNotBlank(SelPreviousEmployerProvince) && 
                validateSelectValue(getStateSelectOptions(), SelPreviousEmployerProvince)) {
                Application.Previous_Employer_Province__c = SelPreviousEmployerProvince;                
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PREVIOUS_EMPLOYER_PROVINCE));
                noValidationErrors = false; 
            }

            // Previous Employer Postal Code
            //if (String.isBlank(Application.Previous_Employer_PostalCode__c) || 
            //    postalCodePattern.matcher(Application.Previous_Employer_PostalCode__c).matches() == false) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PREVIOUS_EMPLOYER_POSTAL_CODE));
            //    noValidationErrors = false;     
            //}

            // Years and Months at Previous Employer
            if (Application.Previous_Employment_Years__c == null || Application.Previous_Employment_Months__c == null || 
                (Application.Previous_Employment_Years__c == 0 && Application.Previous_Employment_Months__c == 0)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_HOW_LONG_PREVIOUS_EMPLOYER));
                noValidationErrors = false;         
            } 

            // Gross Monthly Income
            if (Application.Previous_Gross_Monthly_Income__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_PREVIOUS_GROSS_MONTHLY_INCOME));
                noValidationErrors = false;         
            }

        } else {
            // Clear out Previous employer info as it was collected incidentally
            Application.Previous_Employer_Name__c = null;
            Application.Previous_Employer_Street_Number__c = null;
            Application.Previous_Employer_Street_Name__c = null;
            //Application.Previous_Employer_Unit_Number__c = null;
            Application.Previous_Employer_City__c = null;
            Application.Previous_Employer_PostalCode__c = null;
            Application.Previous_Employment_Years__c = null;
            Application.Previous_Employment_Months__c = null;
            Application.Previous_Gross_Monthly_Income__c = null;
        }

        //check whether postalcode valid or not as per province         
        //validatePostalCodeProvince(Application.Employer_PostalCode__c, Application.Employer_Province__c );      
        //validatePostalCodeProvince(Application.Previous_Employer_PostalCode__c, Application.Previous_Employer_Province__c );
        
        return noValidationErrors;
    }

    //check whether postalcode valid or not as per province  
    /*   
    private Boolean validatePostalCodeProvince(String postalCode, String province){     
                
        Boolean noValidationErrors = true;      
                
        Map<String, set<String>> mapList = New Map<String, set<String>>();      
        mapList.put('NL',new Set<String>{'A'});     
        mapList.put('NS',new Set<String>{'B'});     
        mapList.put('PE',new Set<String>{'C'});     
        mapList.put('NB',new Set<String>{'E'});     
        mapList.put('QC',new Set<String>{'G','H','J'});     
        mapList.put('ON',new Set<String>{'K','L','M','N','P'});     
        mapList.put('MB',new Set<String>{'R'});     
        mapList.put('SK',new Set<String>{'S'});     
        mapList.put('AB',new Set<String>{'T'});     
        mapList.put('BC',new Set<String>{'V'});     
        mapList.put('NU',new Set<String>{'X'});     
        mapList.put('NT',new Set<String>{'X'});     
        mapList.put('YT',new Set<String>{'Y'});     
                
        if(String.isNotBlank(postalCode) && String.isNotBlank(province)){       
                    
            postalCode = postalCode.toUpperCase();      
            province = province.toUpperCase();      
                    
            if(! (mapList.get(province).contains(postalCode.substring(0, 1))) ){        
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERR_POSTALCODE_PROVINCE));     
                noValidationErrors = false;     
            }       
        }       
        return noValidationErrors;      
    }
    */
    
    private Boolean validateSelectValue(Schema.DescribeFieldResult dfr, String value) {
        List<Schema.PicklistEntry> peList = dfr.getPicklistValues();
        for(Schema.PicklistEntry pe : peList) {
            if (value == pe.getValue()) {
                return true;
            }
        }
        return false;
    }

    private Boolean validateSelectValue(List<SelectOption> opts, String value) {
        for(SelectOption opt : opts) {
            if (value == opt.getValue()) {
                return true;
            }
        }
        return false;
    }

    private List<SelectOption> getSelectOptions(Schema.DescribeFieldResult dfr, Boolean addNoneOption, Boolean pleaseSelectOption) {
        List<SelectOption> selOpts = new List<SelectOption>();
        if (addNoneOption) {
            selOpts.add(new SelectOption('',NONE_SEL_TEXT));
        }
        if (pleaseSelectOption) {
            selOpts.add(new SelectOption('', PLEASE_SEL_TEXT)); 
        }
        List<Schema.PicklistEntry> peList = dfr.getPicklistValues();
        for(Schema.PicklistEntry pe : peList) {
            selOpts.add(new SelectOption(pe.getValue(),pe.getLabel()));
        }
        return selOpts;
    }
    
    /*
    private List<SelectOption> getProvinceSelectOptions() {
        List<SelectOption> provOpts = new List<SelectOption>();
        provOpts.add(new SelectOption('', PLEASE_SEL_TEXT));
        provOpts.add(new SelectOption('AB', 'Alberta'));
        provOpts.add(new SelectOption('BC', 'British Columbia'));
        provOpts.add(new SelectOption('MB', 'Manitoba'));
        provOpts.add(new SelectOption('NB', 'New Brunswick'));
        provOpts.add(new SelectOption('NL', 'Newfoundland and Labrador'));
        provOpts.add(new SelectOption('NS', 'Nova Scotia'));
        provOpts.add(new SelectOption('ON', 'Ontario'));
        provOpts.add(new SelectOption('PE', 'Prince Edward Island'));
        provOpts.add(new SelectOption('SK', 'Saskatchewan'));
        provOpts.add(new SelectOption('NT', 'Northwest Territories'));
        provOpts.add(new SelectOption('NU', 'Nunavut'));
        provOpts.add(new SelectOption('YT', 'Yukon'));

        return provOpts;
    }
    */
    
    
    private List<SelectOption> getStateSelectOptions() {
        List<SelectOption> stateOpts = new List<SelectOption>();
        stateOpts.add(new SelectOption('', PLEASE_SEL_TEXT));
        stateOpts.add(new SelectOption('Andra Pradesh', 'Andra Pradesh'));
        stateOpts.add(new SelectOption('Arunachal Pradesh', 'Arunachal Pradesh'));
        stateOpts.add(new SelectOption('Assam', 'Assam'));
        stateOpts.add(new SelectOption('Bihar', 'Bihar'));
        stateOpts.add(new SelectOption('Chhattisgarh', 'Chhattisgarh'));
        stateOpts.add(new SelectOption('Goa', 'Goa'));
        stateOpts.add(new SelectOption('Gujarat', 'Gujarat'));
        stateOpts.add(new SelectOption('Haryana', 'Haryana'));
        stateOpts.add(new SelectOption('Himachal Pradesh', 'Himachal Pradesh'));
        stateOpts.add(new SelectOption('Jammu and Kashmir', 'Jammu and Kashmir'));
        stateOpts.add(new SelectOption('Jharkhand', 'Jharkhand'));
        stateOpts.add(new SelectOption('Karnataka', 'Karnataka'));
        stateOpts.add(new SelectOption('Kerala', 'Kerala'));
        stateOpts.add(new SelectOption('Madya Pradesh', 'Madya Pradesh'));
        stateOpts.add(new SelectOption('Maharashtra', 'Maharashtra'));
        stateOpts.add(new SelectOption('Manipur', 'Manipur'));
        stateOpts.add(new SelectOption('Meghalaya', 'Meghalaya'));
        stateOpts.add(new SelectOption('Mizoram', 'Mizoram'));
        stateOpts.add(new SelectOption('Nagaland', 'Nagaland'));
        stateOpts.add(new SelectOption('Orissa', 'Orissa'));
        stateOpts.add(new SelectOption('Punjab', 'Punjab'));
        stateOpts.add(new SelectOption('Rajasthan', 'Rajasthan'));
        stateOpts.add(new SelectOption('Sikkim', 'Sikkim'));
        stateOpts.add(new SelectOption('Tamil Nadu', 'Tamil Nadu'));
        stateOpts.add(new SelectOption('Tripura', 'Tripura'));
        stateOpts.add(new SelectOption('Uttaranchal', 'Uttaranchal'));
        stateOpts.add(new SelectOption('Uttar Pradesh', 'Uttar Pradesh'));
        stateOpts.add(new SelectOption('West Bengal', 'West Bengal'));
        
        return stateOpts;
    }

    /*
    private List<SelectOption> getProvinceSelectOptionsWithQC() {
        List<SelectOption> provOpts = new List<SelectOption>();
        provOpts.add(new SelectOption('', PLEASE_SEL_TEXT));
        provOpts.add(new SelectOption('AB', 'Alberta'));
        provOpts.add(new SelectOption('BC', 'British Columbia'));
        provOpts.add(new SelectOption('MB', 'Manitoba'));
        provOpts.add(new SelectOption('NB', 'New Brunswick'));
        provOpts.add(new SelectOption('NL', 'Newfoundland and Labrador'));
        provOpts.add(new SelectOption('NS', 'Nova Scotia'));
        provOpts.add(new SelectOption('ON', 'Ontario'));
        provOpts.add(new SelectOption('PE', 'Prince Edward Island'));
        provOpts.add(new SelectOption('QC', 'Quebec'));
        provOpts.add(new SelectOption('SK', 'Saskatchewan'));
        provOpts.add(new SelectOption('NT', 'Northwest Territories'));
        provOpts.add(new SelectOption('NU', 'Nunavut'));
        provOpts.add(new SelectOption('YT', 'Yukon'));

        return provOpts;
    }
    */

    private List<SelectOption> getYesNoSelectOptions() {
        List<SelectOption> opts = new List<SelectOption>();
        opts.add(new SelectOption(YES_SEL_TEXT, YES_SEL_TEXT));
        opts.add(new SelectOption(NO_SEL_TEXT, NO_SEL_TEXT));

        return opts;    
    }

    private List<SelectOption> getPermanentRentOrOwnSelectOptions() {
        List<SelectOption> opts = new List<SelectOption>();
        opts.add(new SelectOption(RENT_SEL_TEXT, RENT_SEL_TEXT));
        opts.add(new SelectOption(OWN_SEL_TEXT, OWN_SEL_TEXT));

        return opts;
    }
    
    //For CS tracking URL - To replace Ampersand to '&'
    private String replaceAmpersand(String str){
        
        String woAmpersand = '';
        
        woAmpersand = str.replaceAll('ampersand', '&');
        return woAmpersand;
    }
    
    //To redirect page to decision page if AFI number present
    private PageReference urlForDecisionPage(){
        
        Application__c app = [select id, Decision__c from application__c where id =: Application.Id];
        PageReference decisionPage = new PageReference(LANDING_PAGE);
        Map<String, String> params = decisionPage.getParameters();
        params.put('FirstName', FirstName);
        params.put('LastName', LastName);        
        
        params.put('id', Application.Id);

        decisionPage.setRedirect(true);
        return decisionPage;
    }
    
    //Get Eligible Product Options for Application Form
    public List<SelectOption> getEligibleProductOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Lending360 Credit Card','Lending360 Credit Card'));
        options.add(new SelectOption('Lending360 Term Loan','Lending360 Term Loan'));
        return options;
    }
}