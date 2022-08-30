@isTest
private class TriggerFilterTest {
  @isTest
  static void testLeafFilter() {
    String testString = '{"v":0,"filter":{"kind":"Leaf","filter":{"field":"Name","kind":"String","filters":[{"op":"EqualTo","value":"ValueOfName"}]}}}';

    Opportunity o = new Opportunity();
    o.Name = 'ValueOfName';
    o.StageName = 'Closed Won';
    o.CloseDate = System.today();

    System.assertEquals(
      true,
      TriggerFilter.applyFiltersFromString(o, testString),
      'Filter matches'
    );

    o.Name = 'NewName';
    System.assertEquals(
      false,
      TriggerFilter.applyFiltersFromString(o, testString),
      'Filter does not match'
    );
  }

  @isTest
  static void testAndFilter() {
    String testString = '{"v":0,"filter":{"kind":"And","filter":[{"kind":"Leaf","filter":{"field":"Name","kind":"String","filters":[{"op":"EqualTo","value":"ValueOfName"}]}},{"kind":"Leaf","filter":{"field":"StageName","kind":"String","filters":[{"op":"EqualTo","value":"Closed Won"}]}}]}}';

    Opportunity o = new Opportunity();
    o.Name = 'ValueOfName';
    o.StageName = 'Closed Won';
    o.CloseDate = System.today();

    System.assertEquals(
      true,
      TriggerFilter.applyFiltersFromString(o, testString),
      'Filter matches'
    );

    o.Name = 'NewName';
    System.assertEquals(
      false,
      TriggerFilter.applyFiltersFromString(o, testString),
      'Filter does not match'
    );
  }

  @isTest
  static void testOrFilter() {
    String testString = '{"v":0,"filter":{"kind":"Or","filter":[{"kind":"Leaf","filter":{"field":"Name","kind":"String","filters":[{"op":"EqualTo","value":"ValueOfName"}]}},{"kind":"Leaf","filter":{"field":"StageName","kind":"String","filters":[{"op":"EqualTo","value":"ValueOfName"}]}}]}}';

    Opportunity o = new Opportunity();
    o.Name = 'ValueOfName';
    o.StageName = 'Closed Won';
    o.CloseDate = Date.newInstance(2000, 6, 6);

    System.assertEquals(
      true,
      TriggerFilter.applyFiltersFromString(o, testString),
      'Filter matches with both fields'
    );

    o.Name = 'NewName';
    System.assertEquals(
      true,
      TriggerFilter.applyFiltersFromString(o, testString),
      'Filter matches with one field'
    );

    o.Name = 'NewName';
    o.StageName = 'Prospecting';
    System.assertEquals(
      true,
      TriggerFilter.applyFiltersFromString(o, testString),
      'Filter does not match'
    );
  }

  static String encodeDate(Date d) {
    return '[' + d.year() + ',' + d.month() + ',' + d.day() + ']';
  }

  static String encodeDatetime(Datetime d) {
    return '[' +
      d.yearGmt() +
      ',' +
      d.monthGmt() +
      ',' +
      d.dayGmt() +
      ',' +
      d.hourGmt() +
      ',' +
      d.minuteGmt() +
      ',' +
      d.secondGmt() +
      ']';
  }

