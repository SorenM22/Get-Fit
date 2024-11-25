import 'dart:io';

import 'package:ctrl_alt_defeat/models/authentication_repository.dart';
import 'package:ctrl_alt_defeat/login_page.dart';
import 'package:ctrl_alt_defeat/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthenticationRepository()));
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return GetMaterialApp(
      home: AuthenticationPage(),
    );
  }

  // This widget is the root of your application.
 /* @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthenticationPage(),
    );
  }*/
}

class AuthenticationPage extends StatelessWidget {

  const AuthenticationPage({Key? key}) : super(key: key);
  final String appLogo = "assets/login_Image/Workout_ClipArt.png";
  

  @override
    Widget build(BuildContext context) {
      var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
           padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(image: AssetImage(appLogo), height: height * 0.35),
              Column(
                  children: [
                   Text("Welcome to MyFit!", textAlign: TextAlign.center, style: TextStyle(fontSize: 40, color: Theme.of(context).colorScheme.onPrimary),),
                   Text("The best place to record all your workouts \n May you have many wonderful workouts in the future",
                     textAlign: TextAlign.center,
                     style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onPrimary),),
                 ],
              ),
              Row(
                children:[
                  Expanded(child: OutlinedButton(
                    onPressed: () => Get.to(() => const LoginPage()),

                     /* Navigator.push(context, MaterialPageRoute(builder: (context) {return LoginPage();},

                          ),
                      );*/
      

                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                      backgroundColor: Theme.of(context).colorScheme.onSecondary,
                      side: BorderSide(color: Color(0xFF272727)),
                      padding: EdgeInsets.symmetric(vertical:30),
                  ), child: const Text("Login")),),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(child: ElevatedButton(
                      onPressed: () => Get.to(() => const SignupPage()), /*{
                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) {
                          return SignupPage();
                        },
                        ),
                        );
                      },*/
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(),
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context).colorScheme.onPrimary,
                        side: BorderSide(color: Color(0xFF434343)),
                        padding: EdgeInsets.symmetric(vertical:30),
                      ),
                      child: const Text("Sign up")),)
                ]
              )
            ]
          )
        )
      ),
    );
  }
  }