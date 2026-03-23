import 'package:flutter/material.dart';
import '../../../../core/services/firestore_service.dart';

class ProfileSelectorScreen extends StatelessWidget {
  final String userId; // هنباصي الـ ID بتاع اليوزر هنا

  const ProfileSelectorScreen({Key? key, required this.userId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // أو لون الـ Dark Mode بتاعنا
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'مين اللي هيبرمج دلوقتي؟',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 1. حساب المحترفين (Pro)
                GestureDetector(
                  onTap: () async {
                    // تحديث الداتا بيز لـ Pro
                    await FirestoreService().switchProfileMode(userId, false);
                    // التوجيه للداشبورد الأساسية
                    Navigator.pushReplacementNamed(context, '/proDashboard');
                  },
                  child: Column(
                    children: const [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.code, size: 60, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text('Pro Mode', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),

                // 2. حساب الأطفال/المبتدئين (Kids)
                GestureDetector(
                  onTap: () async {
                    // تحديث الداتا بيز لـ Kids
                    await FirestoreService().switchProfileMode(userId, true);
                    // التوجيه لداشبورد الأطفال (لو عاملالها شاشة منفصلة)
                    Navigator.pushReplacementNamed(context, '/kidsDashboard');
                  },
                  child: Column(
                    children: const [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.orangeAccent,
                        child: Icon(
                          Icons.child_care,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Kids Mode', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
