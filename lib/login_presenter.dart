import 'package:get/get.dart';
import 'package:ctrl_alt_defeat/authentication_repository.dart';
import 'package:flutter/material.dart';

class loginPresenter extends GetxController {
  static loginPresenter get instance => Get.find();
  final testingAuth = Get.put(AuthenticationRepository());

  final email = TextEditingController();
  final password = TextEditingController();


  void logUserIn(String email, String password){
    AuthenticationRepository.instance.loginWithEmailandPass(email, password);
  }

}