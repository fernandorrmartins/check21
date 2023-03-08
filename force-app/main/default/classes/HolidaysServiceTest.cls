@isTest
class HolidaysServiceTest
{
    @isTest
    static void executeTest()
    {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource(System.Label.StaticResourceBrasilAPIHolidayResponse);
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        String year = String.valueOf(System.now().year());

        Test.startTest();
        HTTPResponse response = HolidaysService.execute(year);
        Test.stopTest();

        String body = response.getBody();
        System.assert(String.isNotBlank(body));
        List<Object> holidaysList = (List<Object>) JSON.deserializeUntyped(body);
        System.assert(!holidaysList.isEmpty());
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

    private static EndpointService__mdt getAnyEndpointService()
    {
        List<EndpointService__mdt> endpointServiceList = EndpointService__mdt.getAll().values();
        System.assert(!endpointServiceList.isEmpty(), 'No record for this medata was found: EndpointService__mdt.');
        EndpointService__mdt record = endpointServiceList.get(0);
        return record;
    }
}