({
    doinit: function(component, event, helper) {
       
        helper.fetchDocType(component, helper, event);
        helper.fetchMonths(component, helper, event);
        helper.fetchYears(component, helper, event);
        //$A.get("e.force:refreshView").fire();
    },
	uploadAttch: function(component, event, helper) {
        var doclen = component.find("fileId").get("v.files");
        if (doclen!= null && doclen.length > 0) {
            
           helper.uploadHelper(component, event);	
            
       } else{	
          	
            alert('Please Select a Valid File');	
       }
        
        var childComp = component.find('childcomp');
        childComp.callChild();
    },
    
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    }
    
})