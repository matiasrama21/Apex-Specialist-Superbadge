
WarehouseSyncSchedule schedulableJob = new WarehouseSyncSchedule();
String sch = '0 0 1 * * ?';
String jobId = System.schedule('WarehouseSyncScheduleJob', sch, schedulableJob);