public with sharing class UrlaubCreateHelper {
  @InvocableMethod(label='Create new PTO days between start date and end date')
  public static void createUrlaub(
    List<UrlaubHelper.UrlaubRequest> inputParams
  ) {
    for (UrlaubHelper.UrlaubRequest p : inputParams) {
      UrlaubHelper.createUrlaubRecords(p);
    }
  }
}
