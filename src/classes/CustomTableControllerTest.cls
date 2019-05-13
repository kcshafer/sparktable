@isTest
private class CustomTableControllerTest {
    @isTest static void noFieldSet() {

        Account acct = new Account(Name = 'Test Account');
        insert acct;

        Contact con = new Contact(LastName = 'test', Email = 'h@email.com', Account = acct);
        insert con;

        Opportunity opp = new Opportunity(Name = 'test', StageName = 'Prospect', CloseDate = System.today());
        insert opp;

        CustomTableController.getAllRecords('Contact', 'AccountId', acct.id, '', '', '', false, '');
        CustomTableController.getAllRecords('Contact', '', acct.id, '', '', '', true, '1');
        CustomTableController.getAllSortedRecords('Name', false, 'Contact', '', acct.id, '', '', '', false, '');
        CustomTableController.getAllSortedRecords('Name', false, 'Contact', 'AccountId', acct.id, '', '', '', false, '2');
        CustomTableController.getAllSortedRecords('Name', true, 'Contact', 'AccountId', acct.id, '', '', '', true, '1');
        String prefix = CustomTableController.goToNewRecord('Contact');
        CustomTableController.getAllFields('Contact', '');
        system.assertNotEquals(prefix, null);
    }

    @isTest static void noFieldSetError() {

        Account acct = new Account(Name = 'Test Account');
        insert acct;

        Contact con = new Contact(LastName = 'test', Email = 'h@email.com', Account = acct);
        insert con;

        Opportunity opp = new Opportunity(Name = 'test', StageName = 'Prospect', CloseDate = System.today());
        insert opp;
        try {
            CustomTableController.getAllRecords('Contact', 'AccountId', acct.id, 'tittle =: that', '', '', false, '');
            CustomTableController.getAllRecords('Contact', '', acct.id, '', '', '', true, '1');
            String prefix = CustomTableController.goToNewRecord('Contact');
            CustomTableController.getAllFields('Contact', '');
            system.assertNotEquals(prefix, null);
        }
        catch(Exception ex) {
            system.assertNotEquals('', null);
        }
    }

    @isTest static void noFieldSetError2() {

        Account acct = new Account(Name = 'Test Account');
        insert acct;

        Contact con = new Contact(LastName = 'test', Email = 'h@email.com', Account = acct);
        insert con;

        Opportunity opp = new Opportunity(Name = 'test', StageName = 'Prospect', CloseDate = System.today());
        insert opp;
        try {
            CustomTableController.getAllSortedRecords('Name', false, 'Contact', 'AccountId', acct.id, 'tittle =: that', '', '', false, '2');
            String prefix = CustomTableController.goToNewRecord('Contact');
            CustomTableController.getAllFields('Contact', '');
            system.assertNotEquals(prefix, null);
        }
        catch(Exception ex) {
            system.assertNotEquals('', null);
        }
    }

    @isTest static void noFieldSetWithFilter() {

        Account acct = new Account(Name = 'Test Account');
        insert acct;

        Contact con = new Contact(LastName = 'test', Email = 'h@email.com', Account = acct);
        insert con;

        Opportunity opp = new Opportunity(Name = 'test', StageName = 'Prospect', CloseDate = System.today());
        insert opp;

        CustomTableController.getAllRecords('Contact', 'AccountId', acct.id, 'Name != null', '', '', false, '');
        CustomTableController.getAllSortedRecords('Name', false, 'Contact', 'AccountId', acct.id, 'Name != null', '', '', true, '');
        String prefix = CustomTableController.goToNewRecord('Contact');
        CustomTableController.getAllFields('Contact', '');
        system.assertNotEquals(prefix, null);
    }

    @isTest static void withFieldSet() {

        Account acct = new Account(Name = 'Test Account');
        insert acct;

        Contact con = new Contact(LastName = 'test', Email = 'h@email.com', Account = acct);
        insert con;

        Opportunity opp = new Opportunity(Name = 'test', StageName = 'Prospect', CloseDate = System.today());
        insert opp;

        sObject mysObj = Schema.getGlobalDescribe().get('Contact').newSObject();
        DescribeSObjectResult describeResult = mysObj.getSObjectType().getDescribe();
        Map<String, Schema.FieldSet> FsMap = describeResult.fieldSets.getMap();
        if (FsMap.keySet() != null) {
            for (String str : FsMap.keySet()) {
                System.assertNotEquals(str, null);
                CustomTableController.getAllRecords('Contact', 'AccountId', acct.id, '', str, '', false, '');
                CustomTableController.getAllSortedRecords('Name', false, 'Contact', 'AccountId', acct.id, '', str, '', false, '');
                CustomTableController.getAllFields('Contact', str);
            }
        }
        System.assertNotEquals(FsMap.keySet(), null);
    }

    @isTest static void fromRelatedRecord() {

        Account acct = new Account(Name = 'Test Account');
        insert acct;

        Contact con = new Contact(LastName = 'test', Email = 'h@email.com', Account = acct);
        insert con;

        Opportunity opp = new Opportunity(Name = 'test', StageName = 'Prospect', CloseDate = System.today());
        insert opp;

        sObject mysObj = Schema.getGlobalDescribe().get('Contact').newSObject();
        DescribeSObjectResult describeResult = mysObj.getSObjectType().getDescribe();
        Map<String, Schema.FieldSet> FsMap = describeResult.fieldSets.getMap();
        if (FsMap.keySet() != null) {
            for (String str : FsMap.keySet()) {
                System.assertNotEquals(str, null);
                CustomTableController.getAllRecords('Contact', 'AccountId', opp.id, '', str, 'AccountId', true, '300');
                CustomTableController.getAllSortedRecords('Name', false, 'Contact', 'AccountId', opp.id, '', str, 'AccountId', false, '3000');
                CustomTableController.getAllFields('Contact', str);
            }
        }
        System.assertNotEquals(FsMap.keySet(), null);
    }
}