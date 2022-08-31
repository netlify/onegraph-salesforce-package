@RestResource(urlMapping='/trigger-filters')
global class TriggerFilterPublic {
  private class Filter {
    public String sobjectName;
    public String filter;

    public Filter(string sobjectName, string filter) {
      this.sobjectName = sobjectName;
      this.filter = filter;
    }
  }

  private static List<Filter> getFilters() {
    List<OneGraph__TriggerFilter__c> filterRows = [
      SELECT OneGraph__Serialized_filter__c, OneGraph__SObject_Name__c
      FROM OneGraph__TriggerFilter__c
    ];

    List<Filter> res = new List<Filter>();

    for (OneGraph__TriggerFilter__c row : filterRows) {
      res.add(
        new Filter(
          row.OneGraph__SObject_Name__c,
          row.OneGraph__Serialized_filter__c
        )
      );
    }
    return res;
  }

  private class PackageVersion {
    public String versionString;

    public PackageVersion(String versionString) {
      this.versionString = versionString;
    }
  }

  private class Response {
    public PackageVersion packageVersion;
    public List<Filter> filters;

    public Response(PackageVersion packageVersion, List<Filter> filters) {
      this.packageVersion = packageVersion;
      this.filters = filters;
    }
  }

  private static Response makeResponse() {
    return new Response(
      new PackageVersion(OneGraphPackageVersion.versionString),
      getFilters()
    );
  }

  @HttpGet
  global static void doGet() {
    RestContext.response.addHeader('Content-Type', 'application/json');
    RestContext.response.responseBody = Blob.valueOf(
      JSON.serialize(makeResponse())
    );
  }

  private class PutBody {
    public List<Filter> filters;
  }

  @HttpPut
  global static void doPut() {
    RestRequest req = RestContext.request;
    PutBody putBody = (PutBody) JSON.deserialize(
      req.requestBody.toString(),
      PutBody.class
    );

    List<OneGraph__TriggerFilter__c> rows = new List<OneGraph__TriggerFilter__c>();

    for (Filter filter : putBody.filters) {
      OneGraph__TriggerFilter__c row = new OneGraph__TriggerFilter__c();
      row.OneGraph__Serialized_filter__c = filter.filter;
      row.OneGraph__SObject_Name__c = filter.sobjectName;
      rows.add(row);
    }

    upsert rows OneGraph__SObject_Name__c;

    RestContext.response.addHeader('Content-Type', 'application/json');
    RestContext.response.responseBody = Blob.valueOf(
      JSON.serialize(makeResponse())
    );
  }

  private class DeleteBody {
    public List<String> sobjectNames;
  }

  @HttpDelete
  global static void doDelete() {
    RestRequest req = RestContext.request;
    DeleteBody delteBody = (DeleteBody) JSON.deserialize(
      req.requestBody.toString(),
      DeleteBody.class
    );

    List<OneGraph__TriggerFilter__c> filterRows = [
      SELECT Id
      FROM OneGraph__TriggerFilter__c
      WHERE OneGraph__SObject_Name__c IN :delteBody.sobjectNames
    ];

    delete filterRows;

    RestContext.response.addHeader('Content-Type', 'application/json');
    RestContext.response.responseBody = Blob.valueOf(
      JSON.serialize(makeResponse())
    );
  }
}
