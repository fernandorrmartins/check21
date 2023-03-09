global class ScheduledHolidayService implements Schedulable {
    private Id contextId;
    private Date nextExecutionDt;
    @TestVisible
    private static final String CRON_EXPRESSION = '0 0 1 1 1 ? *';
    @TestVisible
    private static final String SCHEDULABLE_JOB_TITLE_FORMAT = 'yyyy-MM-dd';
    @TestVisible
    private static final String SCHEDULABLE_JOB_TITLE_TEXT = ' 01:00:00 a.m. Scheduled holiday service to update records in database.';
    

    public ScheduledHolidayService()
    {
        this.nextExecutionDt = this.getNextSchedule().date();
    }

    public ScheduledHolidayService(Date nextExecutionDt)
    {
        this.nextExecutionDt = nextExecutionDt;
    }
    
    public static void scheduleJob()
    {
        ScheduledHolidayService job = new ScheduledHolidayService();
        System.schedule(
            job.getNextSchedule().format(ScheduledHolidayService.SCHEDULABLE_JOB_TITLE_FORMAT) + ScheduledHolidayService.SCHEDULABLE_JOB_TITLE_TEXT,
            ScheduledHolidayService.CRON_EXPRESSION,
            job
        );
    }

    @TestVisible
    @Future(callout=true)
    private static void execute(Integer year, Integer month, Integer day)
    {
        Date nextExecutionDt = Date.newInstance(year, month, day);
        Boolean isValid = ScheduledHolidayService.checkValid(nextExecutionDt);
        if(isValid)
        {
            List<National_Holidays__c> nationalHolidaysList = HolidaysService.execute(String.valueOf(nextExecutionDt.year()));
            insert nationalHolidaysList;
        }
    }

    @TestVisible
    private static Boolean checkValid(Date nextExecutionDt)
    {
        Boolean isValid = nextExecutionDt != null && nextExecutionDt.day() == 1 && nextExecutionDt.month() == 1;
        return isValid;
    }

    global void execute(SchedulableContext context) {
        this.contextId = context?.getTriggerId();
        ScheduledHolidayService.execute(this.nextExecutionDt.year(), this.nextExecutionDt.month(), this.nextExecutionDt.day());
        this.reScheduleJob();
    }

    @TestVisible
    private void reScheduleJob()
    {
        if(String.isNotBlank(this.contextId)) {
            System.abortJob(this.contextId);
        }
        Datetime nextYear = this.getNextSchedule();
        System.schedule(
            nextYear.format(ScheduledHolidayService.SCHEDULABLE_JOB_TITLE_FORMAT) + ScheduledHolidayService.SCHEDULABLE_JOB_TITLE_TEXT,
            ScheduledHolidayService.CRON_EXPRESSION,
            new ScheduledHolidayService(nextYear.date())
        );
    }
    
    @TestVisible
    private Datetime getNextSchedule()
    {
        Datetime nextYear = Datetime.newInstance(System.now().year() + 1, 1, 1);
        return nextYear;
    }
}