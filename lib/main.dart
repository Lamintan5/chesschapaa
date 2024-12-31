import 'package:chesschapaa/auth/login.dart';
import 'package:chesschapaa/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final dialogBgColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.grey[900];
    final size = MediaQuery.of(context).size;
    return GetMaterialApp(
      title: "ChessChapaa",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true,).copyWith(
          dialogBackgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          popupMenuTheme: PopupMenuThemeData(surfaceTintColor: Colors.transparent, color: Colors.white,),
          colorScheme: ColorScheme.highContrastLight(primary: CupertinoColors.activeBlue),
          dialogTheme: DialogTheme(surfaceTintColor: Colors.transparent,),
          bottomSheetTheme: BottomSheetThemeData(surfaceTintColor: Colors.transparent,),
          cardTheme: CardTheme(surfaceTintColor: Colors.transparent),
          appBarTheme: AppBarTheme(backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return CupertinoColors.activeBlue.withOpacity(0.9); // Color when the scrollbar is hovered
                }
                if (states.contains(MaterialState.focused)) {
                  return CupertinoColors.activeBlue; // Color when the scrollbar is focused
                }
                return CupertinoColors.activeBlue.withOpacity(0.5); // Default color
              },
            ),
            thickness: MaterialStateProperty.resolveWith<double?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return 7.0; // Thickness when the scrollbar is hovered
                }
                if (states.contains(MaterialState.dragged)) {
                  return 7.0; // Thickness when the scrollbar is being dragged
                }
                return 5; // Default thickness
              },
            ),
          ),
          tabBarTheme: TabBarTheme( dividerColor: Colors.transparent,)
      ),
      darkTheme: ThemeData.light(useMaterial3: true,).copyWith(
        dialogBackgroundColor: Colors.grey[900],
        scaffoldBackgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        colorScheme: ColorScheme.highContrastDark(primary: CupertinoColors.activeBlue),
        popupMenuTheme: PopupMenuThemeData(surfaceTintColor: Colors.transparent, color: dialogBgColor),
        hintColor: secondaryColor,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white,),
          bodyMedium: TextStyle(color: Colors.white,),
        ),
        tabBarTheme: TabBarTheme(dividerColor: Colors.transparent),
        dialogTheme: DialogTheme(surfaceTintColor: Colors.transparent,),
        bottomSheetTheme: BottomSheetThemeData(surfaceTintColor: Colors.transparent,),
        cardTheme: CardTheme(surfaceTintColor: Colors.transparent),
        appBarTheme: AppBarTheme(backgroundColor: Colors.black),
        snackBarTheme: SnackBarThemeData(
            width: size.width > 450 ? 500: null,
            actionTextColor: CupertinoColors.activeBlue,
            backgroundColor: Colors.grey[900],
            elevation: 10,
            behavior: SnackBarBehavior.floating,
            contentTextStyle: TextStyle(color: Colors.white),
            closeIconColor: CupertinoColors.systemBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
        ),
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return CupertinoColors.activeBlue.withOpacity(0.9); // Color when the scrollbar is hovered
              }
              if (states.contains(MaterialState.focused)) {
                return CupertinoColors.activeBlue; // Color when the scrollbar is focused
              }
              return CupertinoColors.activeBlue.withOpacity(0.5); // Default color
            },
          ),
          thickness: MaterialStateProperty.resolveWith<double?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return 7.0; // Thickness when the scrollbar is hovered
              }
              if (states.contains(MaterialState.dragged)) {
                return 7.0; // Thickness when the scrollbar is being dragged
              }
              return 5; // Default thickness
            },
          ),
        ),
      ),
      home: Login(),
    );
  }
}

