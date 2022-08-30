@namespaceAccessible
public without sharing class TriggerFilter { // XXX: implements Database.AllowsCallouts
  @TestVisible
  private static Boolean evaluateStringOp(
    String fieldValue,
    String op,
    Object value
  ) {
    switch on op {
      when 'In' {
        for (Object v : (List<Object>) value) {
          if (fieldValue == (String) v) {
            return true;
          }
        }
        return false;
      }
      when 'NotIn' {
        for (Object v : (List<Object>) value) {
          if (fieldValue == (String) v) {
            return false;
          }
        }
        return true;
      }
      when 'IsNull' {
        return ((Boolean) value) ? fieldValue == null : fieldValue != null;
      }
      when 'EqualTo' {
        return fieldValue == (String) value;
      }
      when 'NotEqualTo' {
        return fieldValue != (String) value;
      }
      when 'Contains' {
        return fieldValue != null && fieldValue.contains((String) value);
      }
      when 'ContainsIgnoreCase' {
        return fieldValue != null &&
          fieldValue.containsIgnoreCase((String) value);
      }
      when 'EndsWith' {
        return fieldValue != null && fieldValue.endsWith((String) value);
      }
      when 'EndsWithIgnoreCase' {
        return fieldValue != null &&
          fieldValue.endsWithIgnoreCase((String) value);
      }
      when 'EqualToIgnoreCase' {
        return fieldValue != null &&
          fieldValue.equalsIgnoreCase((String) value);
      }
      when 'StartsWith' {
        return fieldValue != null && fieldValue.startsWith((String) value);
      }
      when 'StartsWithIgnoreCase' {
        return fieldValue != null &&
          fieldValue.startsWithIgnoreCase((String) value);
      }
    }
    return true;
  }

  @TestVisible
  private static Boolean evaluateNumberOp(
    Decimal fieldValue,
    String op,
    Object value
  ) {
    switch on op {
      when 'In' {
        for (Object v : (List<Object>) value) {
          if (fieldValue == (Decimal) v) {
            return true;
          }
        }
        return false;
      }
      when 'NotIn' {
        for (Object v : (List<Object>) value) {
          if (fieldValue == (Decimal) v) {
            return false;
          }
        }
        return true;
      }
      when 'IsNull' {
        return ((Boolean) value) ? fieldValue == null : fieldValue != null;
      }
      when 'EqualTo' {
        return fieldValue == (Decimal) value;
      }
      when 'NotEqualTo' {
        return fieldValue != (Decimal) value;
      }
      when 'LessThan' {
        return fieldValue < (Decimal) value;
      }
      when 'LessThanOrEqualTo' {
        return fieldValue <= (Decimal) value;
      }
      when 'GreaterThan' {
        return fieldValue > (Decimal) value;
      }
      when 'GreaterThanOrEqualTo' {
        return fieldValue >= (Decimal) value;
      }
    }
    return true;
  }

  private static Date parseDate(Object value) {
    List<Object> parts = (List<Object>) value;
    return Date.newInstance(
      (Integer) parts[0],
      (Integer) parts[1],
      (Integer) parts[2]
    );
  }

  @TestVisible
  private static Boolean evaluateDateOp(
    Date fieldValue,
    String op,
    Object value
  ) {
    switch on op {
      when 'In' {
        for (Object v : (List<Object>) value) {
          if (fieldValue == parseDate(v)) {
            return true;
          }
        }
        return false;
      }
      when 'NotIn' {
        for (Object v : (List<Object>) value) {
          if (fieldValue == parseDate(v)) {
            return false;
          }
        }
        return true;
      }
      when 'IsNull' {
        return ((Boolean) value) ? fieldValue == null : fieldValue != null;
      }
      when 'EqualTo' {
        return fieldValue == parseDate(value);
      }
      when 'NotEqualTo' {
        return fieldValue != parseDate(value);
      }
      when 'LessThan' {
        return fieldValue < parseDate(value);
      }
      when 'LessThanOrEqualTo' {
        return fieldValue <= parseDate(value);
      }
      when 'GreaterThan' {
        return fieldValue > parseDate(value);
      }
      when 'GreaterThanOrEqualTo' {
        return fieldValue >= parseDate(value);
      }
    }
    return true;
  }

  private static Datetime parseDatetime(Object value) {
    List<Object> parts = (List<Object>) value;
    return Datetime.newInstanceGmt(
      (Integer) parts[0],
      (Integer) parts[1],
      (Integer) parts[2],
      (Integer) parts[3],
      (Integer) parts[4],
      (Integer) parts[5]
    );
  }

  @TestVisible
  private static Boolean evaluateDatetimeOp(
    Datetime fieldValue,
    String op,
    Object value
  ) {
    switch on op {
      when 'In' {
        for (Object v : (List<Object>) value) {
          if (fieldValue == parseDatetime(v)) {
            return true;
          }
        }
        return false;
      }
      when 'NotIn' {
        for (Object v : (List<Object>) value) {
          if (fieldValue == parseDatetime(v)) {
            return false;
          }
        }
        return true;
      }
      when 'IsNull' {
        return ((Boolean) value) ? fieldValue == null : fieldValue != null;
      }
      when 'EqualTo' {
        return fieldValue == parseDatetime(value);
      }
      when 'NotEqualTo' {
        return fieldValue != parseDatetime(value);
      }
      when 'LessThan' {
        return fieldValue < parseDatetime(value);
      }
      when 'LessThanOrEqualTo' {
        return fieldValue <= parseDatetime(value);
      }
      when 'GreaterThan' {
        return fieldValue > parseDatetime(value);
      }
      when 'GreaterThanOrEqualTo' {
        return fieldValue >= parseDatetime(value);
      }
    }
    return true;
  }

  @TestVisible
  private static Boolean evaluateBoolOp(
    Boolean fieldValue,
    String op,
    Object value
  ) {
    switch on op {
      when 'IsNull' {
        return ((Boolean) value) ? fieldValue == null : fieldValue != null;
      }
      when 'EqualTo' {
        return fieldValue == (Boolean) value;
      }
      when 'NotEqualTo' {
        return fieldValue != (Boolean) value;
      }
    }
    return true;
  }

  @TestVisible
  private static Boolean evaluateStringFieldFilters(
    SObject sobj,
    String field,
    List<Object> filters
  ) {
    String fieldValue = (String) sobj.get(field);

    for (Object filterUntyped : filters) {
      Map<String, Object> filter = (Map<String, Object>) filterUntyped;
      String op = (String) filter.get('op');
      Object value = (Object) filter.get('value');
      Boolean result = evaluateStringOp(fieldValue, op, value);
      if (result == false) {
        return false;
      }
    }
    return true;
  }

  @TestVisible
  private static Boolean evaluateNumberFieldFilters(
    SObject sobj,
    String field,
    List<Object> filters
  ) {
    Decimal fieldValue = (Decimal) sobj.get(field);

    for (Object filterUntyped : filters) {
      Map<String, Object> filter = (Map<String, Object>) filterUntyped;
      String op = (String) filter.get('op');
      Object value = (Object) filter.get('value');
      Boolean result = evaluateNumberOp(fieldValue, op, value);
      if (result == false) {
        return false;
      }
    }
    return true;
  }

  @TestVisible
  private static Boolean evaluateDateFieldFilters(
    SObject sobj,
    String field,
    List<Object> filters
  ) {
    Date fieldValue = (Date) sobj.get(field);

    for (Object filterUntyped : filters) {
      Map<String, Object> filter = (Map<String, Object>) filterUntyped;
      String op = (String) filter.get('op');
      Object value = (Object) filter.get('value');
      Boolean result = evaluateDateOp(fieldValue, op, value);
      if (result == false) {
        return false;
      }
    }
    return true;
  }

  @TestVisible
  private static Boolean evaluateDateTimeFieldFilters(
    SObject sobj,
    String field,
    List<Object> filters
  ) {
    Datetime fieldValue = (Datetime) sobj.get(field);

    for (Object filterUntyped : filters) {
      Map<String, Object> filter = (Map<String, Object>) filterUntyped;
      String op = (String) filter.get('op');
      Object value = (Object) filter.get('value');
      Boolean result = evaluateDatetimeOp(fieldValue, op, value);
      if (result == false) {
        return false;
      }
    }
    return true;
  }

  @TestVisible
  private static Boolean evaluateBoolFieldFilters(
    SObject sobj,
    String field,
    List<Object> filters
  ) {
    Boolean fieldValue = (Boolean) sobj.get(field);

    for (Object filterUntyped : filters) {
      Map<String, Object> filter = (Map<String, Object>) filterUntyped;
      String op = (String) filter.get('op');
      Object value = (Object) filter.get('value');
      Boolean result = evaluateBoolOp(fieldValue, op, value);
      if (result == false) {
        return false;
      }
    }
    return true;
  }

  @TestVisible
  private static Boolean evaluateFieldFilters(
    SObject sobj,
    Map<string, Object> fieldFilters
  ) {
    String kind = (String) fieldFilters.get('kind');
    String field = (String) fieldFilters.get('field');
    List<Object> filters = (List<Object>) fieldFilters.get('filters');

    switch on kind {
      when 'String' {
        return evaluateStringFieldFilters(sobj, field, filters);
      }
      when 'Number' {
        return evaluateNumberFieldFilters(sobj, field, filters);
      }
      when 'Date' {
        return evaluateDateFieldFilters(sobj, field, filters);
      }
      when 'Datetime' {
        return evaluateDatetimeFieldFilters(sobj, field, filters);
      }
      when 'Bool' {
        return evaluateBoolFieldFilters(sobj, field, filters);
      }
    }

    return true;
  }
  @TestVisible
  private static Boolean evaluateFilter(
    SObject sobj,
    Map<String, Object> filter
  ) {
    String kind = (String) filter.get('kind');
    switch on kind {
      when 'Leaf' {
        Map<string, Object> fieldFilters = (Map<string, Object>) filter.get(
          'filter'
        );
        return evaluateFieldFilters(sobj, fieldFilters);
      }
      when 'And' {
        List<Object> filters = (List<Object>) filter.get('filter');
        for (Object filterUntyped : filters) {
          Map<String, Object> filterTyped = (Map<String, Object>) filterUntyped;
          Boolean result = evaluateFilter(sobj, filterTyped);
          if (result == false) {
            return false;
          }
        }
        return true;
      }
      when 'Or' {
        List<Object> filters = (List<Object>) filter.get('filter');
        for (Object filterUntyped : filters) {
          Map<String, Object> filterTyped = (Map<String, Object>) filterUntyped;
          Boolean result = evaluateFilter(sobj, filterTyped);
          if (result == false) {
            return true;
          }
        }
        return false;
      }
    }

    return true;
  }

  public static Boolean applyFilters(
    SObject sobj,
    Map<String, Object> filters
  ) {
    Map<String, Object> filter = (Map<String, Object>) filters.get('filter');

    return evaluateFilter(sobj, filter);
  }

  public static Boolean applyFiltersFromString(
    SObject sobj,
    String filterString
  ) {
    Map<String, Object> filters = (Map<String, Object>) JSON.deserializeUntyped(
      filterString
    );

    return applyFilters(sobj, filters);
  }

  public class FilteredTrigger {
    public List<SObject> oldFiltered;
    public List<SObject> newFiltered;
    public Integer size;
    public String error;

    public FilteredTrigger(
      List<SObject> oldFiltered,
      List<SObject> newFiltered,
      Integer size,
      String error
    ) {
      this.oldFiltered = oldFiltered;
      this.newFiltered = newFiltered;
      this.size = size;
      this.error = error;
    }
  }

  public static FilteredTrigger filterTrigger(
    List<SObject> oldUnfiltered,
    List<SObject> newUnfiltered,
    Integer size,
    String sobjectName
  ) {
    try {
      List<OneGraph__TriggerFilter__c> filterRows = [
        SELECT OneGraph__Serialized_filter__c
        FROM OneGraph__TriggerFilter__c
        WHERE OneGraph__SObject_Name__c = :sobjectName
      ];

      if (filterRows.isEmpty()) {
        return new FilteredTrigger(oldUnfiltered, newUnfiltered, size, null);
      }

      OneGraph__TriggerFilter__c filterRow = filterRows[0];

      String filterString = filterRow.OneGraph__Serialized_filter__c;

      Map<String, Object> filters = (Map<String, Object>) JSON.deserializeUntyped(
        filterString
      );

      List<SObject> oldFiltered = new List<SObject>();
      List<SObject> newFiltered = new List<SObject>();
      Integer filteredSize = 0;

      for (Integer i = 0; i < size; i++) {
        Boolean passesFilter = false;

        if (newUnfiltered != null) {
          passesFilter = applyFilters(newUnfiltered[i], filters);
        }

        if (oldUnfiltered != null) {
          // We want to pass if either old or new pass the filter,
          // but ignore any null objects (e.g. Insert has no Trigger.old)
          passesFilter =
            passesFilter || applyFilters(oldUnfiltered[i], filters);
        }

        if (passesFilter) {
          filteredSize += 1;
          if (oldUnfiltered != null) {
            oldFiltered.add(oldUnfiltered[i]);
          }
          if (newUnfiltered != null) {
            newFiltered.add(newUnfiltered[i]);
          }
        }
      }
      return new FilteredTrigger(
        oldUnfiltered == null ? oldUnfiltered : oldFiltered,
        newUnfiltered == null ? newUnfiltered : newFiltered,
        filteredSize,
        null
      );
    } catch (Exception e) {
      return new FilteredTrigger(
        oldUnfiltered,
        newUnfiltered,
        size,
        e.getMessage()
      );
    }
  }
}
