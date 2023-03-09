@isTest
class NationalHolidaysSelectorTest
{
    @TestSetup
    static void setup()
    {
        List<National_Holidays__c> nationalHolidaysList = new List<National_Holidays__c>();
        National_Holidays__c holiday1 = new National_Holidays__c(
            Name='Carnaval 1',
            Date__c=System.today().addDays(1),
            Type__c='National'
        );
        nationalHolidaysList.add(holiday1);
        National_Holidays__c holiday2 = new National_Holidays__c(
            Name='Carnaval 2',
            Date__c=System.today(),
            Type__c='National'
        );
        nationalHolidaysList.add(holiday2);
        National_Holidays__c holiday3 = new National_Holidays__c(
            Name='Carnaval 3',
            Date__c=System.today().addDays(2),
            Type__c='National'
        );
        nationalHolidaysList.add(holiday3);
        insert nationalHolidaysList;
    }

    @isTest
    static void getByYearTest()
    {
        Test.startTest();
        List<National_Holidays__c> nationalHolidaysList = NationalHolidaysSelector.getInstance().getByYear(new Set<Integer> { System.today().year() });
        Test.stopTest();
        System.assertEquals(3, nationalHolidaysList.size());
    }

    @isTest
    static void getNextHolidaysTest()
    {
        Test.startTest();
        List<National_Holidays__c> nationalHolidaysList = NationalHolidaysSelector.getInstance().getNextHolidays();
        Test.stopTest();
        System.assertEquals(3, nationalHolidaysList.size());
        System.assert(nationalHolidaysList.get(0).Date__c < nationalHolidaysList.get(1).Date__c);
        System.assert(nationalHolidaysList.get(1).Date__c < nationalHolidaysList.get(2).Date__c);
    }
}