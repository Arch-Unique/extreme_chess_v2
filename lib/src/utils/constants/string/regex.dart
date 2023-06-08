abstract class Regex {
  static RegExp numReg = RegExp(r".*[0-9].*");
  static RegExp letterReg = RegExp(r".*[A-Za-z].*");
  static RegExp specialCharReg = RegExp(r'[!@#$%^&§±`/\~*(),.?":{}|<>]');
}
