public inherited sharing class EndpointServiceSelector
{
    private static EndpointServiceSelector INSTANCE
    {
        private set;
        private get
        {
            if(EndpointServiceSelector.INSTANCE == null)
            {
                EndpointServiceSelector.INSTANCE = new EndpointServiceSelector();
            }
            return EndpointServiceSelector.INSTANCE;
        }
    }

    private EndpointServiceSelector() {}

    public static EndpointServiceSelector getInstance()
    {
        return EndpointServiceSelector.INSTANCE;
    }

    public List<EndpointService__mdt> get(Set<String> developerNameSet)
    {
        List<EndpointService__mdt> endpointServiceList = [
            SELECT
                Path__c, Method__c, DeveloperName,
                Endpoint__r.Endpoint__c
            FROM EndpointService__mdt
            WHERE DeveloperName IN :developerNameSet
        ];
        return endpointServiceList;
    }
}