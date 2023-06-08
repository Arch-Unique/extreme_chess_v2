part of 'extensions.dart';

extension NumExtension on num {
  ///returns value * (percentage/100)
  double percent(num percentage) => (this * (percentage / 100)).toDouble();

  double get negate => this * -1;

  String toCurrency() {
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    return "₦${myFormat.format(nearest10())}";
  }

  int nearest10() {
    return (this / 100).ceil() * 100;
  }
}
