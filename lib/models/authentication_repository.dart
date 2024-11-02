import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../authentication_page.dart';
import '../home_page.dart';

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

  Future <void> createUserFromSignUpPrompts (String name, String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null ? Get.offAll(() => const AuthenticationPage()) : Get.offAll(() => const MyHomePage(title: "Home Page"));

    } on FirebaseAuthException catch(e){
    } catch(_){}
  }

  Future <void> loginWithEmailandPass (String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password).then(createScreen(firebaseUser.value));
      print("gets here");
      // createScreen(firebaseUser.value);
    } on FirebaseAuthException catch(e){
    } catch(_){}
  }


  Future <void> logoutUser () async => await auth.signOut();

}