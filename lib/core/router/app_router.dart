import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/creature.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/collection/collection_screen.dart';
import '../../presentation/screens/collection/detail_screen.dart';
import '../../presentation/screens/capture/capture_screen.dart';
import '../../presentation/screens/battle/battle_screen.dart';
import '../../presentation/screens/bestiary/bestiary_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/reveal/reveal_screen.dart';
import '../../presentation/screens/main_shell/main_shell_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/reveal',
        builder: (context, state) => const RevealScreen(),
      ),
      // Ini route untuk screen yang bukan bagian dari bottom nav tapi ada di dalam alur home
      GoRoute(
        path: '/home/bestiary',
        builder: (context, state) => const BestiaryScreen(),
      ),
      GoRoute(
        path: '/detail',
        pageBuilder: (context, state) {
          final creature = state.extra as Creature?;
          if (creature == null) {
            return const NoTransitionPage(child: SplashScreen());
          }
          return CustomTransitionPage(
            key: state.pageKey,
            child: DetailScreen(creature: creature),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeOutCubic));
              return SlideTransition(position: animation.drive(tween), child: child);
            },
          );
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainShellScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/home/capture',
            builder: (context, state) => const CaptureScreen(),
          ),
          GoRoute(
            path: '/home/battle',
            builder: (context, state) => const BattleScreen(),
          ),
          GoRoute(
            path: '/home/collection',
            builder: (context, state) => const CollectionScreen(),
          ),
          GoRoute(
            path: '/home/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
