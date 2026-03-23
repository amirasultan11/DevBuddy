import 'package:cloud_firestore/cloud_firestore.dart';
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. جلب الرود مابس الثابتة
  Stream<QuerySnapshot> getRoadmaps() {
    return _db.collection('roadmaps').snapshots();
  }

  // 2. جلب التاسكات (هنا هنفلتر الواجهات حسب نوع التاسك)
  Stream<QuerySnapshot> getStageTasks() {
    // لما تيجي تعرضيهم في الـ UI هتبصي على حقل task_type 
    // لو classic، ai_boosted، أو ai_review وتعرضي الـ Widget المناسب
    return _db.collection('tasks').snapshots(); 
  }

  // 3. تبديل الحساب (Kids / Pro)
  Future<void> switchProfileMode(String userId, bool isKids) async {
    try {
      await _db.collection('users').doc(userId).update({
        'isKidsMode': isKids,
      });
      print("تم التبديل بنجاح!");
    } catch (e) {
      print("حصلت مشكلة في التبديل: $e");
    }
  }

  // 4. جلب بيانات اليوزر (عشان الستريك والإنجازات)
  Stream<DocumentSnapshot> getUserData(String userId) {
    return _db.collection('users').doc(userId).snapshots();
  }
}
