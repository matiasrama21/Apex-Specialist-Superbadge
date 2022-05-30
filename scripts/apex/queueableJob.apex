
WarehouseCalloutService queueableJob = new WarehouseCalloutService();
Id jobId = System.enqueueJob(queueableJob);
System.debug([SELECT Status FROM AsyncApexJob WHERE Id =: jobId][0].Status);