public inherited sharing class EndpointServiceHelper
{
    public static EndpointService__mdt getByDevelopername(List<EndpointService__mdt> endpointServiceList, String developername)
    {
        EndpointService__mdt endpointServiceRecord = null;
        if(endpointServiceList != null)
        {
            for(EndpointService__mdt record : endpointServiceList)
            {
                if(record.DeveloperName.equals(developername))
                {
                    endpointServiceRecord = record;
                }
            }
        }
        return endpointServiceRecord;
    }
}