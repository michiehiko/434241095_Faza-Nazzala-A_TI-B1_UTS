import 'package:flutter/material.dart';
import 'staff_dashboard_screen.dart';
import 'staff_ticket_list_screen.dart';
import '../common/notification_screen.dart';
import '../common/profile_screen.dart';
import '../../../../main.dart';
import '../common/widgets/custom_app_bar.dart';

class StaffMainNavigation extends StatefulWidget {
  const StaffMainNavigation({super.key});

  @override
  State<StaffMainNavigation> createState() => _StaffMainNavigationState();
}

class _StaffMainNavigationState extends State<StaffMainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const StaffDashboardScreen(),
    const StaffTicketListScreen(),
    const NotificationScreen(),
    const ProfileScreen(), // Profil yang sama, nanti otomatis menyesuaikan role
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
        title: 'Portal Staff Ahli',
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
            icon: Icon(Icons.engineering_rounded), // Ikon teknisi
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}