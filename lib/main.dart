import 'package:flutter/cupertino.dart';
import 'constants/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/main_tab_screen.dart';

void main() {
  runApp(const LogiTMSApp());
}

class LogiTMSApp extends StatefulWidget {
  const LogiTMSApp({super.key});

  @override
  State<LogiTMSApp> createState() => _LogiTMSAppState();
}

class _LogiTMSAppState extends State<LogiTMSApp> {
  bool _isLoggedIn = false;

  void _handleLogin() {
    setState(() => _isLoggedIn = true);
  }

  void _handleLogout() {
    setState(() => _isLoggedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'LogiTMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _isLoggedIn
          ? MainTabScreen(onLogout: _handleLogout)
          : LoginScreen(onLoginSuccess: _handleLogin),
    );
  }
}
