import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'authentication_page.dart';
import 'home_page.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, createScreen);
  }

  createScreen(User? user) {
    user == null ? Get.offAll(() => const AuthenticationPage()) : Get.offAll(() => const MyHomePage(title: "Home Page"));
  }
}