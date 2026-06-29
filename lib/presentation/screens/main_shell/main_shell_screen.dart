import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:morphanimal/core/theme/app_colors.dart';
import 'package:morphanimal/core/theme/app_spacing.dart';

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Determine the current index based on the location
    final location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    
    if (location.startsWith('/home/capture')) {
      currentIndex = 1;
    } else if (location.startsWith('/home/battle')) {
      currentIndex = 2;
    } else if (location.startsWith('/home/collection')) {
      currentIndex = 3;
    } else if (location.startsWith('/home/profile')) {
      currentIndex = 4;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: AppShadows.navBarShadow,
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/home');
                break;
              case 1:
                context.go('/home/capture');
                break;
              case 2:
                context.go('/home/battle');
                break;
              case 3:
                context.go('/home/collection');
                break;
              case 4:
                context.go('/home/profile');
                break;
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.captureOrange,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppShadows.cardShadowColored(AppColors.captureOrange),
                ),
                child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 24),
              ),
              label: 'Capture',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.sports_kabaddi_rounded),
              label: 'Battle',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.style_rounded),
              label: 'Collection',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
