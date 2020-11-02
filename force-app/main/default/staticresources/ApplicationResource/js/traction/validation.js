var phoneNumberRegex = /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/;
var postalCodeRegex = /^[ABCEGHJKLMNPRSTVXY]{1}\d{1}[A-Z]{1} *\d{1}[A-Z]{1}\d{1}$/;
var currencyRegex = /^([0-9]{1,3},([0-9]{3},)*[0-9]{3}|[0-9]+)(\.[0-9][0-9])?$/;
var allNumbersRegex = /^\d+$/;
var emailRegex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;

function isInt(value) {
	return !isNaN(value) && (function(x) { return (x | 0) === x; })(parseFloat(value))
}

function isCurrency(value) {
	return currencyRegex.test(value);
}

function isAllNumbers(value) {
	return allNumbersRegex.test(value);
}

function isEmail(value) {
	return emailRegex.test(value);
}

function isPhoneNumber(value) {
	return phoneNumberRegex.test(value);
}

function isPostalCode(value) {
	//return value != undefined && postalCodeRegex.test(value.toUpperCase());
	return true;
}

// Standard Validation and Error Messaging
// -- Checks only field's val() against "", then applies standard error messaging
// -- This covers most of our cases
// -- returns true if no error
function validateField(fieldPrefix) {
	var fieldObj = $("[id*='" + fieldPrefix + "Field']");
	if(fieldObj.val() == undefined || fieldObj.val().trim() == "") {
		fieldObj.addClass("invalidField");
		$("[id*='" + fieldPrefix + "ErrMsg']").removeClass("hidden");
		return false;
	}
	
	// Remove error messaging related class (if existing) and hide error message
	fieldObj.removeClass("invalidField");
	$("[id*='" + fieldPrefix + "ErrMsg']").addClass("hidden");

	return true;
}

function validateRadio(fieldPrefix) {
	var fieldObj = $("input[id*='" + fieldPrefix + "Field']:checked");
	if(fieldObj.val() == undefined || fieldObj.val().trim() == "") {
		$("table[id*='" + fieldPrefix + "Field']").addClass("invalidField");
		$("[id*='" + fieldPrefix + "ErrMsg']").removeClass("hidden");
		return false;
	}
	
	// Remove error messaging related class (if existing) and hide error message
	$("table[id*='" + fieldPrefix + "Field']").removeClass("invalidField");
	$("[id*='" + fieldPrefix + "ErrMsg']").addClass("hidden");

	return true;
}

function validateAllRadio(fieldPrefix) {
	var count = 0;

	while (count >= 0 && count < 1000) {
		var currentFieldPrefix = count.toString() + ":" + fieldPrefix;
		var fieldObj = $("input[id*='" + currentFieldPrefix + "Field']");
		if (fieldObj.length != 0) {
			if(!fieldObj.is(':checked')) {
				$("table[id*='" + fieldPrefix + "Field']").addClass("invalidField");
				$("[id*='" + fieldPrefix + "ErrMsg']").removeClass("hidden");
				return false;
			}
			count++;
		} else {
			count = -1;
		}
	}
	
	// Remove error messaging related class (if existing) and hide error message
	$("table[id*='" + fieldPrefix + "Field']").removeClass("invalidField");
	$("[id*='" + fieldPrefix + "ErrMsg']").addClass("hidden");

	return true;
}

function validateDate(fieldPrefix) {
	var yearObj = $("[id*='" + fieldPrefix + "YearField']");
	var monthObj = $("[id*='" + fieldPrefix + "MonthField']");
	var dayObj = $("[id*='" + fieldPrefix + "DayField']");

	var year = yearObj.val();
	var month = monthObj.val();
	var day = dayObj.val();

	var noErrors = false;

	if (isInt(year) == true && isInt(month) == true && isInt(day) == true) {
		
		// Check the ranges of month and year
		if (year > 1000 && year < 3000 && month != 0 && month < 13) {
			
			// Trick to test against invalid dates such as 02/31
			// note: month is zero-based!
			var dateObj = new Date(year, month-1, day);

			if ((dateObj.getMonth()+1 == month) && 
				dateObj.getDate() == day && 
				dateObj.getFullYear() == year ) {
				noErrors = true;
			}
		}
	}

	if (noErrors == false) {
		yearObj.addClass("invalidField"); 
		monthObj.addClass("invalidField"); 
		dayObj.addClass("invalidField"); 
		$("[id*='" + fieldPrefix + "ErrMsg']").removeClass("hidden");   
	} else {
		// Remove existing error-related classes, hide error msg
		yearObj.removeClass("invalidField"); 
		monthObj.removeClass("invalidField"); 
		dayObj.removeClass("invalidField");
		$("[id*='" + fieldPrefix + "ErrMsg']").addClass("hidden");   
	}

	return noErrors;
}

