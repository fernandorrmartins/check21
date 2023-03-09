public without sharing class NextHolidayController {
    @AuraEnabled(cacheable=true)
    public static National_Holidays__c getNextHoliday()
    {
        List<National_Holidays__c> nextHolidays = NationalHolidaysSelector.getInstance().getNextHolidays();
        National_Holidays__c nextNationalHolidayRecord = nextHolidays.isEmpty() ? null : nextHolidays.get(0);
        return nextNationalHolidayRecord;
    }
}