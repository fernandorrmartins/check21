@isTest
class HolidaysServiceTest
{
    private static final String WRONG_EXCEPTION = 'Wrong exception!';
    private static final String SUPOSED_TO_THROW_AN_ERRO = 'Was suposed to throw an error!';
    @isTest
    static void execute200Test()
    {
        Integer statusCode = 200;
        HolidaysServiceTest.setTestMock(statusCode);
        String year = String.valueOf(System.now().year());

        Test.startTest();
        List<National_Holidays__c> nationalHolidaysList = HolidaysService.execute(year);
        Test.stopTest();
        System.assert(!nationalHolidaysList.isEmpty());
    }

    @isTest
    static void execute404Test()
    {
        Integer statusCode = 404;
        HolidaysServiceTest.setTestMock(statusCode);
        String year = String.valueOf(System.now().year());

        try
        {
            List<National_Holidays__c> nationalHolidaysList = HolidaysService.execute(year);
            System.assert(false, HolidaysServiceTest.WRONG_EXCEPTION);
        }
        catch(HolidaysService.HolidaysServiceException e)
        {
            System.assert(e.getMessage().contains(String.valueOf(statusCode)));
        }
        catch (Exception e)
        {
            System.assert(false, HolidaysServiceTest.WRONG_EXCEPTION);
        }
        
    }

    @isTest
    static void execute500Test()
    {
        Integer statusCode = 500;
        HolidaysServiceTest.setTestMock(statusCode);
        String year = String.valueOf(System.now().year());

        try
        {
            List<National_Holidays__c> nationalHolidaysList = HolidaysService.execute(year);
            System.assert(false, HolidaysServiceTest.WRONG_EXCEPTION);
        }
        catch(HolidaysService.HolidaysServiceException e)
        {
            System.assert(e.getMessage().contains(String.valueOf(statusCode)));
        }
        catch (Exception e)
        {
            System.assert(false, HolidaysServiceTest.WRONG_EXCEPTION);
        }
        
    }

    @isTest
    static void retrieveNationalHolidayListFromJSONTest()
    {
        String jsonStr = '[{"date":"2023-01-01","name":"Confraternização mundial","type":"national"}]';
        List<National_Holidays__c> nationalHolidaysList = HolidaysService.retrieveNationalHolidayListFromJSON(jsonStr);
        System.assertEquals(1, nationalHolidaysList.size());
    }

    @isTest
    static void retrieveHolidayFromObjTest()
    {
        Object obj = JSON.deserializeUntyped('{"date":"2023-01-01","name":"Confraternização mundial","type":"national"}');
        National_Holidays__c nationalHoliday = HolidaysService.retrieveHolidayFromObj(obj);
        System.assert(nationalHoliday.Name.equals('Confraternização mundial'));
        System.assert(nationalHoliday.Date__c == Date.valueOf('2023-01-01'));
        System.assert(nationalHoliday.Type__c.equals('national'));
    }

    @isTest
    static void handleStatusTest()
    {
        HolidaysService.HolidayServiceError error = new HolidaysService.HolidayServiceError();
        error.message = 'Error';
        HttpResponse response = new HttpResponse();
        response.setBody(JSON.serialize(error));
        response.setStatusCode(200);

        HolidaysService.handleStatus(response);

        try
        {
            response.setStatusCode(404);
            HolidaysService.handleStatus(response);
            System.assert(false, HolidaysServiceTest.SUPOSED_TO_THROW_AN_ERRO);
        }
        catch(HolidaysService.HolidaysServiceException e)
        {
            String errorMessage = String.format('({0}) {1}', new String[] { String.valueOf(response.getStatusCode()), error.message });
            System.assert(errorMessage.equals(e.getMessage()));
        }
        catch (Exception e)
        {
            System.assert(false, HolidaysServiceTest.WRONG_EXCEPTION);
        }

        try
        {
            response.setStatusCode(500);
            HolidaysService.handleStatus(response);
            System.assert(false, HolidaysServiceTest.SUPOSED_TO_THROW_AN_ERRO);
        }
        catch(HolidaysService.HolidaysServiceException e)
        {
            String errorMessage = String.format('({0}) {1}', new String[] { String.valueOf(response.getStatusCode()), error.message });
            System.assert(errorMessage.equals(e.getMessage()));
        }
        catch (Exception e)
        {
            System.assert(false, HolidaysServiceTest.WRONG_EXCEPTION);
        }
    }

    @isTest
    static void createRequestTest()
    {
        EndpointService__mdt record = HolidaysServiceTest.getAnyEndpointService();
        String year = String.valueOf(System.now().year());
        String endpoint = HolidaysService.formatEndpoint(record, year);

        Test.startTest();
        HttpRequest request = HolidaysService.createRequest(endpoint, record.Method__c);
        Test.stopTest();
        System.assertEquals(request.getEndpoint(), endpoint);
        System.assertEquals(request.getMethod(), record.Method__c);
    }

    @isTest
    static void formatEndpointTest()
    {
        EndpointService__mdt record = HolidaysServiceTest.getAnyEndpointService();
        String year = String.valueOf(System.now().year());
        String path = String.format(record.Path__c, new String[] { year });
        String endpoint = record.Endpoint__r.Endpoint__c + path;

        Test.startTest();
        String endpointFormated = HolidaysService.formatEndpoint(record, year);
        Test.stopTest();
        System.assertEquals(endpoint, endpointFormated);
    }

    private static void setTestMock(Integer statusCode)
    {
        String staticResource = null;
        switch on statusCode {
            when 200 { staticResource = System.Label.StaticResourceBrasilAPIHolidayResponseStatusCode200; }
            when 404 { staticResource = System.Label.StaticResourceBrasilAPIHolidayResponseStatusCode404; }
            when 500 { staticResource = System.Label.StaticResourceBrasilAPIHolidayResponseStatusCode500; }
        }
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource(staticResource);
        mock.setStatusCode(statusCode);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
    }

    private static EndpointService__mdt getAnyEndpointService()
    {
        List<EndpointService__mdt> endpointServiceList = EndpointService__mdt.getAll().values();
        System.assert(!endpointServiceList.isEmpty(), 'No record for this medata was found: EndpointService__mdt.');
        EndpointService__mdt record = endpointServiceList.get(0);
        return record;
    }
}