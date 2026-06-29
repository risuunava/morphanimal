import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const ProviderScope(child: MorphanimalApp()));
}

class MorphanimalApp extends ConsumerWidget {
  const MorphanimalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Morphanimal',
      theme: AppTheme.light,
      home: const Scaffold(
        body: Center(
          child: Text('Morphanimal Setup OK'),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