// Validation and Error Messaging for phone number fields
// -- Checks field's val() against phone number regex, then applies standard error messaging
// -- returns true if no error
function validatePhoneNumberField(fieldPrefix) {
	var phoneNumberObj = $("[id*='" + fieldPrefix + "Field']");
	var phoneNumber = phoneNumberObj.val();
	if (isPhoneNumber(phoneNumber) == false) {
		phoneNumberObj.addClass("invalidField"); 
		$("[id*='" + fieldPrefix + "ErrMsg']").removeClass("hidden");
		return false;
	}

	// Remove error messaging related class (if existing) and hide error message
	phoneNumberObj.removeClass("invalidField"); 
	$("[id*='" + fieldPrefix + "ErrMsg']").addClass("hidden");

	return true;
}

// Validation and Error Messaging for postal code fields
// -- Checks if valid postal code, then applies standard error messaging
// -- returns true if no error
function validatePostalCodeField(fieldPrefix) {
	var postalCodeObj = $("[id*='" + fieldPrefix + "Field']");
	var postalCode = postalCodeObj.val();
	if (isPostalCode(postalCode) == false) {
		postalCodeObj.addClass("invalidField"); 
		$("[id*='" + fieldPrefix + "ErrMsg']").removeClass("hidden");
		return false;
	}

	// Remove error messaging related class (if existing) and hide error message
	postalCodeObj.removeClass("invalidField"); 
	$("[id*='" + fieldPrefix + "ErrMsg']").addClass("hidden");

	return true;
}

// Validation and Error Messaging for our How Long (Years and Months) construct
// -- Checks if both are ints and not both zero, then applies standard error messaging
// -- returns true if no error
function validateHowLongField(field) {
	var yearsObj = $("[id*='yearsAt" + field + "Field']");
	var monthsObj = $("[id*='monthsAt" + field + "Field']");

	var years = yearsObj.val();
	var months = monthsObj.val();
	var noErrors = true;

	// Validate that Years is an Int
	if (isInt(years) == false || years < 0) {
		yearsObj.addClass("invalidField"); 
		noErrors = false;
	} else {
		// clear error display
		yearsObj.removeClass("invalidField"); 
	}

	// Validate that Months is an int
	if (isInt(months) == false || months < 0 || months > 11) {
		monthsObj.addClass("invalidField"); 
		noErrors = false;
	} else {
		// clear error display
		monthsObj.removeClass("invalidField"); 
	}

	// Validate that both are not zero
	if (years == 0 && months == 0) {
		monthsObj.addClass("invalidField"); 
		yearsObj.addClass("invalidField"); 
		noErrors = false;
	}

	// Display error msg if any errors
	if (noErrors == false) {
		$("[id*='howLongAt" + field + "ErrMsg']").removeClass("hidden");   
	} else {
		// Hide error message
		$("[id*='howLongAt" + field + "ErrMsg']").addClass("hidden");   
	}

	return noErrors;
}

