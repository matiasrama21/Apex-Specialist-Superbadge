@isTest
private with sharing class WarehouseSyncScheduleTest {
    
    public static final String CRON_EXP = '0 0 1 * * ?';

    @isTest
    static void unitTest() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        Test.startTest();

        String jobId = System.schedule(
            'Test job', 
            CRON_EXP, 
            new WarehouseSyncSchedule()
        );

        WarehouseCalloutService.calloutLogic();

        System.assertEquals(
            0, 
            [SELECT TimesTriggered FROM CronTrigger WHERE Id =: jobId][0].TimesTriggered, 
            'El shcedulable job se ejecuto antes del metodo stopTest'
        );

        Test.stopTest();

        System.assertEquals(
            3,
            [SELECT COUNT() FROM Product2], 
            'No se encontraron los 3 records de la fake response'
        );
        
        System.assertEquals(
            2,
            [SELECT COUNT() FROM Product2 WHERE Maintenance_Cycle__c = 0], 
            'No se encontraron 2 records con un periodo de mantenimiento de 0'
        );
        
        System.assertEquals(
            1,
            [SELECT COUNT() FROM Product2 WHERE Warehouse_SKU__c = '100003'], 
            'No se encontro el equipment de sku: 100003'
        );
    }
}
