trigger MaintenanceRequest on Case (before update) {
    MaintenanceRequestHelper.beforeUpdate(Trigger.New);
}