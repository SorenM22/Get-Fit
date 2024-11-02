import 'package:ctrl_alt_defeat/models/authentication_repository.dart';
import 'package:ctrl_alt_defeat/models/user_model.dart';
import 'package:ctrl_alt_defeat/models/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class signupPresenter extends GetxController {
  static signupPresenter get instance => Get.find();
  final testingAuth = Get.put(AuthenticationRepository());

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  final userRepo = Get.put(UserRepository());

  void registerUser(String name, String email, String password){
  AuthenticationRepository.instance.createUserFromSignUpPrompts(name, email, password);
  }
  
  Future<void> createUser(UserModel user) async {
    await userRepo.createUser(user);
  }

}