import 'package:flutter/material.dart';

class AppTheme {
  AppTheme();

  static final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      cursorColor: const Color(0xFF64ffda),
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xFF212121),
      accentColor: const Color(0xFF64ffda),
      canvasColor: const Color(0xFF333131),
      errorColor: const Color.fromRGBO(235, 154, 148, 1),
      fontFamily: 'Roboto',
      cardTheme: CardTheme(
        color: const Color(0xFF333131),
        elevation: 3,
      ),
      sliderTheme: SliderThemeData(
        valueIndicatorColor: const Color(0xFF64ffda),
        inactiveTrackColor:
            const Color.fromRGBO(72, 122, 122, 0.7), // Custom Gray Color
        activeTrackColor: const Color.fromRGBO(34, 212, 212, 1),
        thumbColor: const Color.fromRGBO(34, 212, 212, 1),
        overlayColor: const Color.fromRGBO(
            72, 122, 122, 0.7), // Custom Thumb overlay Color
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
      ));
}
