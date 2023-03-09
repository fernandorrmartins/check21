public inherited sharing class TaskTriggerHandler
{
    public static void checkHolidays(List<Task> taskList)
    {
        Set<Integer> yearSet = new Set<Integer>();
        for(Task record : taskList)
        {
            if(record.ActivityDate != null)
            {
                yearSet.add(record.ActivityDate.year());
            }
        }
        
        List<National_Holidays__c> nationalHolidaysList = NationalHolidaysSelector.getInstance().getByYear(yearSet);
        Set<Date> existHolidays = new Set<Date>();
        for(National_Holidays__c record : nationalHolidaysList)
        {
            if(record.Date__c != null)
            {
                existHolidays.add(record.Date__c);
            }
        }

        for(Task record : taskList)
        {
            if(record?.ActivityDate != null && existHolidays.contains(record.ActivityDate))
            {
                record.IsHoliday__c = true;
            }
        }
    }
}