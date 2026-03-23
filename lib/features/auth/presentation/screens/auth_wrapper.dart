import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../onboarding/screens/splash_screen.dart';
import '../../../onboarding/screens/language_selection_screen.dart';
import '../../../pro_mode/presentation/screens/pro_home_screen.dart';
import '../../../onboarding/screens/personality_test_screen.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        if (snapshot.hasData && snapshot.data != null) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                final pt = state.user.personalityType;
                
                // Route to quiz only if personality type is genuinely unset.
                // Valid MBTI types (e.g. 'INTJ', 'ENFP', ...) must NOT be
                // treated as missing — this was the original routing bug.
                if (pt == null || pt.isEmpty || pt == 'Unknown') {
                  return const PersonalityTestScreen();
                }
                
                return const ProHomeScreen();
              }
              
              if (state is AuthError) {
                // ضفنا زرار عشان اليوزر يقدر يسجل خروج لو الداتا بيز فيها مشكلة
                return Scaffold(
                  backgroundColor: const Color(0xFF1E293B),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error loading profile:\n${state.message}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            context.read<AuthCubit>().logout();
                          },
                          child: const Text('تسجيل خروج والمحاولة مجدداً'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // ✅ التعديل الجوهري: لو فايربيز شايفه مسجل بس الداتا مش موجودة (Limbo state)
              if (state is Unauthenticated) {
                // نعمل تسجيل خروج إجباري في الخلفية عشان نفك التعليقة
                FirebaseAuth.instance.signOut();
                return const LanguageSelectionScreen();
              }

              return const SplashScreen();
            },
          );
        }

        return const LanguageSelectionScreen();
      },
    );
  }
}