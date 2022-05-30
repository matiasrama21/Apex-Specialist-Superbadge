@isTest
public class TestDataFactory {
    
    public static List<Case> fullDataSetup() {
        List<Vehicle__c> vehicles = new List<Vehicle__c>();
        List<Case> cases = new List<Case>();
        List<Equipment_Maintenance_Item__c> items = new List<Equipment_Maintenance_Item__c>();
        List<Product2> equipments = new List<Product2>();

        for(Integer i = 0; i < 300; i++) {
            Vehicle__c vehicle = new Vehicle__c();
            vehicle.Name = 'Test Vehicle ' + i;
            vehicles.add(vehicle);
        }

        insert vehicles;

        for(Integer i = 0; i < 300; i++) {
            Case c = new Case();
            c.Type = 'Repair';
            c.Status = 'New';
            c.Subject = 'Test Maintenance Request Routine';
            c.Date_Reported__c = date.today();
            c.Vehicle__c = vehicles.get(i).Id;
            cases.add(c);
        }

        insert cases;

        for(Integer i = 0; i < 300; i++) {
            Product2 equipment = new Product2();
            equipment.Name = 'Test Equipment ' + i;
            equipment.Replacement_Part__c = true;
            equipment.Maintenance_Cycle__c = i*10;
            equipments.add(equipment);
        }

        insert equipments;

        for(Integer i = 0; i < 300; i++) {
            Equipment_Maintenance_Item__c item = new Equipment_Maintenance_Item__c();
            item.Maintenance_Request__c = cases.get(i).Id;
            item.Equipment__c = equipments.get(i).Id;
            items.add(item);
        }

        insert items;

        return cases;
    }

    public static Vehicle__c singleVehicle() {
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Name = 'Test Vehicle 1';
        insert vehicle;
        return vehicle;
    }

    public static Case singleCase(Vehicle__c vehicle) {
        Case c = new Case();
        c.Type = 'Repair';
        c.Status = 'New';
        c.Subject = 'Single Test Maintenance Request Routine';
        c.Date_Reported__c = date.today();
        c.Vehicle__c = vehicle.Id;
        insert c;
        return c;
    }

    public static Product2 singleEquipment() {
        Product2 equipment = new Product2();
        equipment.Name = 'Test Equipment 1';
        equipment.Replacement_Part__c = true;
        equipment.Maintenance_Cycle__c = 15;
        insert equipment;
        return equipment;
    }

    public static Equipment_Maintenance_Item__c singleEquipmentItem(Case c, Product2 equipment) {
        Equipment_Maintenance_Item__c item = new Equipment_Maintenance_Item__c();
        item.Maintenance_Request__c = c.Id;
        item.Equipment__c = equipment.Id;
        insert item;
        return item;
    }
}