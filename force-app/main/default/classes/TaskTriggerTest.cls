@isTest
class TaskTriggerTest {
    @TestSetup
    static void setup()
    {
        National_Holidays__c holiday1 = new National_Holidays__c(
            Name='Carnaval 1',
            Date__c=System.today().addDays(1),
            Type__c='National'
        );
        insert holiday1;
    }

    @isTest
    static void insertTest()
    {
        Task newTask = new Task(
            Status='Not Started',
            Subject='Other',
            ActivityDate=System.today().addDays(1),
            Priority='Normal',
            OwnerId=UserInfo.getUserId()
        );

        Test.startTest();
        insert newTask;
        Test.stopTest();

        List<Task> taskList = [SELECT Id, IsHoliday__c FROM Task];
        System.assert(!taskList.isEmpty());
        System.assert(taskList.get(0).IsHoliday__c);
    }

    @isTest
    static void updateTest()
    {
        Task newTask = new Task(
            Status='Not Started',
            Subject='Other',
            Priority='Normal',
            OwnerId=UserInfo.getUserId()
        );
        insert newTask;

        List<Task> taskList = [SELECT Id, IsHoliday__c FROM Task];
        System.assert(!taskList.isEmpty());
        System.assert(!taskList.get(0).IsHoliday__c);

        newTask.ActivityDate=System.today().addDays(1);

        Test.startTest();
        update newTask;
        Test.stopTest();

        List<Task> taskList1 = [SELECT Id, IsHoliday__c FROM Task];
        System.assert(!taskList1.isEmpty());
        System.assert(taskList1.get(0).IsHoliday__c);
    }
}