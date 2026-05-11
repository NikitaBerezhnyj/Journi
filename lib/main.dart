import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journi/providers/app_lifecycle_provider.dart';
import 'package:journi/services/notification_service.dart';
import 'package:journi/widgets/initial_screen.dart';
import './providers/locale_provider.dart';
import './providers/theme_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  NotificationService.init();

  runApp(const ProviderScope(child: JourniApp()));
}

class JourniApp extends ConsumerWidget {
  const JourniApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appLifecycleProvider);

    final localeAsync = ref.watch(localeProvider);
    final themeAsync = ref.watch(themeProvider);

    final locale = localeAsync.valueOrNull;
    final themeMode = themeAsync.valueOrNull ?? ThemeMode.system;

    return MaterialApp(
      title: 'Journi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF5C6BC0),
            brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C6BC0),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('uk'),
        Locale('es'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const InitialScreen(),
    );
  }
}