function validateStepZero() {
	var noErrors = true;

	// Disable Submit button
	$("[id*='stepZeroContinue']").attr("disabled", "true");

	// Validate Loan Type
	if (validateRadio("loanType") == false) {
		noErrors = false;
	} 
	else {		
		var jsLoanTypeFieldObj = $("[id*='loanTypeField']:checked");  
		
		if (jsLoanTypeFieldObj != undefined && jsLoanTypeFieldObj.val() == "Lending360 Credit Card") {
			if(validateRadio("homeOwner") == false){
				noErrors = false;		
			}		
		}	
	}
	
	//Manitoba Disclosure changes
	// Validate Province
	if (validateField("province") == false) {
		noErrors = false;
	}

	if (noErrors == true) {
		$("#stepZeroLoading").show();
		// AJAX call to controller method: impl provided by actionFunction
		saveStepZero();
	} else {
		scrollToTop();
		adjustHeight();
		// Re-enable submit button
		$("[id*='stepZeroContinue']").removeAttr("disabled");
	}
}

function validateStepOne() {    
	var noErrors = true;

	// Disable Submit button (this logic should live in another function)
	$("[id*='stepOneContinue']").attr("disabled", "true");
	
	// Validate Has Accepted Disclosure Terms 
	var hasAcceptedDisclosureTermsObj = $("[id*='hasAcceptedDisclosureTermsField']");
	if (hasAcceptedDisclosureTermsObj.is(':checked') == false) {
		$("[id*='hasAcceptedDisclosureTermsLabel']").addClass("invalidField");
		$("[id*='hasAcceptedDisclosureTermsErrMsg']").removeClass("hidden");   
		noErrors = false;
	} else {
		// Remove existing error-related classes, hide error msg
		$("[id*='hasAcceptedDisclosureTermsLabel']").removeClass("invalidField");
		$("[id*='hasAcceptedDisclosureTermsErrMsg']").addClass("hidden");   
	}
	
	
	var proviObj = $("[id*='provinceField']");
	if(proviObj.val() != undefined && proviObj.val().trim() == "MB") {
		//Manitoba Updates
		//Validate Has Accepted Personal Consent 
		var hasAcceptedPersonalConsentTermsObj = $("[id*='hasAcceptedPersonalConsentTermsField']");   
		if (hasAcceptedPersonalConsentTermsObj.is(':checked') == false) {
			$("[id*='hasAcceptedPersonalConsentTermsLabel']").addClass("invalidField");
			$("[id*='hasAcceptedPersonalConsentTermsErrMsg']").removeClass("hidden");   
			noErrors = false;
		} else {
			// Remove existing error-related classes, hide error msg
			$("[id*='hasAcceptedPersonalConsentTermsLabel']").removeClass("invalidField");
			$("[id*='hasAcceptedPersonalConsentTermsErrMsg']").addClass("hidden");   
		}
	}

	// Validate Salutation
	if (validateField("salutation") == false) {
		noErrors = false;
	}

	// Validate First Name
	if (validateField("firstName") == false) {
		noErrors = false;
	}

	// Validate Last Name
	if (validateField("lastName") == false) {
		noErrors = false;
	}

	// Validate Province
	//if (validateField("province") == false) {
	//	noErrors = false;
	//}

	// Validate Date of Birth
	if (validateDate("birthdate") == false) {
		noErrors = false;
	}

	// Validate SIN, if entered
	//var sin = $("[id*='sinField']").val();
	//if (sin != undefined && sin != "" && (isAllNumbers(sin) == false || sin.length != 16)) {
	//	$("[id*='sinField']").addClass("invalidField");
	//	$("[id*='sinErrMsg']").removeClass("hidden");   
	//	noErrors = false;
	//} else {
	//	// Remove existing error-related classes, hide error msg
	//	$("[id*='sinField']").removeClass("invalidField");
	//	$("[id*='sinErrMsg']").addClass("hidden");   
	//}

	// Validate email, if entered
	var email = $("[id*='emailAddressField']").val();
	if (email != "" && email != undefined && isEmail(email) == false) {
		$("[id*='emailAddressField']").addClass("invalidField");
		$("[id*='emailAddressErrMsg']").removeClass("hidden");   
		noErrors = false;
	} else {
		// Remove existing error-related classes, hide error msg
		$("[id*='emailAddressField']").removeClass("invalidField");
		$("[id*='emailAddressErrMsg']").addClass("hidden");   
	}

	// Validate Employment Status
	if (validateField("employmentStatus") == false) {
		noErrors = false;
	}

	// Validate Current BKCP
	// selected the 'checked' radio button, undefined means none is checked
	//var currentBKCPObj = $("[id*='currentBKCPField']:checked");
	//if (currentBKCPObj.val() == undefined) {
	//	$("[id*='currentBKCPField']").addClass("invalidField");
	//	$("[id*='currentBKCPErrMsg']").removeClass("hidden");   
	//	noErrors = false;
	//} else {
	//	// Remove existing error-related classes, hide error msg
	//	$("[id*='currentBKCPField']").removeClass("invalidField");
	//	$("[id*='currentBKCPErrMsg']").addClass("hidden");   
	//}

	// Validate Requested Credit limit
	var requestedCreditLimitObj = $("[id*='requestedCreditLimitField']");
	var requestedCreditLimit = requestedCreditLimitObj.val();
	if (isCurrency(requestedCreditLimit) == false) {
		requestedCreditLimitObj.addClass("invalidField"); 
		$("[id*='requestedCreditLimitErrMsg']").removeClass("hidden");   
		noErrors = false;
	} else {
		// Remove existing error-related classes, hide error msg
		requestedCreditLimitObj.removeClass("invalidField"); 
		$("[id*='requestedCreditLimitErrMsg']").addClass("hidden");
	}

	// Validate Authorized Credit Check
	// TODO: "No" should really be a property from server-side
	var authorizedCreditCheckObj = $("[id*='authorizedCreditCheckField']:checked");
	if (authorizedCreditCheckObj.val() == undefined ||
		authorizedCreditCheckObj.val() == "No") {
		$("[id*='authorizedCreditCheckField']").addClass("invalidField");
		$("[id*='authorizedCreditCheckErrMsg']").removeClass("hidden");   
		noErrors = false;
	} else {
		// Remove existing error-related classes, hide error msg
		$("[id*='authorizedCreditCheckField']").removeClass("invalidField");
		$("[id*='authorizedCreditCheckErrMsg']").addClass("hidden");
	}

	if (noErrors == true) {
		$("#stepOneLoading").show();
		// AJAX call to controller method: impl provided by actionFunction
		saveStepOne();
	} else {
		scrollToTop();
		adjustHeight();
		// Re-enable submit button
		$("[id*='stepOneContinue']").removeAttr("disabled");
	}
}

