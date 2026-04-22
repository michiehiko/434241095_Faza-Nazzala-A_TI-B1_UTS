import 'package:flutter/material.dart';
import 'admin_dashboard_screen.dart';
import 'admin_ticket_list_screen.dart';
import '../common/notification_screen.dart';
import '../common/profile_screen.dart';
import '../../../../main.dart';
import '../common/widgets/custom_app_bar.dart';

class AdminMainNavigation extends StatefulWidget {
  const AdminMainNavigation({super.key});

  @override
  State<AdminMainNavigation> createState() => _AdminMainNavigationState();
}

class _AdminMainNavigationState extends State<AdminMainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdminDashboardScreen(),
    const AdminTicketListScreen(),
    const NotificationScreen(),
    const ProfileScreen(isAdmin: true),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Portal Helpdesk',
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              if (Theme.of(context).brightness == Brightness.light) {
                MyApp.of(context)?.changeTheme(ThemeMode.dark);
              } else {
                MyApp.of(context)?.changeTheme(ThemeMode.light);
              }
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.5),
        backgroundColor: colorScheme.surface,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Antrean',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings_rounded),
            label: 'Sistem',
          ),
        ],
      ),
    );
  }
}
