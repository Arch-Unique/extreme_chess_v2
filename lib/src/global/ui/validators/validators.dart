import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../src_barrel.dart';

abstract class Validators {
  static String? passwordValidator(dynamic value) {
    if (value?.isEmpty ?? true) {
      return ('Password is required');
    } else if (value.length < 8) {
      return ('Password must not be less than 8 characters');
    } else {
      return null;
    }
  }

  static String? confirmPasswordValidator(dynamic value, String password) {
    if (value?.isEmpty ?? true) {
      return 'Field cannot be empty';
    } else if (value.toString().trim() != password.trim()) {
      debugPrint(value);
      debugPrint(password);
      return 'Password doesn\'t match';
    } else {
      return null;
    }
  }

  static String? validateEmail(dynamic value) {
    if (value != null && GetUtils.isEmail(value!)) {
      return null;
    }
    return "Invalid Email";
  }

  static String? validatePhone(dynamic value) {
    if (value != null && GetUtils.isPhoneNumber(value!)) {
      return null;
    }
    return "Invalid Phone Number";
  }

  static String? validateNum(dynamic value) {
    if (value != null && value!.length > 5 && GetUtils.isNumericOnly(value!)) {
      return null;
    }
    return "Invalid Code";
  }

  static String? emptyFieldValidator(dynamic value) {
    if (value?.isEmpty ?? true) {
      return 'Field must not be empty';
    }
    return null;
  }

  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field must not be empty';
    }

    if (value.length < 3 || value.length > 4) {
      return "CVV is invalid";
    }
    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field must not be empty';
    }

    int year;
    int month;
    // The value contains a forward slash if the month and year has been
    // entered.
    if (value.contains(RegExp(r'(/)'))) {
      var split = value.split(RegExp(r'(/)'));
      // The value before the slash is the month while the value to right of
      // it is the year.
      month = int.parse(split[0]);
      year = int.parse(split[1]);
    } else {
      // Only the month was entered
      month = int.parse(value.substring(0, (value.length)));
      year = -1; // Lets use an invalid year intentionally
    }

    if ((month < 1) || (month > 12)) {
      // A valid month is between 1 (January) and 12 (December)
      return 'Expiry month is invalid';
    }

    var fourDigitsYear = convertYearTo4Digits(year);
    if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
      // We are assuming a valid should be between 1 and 2099.
      // Note that, it's valid doesn't mean that it has not expired.
      return 'Expiry year is invalid';
    }

    if (!hasDateExpired(month, year)) {
      return "Card has expired";
    }
    return null;
  }

  /// Convert the two-digit year to four-digit year if necessary
  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static bool hasDateExpired(int month, int year) {
    return isNotExpired(year, month);
  }

  static bool isNotExpired(int year, int month) {
    // It has not expired if both the year and date has not passed
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  static List<int> getExpiryDate(String value) {
    var split = value.split(RegExp(r'(/)'));
    return [int.parse(split[0]), int.parse(split[1])];
  }

  static bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is more than current month.
    return hasYearPassed(year) ||
        convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  static bool hasYearPassed(int year) {
    int fourDigitsYear = convertYearTo4Digits(year);
    var now = DateTime.now();
    // The year has passed if the year we are currently is more than card's
    // year
    return fourDigitsYear < now.year;
  }

  static String getCleanedNumber(String text) {
    RegExp regExp = RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }

  /// With the card number with Luhn Algorithm
  /// https://en.wikipedia.org/wiki/Luhn_algorithm
  static String? validateCardNum(String? input) {
    if (input == null || input.isEmpty) {
      return 'Field must not be empty';
    }

    input = getCleanedNumber(input);

    if (input.length < 8) {
      return 'Invalid card';
    }

    int sum = 0;
    int length = input.length;
    for (var i = 0; i < length; i++) {
      // get digits in reverse order
      int digit = int.parse(input[length - i - 1]);

      // every 2nd number multiply with 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    if (sum % 10 == 0) {
      return null;
    }

    return 'Invalid card';
  }

  static String? validateAllTextFields(List<TextEditingController> conts) {
    final c = conts.any((element) => element.value.text.isEmpty);
    return c ? "All Fields are required" : null;
  }

  static String? validate(FPL m, dynamic value) {
    switch (m) {
      case FPL.text:
        return emptyFieldValidator(value);
      case FPL.email:
        return validateEmail(value);
      case FPL.phone:
        return validatePhone(value);
      case FPL.password:
        return passwordValidator(value);
      case FPL.number:
        return validateNum(value);
      case FPL.cvv:
        return validateCVV(value);
      case FPL.cardNo:
        return validateCardNum(value);
      case FPL.dateExpiry:
        return validateDate(value);
      case FPL.money:
        return validateNum(value);
      default:
        return null;
    }
  }
}