function validateStepTwo() {
	var noErrors = true;
	
	// Disable Submit button (this logic should live in another function)
	$("[id*='stepTwoContinue']").attr("disabled", "true");
	$("[id*='stepTwoBack']").attr("disabled", "true");

	// Validate Gender
	if (validateField("gender") == false) {
		noErrors = false;
	}

	// Validate Home Phone
	if (validatePhoneNumberField("homePhone") == false ) {
		noErrors = false;
	}

	// Validate Cell Phone (if entered)
	var cellPhone = $("[id*='cellPhoneField']").val();
	if (cellPhone != undefined && cellPhone != "" && validatePhoneNumberField("cellPhone") == false) {
		noErrors = false;
	}

	// Validate Work Phone
	if (validatePhoneNumberField("workPhone") == false ) {
		noErrors = false;
	}

	// Validate Number of Dependants
	if (validateField("numberOfDependants") == false) {
		noErrors = false;
	}

	// Validate Marital Status
	if (validateField("maritalStatus") == false) {
		noErrors = false;
	}

	// Validate Permanent Address Street Number
	if (validateField("permanentAddressStreetNumber") == false) {
		noErrors = false;
	}

	// Validate Permanent Address Street Name
	if (validateField("permanentAddressStreetName") == false) {
		noErrors = false;
	}

	// Validate Permanent Address City
	if (validateField("permanentAddressCity") == false) {
		noErrors = false;
	}

	// Validate Permanent Province
	if (validateField("permanentProvince") == false) {
		noErrors = false;
	}

	// Validate Permanent Address Postal Code
	if (validatePostalCodeField("permanentAddressPostalCode") == false) {
		noErrors = false;
	}

	// Validate Years/Months At Permanent Address
	if (validateHowLongField("PermanentAddress") == false) {
		noErrors = false;
	}
	
	var jsStpTwoLoanTypeFieldObj = $("[id*='loanTypeField']:checked");  
	var isMasterCard = false;	
	if (jsStpTwoLoanTypeFieldObj != undefined && jsStpTwoLoanTypeFieldObj.val() == "Lending360 Credit Card") {
		var isMasterCard = true;		
	}

	// Validate Permanent Rent Or Own
	var jsStpTwohomeOwnerFieldObj = $("[id*='homeOwnerField']:checked"); 
	if (isMasterCard && jsStpTwohomeOwnerFieldObj != undefined && (jsStpTwohomeOwnerFieldObj.val() == "Yes" || jsStpTwohomeOwnerFieldObj.val() == "No")) {
		//Do Nothing
	}
	else{
		// selected the 'checked' radio button, undefined means none is checked
		var permanentRentOrOwnObj = $("[id*='permanentRentOrOwnField']:checked");		
		
		if (permanentRentOrOwnObj.val() == undefined) {
			$("[id*='permanentRentOrOwnField']").addClass("invalidField");
			$("[id*='permanentRentOrOwnErrMsg']").removeClass("hidden");   
			noErrors = false;
		} else {
			// Remove existing error-related classes, hide error msg
			$("[id*='permanentRentOrOwnField']").removeClass("invalidField");
			$("[id*='permanentRentOrOwnErrMsg']").addClass("hidden");
		}
	}
	
	 // Validate Housing Costs
	var housingCostsObj = $("[id*='housingCostsField']");
	var housingCosts = housingCostsObj.val();
	if (isCurrency(housingCosts) == false) {
		housingCostsObj.addClass("invalidField"); 
		$("[id*='housingCostsErrMsg']").removeClass("hidden");   
		noErrors = false;
	} else {
		// Remove existing error-related classes, hide error msg
		housingCostsObj.removeClass("invalidField"); 
		$("[id*='housingCostsErrMsg']").addClass("hidden");   
	}
	
	//Validate Mortgae With
	if (!isMasterCard && permanentRentOrOwnObj != undefined && permanentRentOrOwnObj.val() == "Own Property") {
		
		if(isCurrency(housingCosts) == true){
			
			if(housingCosts > 0){
				
				if (validateField("homeMortgageWith") == false) {
					noErrors = false;
				}					
			}				
		}				
	}

	
	if (isMasterCard && jsStpTwohomeOwnerFieldObj != undefined && jsStpTwohomeOwnerFieldObj.val() == "Yes") {
		
		if(isCurrency(housingCosts) == true){
			
			if(housingCosts > 0){
				
				if (validateField("homeMortgageWith") == false) {
					noErrors = false;
				}					
			}				
		}				
	}
	
	//Dont allow to change Home Owner or Rent
	/*
	var jsStpTwohomeOwnerFieldObj = $("[id*='homeOwnerField']:checked");  		
	if (jsStpTwohomeOwnerFieldObj != undefined && jsStpTwohomeOwnerFieldObj.val() == "Yes") {
		if (permanentRentOrOwnObj != undefined && permanentRentOrOwnObj.val() == "Rent") {
			$("[id*='ownErrMsg']").removeClass("hidden"); 
			$("[id*='rentErrMsg']").addClass("hidden");	
			$("table[id*='permanentRentOrOwnField']").addClass("invalidField");
			noErrors = false;
		}	
		else{
			$("[id*='ownErrMsg']").addClass("hidden"); 
			$("table[id*='permanentRentOrOwnField']").removeClass("invalidField");
		}		
	}
	else if (jsStpTwohomeOwnerFieldObj != undefined && jsStpTwohomeOwnerFieldObj.val() == "No") {
		if (permanentRentOrOwnObj != undefined && permanentRentOrOwnObj.val() == "Own Property") {
			$("[id*='rentErrMsg']").removeClass("hidden"); 
			$("[id*='ownErrMsg']").addClass("hidden");
			$("table[id*='permanentRentOrOwnField']").addClass("invalidField");
			noErrors = false;
		}
		else{
			$("[id*='rentErrMsg']").addClass("hidden"); 
			$("table[id*='permanentRentOrOwnField']").removeClass("invalidField");			
		}		
	}	
	*/

	// Validate Monthly Expenses
	var monthlyExpensesObj = $("[id*='monthlyExpensesField']");
	var monthlyExpenses = monthlyExpensesObj.val();
	if (isCurrency(monthlyExpenses) == false) {
		monthlyExpensesObj.addClass("invalidField"); 
		$("[id*='monthlyExpensesErrMsg']").removeClass("hidden");   
		noErrors = false;
	} else {
		// Remove existing error-related classes, hide error msg
		monthlyExpensesObj.removeClass("invalidField"); 
		$("[id*='monthlyExpensesErrMsg']").addClass("hidden");   
	}

	if (previousAddressSectionIsRequired == true) {
		// Validate Previous Address Street Number
		if (validateField("previousAddressStreetNumber") == false) {
			noErrors = false;
		}

		// Validate Previous Address Street Name
		if (validateField("previousAddressStreetName") == false) {
			noErrors = false;
		}

		// Validate Previous Address Street City
		if (validateField("previousAddressCity") == false) {
			noErrors = false;
		}

		// Validate Previous Province
		if (validateField("previousProvince") == false) {
			noErrors = false;
		}

		// Validate Previous Address Postal Code
		if(validatePostalCodeField("previousAddressPostalCode") == false) {
			noErrors = false;
		}

		// Validate Years/Months At Previous Address
		if (validateHowLongField("PreviousAddress") == false) {
			noErrors = false;
		}            
	}

	if (noErrors == true) {
		$("#stepTwoLoading").show();
		// AJAX call to controller method: impl provided by actionFunction
		saveStepTwo();
	} else {
		scrollToTop();
		adjustHeight();
		// Re-enable submit button
		$("[id*='stepTwoContinue']").removeAttr("disabled");
		$("[id*='stepTwoBack']").removeAttr("disabled");
	} 
}

