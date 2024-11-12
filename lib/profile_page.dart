import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
Color selectedColor = Colors.blue;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key,required this.title});
  final String title;
  @override
  State<ProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<ProfilePage> {
  Future<void> _openColorPicker() async{
    bool pickedColor = await ColorPicker(
      color: selectedColor,
      onColorChanged: (Color newColor) {
        setState(() {
          selectedColor = newColor;
        });
      },
      width: 40,
      height: 40,
      borderRadius: 20,
      spacing: 10,
      runSpacing: 10,
      heading: const Text('Pick a color'),
      subheading: const Text('Select a color for your widget'),
      wheelDiameter: 200,
      wheelWidth: 20,
    ).showPickerDialog(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
            const Text(
              'Profile',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: _openColorPicker,
              child: const Text('Pick a Color'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
