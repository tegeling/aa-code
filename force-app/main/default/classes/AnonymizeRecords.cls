public without sharing class AnonymizeRecords {
  @InvocableMethod(
    label='Anonymize Records'
    description='NULLs or randomizes fields of the records based on the compliance group definition.'
  )
  public static void anonymize(List<List<String>> recordIds) {
    for (List<String> recordList : recordIds) {
      // We assume all records are of the same sObject
      String sobjectType = ((Id) recordList[0])
        .getSObjectType()
        .getDescribe()
        .getName();

      Map<String, FieldDefinition> fieldDefinitionMap = new Map<String, FieldDefinition>();
      for (FieldDefinition field : [
        SELECT QualifiedApiName, ComplianceGroup, ServiceDataType.DeveloperName
        FROM FieldDefinition
        WHERE
          EntityDefinitionId = :sobjectType
          AND ComplianceGroup IN ('DELETE', 'ANONYMIZE')
      ]) {
        fieldDefinitionMap.put(field.QualifiedApiName, field);
      }

      // For the SELECT statement, we only need to query the fields that have to be anonymized/deleted
      String fields = String.join(
        new List<String>(fieldDefinitionMap.keySet()),
        ', '
      );

      if (sobjectType == 'Account') {
        fields += ', IsPersonAccount';
      }

      String query =
        'SELECT ' +
        fields +
        ' FROM ' +
        sobjectType +
        ' WHERE Id IN :recordList';

      String escapedQuery = String.escapeSingleQuotes(query);
      List<sObject> records = Database.query(escapedQuery);

      //Iterate through all fields of all records and anonymize or delete them
      for (SObject record : records) {
        for (String field : fieldDefinitionMap.keySet()) {
          //Are we deleting or anonymizing?
          Boolean deleteValue = (fieldDefinitionMap.get(field)
            .ComplianceGroup == 'DELETE');
          Object fieldValue = record.get(field);
          //This only covers primitives, might be a problem with fields like email or restricted picklist fields :(
          String fieldType = fieldDefinitionMap.get(field)
            .ServiceDataType.DeveloperName;

          //Handle all the special cases...
          if (
            ((sobjectType == 'Account' &&
            (Boolean) record.get('IsPersonAccount')) ||
            sobjectType == 'Contact') && field == 'Name'
          ) {
            Object lastName = anonymizeField(
              fieldValue,
              fieldType,
              deleteValue
            );
            record.put('LastName', lastName);
            record.put('FirstName', null);
            record.put('Salutation', null);
          } else if (field.endsWith('Address')) {
            String prefix = field.removeEnd('Address');
            List<String> addressFields = new List<String>{
              'City',
              'Country',
              'GeocodeAccuracy',
              'Latitude',
              'Longitude',
              'PostalCode',
              'State',
              'Street'
            };
            for (String addField : addressFields) {
              record.put(prefix + addField, null);
            }
          } else if (fieldType == 'location' && field.endsWith('__c')) {
            String latitude = field.replace('__c', '__Latitude__s');
            String longitude = field.replace('__c', '__Longitude__s');
            record.put(latitude, null);
            record.put(longitude, null);
          } else {
            fieldValue = anonymizeField(fieldValue, fieldType, deleteValue);
            record.put(field, fieldValue);
          }
        }
      }

      try {
        update records;
      } catch (DmlException e) {
        System.debug('### EXCEPTION OCCURED: ' + e.getMessage());
      }
    }
  }

  // Helper class with static variable to minimize SOQL queries
  private static List<String> randomStrings;
  private static List<String> getRandomStrings() {
    if (randomStrings == null) {
      randomStrings = new List<String>();
      for (Anonym__c a : [SELECT Name__c FROM Anonym__c]) {
        randomStrings.add(a.Name__c);
      }
    }
    return randomStrings;
  }

  private static Object anonymizeField(
    Object fieldValue,
    String fieldType,
    Boolean deleteValue
  ) {
    List<String> randomStrings = getRandomStrings();
    String randomString = randomStrings[
      Integer.valueof((Math.random() * (randomStrings.size() - 1)))
    ];
    Double randomDouble = math.random() * 100;
    Integer randomInteger = Integer.valueof(randomDouble);
    Boolean randomBoolean = Math.mod(randomInteger, 2) == 0 ? true : false;
    Date randomDate = Date.newInstance(System.today().year(), 1, 1);
    DateTime randomDateTime = DateTime.newInstance(System.today().year(), 1, 1);

    switch on fieldType {
      when 'address' {
        System.debug('Skipping address');
      }
      when 'boolean' {
        fieldValue = deleteValue ? false : randomBoolean;
      }
      when 'date' {
        fieldValue = deleteValue ? null : randomDate;
      }
      when 'datetime' {
        fieldValue = deleteValue ? null : randomDateTime;
      }
      when 'double' {
        fieldValue = deleteValue ? null : randomDouble;
      }
      when 'id' {
        fieldValue = null;
      }
      when 'integer' {
        fieldValue = deleteValue ? null : randomInteger;
      }
      when 'location' {
        System.debug('Skipping location');
      }
      when 'string' {
        fieldValue = deleteValue ? null : randomString;
      }
    }
    return fieldValue;
  }
}