function validateStepThree() {
	var noErrors = true;

	// Disable Submit button (this logic should live in another function)
	$("[id*='stepThreeContinue']").attr("disabled", "true");
	$("[id*='stepThreeBack']").attr("disabled", "true");

	// Validate Employer Name
	if (validateField("employerName") == false) {
		noErrors = false;
	}

	// Validate Employer Number
	if (validatePhoneNumberField("employerPhone") == false) {
		noErrors = false;
	}

	// Validate Employer Street Number
	if (validateField("employerStreetNumber") == false) {
		noErrors = false;
	}

	// Validate Employer Street Name
	if (validateField("employerStreetName") == false) {
		noErrors = false;
	}

	// Validate Employer Address City
	if (validateField("employerCity") == false) {
		noErrors = false;
	}

	// Validate Employer Province
	if (validateField("employerProvince") == false) {
		noErrors = false;
	}

	// Validate Employer Postal Code
	if (validatePostalCodeField("employerPostalCode") == false) {
		noErrors = false;
	}

	// Validate Years/Months At Employer
	if (validateHowLongField("Employer") == false) {
		noErrors = false;
	}

	// Validate gross monthly income
	var grossMonthlyIncomeObj = $("[id*='grossMonthlyIncomeField']");
	var grossMonthlyIncome = grossMonthlyIncomeObj.val();
	if (isCurrency(grossMonthlyIncome) == false) {
		grossMonthlyIncomeObj.addClass("invalidField"); 
		$("[id*='grossMonthlyIncomeErrMsg']").removeClass("hidden");   
		noErrors = false;
	} else {
		// Remove existing error-related classes, hide error msg
		grossMonthlyIncomeObj.removeClass("invalidField"); 
		$("[id*='grossMonthlyIncomeErrMsg']").addClass("hidden");   
	}

	if (previousEmployerSectionIsRequired == true) {
		// Validate Previous Employer Name
		if (validateField("previousEmployerName") == false) {
			noErrors = false;
		}

		// Validate Previous Employer Street Number
		if (validateField("previousEmployerStreetNumber") == false) {
			noErrors = false;
		}

		// Validate Previous Employer Street Name
		if (validateField("previousEmployerStreetName") == false) {
			noErrors = false;
		}

		// Validate Previous Employer Address City
		if (validateField("previousEmployerCity") == false) {
			noErrors = false;
		}

		// Validate Previous Employer Province
		if (validateField("previousEmployerProvince") == false) {
			noErrors = false;
		}

		// Validate Previous Employer Postal Code
		if (validatePostalCodeField("previousEmployerPostalCode") == false) {
			noErrors = false;
		}

		// Validate Years/Months At Previous Employer
		if (validateHowLongField("PreviousEmployer") == false) {
			noErrors = false;
		}

		// Validate previous gross monthly income
		var previousGrossMonthlyIncomeObj = $("[id*='previousGrossMonthlyIncomeField']");
		var previousGrossMonthlyIncome = previousGrossMonthlyIncomeObj.val();
		if (isCurrency(previousGrossMonthlyIncome) == false) {
			previousGrossMonthlyIncomeObj.addClass("invalidField"); 
			$("[id*='previousGrossMonthlyIncomeErrMsg']").removeClass("hidden");   
			noErrors = false;
		} else {
			// Remove existing error-related classes, hide error msg
			previousGrossMonthlyIncomeObj.removeClass("invalidField"); 
			$("[id*='previousGrossMonthlyIncomeErrMsg']").addClass("hidden");   
		}

	}

	if (noErrors == true) {
		$("#stepThreeLoading").show();
		// AJAX call to controller method: impl provided by actionFunction
		saveStepThree();
	} else {
		scrollToTop();
		adjustHeight();
		// Re-enable submit button
		$("[id*='stepThreeContinue']").removeAttr("disabled");
		$("[id*='stepThreeBack']").removeAttr("disabled");
	}

}

