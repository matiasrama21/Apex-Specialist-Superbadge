public with sharing class MaintenanceRequestHelper {
    
    /*
     * Retorna el ciclo de mantenimineto mas corto de una lista de Equipment_Maintenance_Item__c 
     */
    private static Integer lowestMaintenanceCycle(List<Equipment_Maintenance_Item__c> equipment, ID caseId) {
        Integer lowest = 2147483647;
        for(Equipment_Maintenance_Item__c emi : equipment) {
            if(emi.Maintenance_Request__c == caseId && emi.Equipment__r.Maintenance_Cycle__c < lowest) {
                lowest = (Integer) emi.Equipment__r.Maintenance_Cycle__c;
            }
        }
        return lowest;
    }

    public static void beforeUpdate(List<Case> cases) {
        List<Case> cases2insert = new List<Case>();
        Map<Id, Case> moveEquipmentMap = new Map<Id, Case>();
        Map<Id, Case> cases2proccesMap = new Map<Id, Case>();
        
        /*
         * Solo proceso las solicitudes de mantenimiento que tengo que procesar
         */
        for(Case c : cases) {
            if(c.Status == 'Closed' && (c.Type == 'Repair' || c.Type == 'Routine Maintenance')) {
                cases2proccesMap.put(c.id, c);
            }
        }

        /* 
         * Traigo los items de equipamiento de las solicitudes a procesar 
         */
        List<Equipment_Maintenance_Item__c> allEquipment = 
            [SELECT Maintenance_Request__c, Equipment__r.Maintenance_Cycle__c
            FROM Equipment_Maintenance_Item__c 
            WHERE Maintenance_Request__c IN :cases2proccesMap.keySet() 
            WITH SECURITY_ENFORCED];

        for(Case c : cases2proccesMap.values()) {
            Case newCase = new Case();
            newCase.Type = 'Routine Maintenance';
            newCase.Status = 'New';
            newCase.Subject = 'Maintenance request routine for: ' + (c.Subject != null ? c.Subject : '');
            newCase.Date_Reported__c = date.today();
            newCase.Vehicle__c = c.Vehicle__c;
            Integer maintenanceCycle = lowestMaintenanceCycle(allEquipment, c.Id);
            newCase.Date_Due__c = date.today().addDays(maintenanceCycle);
            
            cases2insert.add(newCase);
            moveEquipmentMap.put(c.Id, newCase);
        }

        if(Case.sObjectType.getDescribe().isCreateable()){
            insert cases2insert;
        }

        /*
         * Muevo el equipamiento de las solicitudes viejas a las nuevas
         */
        for(Equipment_Maintenance_Item__c emi : allEquipment){
            emi.Maintenance_Request__c = moveEquipmentMap.get(emi.Maintenance_Request__c).Id;
        }

        if(Equipment_Maintenance_Item__c.sObjectType.getDescribe().isUpdateable()) {
            update allEquipment;
        }
    } 
}