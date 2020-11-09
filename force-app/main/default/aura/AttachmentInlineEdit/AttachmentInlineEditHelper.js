({
    fetchData: function(component, event, helper) {  
        var action = component.get("c.getAttachment");
        action.setParams({
            parentId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.draftValues", data);        
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
            if (state === "ERROR") {
                alert(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },   
    populateList: function(component, event, helper){
        var action = component.get("c.getPickListValuesIntoList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.options", data);
                
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
            if (state === "ERROR") {
                alert(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    fetchMonths: function(component, event, helper) {
        var action1 = component.get("c.monthList");
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.listMonth", data);
                
            }
            
        });
        $A.enqueueAction(action1);
        
    },
    fetchYears: function(component, event, helper) {
        
        var action2 = component.get("c.yearList");
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.listYear", data);
            }
            
        });
        $A.enqueueAction(action2);
    },
    updateattachment: function(component, event, helper) {
        
       var jvar= JSON.stringify(component.get("v.draftValues"));
        var action = component.get("c.updateAttachmentrecord");
        var parentid = component.get("v.entityId");
       
        action.setParams({"jvar" : jvar,
                          "parentid" : parentid
                         });
        action.setCallback(component, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                $A.get("e.force:refreshView").fire();   
            } 
            else {
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);
    }
});