function validateStepFour() {
	var noErrors = true;

	// Disable Submit button (this logic should live in another function)
	$("[id*='stepFourSubmit']").attr("disabled", "true");

	// Validate Is Consumer Legal Consent
	var isConsumerLegalConsentObj = $("[id*='isConsumerLegalConsentField']");
	if (!isConsumerLegalConsentObj.is(':checked')) {
		
		//todo: add an alert to make error more visible?

		$("[id*='isConsumerLegalConsentErrMsg']").removeClass("hidden");   
		noErrors = false;
	} else {
		// Hide error msg
		$("[id*='isConsumerLegalConsentErrMsg']").addClass("hidden");   
	}

	// Validate Politically Exposed Foreign Person
	var politicallyExposedForeignPersonObj = $("[id*='politicallyExposedForeignPersonField']:checked");
	if (politicallyExposedForeignPersonObj.val() == undefined) {
		$("[id*='politicallyExposedForeignPersonField']").addClass("invalidField");
		$("[id*='politicallyExposedForeignPersonErrMsg']").removeClass("hidden");   
		noErrors = false;
	} else {
		// Remove existing error-related classes, hide error msg
		$("[id*='politicallyExposedForeignPersonField']").removeClass("invalidField");
		$("[id*='politicallyExposedForeignPersonErrMsg']").addClass("hidden");   
	}

	// Validate Third Party Direction
	var thirdPartyDirectionObj = $("[id*='thirdPartyDirectionField']:checked");
	if (thirdPartyDirectionObj.val() == undefined) {
		$("[id*='thirdPartyDirectionField']").addClass("invalidField");
		$("[id*='thirdPartyDirectionErrMsg']").removeClass("hidden");   
		noErrors = false;
	} else {
		// Remove existing error-related classes, hide error msg
		$("[id*='thirdPartyDirectionField']").removeClass("invalidField");
		$("[id*='thirdPartyDirectionErrMsg']").addClass("hidden");
	}

	if (noErrors == true) {
		$("#processingDialog").dialog({dialogClass: "pd-no-titlebar", modal: true, minHeight:80, minWidth:300});
		// AJAX call to controller method: impl provided by actionFunction
		saveStepFour();
	} else {
		scrollToTop();
		adjustHeight();
		// Re-enable submit button
		$("[id*='stepFourSubmit']").removeAttr("disabled");
	} 
}

