public with sharing class UrlaubDeleteHelper {
  @InvocableMethod(
    label='Delete existing PTO days between start date and end date'
  )
  public static void deleteUrlaub(
    List<UrlaubHelper.UrlaubRequest> inputParams
  ) {
    for (UrlaubHelper.UrlaubRequest p : inputParams) {
      UrlaubHelper.deleteUrlaubRecords(p);
    }
  }
}
