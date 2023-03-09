public without sharing class NationalHolidaysSelector {
    private static NationalHolidaysSelector INSTANCE
    {
        private set;
        private get
        {
            if(NationalHolidaysSelector.INSTANCE == null)
            {
                NationalHolidaysSelector.INSTANCE = new NationalHolidaysSelector();
            }
            return NationalHolidaysSelector.INSTANCE;
        }
    }

    private NationalHolidaysSelector() {}

    public static NationalHolidaysSelector getInstance()
    {
        return NationalHolidaysSelector.INSTANCE;
    }

    public List<National_Holidays__c> getByYear(Set<Integer> yearSet)
    {
        Integer year = System.now().year();
        List<National_Holidays__c> nationalHolidaysList = [
            SELECT Name, Date__c, Type__c
            FROM National_Holidays__c
            WHERE CALENDAR_YEAR(Date__c) = :yearSet
        ];
        return nationalHolidaysList;
    }
}