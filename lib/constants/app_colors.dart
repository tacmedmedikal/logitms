import 'package:flutter/cupertino.dart';

class AppColors {
  // Tiger Tail Palette
  static const Color tigerTail1 = Color(0xFFF2EEB6); // Light cream
  static const Color tigerTail2 = Color(0xFFFFB71B); // Golden yellow
  static const Color tigerTail3 = Color(0xFFF2A922); // Orange/gold
  static const Color tigerTail4 = Color(0xFFBF6F41); // Brown/rust
  static const Color tigerTail5 = Color(0xFF0C1F34); // Dark navy

  // Primary Colors
  static const Color primary = tigerTail3;           // Orange/gold
  static const Color primaryDark = tigerTail4;       // Brown/rust
  static const Color primaryLight = tigerTail2;      // Bright yellow

  // Status Colors
  static const Color success = Color(0xFF34C759);
  static const Color warning = tigerTail2;           // Bright yellow
  static const Color error = Color(0xFFE53935);
  static const Color info = tigerTail4;              // Brown/rust

  // Shipment Status Colors
  static const Color statusPending = tigerTail2;     // Bright yellow
  static const Color statusInTransit = tigerTail3;   // Orange/gold
  static const Color statusDelivered = Color(0xFF34C759);
  static const Color statusCancelled = Color(0xFFE53935);

  // Neutral Colors
  static const Color background = Color(0xFFFAF9F3); // Warm white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = tigerTail1;  // Light cream
  static const Color textPrimary = tigerTail5;       // Dark brown
  static const Color textSecondary = Color(0xFF6B5B4F); // Warm gray
  static const Color border = Color(0xFFE8E4D9);     // Warm border
  static const Color divider = Color(0xFFF0EDE3);    // Warm divider

  // Dark Mode Colors
  static const Color backgroundDark = tigerTail5;    // Dark brown
  static const Color surfaceDark = Color(0xFF2D2424);
  static const Color textPrimaryDark = Color(0xFFFAF9F3);
  static const Color textSecondaryDark = Color(0xFFB8A99A);
}
