@isTest
class NationalHolidaysSelectorTest
{
    @TestSetup
    static void setup()
    {
        National_Holidays__c holiday = new National_Holidays__c(
            Name='Carnaval',
            Date__c=System.today(),
            Type__c='National'
        );
        insert holiday;
    }

    @isTest
    static void getTest()
    {
        Test.startTest();
        List<National_Holidays__c> nationalHolidaysList = NationalHolidaysSelector.getInstance().getByYear(new Set<Integer> { System.today().year() });
        Test.stopTest();
        System.assertEquals(1, nationalHolidaysList.size());
    }
}