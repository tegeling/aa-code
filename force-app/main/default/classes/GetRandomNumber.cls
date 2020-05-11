global with sharing class GetRandomNumber {
  global static String TYPE_NUMBER = 'number';
  global static String TYPE_BOOLEAN = 'boolean';

  global static Integer MAX_INTEGER = 2147483647;

  @InvocableMethod
  global static List<Results> getRandomNumberFromRange(
    List<Requests> requests
  ) {
    Results curResult = new Results();
    curResult.randomNumber = generateRandomFromRange(
      requests[0].startNumber,
      requests[0].endNumber
    );

    List<Results> resultsList = new List<results>();
    resultsList.add(curResult);
    return resultsList;
  }

  global static Double generateRandomFromRange(
    Integer startNum,
    Integer endNum
  ) {
    Double rand = Math.random();
    // If no range is provided return a random number in [0;1[
    if (startNum == null && endNum == null) {
      return rand;
    }
    if (startNum == null) {
      startNum = 0;
    } else if (endNum == null) {
      endNum = MAX_INTEGER;
    }
    // Generate random number in range
    Integer min = Math.min(startNum, endNum);
    Integer range = Math.abs(endNum - startNum);
    return min + rand * range;
  }

  global class Requests {
    @InvocableVariable(required=true)
    global Integer startNumber;

    @InvocableVariable(required=true)
    global Integer endNumber;
  }

  global class Results {
    @InvocableVariable
    global Double randomNumber;
  }
}