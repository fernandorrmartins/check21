@isTest
class EndpointServiceHelperTest
{
    @isTest
    static void getByDevelopernameTest()
    {
        List<EndpointService__mdt> endpointServiceList = EndpointService__mdt.getAll().values();
        System.assert(!endpointServiceList.isEmpty(), 'No record for this medata was found: EndpointService__mdt.');
        EndpointService__mdt record = endpointServiceList.get(0);
        Test.startTest();
        EndpointService__mdt endpointServiceRecord = EndpointServiceHelper.getByDevelopername(endpointServiceList, record.DeveloperName);
        Test.stopTest();
        System.assertEquals(record.DeveloperName, endpointServiceRecord.DeveloperName);
        System.assertEquals(record.Path__c, endpointServiceRecord.Path__c);
        System.assertEquals(record.Method__c, endpointServiceRecord.Method__c);
        System.assertEquals(record.Endpoint__c, endpointServiceRecord.Endpoint__c);
    }
}