function validateAuthentication() {    
	var noErrors = true;

	if (validateAllRadio("answer") == false) {
		noErrors = false;
	}

	if ($("[id*='maidenName']").length != 0) {
		if (validateField("maidenName") == false) {
			noErrors = false;
		}
	}
	if (noErrors) {
		sendAnswersRequest();
	}

	return noErrors;
}

function checkStepZeroResponseAndTransition() {
	$("#stepZeroLoading").hide();
	scrollToTop();
	// Check Server response
	//var errorReturned = $("[id*='stepOnePageMessages']").is(":visible");
	var errorReturned = $("[id*='stepZeroPageMessages']").children().length > 0;
	if (errorReturned == false) {
		// Transition to Step Two
		$("#stepZero").addClass("hidden");
		$("#stepOne").removeClass("hidden");

		pushHit('/application-form/step1', 'Application Form Step 1');
	}
	// Re-enable submit button -- whether errors or not
	$("[id*='stepZeroContinue']").removeAttr("disabled");
	adjustHeight();
}

function checkStepOneResponseAndTransition() {
	$("#stepOneLoading").hide();
	scrollToTop();
	// Check Server response
	//var errorReturned = $("[id*='stepOnePageMessages']").is(":visible");
	var errorReturned = $("[id*='stepOnePageMessages']").children().length > 0;
	if (errorReturned == false) {
		// Transition to Step Two
		$("#stepOne").addClass("hidden");
		$("#stepTwo").removeClass("hidden");

		pushHit('/application-form/step2', 'Application Form Step 2');
	}
	// Re-enable submit button -- whether errors or not
	$("[id*='stepOneContinue']").removeAttr("disabled");
	adjustHeight();
}

