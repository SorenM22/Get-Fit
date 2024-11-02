

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctrl_alt_defeat/models/user_model.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController{
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  
  createUser(UserModel user) async {
   await _db.collection("User_Data").add(user.userDataToJson()).catchError((error) {
      print(error.toString());
    });

  }

}