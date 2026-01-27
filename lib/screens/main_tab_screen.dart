import 'package:flutter/cupertino.dart';
import '../constants/app_colors.dart';
import 'dashboard_screen.dart';
import 'shipments_screen.dart';
import 'vehicles_screen.dart';
import 'drivers_screen.dart';
import 'profile_screen.dart';

class MainTabScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const MainTabScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: AppColors.primary,
        inactiveColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cube_box),
            activeIcon: Icon(CupertinoIcons.cube_box_fill),
            label: 'Sevkiyat',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.car),
            activeIcon: Icon(CupertinoIcons.car_detailed),
            label: 'Araclar',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2),
            activeIcon: Icon(CupertinoIcons.person_2_fill),
            label: 'Suruculer',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_circle),
            activeIcon: Icon(CupertinoIcons.person_circle_fill),
            label: 'Profil',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => const DashboardScreen(),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) => const ShipmentsScreen(),
            );
          case 2:
            return CupertinoTabView(
              builder: (context) => const VehiclesScreen(),
            );
          case 3:
            return CupertinoTabView(
              builder: (context) => const DriversScreen(),
            );
          case 4:
            return CupertinoTabView(
              builder: (context) => ProfileScreen(onLogout: onLogout),
            );
          default:
            return CupertinoTabView(
              builder: (context) => const DashboardScreen(),
            );
        }
      },
    );
  }
}
