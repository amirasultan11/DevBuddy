import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_themes.dart';
import 'core/theme/app_mode_provider.dart';
import 'core/theme/locale_provider.dart';
import 'core/theme/theme_provider.dart'; // ✅ ضفنا الـ ThemeProvider
import 'features/auth/presentation/screens/auth_wrapper.dart';
import 'features/pro_mode/presentation/cubit/gamification_cubit.dart';
import 'features/pro_mode/presentation/cubit/roadmap_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  // Open all boxes concurrently — no ordering dependency between them.
  await Future.wait([
    Hive.openBox('auth'),
    Hive.openBox('gamification'),
    Hive.openBox('roadmaps'),
    Hive.openBox('settings'),
  ]);
}

void main() async {
  // MUST be the very first line before any async work or plugins.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and Hive concurrently to reduce startup time.
  // Firebase is wrapped in try/catch to gracefully handle GMS SecurityException
  // on certain Android devices/emulators without crashing the entire app loop.
  await Future.wait([
    (() async {
      try {
        await Firebase.initializeApp();
      } catch (e) {
        debugPrint('[DevBuddy] Firebase init failed: $e');
      }
    })(),
    initHive(),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GamificationCubit()),
        BlocProvider(create: (_) => RoadmapCubit(box: Hive.box('roadmaps'))),
        BlocProvider(
          create: (_) => AuthCubit(
            repository: AuthRepositoryImpl(
              remoteDataSource: AuthRemoteDataSource(),
            ),
          )..initialize(),
        ),
      ],
      // ✅ ضفنا الـ ThemeProvider هنا
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppModeProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        // ✅ خلينا الـ Consumer يسمع التغييرات
        child: Consumer3<AppModeProvider, LocaleProvider, ThemeProvider>(
          builder:
              (context, modeProvider, localeProvider, themeProvider, child) {
                return MaterialApp(
                  title: 'DevBuddy',
                  debugShowCheckedModeBanner: false,

                  // ✅ ربط الثيم بوضع الأطفال أو الـ ThemeProvider
                  themeMode: modeProvider.isKidsMode
                      ? ThemeMode.light
                      : themeProvider.themeMode,
                  theme: AppThemes.kidsTheme, // افتراضي للـ light
                  darkTheme: AppThemes.professionalTheme,

                  // ✅ ربط اللغة
                  locale: localeProvider.locale,
                  supportedLocales: const [Locale('en'), Locale('ar')],
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],

                  // ✅ عشان لو التطبيق عربي يعكس الـ Layout (RTL)
                  builder: (context, child) {
                    return Directionality(
                      textDirection: localeProvider.locale.languageCode == 'ar'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: child!,
                    );
                  },

                  home: const AuthWrapper(),
                );
              },
        ),
      ),
    );
  }
}
