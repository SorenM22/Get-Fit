import 'package:ctrl_alt_defeat/models/user_repository.dart';
import 'package:ctrl_alt_defeat/presenter/profile_avatar_icon_presenter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ctrl_alt_defeat/home_page.dart';
import 'package:get/get.dart';
import 'models/authentication_repository.dart';
import 'package:ctrl_alt_defeat/ThemeController.dart';


Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthenticationRepository()));
  final themeController = Get.put(ThemeController());
  themeController.getTheme();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());
    profileController.fetchProfileData();

    final themeController = Get.find<ThemeController>();

    return Obx(() {
      // The app will reactively rebuild based on the theme state
      return GetMaterialApp(
        title: 'GetFit',
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFFF9F9F9),
            onPrimary: Color(0xFF3E10C6),
            secondary: Color(0xFFF9F9F9),
            onSecondary: Color(0xFF1A73E8),
            error: Color(0xFFF9F9F9),
            onError: Color(0xFFE30E00),
            surface: Color(0xFFF9F9F9),
            onSurface: Color(0xFF3E10C6),
            onPrimaryContainer: Color(0xffD4D2D5),
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: const ColorScheme(
              brightness: Brightness.dark,
              primary: Color(0xFF333333),
              onPrimary: Color(0xFFFBE073),
              secondary: Color(0xFF333333),
              onSecondary: Color(0xFFB8AEAD),
              error: Color(0xFF333333),
              onError: Color(0xFFE30E00),
              surface: Color(0xFF333333),
              onSurface: Color(0xFFFACE1D),
              onPrimaryContainer: Color(0xFF606060)
          ),
          useMaterial3: true,
        ),
        themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light, // Reactive theme change
        home: MyHomePage.instance,
      );
    });
  }
}
