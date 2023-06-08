import 'package:intl/intl.dart';

class DateUtils {
  static final _dayMap = {1: 'st', 2: 'nd', 3: 'rd'};
  static String dayOfMonth(int day) => "$day${_dayMap[day] ?? 'th'}";

  static int currentWeek() {
    return weekOfYear(DateTime.now());
  }

  static int weekOfYear(DateTime date) {
    DateTime monday = weekStart(date);
    DateTime first = weekYearStartDate(monday.year);

    int week = 1 + (monday.difference(first).inDays / 7).floor();

    if (week == 53 && DateTime(monday.year, 12, 31).weekday < 4) {
      week = 1;
    }

    return week;
  }

  static DateTime weekStart(DateTime date) {
    // This is ugly, but to avoid problems with daylight saving
    DateTime monday = DateTime.utc(date.year, date.month, date.day);
    monday = monday.subtract(Duration(days: monday.weekday - 1));

    return monday;
  }

  static DateTime weekEnd(DateTime date) {
    // This is ugly, but to avoid problems with daylight saving
    // Set the last microsecond to really be the end of the week
    DateTime sunday =
        DateTime.utc(date.year, date.month, date.day, 23, 59, 59, 999, 999999);
    sunday = sunday.add(Duration(days: 7 - sunday.weekday));

    return sunday;
  }

  static String weekInString(DateTime date) {
    if (currentWeek() == weekOfYear(date)) {
      return "This Week";
    } else if (currentWeek() == (weekOfYear(date) + 1)) {
      return "Last Week";
    }
    final sd = weekStart(date);
    final ed = weekEnd(date);
    final sm = DateFormat.MMM().format(sd);
    final em = DateFormat.MMM().format(ed);
    if (sd.month == ed.month) {
      return "${dayOfMonth(sd.day)} - ${dayOfMonth(ed.day)} $sm";
    }
    return "${dayOfMonth(sd.day)} $sm - ${dayOfMonth(ed.day)} $em";
  }

  static DateTime weekYearStartDate(int year) {
    final firstDayOfYear = DateTime.utc(year, 1, 1);
    final dayOfWeek = firstDayOfYear.weekday;

    return firstDayOfYear.add(
        Duration(days: (dayOfWeek <= DateTime.thursday ? 1 : 8) - dayOfWeek));
  }
}
