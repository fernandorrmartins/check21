public class HolidaysService
{
    public static List<National_Holidays__c> execute(String year)
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
        HolidaysService.handleStatus(response);
        List<National_Holidays__c> nationalHolidaysList = HolidaysService.retrieveNationalHolidayListFromJSON(response.getBody());
        return nationalHolidaysList;
    }

    @TestVisible
    private static List<National_Holidays__c> retrieveNationalHolidayListFromJSON(String jsonStr)
    {
        List<National_Holidays__c> nationalHolidaysList = new List<National_Holidays__c>();
        if(String.isNotBlank(jsonStr))
        {
            List<Object> holidaysObjList = (List<Object>) JSON.deserializeUntyped(jsonStr);
            for(Object obj : holidaysObjList)
            {
                National_Holidays__c nationalHoliday = HolidaysService.retrieveHolidayFromObj(obj);
                if(nationalHoliday != null)
                {
                    nationalHolidaysList.add(nationalHoliday);
                }
            }
        }
        return nationalHolidaysList;
    }

    @TestVisible
    private static National_Holidays__c retrieveHolidayFromObj(Object obj)
    {
        National_Holidays__c nationalHoliday = null;
        Map<String, Object> objMapped = (Map<String, Object>) obj;
        if(objMapped != null)
        {
            nationalHoliday = new National_Holidays__c(
                Name = String.valueOf(objMapped.get('name')),
                Date__c = Date.valueOf(String.valueOf(objMapped.get('date'))),
                Type__c = String.valueOf(objMapped.get('type'))
            );
        }
        return nationalHoliday;
    }

    @TestVisible
    private static void handleStatus(HTTPResponse response)
    {
        if(response != null && response.getStatusCode() != 200)
        {
            HolidayServiceError error = (HolidayServiceError) JSON.deserialize(response.getBody(), HolidayServiceError.class);
            throw new HolidaysServiceException(String.format('({0}) {1}', new String[] { String.valueOf(response.getStatusCode()), error.message }));
        }
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

    @TestVisible
    class HolidayServiceError
    {
        public String type;
        public String message;
    }

    public class HolidaysServiceException extends Exception {}
}