import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class MainShellScreen extends StatelessWidget {
  final Widget child;
  const MainShellScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    
    if (path.startsWith('/home/collection')) currentIndex = 1;
    if (path.startsWith('/home/capture')) currentIndex = 2; // Biarkan capture di tengah tapi berupa tombol khusus
    if (path.startsWith('/home/battle')) currentIndex = 3;
    if (path.startsWith('/home/profile')) currentIndex = 4;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex > 2 ? currentIndex - 1 : currentIndex, // Skip index 2 (capture) untuk nav items biasa
        onDestinationSelected: (index) {
          switch (index) {
            case 0: context.go('/home'); break;
            case 1: context.go('/home/collection'); break;
            case 2: context.go('/home/battle'); break;
            case 3: context.go('/home/profile'); break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.pets_rounded), label: 'Koleksi'),
          NavigationDestination(icon: Icon(Icons.sports_kabaddi_rounded), label: 'Battle'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/home/capture'),
        backgroundColor: AppColors.captureOrange,
        child: const Icon(Icons.camera_alt_rounded, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
