import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider  extends ChangeNotifier{

final String key = "theme";
SharedPreferences chosentheme;
bool _darkTheme;

//dark theme
  ThemeData darkTheme = ThemeData.dark().copyWith(
      accentColor: Colors.blueGrey,
      brightness: Brightness.dark,
      primaryColor: Colors.black
  );

// normal theme
  ThemeData lightTheme = ThemeData.light().copyWith(
      accentColor:  Colors.blueGrey,
      brightness: Brightness.light,
      primaryColor: Color(0xFF005792)
  );

  bool get darkThemeEnabled => _darkTheme;



  void changeTheme() {

    _darkTheme = !_darkTheme;
    notifyListeners();
  }

ThemeProvider() {
  _darkTheme = true;
}


}


