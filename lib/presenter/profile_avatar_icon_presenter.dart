import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_repository.dart';

class ProfileController extends GetxController {
  // Observable variables
  var profileInitial = ''.obs;
  var profileColor = Rx<Color>(Colors.grey); // Updated to Rx<Color>

  // Fetch data from the database
  Future<void> fetchProfileData() async {
    final user = Get.put(UserRepository());
    try {
      profileInitial.value = (await user.getCurrentProfileInitial())!;
      profileColor.value = (await user.getCurrentProfileColor())!;
    } catch (e) {
      print("Error fetching profile data: $e");
    }
  }
}
