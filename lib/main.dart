import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_themes.dart';
import 'core/theme/app_mode_provider.dart';
import 'core/theme/locale_provider.dart';
import 'features/onboarding/screens/splash_screen.dart';
import 'features/pro_mode/presentation/cubit/gamification_cubit.dart';
import 'features/pro_mode/presentation/cubit/roadmap_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

/// Initialize Hive and open all required boxes
Future<void> initHive() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Open boxes used by Cubits
  // These boxes will be used for persistent storage
  await Hive.openBox('auth'); // Used by AuthCubit
  await Hive.openBox('gamification'); // Used by GamificationCubit
  await Hive.openBox('settings'); // For future use
}

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase BEFORE running the app
  await Firebase.initializeApp();

  // Initialize Hive before running the app
  await initHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Cubit Providers
        BlocProvider(create: (_) => GamificationCubit()),
        BlocProvider(create: (_) => RoadmapCubit()),
        BlocProvider(
          create: (_) => AuthCubit(
            repository: AuthRepositoryImpl(
              remoteDataSource: AuthRemoteDataSource(),
            ),
          )..initialize(),
        ),

        // State Management Providers
        ChangeNotifierProvider(create: (_) => AppModeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer2<AppModeProvider, LocaleProvider>(
        builder: (context, modeProvider, localeProvider, child) {
          return MaterialApp(
            title: 'DevBuddy',
            debugShowCheckedModeBanner: false,

            // Switch theme based on isKidsMode value
            theme: modeProvider.isKidsMode
                ? AppThemes.kidsTheme
                : AppThemes.professionalTheme,

            // Localization configuration
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('ar'), // Arabic
              Locale('en'), // English
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
