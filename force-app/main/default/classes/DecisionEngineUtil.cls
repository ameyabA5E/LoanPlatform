public with sharing class DecisionEngineUtil {
    //This inner class is used for the XML part of the adjudication request
    public class DecisionXMLRequest extends XMLComplexType {
        public DecisionXMLRequest() {
            fieldName = 'TUCANREL4';
            field_order_type_info = new String[]{'Route','UserReference','MemberCode','Password','Product','TTY','Subject','OptionalRequest'};
        }
    }

    //This inner class is used for the XML part of the adjudication request - Subject tag
    public class DecisionXMLRequest_Subject extends XMLComplexType{
        public DecisionXMLRequest_Subject() {
            fieldName = 'Subject';
            field_order_type_info = new String[]{'Name','DOB','Address','SIN'};
        }
    }

    //This inner class is used for the XML part of the adjudication request - Subject tag - Name tag
    public class DecisionXMLRequest_SubjectName extends XMLComplexType{
        public DecisionXMLRequest_SubjectName() {
            fieldName = 'Name';
            field_order_type_info = new String[]{'LastName','FirstName'};
        }
    }
    //This inner class is used for the XML part of the AML request
    public class AMLXMLRequest extends XMLComplexType{
        public AMLXMLRequest() {
            fieldName = 'IFSXML';
            field_order_type_info = new String[]{'Route','UserReference','MemberCode','Password','PRODUCTCODE','AML','PI','Errors'};
        }
    }

    //This inner class is used for the XML part of the AML request - AML tag
    public class AMLXMLRequest_AML extends XMLComplexType{
        public AMLXMLRequest_AML() {
            fieldName = 'AML';
            field_order_type_info = new String[]{'LastName','FirstName','Address','Telephone'};
        }
    }
    
    public virtual class XMLComplexType {
        public Map<String,Object> FieldValues {get;private set;}
        protected String fieldName;
        protected String[] field_order_type_info;
        public XMLComplexType() {
            FieldValues = new Map<String,Object>();
        }
        public void getXmlString(XmlStreamWriter w) {
            w.writeStartElement(null, fieldName, null);
            
            for (String f : field_order_type_info) {
                
                
                Object o = fieldValues.get(f);
                if (o == null && !fieldValues.containsKey(f)) {
                    continue;
                }
                
                if (o instanceof List<XMLComplexType>) {
                    List<XMLComplexType> xmlList = (List<XMLComplexType>)o;
                    for (XMLComplexType xmlct : xmlList) {
                        xmlct.getXmlString(w);
                    }
                } else if (o instanceof XMLComplexType) {
                    XMLComplexType xmlct = (XMLComplexType)o;
                    xmlct.getXmlString(w);
                } else {
                    w.writeStartElement(null, f, null);
                    if (o != null) {
                        if(f == 'Route'){
                            List<String> attributeList = new List<String>(String.valueOf(o).split(':'));
                            
                            for(String str : attributeList){
                                List<String> attributeValuesList = new List<String>(str.split('='));
                                w.writeAttribute(null, null, attributeValuesList[0] , attributeValuesList[1]);
                            }
                        }else{
                            w.writeCharacters(String.valueOf(o));
                        }
                    }
                    w.writeEndElement();
                }
            }
            
            w.writeEndElement();
        }
    }
    
    //Inner class for response from Integration
    public class IntegrationResponse{
       public string request{get;set;}
       public string response{get;set;}
       public string applicationStatus{get;set;}
       public string adjudicationStatus{get;set;}
       public string declineReason{get;set;}
       public Decimal approvedAmount{get;set;}
       public Decimal approvedInterestRate{get;set;}
       public String decisionSummary{get;set;}
       public String amlResponse{get;set;}
       public String adjudicationResponse{get;set;}
       public DateTime adjudicationDecisionTimestamp{get;set;}
       public Integer creditScore{get;set;}
       public Integer totalNumberofBankrupcies{get;set;}
       public String amlDeclineReason{get;set;}
       public String amlSummary{get;set;}
       public String amlStatus{get;set;}
       public DateTime amlTimestamp{get;set;}
       public String adjudicationFile{get;set;}
       public String fraudFlag{get;set;}
       public String needsReviewReason{get;set;}
       public String amlUniqueNumber{get;set;}
    }
}