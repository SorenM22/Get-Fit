import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../ThemeController.dart';
import '../authentication_page.dart';
import '../home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;
  late String UID;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, createScreen);
    // ever(firebaseUser, updateUID); Uncomment if needed for testing if UID is properly retrieved
  }

  //sets the landing screen based on if a user is logged in or not
  createScreen(User? user) {
    final themeController = Get.put(ThemeController());
    themeController.getTheme();
    user == null ? Get.offAll(() => const AuthenticationPage()) : Get.offAll(() => const MyHomePage(title: "Home Page"));

  }

  //allows us to grab the current user's UID
  updateUID(User? user){
     user == null ? UID = "null" : UID = user.uid;
     print("UID has changed");
  }


  // general login with user credentials --> email and password
  Future <void> createUserFromSignUpPrompts (String name, String email, String password) async {
    try {
       await auth.createUserWithEmailAndPassword(email: email, password: password);




    } on FirebaseAuthException catch(e){
    } catch(_){}
  }

  Future <void> loginWithEmailandPass (String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);


    } on FirebaseAuthException catch(e){
    } catch(_){}
  }

  Future <void> signout () async{
    try {
      await logoutUser();
      await googleSignout();
    } catch (e){
      print("Error logging out: $e");
    }
  }

  Future <void> logoutUser () async => await auth.signOut();



  Future<UserCredential> signInWithGoogle() async {

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user;

    if(user != null && userCredential.additionalUserInfo?.isNewUser == true){
      await FirebaseFirestore.instance.collection('User_Data').doc(user.uid).set({
        'Name': user.displayName,
        'Email': user.email,
        'WorkoutPref' : 'weights'
      });
    }

    // Once signed in, return the UserCredential
    return userCredential;
    // return await auth.signInWithCredential(credential);
  }

  Future <void> googleSignout () async => await GoogleSignIn().signOut();


}