public class GoogleDriveCallouts {
	@future(callout=true)
    public static void deleteFile(String fileID) {
        // Get settings from metadata
        Google_Drive_Setting__mdt settings = [SELECT prefix__c, from_folder__c, to_folder__c FROM Google_Drive_Setting__mdt WHERE DeveloperName='ArrivalAid'];
        System.debug('Google Drive Settings: ' + settings.prefix__c + ' - ' + settings.from_folder__c + ' - ' + settings.to_folder__c);

        Http httpGetParents = new Http();
        HttpRequest requestGetParents = new HttpRequest();
        requestGetParents.setEndpoint('callout:Google_Drive_API/' + fileID + '/?fields=id,name,parents');
        requestGetParents.setMethod('GET');
        HttpResponse responseGetParents = httpGetParents.send(requestGetParents);
        System.debug('GET parents callout executed: ' + responseGetParents.getBody());
        String joinedParents = '';
        // If the request is successful, parse the JSON response.
        if (responseGetParents.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            Map<String, Object> getParentsResults = (Map<String, Object>) JSON.deserializeUntyped(responseGetParents.getBody());
            // Cast the values in the 'parents' key as a list
            List<Object> parents = (List<Object>) getParentsResults.get('parents');
            joinedParents = String.join(parents, ',');
            System.debug('Received the following parents: ' + joinedParents);
        }        
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Google_Drive_API/' + fileID + '?addParents=' + settings.to_folder__c + '&removeParents=' + joinedParents);
        request.setHeader('Content-Type', 'application/json');
		request.setHeader('X-HTTP-Method-Override','PATCH');
        request.setMethod('POST');
        request.setBody('{}');
        HttpResponse response = http.send(request);
        System.debug('PATCH callout executed: ' + response.getBody());
    }

    @InvocableMethod(label='Delete Google File')
    public static void deleteFileInvocable(List<String> fileIDS) {
        for (String fileID:fileIDS) {
         deleteFile(fileID);           
        }
    }

}