  @isTest
  static void testAllFilterList() {
    Opportunity opp = new Opportunity();
    opp.Name = 'ValueOfName';
    opp.StageName = 'Closed Won';
    opp.Amount = 50;
    opp.CloseDate = Date.newInstance(2000, 6, 6);

    insert opp;

    Opportunity o = [
      SELECT FIELDS(STANDARD)
      FROM Opportunity
      WHERE Id = :opp.Id
    ];

    String closeAt = encodeDate(o.CloseDate);
    String beforeCloseAt = encodeDate(o.CloseDate.addDays(-1));
    String afterCloseAt = encodeDate(o.CloseDate.addDays(1));

    String createdAt = encodeDatetime(o.CreatedDate);
    String beforeCreatedAt = encodeDatetime(o.CreatedDate.addDays(-1));
    String afterCreatedAt = encodeDatetime(o.CreatedDate.addDays(1));

    Map<String, String> fieldOfKind = new Map<String, String>{
      'String' => 'Name',
      'Number' => 'Amount',
      'Date' => 'CloseDate',
      'Datetime' => 'CreatedDate',
      'Bool' => 'IsClosed'
    };

    // XXX: Handle isNull(bool) and test cases here
    List<List<string>> testCases = new List<List<string>>{
      // String
      new List<string>{ 'String', 'In', '["ValueOfName"]', 'true' },
      new List<string>{ 'String', 'In', '["Other"]', 'false' },
      new List<string>{ 'String', 'NotIn', '["ValueOfName"]', 'false' },
      new List<string>{ 'String', 'NotIn', '["Other"]', 'true' },
      new List<string>{ 'String', 'IsNull', 'true', 'false' },
      new List<string>{ 'String', 'IsNull', 'false', 'true' },
      new List<string>{ 'String', 'EqualTo', '"Other"', 'false' },
      new List<string>{ 'String', 'NotEqualTo', '"ValueOfName"', 'false' },
      new List<string>{ 'String', 'NotEqualTo', '"Other"', 'true' },
      new List<string>{ 'String', 'Contains', '"Of"', 'true' },
      new List<string>{ 'String', 'Contains', '"Other"', 'false' },
      new List<string>{ 'String', 'ContainsIgnoreCase', '"of"', 'true' },
      new List<string>{ 'String', 'ContainsIgnoreCase', '"Other"', 'false' },
      new List<string>{ 'String', 'EndsWith', '"Name"', 'true' },
      new List<string>{ 'String', 'EndsWith', '"Other"', 'false' },
      new List<string>{ 'String', 'EndsWithIgnoreCase', '"name"', 'true' },
      new List<string>{ 'String', 'EndsWithIgnoreCase', '"Other"', 'false' },
      new List<string>{
        'String',
        'EqualToIgnoreCase',
        '"vaLuEofnAme"',
        'true'
      },
      new List<string>{ 'String', 'EqualToIgnoreCase', '"Other"', 'false' },
      new List<string>{ 'String', 'StartsWith', '"Value"', 'true' },
      new List<string>{ 'String', 'StartsWith', '"Other"', 'false' },
      new List<string>{ 'String', 'StartsWithIgnoreCase', '"value"', 'true' },
      new List<string>{ 'String', 'StartsWithIgnoreCase', '"Other"', 'false' },
      // Number
      new List<string>{ 'Number', 'In', '[50]', 'true' },
      new List<string>{ 'Number', 'In', '[40]', 'false' },
      new List<string>{ 'Number', 'NotIn', '[50]', 'false' },
      new List<string>{ 'Number', 'NotIn', '[40]', 'true' },
      new List<string>{ 'Number', 'IsNull', 'true', 'false' },
      new List<string>{ 'Number', 'IsNull', 'false', 'true' },
      new List<string>{ 'Number', 'EqualTo', '50', 'true' },
      new List<string>{ 'Number', 'EqualTo', '40.4', 'false' },
      new List<string>{ 'Number', 'NotEqualTo', '50', 'false' },
      new List<string>{ 'Number', 'NotEqualTo', '40.4', 'true' },
      new List<string>{ 'Number', 'LessThan', '40', 'false' },
      new List<string>{ 'Number', 'LessThan', '60', 'true' },
      new List<string>{ 'Number', 'LessThanOrEqualTo', '40', 'false' },
      new List<string>{ 'Number', 'LessThanOrEqualTo', '50', 'true' },
      new List<string>{ 'Number', 'GreaterThan', '40', 'true' },
      new List<string>{ 'Number', 'GreaterThan', '60', 'false' },
      new List<string>{ 'Number', 'GreaterThanOrEqualTo', '50', 'true' },
      new List<string>{ 'Number', 'GreaterThanOrEqualTo', '60', 'false' },
      // Date
      new List<string>{ 'Date', 'In', '[' + closeAt + ']', 'true' },
      new List<string>{ 'Date', 'In', '[' + beforeCloseAt + ']', 'false' },
      new List<string>{ 'Date', 'NotIn', '[' + closeAt + ']', 'false' },
      new List<string>{ 'Date', 'NotIn', '[' + beforeCloseAt + ']', 'true' },
      new List<string>{ 'Date', 'IsNull', 'true', 'false' },
      new List<string>{ 'Date', 'IsNull', 'false', 'true' },
      new List<string>{ 'Date', 'EqualTo', closeAt, 'true' },
      new List<string>{ 'Date', 'EqualTo', afterCloseAt, 'false' },
      new List<string>{ 'Date', 'NotEqualTo', closeAt, 'false' },
      new List<string>{ 'Date', 'NotEqualTo', afterCloseAt, 'true' },
      new List<string>{ 'Date', 'LessThan', closeAt, 'false' },
      new List<string>{ 'Date', 'LessThan', afterCloseAt, 'true' },
      new List<string>{ 'Date', 'LessThanOrEqualTo', beforeCloseAt, 'false' },
      new List<string>{ 'Date', 'LessThanOrEqualTo', closeAt, 'true' },
      new List<string>{ 'Date', 'GreaterThan', beforeCloseAt, 'true' },
      new List<string>{ 'Date', 'GreaterThan', closeAt, 'false' },
      new List<string>{ 'Date', 'GreaterThanOrEqualTo', closeAt, 'true' },
      new List<string>{ 'Date', 'GreaterThanOrEqualTo', afterCloseAt, 'false' },
      // Datetime
      new List<string>{ 'Datetime', 'In', '[' + createdAt + ']', 'true' },
      new List<string>{
        'Datetime',
        'In',
        '[' +
        beforeCreatedAt +
        ']',
        'false'
      },
      new List<string>{ 'Datetime', 'NotIn', '[' + createdAt + ']', 'false' },
      new List<string>{
        'Datetime',
        'NotIn',
        '[' +
        beforeCreatedAt +
        ']',
        'true'
      },
      new List<string>{ 'Datetime', 'IsNull', 'true', 'false' },
      new List<string>{ 'Datetime', 'IsNull', 'false', 'true' },
      new List<string>{ 'Datetime', 'EqualTo', createdAt, 'true' },
      new List<string>{ 'Datetime', 'EqualTo', beforeCreatedAt, 'false' },
      new List<string>{ 'Datetime', 'NotEqualTo', createdAt, 'false' },
      new List<string>{ 'Datetime', 'NotEqualTo', beforeCreatedAt, 'true' },
      new List<string>{ 'Datetime', 'LessThan', createdAt, 'false' },
      new List<string>{ 'Datetime', 'LessThan', afterCreatedAt, 'true' },
      new List<string>{
        'Datetime',
        'LessThanOrEqualTo',
        beforeCreatedAt,
        'false'
      },
      new List<string>{ 'Datetime', 'LessThanOrEqualTo', createdAt, 'true' },
      new List<string>{ 'Datetime', 'GreaterThan', beforeCreatedAt, 'true' },
      new List<string>{ 'Datetime', 'GreaterThan', createdAt, 'false' },
      new List<string>{ 'Datetime', 'GreaterThanOrEqualTo', createdAt, 'true' },
      new List<string>{
        'Datetime',
        'GreaterThanOrEqualTo',
        afterCreatedAt,
        'false'
      },
      new List<string>{ 'Bool', 'IsNull', 'true', 'false' },
      new List<string>{ 'Bool', 'IsNull', 'false', 'true' },
      new List<string>{ 'Bool', 'EqualTo', 'true', 'true' },
      new List<string>{ 'Bool', 'EqualTo', 'false', 'false' },
      new List<string>{ 'Bool', 'NotEqualTo', 'true', 'false' },
      new List<string>{ 'Bool', 'NotEqualTo', 'false', 'true' }
    };

    for (List<string> testCase : testCases) {
      String kind = testCase[0];
      String op = testCase[1];
      String value = testCase[2];
      Boolean expected = Boolean.valueOf(testCase[3]);
      String testString =
        '{"v":0,"filter":{"kind":"Leaf","filter":{"field":"' +
        fieldOfKind.get(kind) +
        '","kind":"' +
        kind +
        '","filters":[{"op":"' +
        op +
        '","value":' +
        value +
        '}]}}}';
      System.assertEquals(
        expected,
        TriggerFilter.applyFiltersFromString(o, testString),
        'Filter does not match for kind=' +
        kind +
        ', op=' +
        op +
        ', value=' +
        value +
        ', testString=' +
        testString
      );
    }
  }

