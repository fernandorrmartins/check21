@isTest
class ScheduledHolidayServiceTest {
    @isTest
    static void executeTest()
    {
        ScheduledHolidayServiceTest.setMock();
        Test.startTest();
        ScheduledHolidayService.execute(2023, 1, 1);
        Test.stopTest();
        List<National_Holidays__c> nationalHolidaysList = [SELECT Id FROM National_Holidays__c];
        System.assert(!nationalHolidaysList.isEmpty());
    }

    @isTest
    static void scheduleJobTest()
    {
        ScheduledHolidayServiceTest.setMock();
        Test.startTest();
        ScheduledHolidayService.scheduleJob();
        Test.stopTest();
    }

    @isTest
    static void scheduleTest()
    {
        ScheduledHolidayServiceTest.setMock();
        Date executeDt = Date.newInstance(System.today().year(), 1, 1);
        ScheduledHolidayService job = new ScheduledHolidayService(executeDt);

        Test.startTest();
        System.schedule(
            job.getNextSchedule().format(ScheduledHolidayService.SCHEDULABLE_JOB_TITLE_FORMAT) + ScheduledHolidayService.SCHEDULABLE_JOB_TITLE_TEXT,
            ScheduledHolidayService.CRON_EXPRESSION,
            job
        );
        Test.stopTest();
    }

    private static void setMock()
    {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource(System.Label.StaticResourceBrasilAPIHolidayResponseStatusCode200);
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
    }
}