import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/datasources/local/hive_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveLocalDatasource.init();
  runApp(const ProviderScope(child: MorphanimalApp()));
}

class MorphanimalApp extends ConsumerWidget {
  const MorphanimalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Morphanimal',
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
