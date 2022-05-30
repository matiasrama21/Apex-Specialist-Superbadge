@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    @isTest
    static void unitTest() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        Test.startTest();

        Id jobId = System.enqueueJob(new WarehouseCalloutService());

        WarehouseCalloutService.calloutLogic();

        System.assertEquals(
            'Queued', 
            [SELECT Status FROM AsyncApexJob WHERE Id =: jobId][0].Status, 
            'El job se ejecuto antes de tiempo o no se encolo'
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