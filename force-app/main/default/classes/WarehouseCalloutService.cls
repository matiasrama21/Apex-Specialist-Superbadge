public with sharing class WarehouseCalloutService implements Queueable {
    
    @future(callout=true)
    public static void calloutLogic() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            List<Object> result = (List<Object>) JSON.deserializeUntyped(response.getBody());
            List<Product2> equipments2update = new List<Product2>();

            for(Object iterEquipment : result) {
                Map<String, Object> equipmentMap = (Map<String, Object>) iterEquipment;

                Product2 equipment = new Product2();
                equipment.Name = (String) equipmentMap.get('name');
                equipment.Replacement_Part__c = true;
                equipment.Cost__c = (Decimal) equipmentMap.get('cost');
                equipment.Current_Inventory__c = (Integer) equipmentMap.get('quantity');
                equipment.Lifespan_Months__c = (Integer) equipmentMap.get('lifespan');
                equipment.Maintenance_Cycle__c = (Integer) equipmentMap.get('maintenanceperiod');
                equipment.Warehouse_SKU__c = (String) equipmentMap.get('sku');

                equipments2update.add(equipment);
            }

            upsert equipments2update Warehouse_SKU__c;
        }
    }

    public void execute(QueueableContext context) {
        calloutLogic();
    }
}