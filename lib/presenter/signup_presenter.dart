import 'package:ctrl_alt_defeat/models/authentication_repository.dart';
import 'package:ctrl_alt_defeat/models/user_model.dart';
import 'package:ctrl_alt_defeat/models/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class signupPresenter extends GetxController {
  static signupPresenter get instance => Get.find();


  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  final userRepo = Get.put(UserRepository());
  final authRepo = Get.put(AuthenticationRepository());

  Future <void> registerUser(String name, String email, String password) async{
  authRepo.createUserFromSignUpPrompts(name, email, password);
  }

  Future<void> signupAndCreateUser(UserModel user)  async {
    try {
      await authRepo.createUserFromSignUpPrompts(
          user.name,
          user.email,
          user.password
      );

      await userRepo.createUser(user);
    } catch (e) {
      print('Error creating user document: $e');
      rethrow;
    }
  }


}