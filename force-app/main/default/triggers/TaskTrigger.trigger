trigger TaskTrigger on Task (before insert, before update) {
    switch on Trigger.OperationType  {
        when BEFORE_INSERT
        {
            TaskTriggerHandler.checkHolidays(Trigger.new);
        }
        when BEFORE_UPDATE
        {
            TaskTriggerHandler.checkHolidays(Trigger.new);
            
        }
    }
}