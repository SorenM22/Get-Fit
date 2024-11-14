import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctrl_alt_defeat/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'authentication_repository.dart';

class UserRepository extends GetxController{
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance.collection("User_Data");
  
  createUser(UserModel user) async {
   await _db.doc(getCurrentUserUID().toString()).set(user.userDataToJson()).catchError((error) {
      print(error.toString());
    });

  }

  String? getCurrentUserUID() {
    User? user = AuthenticationRepository.instance.firebaseUser.value;
    print("grabbing UID");
    return user?.uid; // This returns null if the user is not logged in
  }

  Future<String?> getCurrentProfileColor() async{
    String profileColor = Colors.black.hex;

    await _db.doc(getCurrentUserUID()).get().then((grabColor){
      profileColor = grabColor.get("Profile Color");
    });

    return profileColor;
  }


  Future<String?> getCurrentProfileInitial() async{
    String profileInitial = 'P';

    await _db.doc(getCurrentUserUID()).get().then((grabInitial){
      profileInitial = grabInitial.get("Name")[0];
    });

    return profileInitial;
  }


}