import 'package:intl/intl.dart';

String formatDateTimeIntoTime(DateTime dateTime) {
  return DateFormat('h:mm a').format(dateTime);
}

String getCurrentDay(DateTime dateTime) {
  return DateFormat('EEEE, MMMM d, h:mm a').format(dateTime);
}

String formatDateForDatePicker(DateTime dateTime) {
  final DateTime rightNow = DateTime.now();
  if (dateTime.day == rightNow.day) {
    return "Today";
  }
  if (dateTime.day == rightNow.day + 1) {
    return "Tomorrow";
  }
  return DateFormat("dd/MM/yyyy").format(dateTime);
}

String isMorningOrAfterNoon() {
  final DateTime rightNow = DateTime.now();
  final period = DateFormat('a').format(rightNow);
  return period == "AM" ? "Morning" : "Evening";
}
