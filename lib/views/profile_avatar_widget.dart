import 'package:ctrl_alt_defeat/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../models/user_repository.dart';

class ProfileAvatar extends StatefulWidget{
  final String userID;

  const ProfileAvatar({ required this.userID, Key? key}) : super(key:key);

  @override
  _ProfileAvatarState createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  String? profileInitial;
  Color? profileColor;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }


  Future<void> _fetchProfileData() async {
    final user = Get.put(UserRepository());
    try {
      final initial = await user.getCurrentProfileInitial();
      final color = await user.getCurrentProfileColor();

      setState(() {
        profileInitial = initial;
        profileColor = color;
      });
    } catch (e){
      print("Error fetching profile data: $e");
    }
  }

  @override
  Widget build(BuildContext context){
    if (profileInitial == null || profileColor == null){
      return const CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey,
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return CircleAvatar(
      radius: 25,
      backgroundColor: profileColor,
      child: Text(
        profileInitial!,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}