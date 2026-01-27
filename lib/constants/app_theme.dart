import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

class AppTheme {
  static CupertinoThemeData get lightTheme {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      barBackgroundColor: AppColors.surface,
      textTheme: CupertinoTextThemeData(
        primaryColor: AppColors.textPrimary,
        textStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        navTitleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        navLargeTitleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 34,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static CupertinoThemeData get darkTheme {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      barBackgroundColor: AppColors.surfaceDark,
      textTheme: CupertinoTextThemeData(
        primaryColor: AppColors.textPrimaryDark,
        textStyle: TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 16,
        ),
        navTitleTextStyle: TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        navLargeTitleTextStyle: TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 34,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
