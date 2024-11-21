import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ctrl_alt_defeat/models/user_repository.dart';


class ThemeController extends GetxController {
  final user = Get.put(UserRepository());
  final db = FirebaseFirestore.instance.collection("User_Data");

  var isDarkMode = false.obs;

  void onLoad() {
    db.doc(user.getCurrentUserUID()).get().then((grabTheme){
      isDarkMode = grabTheme.get("Theme");
    });
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    db.doc(user.getCurrentUserUID()).set(
      {'Theme': isDarkMode.value},
      SetOptions(merge: true),
    );
  }
}
