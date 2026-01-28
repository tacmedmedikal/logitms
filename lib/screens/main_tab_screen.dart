import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../widgets/custom_bottom_nav.dart';
import 'dashboard_screen.dart';
import 'shipments_screen.dart';
import 'vehicles_screen.dart';
import 'drivers_screen.dart';
import 'profile_screen.dart';

class MainTabScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const MainTabScreen({super.key, required this.onLogout});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;
  bool _isNavVisible = true;
  Timer? _scrollTimer;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const DashboardScreen(),
      const ShipmentsScreen(),
      const VehiclesScreen(),
      const DriversScreen(),
      ProfileScreen(onLogout: widget.onLogout),
    ];
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    super.dispose();
  }

  void _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      // Scrolling - hide nav
      if (_isNavVisible) {
        setState(() => _isNavVisible = false);
      }
      // Reset timer
      _scrollTimer?.cancel();
      _scrollTimer = Timer(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() => _isNavVisible = true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _onScrollNotification(notification);
          return false;
        },
        child: Stack(
          children: [
            // Screen content
            IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
            // Custom bottom navigation with animation
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              left: 0,
              right: 0,
              bottom: _isNavVisible ? 8 : -100,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isNavVisible ? 1.0 : 0.0,
                child: CustomBottomNav(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
