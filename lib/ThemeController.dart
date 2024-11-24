import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ctrl_alt_defeat/models/user_repository.dart';


class ThemeController extends GetxController {
  final user = Get.put(UserRepository());
  final db = FirebaseFirestore.instance.collection("User_Data");

  var isDarkMode = false.obs;

  Future<void> getTheme() async {
    try {
      final uid = user.getCurrentUserUID();
      if (uid == null) {
        throw Exception("User is not available.");
      }

      DocumentSnapshot grabTheme = await db.doc(uid).get();
      if (grabTheme.exists) {
        isDarkMode.value = grabTheme.get("Theme") ?? false;
        print("Theme loaded: ${isDarkMode.value}");
      } else {
        isDarkMode.value = false;
        print("No theme found");
      }
    } catch (e) {
      print("Error getting theme: $e");
      isDarkMode.value = false; // Fallback to Light mode
    }
  }


  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    db.doc(user.getCurrentUserUID()).set(
      {'Theme': isDarkMode.value},
      SetOptions(merge: true),
    );
  }
}
