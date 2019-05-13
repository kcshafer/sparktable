({
    init : function(component, event, helper) {
        helper.getRecords(component, event, helper);
    },
    sort : function(component, event, helper) {
       helper.sortHelper(component, event, helper);
    },
    newObj : function(component, event, helper) {
        helper.newRecord(component, event, helper);
    },
    viewAll : function(component, event, helper) {
       helper.getAllRecords(component, event, helper);
    }
})