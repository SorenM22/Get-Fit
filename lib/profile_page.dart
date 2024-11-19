import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctrl_alt_defeat/entry_form.dart';
import 'package:ctrl_alt_defeat/models/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key,required this.title});
  final String title;
  @override
  State<ProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<ProfilePage> {
  final user = Get.put(UserRepository());
  final db = FirebaseFirestore.instance.collection("User_Data");
  Color selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    db.doc(user.getCurrentUserUID()).get().then((grabColor){
      String profileColor = grabColor.get("Profile Color");
      setState(() {
        selectedColor = profileColor.toColor;
      });
    });
  }


  Future<void> _openColorPicker() async {
    // Show a custom dialog with the color picker inside it
    Color? pickedColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              color: selectedColor,
              onColorChanged: (Color newColor) {
                selectedColor = newColor;
              },

              width: 40,
              height: 40,
              borderRadius: 20,
              spacing: 10,
              runSpacing: 10,
              heading: const Text('Pick a color'),
              wheelDiameter: 200,
              wheelWidth: 20,
              pickersEnabled: {ColorPickerType.accent: false},
              enableShadesSelection: false,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, null); // Close the dialog without any change
              },
              child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary),
                  ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, selectedColor);
                  setState(() {});
                  db.doc(user.getCurrentUserUID()).set(
                    {'Profile Color': selectedColor.hex},
                    SetOptions(merge: true),
                  );
              },
              child: Text(
                'OK',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ],
        );
      },
    );

    // If a color was picked (OK button), update the state
    if (pickedColor != null) {
      setState(() {
        selectedColor = pickedColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context,selectedColor);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: selectedColor, // Circle color
              child: const Text(
                'P',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
            ),
            Text(
              'Profile',
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).colorScheme.onPrimary
              ),
            ),
            ElevatedButton(
              onPressed: _openColorPicker,
              child: Text('Pick a Color',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onPrimary
                )),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
