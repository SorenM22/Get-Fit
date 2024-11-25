import 'package:ctrl_alt_defeat/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../models/user_repository.dart';
import '../presenter/profile_avatar_icon_presenter.dart';


class ProfileAvatar extends StatelessWidget {
  final double scale;

  const ProfileAvatar({
    this.scale = 1,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the ProfileController
    final profileController = Get.find<ProfileController>();

    return Obx(() {
      // Rebuild widget when profileInitial or profileColor changes
      if (profileController.profileInitial.isEmpty) {
        return CircleAvatar(
          radius: 25 * scale,
          backgroundColor: Colors.grey,
          child: const CircularProgressIndicator(color: Colors.white),
        );
      }

      return CircleAvatar(
        radius: 25 * scale,
        backgroundColor: profileController.profileColor.value,
        child: Text(
          profileController.profileInitial.value,
          style: TextStyle(
            color: Colors.white,
            fontSize: (20 * scale),
          ),
        ),
      );
    });
  }
}
