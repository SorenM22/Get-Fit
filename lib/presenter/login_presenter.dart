import 'package:get/get.dart';
import 'package:ctrl_alt_defeat/models/authentication_repository.dart';
import 'package:flutter/material.dart';

class loginPresenter extends GetxController {
  static loginPresenter get instance => Get.find();
  final testingAuth = Get.put(AuthenticationRepository());

  final email = TextEditingController();
  final password = TextEditingController();

  final isGoogleLoading = false.obs;


  void logUserIn(String email, String password){
    AuthenticationRepository.instance.loginWithEmailandPass(email, password);
  }

  Future<void> googleLogin() async {
    try{
      isGoogleLoading.value = true;
      await testingAuth.signInWithGoogle();
      isGoogleLoading.value = false;
    } catch (e) {
      isGoogleLoading.value = false;
      print("Failed to log in with google: $e");
    }
  }

}