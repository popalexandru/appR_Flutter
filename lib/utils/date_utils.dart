import 'package:intl/intl.dart';

class DateUtilities{

  DateUtilities(){

  }

  String convertTimestamp(int timestamp){
    DateTime dt = DateTime.fromMicrosecondsSinceEpoch(timestamp);
    var format = new DateFormat('MM-dd HH:mm');

    return format.format(dt);
  return "Maine";
  }
}