function checkStepTwoResponseAndTransition() {
	$("#stepTwoLoading").hide();
	scrollToTop();
	// Check Server response
	var errorReturned = $("[id*='stepTwoPageMessages']").children().length > 0;
	if (errorReturned == false) {
		// Transition to Step Three
		$("#stepTwo").addClass("hidden");
		$("#stepThree").removeClass("hidden");

		pushHit('/application-form/step3', 'Application Form Step 3');
	}
	// Re-enable submit button -- whether errors or not
	$("[id*='stepTwoContinue']").removeAttr("disabled");
	$("[id*='stepTwoBack']").removeAttr("disabled");
	adjustHeight();
}

function checkStepThreeResponseAndTransition() {
	$("#stepThreeLoading").hide();
	scrollToTop();
	// Check Server response
	var errorReturned = $("[id*='stepThreePageMessages']").children().length > 0;
	if (errorReturned == false) {
		 // Transition to Step Four
		$("#stepThree").addClass("hidden");
		$("#stepFour").removeClass("hidden");

		pushHit('/application-form/step4', 'Application Form Step 4');
	}
	// Re-enable submit button -- whether errors or not
	$("[id*='stepThreeContinue']").removeAttr("disabled");
	$("[id*='stepThreeBack']").removeAttr("disabled");
	adjustHeight();
}

function checkStepFourResponseAndTransition() {
	$("#processingDialog").dialog("close");
	scrollToTop();
	// Check Server response
	var errorReturned = $("[id*='stepFourPageMessages']").children().length > 0;
	if (errorReturned == false) {
		$("#stepFour").addClass("hidden");
	} else {
		// Re-enable submit button
		$("[id*='stepFourSubmit']").removeAttr("disabled");
	}
	adjustHeight();
}

function afStepOneBack() {
	scrollToTop();   
	$("#stepOne").addClass("hidden");
	$("#stepZero").removeClass("hidden");
	adjustHeight();
}

function afStepTwoBack() {
	scrollToTop();   
	$("#stepTwo").addClass("hidden");
	$("#stepOne").removeClass("hidden");
	adjustHeight();
}

function afStepThreeBack() {
	scrollToTop();   
	$("#stepThree").addClass("hidden");
	$("#stepTwo").removeClass("hidden");
	adjustHeight();
}

function afStepFourBack() {
	scrollToTop();   
	$("#stepFour").addClass("hidden");
	$("#stepThree").removeClass("hidden");
	adjustHeight();
}