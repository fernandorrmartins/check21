@isTest
class TaskTriggerHandlerTest {
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
    static void checkHolidaysTest()
    {
        Task taskRecord1 = new Task(ActivityDate=System.today());
        Task taskRecord2 = new Task(ActivityDate=System.today().addDays(1));
        Test.startTest();
        TaskTriggerHandler.checkHolidays(new List<Task> { taskRecord1, taskRecord2 });
        Test.stopTest();
        System.assert(taskRecord1.IsHoliday__c);
        System.assert(!taskRecord2.IsHoliday__c);
    }
}