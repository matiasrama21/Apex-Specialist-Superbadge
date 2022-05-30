public with sharing class WarehouseSyncSchedule implements Schedulable {
    
    public void execute(SchedulableContext context) {
        Id jobId = System.enqueueJob(new WarehouseCalloutService());
    }
}