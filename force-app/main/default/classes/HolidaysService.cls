public class HolidaysService
{
    public static HTTPResponse execute(String year)
    {
        List<EndpointService__mdt> endpointServiceList = EndpointServiceSelector.getInstance().get(
            new Set<String> { System.Label.EndpointServiceDevelopernameBrasilAPIHolidays }
        );
        EndpointService__mdt endpointServiceRecord = EndpointServiceHelper.getByDevelopername(
            endpointServiceList,
            System.Label.EndpointServiceDevelopernameBrasilAPIHolidays
        );
        if(endpointServiceRecord == null) { throw new HolidaysServiceException(System.Label.HolidaysServiceExceptionEndpointServiceNotFound); }
        String endpoint = formatEndpoint(endpointServiceRecord, year);
        HttpRequest request = HolidaysService.createRequest(endpoint, endpointServiceRecord.Method__c);
        HTTPResponse response = new Http().send(request);
        return response;
    }

    @TestVisible
    private static HttpRequest createRequest(String endpoint, String method)
    {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(method);
        return request;
    }
    
    @TestVisible
    private static String formatEndpoint(EndpointService__mdt endpointServiceRecord, String year)
    {
        String path = String.format(endpointServiceRecord.Path__c, new String[] { year });
        String endpoint = endpointServiceRecord.Endpoint__r.Endpoint__c + path;
        return endpoint;
    }

    public class HolidaysServiceException extends Exception {}
}