public without sharing class DynamicAnonymizerActions {
  public class anonymizeRequests {
    @InvocableVariable(
      label='Record Id'
      description='Id of record to be anonymized'
      required=true
    )
    public String record;

    @InvocableVariable(
      label='Compliance Group Delete'
      description='Value of the selected compliance group attribute to delete fields'
      required=true
    )
    public String complianceGroupDelete;

    @InvocableVariable(
      label='Compliance Group Anonymize'
      description='Value of the selected compliance group attribute to anonymize fields'
      required=true
    )
    public String complianceGroupAnonymize;
  }

  @InvocableMethod(
    label='Anonymize Field Values'
    description='Filed values are either deleted or anonymized based on data classification metadata.'
  )
  public static void anonymizeFields(List<anonymizeRequests> requests) {
    List<Sobject> updatedList = new List<Sobject>();
    for (anonymizeRequests request : requests) {
      // get metadata information about object and fields
      Id recordId = Id.valueOf(request.record);
      Schema.SObjectType token = recordId.getSObjectType();
      Schema.DescribeSObjectResult dr = token.getDescribe();
      String entityName = dr.getName();
      updatedList.add(
        getSobject(
          entityName,
          request.record,
          request.complianceGroupDelete,
          request.complianceGroupAnonymize
        )
      );
    }
    // batch update records
    System.debug('#### updatedList: ' + updatedList.size());
    Database.update(updatedList);
  }

  private static Sobject getSobject(
    String entityName,
    String recordId,
    String complianceGroupDelete,
    String complianceGroupAnonymize
  ) {
    List<FieldDefinition> fieldsDelete = [
      SELECT QualifiedApiName, DeveloperName, DataType
      FROM FieldDefinition
      WHERE
        EntityDefinitionId = :entityName
        AND ComplianceGroup = :complianceGroupDelete
    ];
    List<FieldDefinition> fieldsAnonymize = [
      SELECT QualifiedApiName, DeveloperName, DataType
      FROM FieldDefinition
      WHERE
        EntityDefinitionId = :entityName
        AND ComplianceGroup = :complianceGroupAnonymize
    ];

    // get record
    String query = 'SELECT Id';
    for (FieldDefinition field : fieldsAnonymize) {
      query += ', ' + field.QualifiedApiName;
    }
    query += ' FROM ' + entityName + ' WHERE Id = \'' + recordId + '\' LIMIT 1';
    Sobject s = Database.query(query);

    // delete fields
    for (FieldDefinition field : fieldsDelete) {
      s.put(field.QualifiedApiName, null);
    }

    // anonymize fields
    for (FieldDefinition field : fieldsAnonymize) {
      // check datatype
      switch on field.DataType {
        when 'Date' {
          Date value = (Date) s.get(field.QualifiedApiName);
          Date newValue = Date.newInstance(value.year(), 1, 1);
          s.put(field.QualifiedApiName, newValue);
        }
        when 'Checkbox' {
          s.put(field.QualifiedApiName, false);
        }
        when else {
          s.put(field.QualifiedApiName, null);
        }
      }
    }
    fieldsDelete = null;
    fieldsAnonymize = null;
    return s;
  }
}
