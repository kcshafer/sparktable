public with sharing class CustomTableController {

    @auraEnabled
    public static String goToNewRecord(String sObj) {
        sObject mysObj = Schema.getGlobalDescribe().get(sObj).newSObject();
        DescribeSObjectResult describeResult = mysObj.getSObjectType().getDescribe();
        String keyPrefix = describeResult.getKeyPrefix();
        return keyPrefix;
    }

    @auraEnabled
    public static List<sObject> getAllRecords(String sObj, String relateField, Id recId, String filterString, String fieldSetName, String recordIdField, Boolean nullSort, String recordLimit) {
        List<sObject> records = new LIST<sObject> ();
        String relatedFieldId;
        system.debug('record id field -> ' + recordIdField);
        if (recordIdField != '' && recordIdField != null) {
            relatedFieldId = getRelatedId(recId, recordIdField);
        }

        System.debug('related field id -> ' + relatedFieldId);
        System.debug('relate field -> ' + relateField);

        system.debug('sobj -> ' + sObj);
        String query = 'SELECT Id, Name,';
        String fields = '';
        if (relateField == '' || relateField == null) {
            relateField = 'Id';
        }
        sObject mysObj = Schema.getGlobalDescribe().get(sObj).newSObject();
        DescribeSObjectResult describeResult = mysObj.getSObjectType().getDescribe();
        system.debug('fieldSetName ' + fieldSetName);
        system.debug('fieldsetMap ' + describeResult.fieldsets.getMap());
        if (fieldSetName != '' && fieldSetName != null) {
            fieldSetName = fieldSetName.toLowerCase();
            if (describeResult.fieldsets.getMap().get(fieldSetName) != null) {
                for (Schema.FieldSetMember f : describeResult.fieldsets.getMap().get(fieldSetName).getFields()) {
                    String fieldType = String.valueOf(f.getType());
                    system.debug('type ' + fieldType);
                    system.debug(fieldType == 'REFERENCE');
                    if (f.getFieldPath() != 'Name' && f.getFieldPath() != 'Id') {
                        if (fieldType == 'REFERENCE') {
                            if (f.getFieldPath().substring(f.getFieldPath().length() - 2, f.getFieldPath().length()) == 'Id') {
                                fields += ' ' + f.getFieldPath().replace('Id', '') + '.Id,';
                                fields += ' ' + f.getFieldPath().replace('Id', '') + '.Name,';
                            }
                            else {
                                fields += ' ' + f.getFieldPath().replace('__c', '__r') + '.Id,';
                                fields += ' ' + f.getFieldPath().replace('__c', '__r') + '.Name,';
                            }
                        }
                        else {
                            fields += ' ' + f.getFieldPath() + ',';
                        }
                    }
                }
            }
        }
        if (fields != '' && fields != null) {
            query += fields.substring(0, fields.length() - 1);
        }
        else {
            query = query.substring(0, query.length() - 1);
        }
        query += ' FROM ' + describeResult.getName() + ' WHERE ' + relateField;
        if (recordIdField != '' && recordIdField != null) {
            query += ' =: relatedFieldId';
        }
        else {
            query += ' =: recId';
        }
        if (filterString != '' && filterString != null) {
            query += ' AND ' + filterString;
        }
        if (recordLimit != '' && recordLimit != null) {
            if (recordLimit.isNumeric()) {
                query += ' LIMIT ' + recordLimit;
            }
        }
        try {
            system.debug('query ' + query);
            records = Database.query(query);
            system.debug('results ' + records);
            return records;
        }
        catch(Exception ex) {
            AuraHandledException e = new AuraHandledException('Error Querying Records: ' + ex);
            e.setMessage('Error Querying Records: ' + ex);
            throw e;
        }
    }

    @auraEnabled
    public static List<sObject> getAllSortedRecords(String sortField, Boolean isAsc, String sObj, String relateField, Id recId, String filterString, String fieldSetName, String recordIdField, Boolean nullSort, String recordLimit) {
        List<sObject> records = new LIST<sObject> ();
        String relatedFieldId;
        if (recordIdField != null && recordIdField != '') {
            relatedFieldId = getRelatedId(recId, recordIdField);
        }
        String query = 'SELECT Id, Name,';
        String fields = '';
        if (relateField == '' || relateField == null) {
            relateField = 'Id';
        }
        sObject mysObj = Schema.getGlobalDescribe().get(sObj).newSObject();
        DescribeSObjectResult describeResult = mysObj.getSObjectType().getDescribe();
        system.debug('fieldSetName ' + fieldSetName);
        system.debug('fieldsetMap ' + describeResult.fieldsets.getMap());
        if (fieldSetName != '' && fieldSetName != null) {
            fieldSetName = fieldSetName.toLowerCase();
            if (describeResult.fieldsets.getMap().get(fieldSetName) != null) {
                for (Schema.FieldSetMember f : describeResult.fieldsets.getMap().get(fieldSetName).getFields()) {
                    String fieldType = String.valueOf(f.getType());
                    system.debug('type ' + fieldType);
                    system.debug(fieldType == 'REFERENCE');
                    if (f.getFieldPath() != 'Name' && f.getFieldPath() != 'Id') {
                        if (fieldType == 'REFERENCE') {
                            if (f.getFieldPath().substring(f.getFieldPath().length() - 2, f.getFieldPath().length()) == 'Id') {
                                fields += ' ' + f.getFieldPath().replace('Id', '') + '.Id,';
                                fields += ' ' + f.getFieldPath().replace('Id', '') + '.Name,';
                            }
                            else {
                                fields += ' ' + f.getFieldPath().replace('__c', '__r') + '.Id,';
                                fields += ' ' + f.getFieldPath().replace('__c', '__r') + '.Name,';
                            }
                        }
                        else {
                            fields += ' ' + f.getFieldPath() + ',';
                        }
                    }
                }
            }
        }
        if (fields != '' && fields != null) {
            query += fields.substring(0, fields.length() - 1);
        }
        else {
            query = query.substring(0, query.length() - 1);
        }
        query += ' FROM ' + describeResult.getName() + ' WHERE ' + relateField;
        if (recordIdField != null && recordIdField != '') {
            query += ' =: relatedFieldId';
        }
        else {
            query += ' =: recId';
        }
        if (filterString != '' && filterString != null) {
            query += ' AND ' + filterString + ' ';
        }
        if (sortField != '' && sortField != null) {
            query += ' ORDER BY ' + sortField;
            if (isAsc) {
                query += ' ASC';
            }
            else {
                query += ' DESC';
            }
            if (nullSort) {
                query += ' NULLS FIRST ';
            }
            else {
                query += ' NULLS LAST ';
            }
        }
        if (recordLimit != '' && recordLimit != null) {
            if (recordLimit.isNumeric()) {
                query += ' LIMIT ' + recordLimit;
            }
        }
        try {
            system.debug('query ' + query);
            records = Database.query(query);
            system.debug('results ' + records);
            return records;
        }
        catch(Exception ex) {
            AuraHandledException e = new AuraHandledException('Error Querying Records: ' + ex);
            e.setMessage('Error Querying Records: ' + ex);
            throw e;
        }
    }

    @auraEnabled
    public static List<MyField> getAllFields(String sObj, String fieldSetName) {
        sObject mysObj = Schema.getGlobalDescribe().get(sObj).newSObject();
        Set<MyField> setAllFields = new Set<MyField> ();
        List<MyField> allFields = new List<MyField> ();
        setAllFields.add(new MyField('Id', 'Id', '', 'ID'));
        setAllFields.add(new MyField('Name', 'Name', '', 'STRING'));
        DescribeSObjectResult describeResult = mysObj.getSObjectType().getDescribe();
        if (fieldSetName != '' && fieldSetName != null) {
            fieldSetName = fieldSetName.toLowerCase();
            if (describeResult.fieldsets.getMap().get(fieldSetName) != null) {
                for (Schema.FieldSetMember f : describeResult.fieldsets.getMap().get(fieldSetName).getFields()) {
                    if (String.valueOf(f.getType()) == 'REFERENCE') {
                        setAllFields.add(new MyField(f.getLabel(), f.getFieldPath(), f.getFieldPath().replace('__c', '__r'), 'REFERENCE'));
                    }
                    else {
                        setAllFields.add(new MyField(f.getLabel(), f.getFieldPath(), '', String.valueOf(f.getType())));
                    }
                }
            }
        }
        system.debug('setAllFields ' + setAllFields);
        allFields.addAll(setAllFields);
        return allFields;
    }

    public static String getRelatedId(String recId, String recordIdField) {
        System.debug('record id field -> ' + recordIdField);
        Schema.SObjectType sobjectType = Id.valueOf(recId).getSObjectType();
        SObject record = Database.query('SELECT ' + recordIdField + ' FROM ' + sobjectType.getDescribe().getName() + ' WHERE Id = :recId');
        String relatedId = String.valueOf(record.get(recordIdField));
        return relatedId;
    }

    public class MyField {
        @auraEnabled
        public String label;

        @auraEnabled
        public String apiName;

        @auraEnabled
        public String relationName;

        @auraEnabled
        public String fieldType;

        public MyField(String label, String apiName, String relationName, String fieldType) {
            this.label = label;
            this.apiName = apiName;
            this.relationName = relationName;
            this.fieldType = fieldType;
        }
    }
}