({
    getRecords : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var action = component.get("c.getAllRecords");
        action.setParams({
            sObj : component.get("v.objectAPI"),
            relateField : component.get("v.relatedFieldAPI"),
            recId : recId,
            filterString : component.get("v.filterString"),
            fieldSetName : component.get("v.fieldSetName"),
            recordIdField : component.get("v.recordIdField"),
            nullSort : component.get("v.nullSort"),
            recordLimit : component.get("v.recordLimit")
        });
        action.setCallback(this, function(response){
            var name = response.getState();
            if(name === "SUCCESS") {
                component.set("v.records", response.getReturnValue());
                helper.getFields(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    getAllRecords : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var action = component.get("c.getAllRecords");
        action.setParams({
            sObj : component.get("v.objectAPI"),
            relateField : component.get("v.relatedFieldAPI"),
            recId : recId,
            filterString : component.get("v.filterString"),
            fieldSetName : component.get("v.fieldSetName"),
            recordIdField : component.get("v.recordIdField"),
            nullSort : component.get("v.nullSort"),
            recordLimit : '5000'
        });
        action.setCallback(this, function(response){
            var name = response.getState();
            if(name === "SUCCESS") {
                component.set("v.records", response.getReturnValue());
                helper.getFields(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    getFields : function(component, event, helper) {
        var action = component.get("c.getAllFields");
        action.setParams({
            sObj : component.get("v.objectAPI"),
            fieldSetName : component.get("v.fieldSetName")
        });
        action.setCallback(this, function(response){
            var name = response.getState();
            if(name === "SUCCESS") {
                component.set("v.fields", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    sortHelper : function(component, event, helper) {
        var currentDir = component.get("v.arrowDirection");
        var sortField = event.currentTarget.getAttribute('data-sortField');
        console.log('sortField '+sortField);
        component.set("v.sortField", sortField);
        if(currentDir == "arrowdown") {
            component.set("v.arrowDirection", "arrowup");
            component.set("v.isAsc", true);
        }
        else {
            component.set("v.arrowDirection", "arrowdown");
            component.set("v.isAsc", false);
        }
        var recId = component.get("v.recordId");
        var action = component.get("c.getAllSortedRecords");
        action.setParams({
            sortField : component.get("v.sortField"),
            isAsc : component.get("v.isAsc"),
            sObj : component.get("v.objectAPI"),
            relateField : component.get("v.relatedFieldAPI"), 
            recId : recId,
            filterString : component.get("v.filterString"),
            fieldSetName : component.get("v.fieldSetName"),
            recordIdField : component.get("v.recordIdField"),
            nullSort : component.get("v.nullSort"),
            recordLimit : component.get("v.recordLimit")
        });
        action.setCallback(this, function(response){
            var name = response.getState();
            if(name === "SUCCESS") {
                component.set("v.records", response.getReturnValue());
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },
    newRecord : function(component, event, helper) {
        window.open('/lightning/o/'+component.get("v.objectAPI")+'/new');
    }
})