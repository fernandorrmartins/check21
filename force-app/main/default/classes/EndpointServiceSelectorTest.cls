@isTest
class EndpointServiceSelectorTest
{
    @isTest
    static void getTest()
    {
        List<EndpointService__mdt> endpointServiceList0 = EndpointService__mdt.getAll().values();
        System.assert(!endpointServiceList0.isEmpty(), 'No record for this medata was found: EndpointService__mdt.');
        EndpointService__mdt record = endpointServiceList0.get(0);

        Test.startTest();
        List<EndpointService__mdt> endpointServiceList1 = EndpointServiceSelector.getInstance().get(new Set<String> { record.DeveloperName });
        Test.stopTest();

        System.assert(!endpointServiceList1.isEmpty(), 'No record was found for this developername: ' + record.DeveloperName);

        EndpointService__mdt endpointServiceRecord = endpointServiceList1.get(0);
        System.assertEquals(record.DeveloperName, endpointServiceRecord.DeveloperName);
        System.assertEquals(record.Path__c, endpointServiceRecord.Path__c);
        System.assertEquals(record.Method__c, endpointServiceRecord.Method__c);
        System.assertEquals(record.Endpoint__c, endpointServiceRecord.Endpoint__c);
    }
}