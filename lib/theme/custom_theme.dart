import 'package:flutter/material.dart';

import 'custom_colors.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: CustomColors.shimmerGreen,
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: Colors.grey[300],
      fontFamily: 'Metropolis',
      textTheme: ThemeData.light().textTheme,
      dialogTheme: const DialogTheme(
        backgroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        color: Colors.grey[300],
        shadowColor: Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.shimmerGreen,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.normal),
          padding: const EdgeInsets.all(18.0),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: Colors.grey.shade200,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade700,
        thickness: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: Colors.grey.shade800,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.grey[900],
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: Colors.grey[700],
      fontFamily: 'Metropolis',
      textTheme: ThemeData.dark().textTheme,
      dialogTheme: const DialogTheme(
        backgroundColor: Colors.black,
      ),
      cardTheme: CardTheme(
        color: Colors.grey[700],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.shimmerGreen,
          foregroundColor: Colors.black, // change text color of button
          disabledBackgroundColor: Colors.grey, // ,
          disabledForegroundColor: Colors.black, // ,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.normal),
          padding: const EdgeInsets.all(18.0),
        ),
      ),
      hintColor: Colors.grey,
      drawerTheme: DrawerThemeData(
        backgroundColor: Colors.grey.shade800,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade300,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Colors.white,
      ),
    );
  }
}
