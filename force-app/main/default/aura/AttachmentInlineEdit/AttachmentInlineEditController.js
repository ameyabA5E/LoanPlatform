({
    doinit : function(component, event, helper) {     
        helper.populateList(component, helper, event);
       helper.fetchMonths(component, helper, event);
        helper.fetchYears(component, helper, event);
        helper.fetchData(component, helper, event);
    },
    updateAttachmentsJS: function(component,event,helper) {
        helper.updateattachment(component,event,helper); 
         
    },    
    fetchrefreshdata : function(component, event, helper) { 
     helper.fetchData(component, helper, event);
} 
})