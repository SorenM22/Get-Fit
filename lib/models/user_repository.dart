

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctrl_alt_defeat/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'authentication_repository.dart';

class UserRepository extends GetxController{
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  
  createUser(UserModel user) async {
   await _db.collection("User_Data").doc(getCurrentUserUID().toString()).set(user.userDataToJson()).catchError((error) {
      print(error.toString());
    });

  }

  String? getCurrentUserUID() {
    User? user = AuthenticationRepository.instance.firebaseUser.value;
    print("grabbing UID");
    return user?.uid; // This returns null if the user is not logged in
  }

}