  @isTest
  static void testPassFilterJob() {
    new MockUtils().mockHttp();
    String testString = '{"v":0,"filter":{"kind":"Leaf","filter":{"field":"Name","kind":"String","filters":[{"op":"EqualTo","value":"ValueOfName"}]}}}';

    OneGraph__TriggerFilter__c t = new OneGraph__TriggerFilter__c();
    t.OneGraph__Serialized_filter__c = testString;
    t.OneGraph__SObject_Name__c = 'Account';
    insert t;
    Test.startTest();

    Account o = new Account();
    o.Name = 'ValueOfName';
    insert o;

    System.assertEquals(
      Limits.getQueueableJobs(),
      1,
      'job should have been queued'
    );
    Test.stopTest();
  }

  @isTest
  static void testFailFilterJob() {
    new MockUtils().mockHttp();
    Test.startTest();
    String testString = '{"v":0,"filter":{"kind":"Leaf","filter":{"field":"Name","kind":"String","filters":[{"op":"EqualTo","value":"ValueOfName"}]}}}';

    OneGraph__TriggerFilter__c t = new OneGraph__TriggerFilter__c();
    t.OneGraph__Serialized_filter__c = testString;
    t.OneGraph__SObject_Name__c = 'Account';
    insert t;

    Account o = new Account();
    o.Name = 'NonMatching';
    insert o;

    System.assertEquals(
      0,
      Limits.getQueueableJobs(),
      'job should not have been queued'
    );
    Test.stopTest();
  }

  @isTest
  static void testBatchesAreFiltered() {
    MockUtils m = new MockUtils();
    m.mockHttp();
    String testString = '{"v":0,"filter":{"kind":"Leaf","filter":{"field":"Name","kind":"String","filters":[{"op":"EqualTo","value":"ValueOfName"}]}}}';

    OneGraph__TriggerFilter__c t = new OneGraph__TriggerFilter__c();
    t.OneGraph__Serialized_filter__c = testString;
    t.OneGraph__SObject_Name__c = 'Account';
    insert t;
    Test.startTest();
    List<Account> accounts = new List<Account>();

    Account o = new Account();
    o.Name = 'ValueOfName';
    accounts.add(o);

    Account o2 = new Account();
    o2.Name = 'NonMatching';
    accounts.add(o2);

    Account o3 = new Account();
    o3.Name = 'ValueOfName';
    accounts.add(o3);

    insert accounts;

    System.assertEquals(
      1,
      Limits.getQueueableJobs(),
      'job should have been queued'
    );

    Test.stopTest();

    Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(
      m.getWebhookRequests()[0].getBody()
    );

    System.assertEquals(
      2,
      (Integer) body.get('size'),
      'Only matching trigger objects should be sent'
    );
  }
}
