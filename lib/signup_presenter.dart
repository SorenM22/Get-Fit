import 'package:flutter/material.dart';
import 'package:get/get.dart';


class signupPresenter extends GetxController {
  static signupPresenter get instance => Get.find();

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();


  void registerUser(String name, String email, String password){

  }

}