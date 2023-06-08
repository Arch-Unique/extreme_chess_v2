part of 'extensions.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  Size get queryScreenSize => MediaQuery.of(this).size;

  double get screenHeight => queryScreenSize.height;

  double get screenWidth => queryScreenSize.width;
}
