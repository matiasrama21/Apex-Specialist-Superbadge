@isTest 
private class MaintenanceRequestHelperTest {
    
    @isTest 
    static void positiveBulkTest() {
        List<Case> cases = TestDataFactory.fullDataSetup();

        for(Case c : cases) {
            c.Status = 'Closed';
        }

        Test.startTest();
        List<Database.SaveResult> results = Database.update(cases, true);
        Test.stopTest();

        for(Database.SaveResult result : results) {
            System.assert(result.isSuccess(), 'Update was not successful');
        }

        System.assertEquals(
            300, 
            [SELECT count() FROM Case WHERE Status = 'New'],
            'No se crearon 10 records de Case con estado = "New"'
        );

        System.assertEquals(
            300,
            [SELECT count() FROM Case WHERE Subject = 'Maintenance request routine for: Test Maintenance Request Routine'],
            'No se crearon 10 record de Case con Subject = "Maintenance request routine for: Test Maintenance Request Routine"'
        );
        
        System.assertEquals(
            300,
            [SELECT count() FROM Case WHERE Type = 'Routine Maintenance'],
            'No se crearon 10 record de Case con Type = "Routine Maintenance"'
        );
    }

    @isTest 
    static void positiveUnitTest() {
        Vehicle__c vehicle = TestDataFactory.singleVehicle();
        Case c = TestDataFactory.singleCase(vehicle);
        Product2 equipment = TestDataFactory.singleEquipment();
        Equipment_Maintenance_Item__c item = TestDataFactory.singleEquipmentItem(c, equipment);
        
        c.Status = 'Closed';

        Test.startTest();
        Database.SaveResult result = Database.update(c, true);
        Test.stopTest();

        System.assert(result.isSuccess(), 'Update was not successful');
        
        Case actual = [SELECT Id, Vehicle__r.Id, Date_Due__c FROM Case WHERE Subject = 'Maintenance request routine for: Single Test Maintenance Request Routine'][0];
        
        System.assertEquals(
            vehicle.Id, 
            actual.Vehicle__r.id,
            'El Vehiculo del Case creado por el trigger no es el mismo que el del Case que se cerro'
        );
            
        System.assertEquals(
            equipment.id, 
            [SELECT Equipment__r.Id FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c =: actual.Id][0].Equipment__r.Id,
            'El equipment del Case creado por el trigger no es el mismo que el del Case que se cerro'    
        );
                
        System.assertEquals(
            Date.today().addDays(15).format(), 
            actual.Date_Due__c.format(),
            'El Due Date no se calculo correctamente'
        );
    }
    
    @isTest 
    static void negativeTest() {
        Vehicle__c vehicle = TestDataFactory.singleVehicle();
        Case c = TestDataFactory.singleCase(vehicle);
        Product2 equipment = TestDataFactory.singleEquipment();
        Equipment_Maintenance_Item__c item = TestDataFactory.singleEquipmentItem(c, equipment);
        
        c.Type = 'Other';
        c.Status = 'Closed';
        
        Test.startTest();
        Database.SaveResult result = Database.update(c, true);
        Test.stopTest();

        System.assert(result.isSuccess(), 'Update was not successful');

        System.assert(
            [SELECT Id, Vehicle__r.Id, Date_Due__c FROM Case WHERE Subject = 'Maintenance request routine for: Single Test Maintenance Request Routine'].isEmpty(),
            'El trigger se ejecuto cuando se cerro un record de tipo "Other"'    
        );
    }
}