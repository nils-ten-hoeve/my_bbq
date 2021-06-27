import 'package:flutter/material.dart';

/// Styling is a matter of taste.
/// Google's [material design][https://material.io/design] is arguably
/// one of the best and most used styling guide lines out there.
///
/// But then there are people that think they know even better.
/// This is how the [ExtendedTheme] came to be.
/// It contains small styling pre-sets on top of the default style theme.
/// Always with arguments why...
class ExtendedTheme {
  static final minItemHeight = 50.0;
  static final spacing = 20.0;
  static final rounding = 20.0;
  static final Radius radius = Radius.circular(rounding);
  static final RoundedRectangleBorder roundedRectangleBorder =
      RoundedRectangleBorder(borderRadius: BorderRadius.all(radius));

  static ThemeData _genericTheme(
          {required MaterialColor primarySwatch,
          required Brightness brightness}) =>
      ThemeData(
          primarySwatch: primarySwatch,
          brightness: brightness,
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.all(spacing),
                  shape: roundedRectangleBorder)));

  static ThemeData light(MaterialColor primarySwatch) =>
      _genericTheme(primarySwatch: primarySwatch, brightness: Brightness.light);

  static ThemeData dark(MaterialColor primarySwatch) =>
      _genericTheme(primarySwatch: primarySwatch, brightness: Brightness.dark);
}
