abstract class AppUrls {
  static const String homeURL = 'https://extremechess.archyuniq.com';
  // static const String homeURL = 'http://www.archyuniq.xyz:3060';
  static const String baseURL = '$homeURL/api';

  //auth repo
  static const String login = "/user/login";
  static const String logout = "/logout";
  // static const String register = "/register";
  // static const String forgotPassword = "/forgot-password";

  //profile repo
  static const String getUser = "/user/profile/";
  static const String changePassword = "/user/change-password";
  static const String leaderboard = "/user/leaderboard";
  static const String history = "/user/history";

  //contributor repo
  static const String contributor = "/contributor";

  //engine repo
  static const String engine = "/engine";
}
