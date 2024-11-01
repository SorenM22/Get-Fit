import 'package:ctrl_alt_defeat/login_page.dart';
import 'package:ctrl_alt_defeat/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthenticationPage(title: 'Flutter Auth'),
    );
  }
}

class AuthenticationPage extends StatelessWidget {

  const AuthenticationPage({Key? key, required this.title}) : super(key: key);
  final String title;
  final String loginImage = "assets/login_Image/Workout_ClipArt.jpg";
  

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
              Image(image: AssetImage(loginImage), height: height * 0.6),
               const Column(
                  children: [
                   Text("Welcome to MyFit!", textAlign: TextAlign.center, style: TextStyle(fontSize: 40),),
                   Text("The best place to record all your workouts \n May you have many wonderful workouts in the future",
                     textAlign: TextAlign.center,
                     style: TextStyle(fontSize: 15),),
                 ],
              ),
              Row(
                children:[
                  Expanded(child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) {
                            return LoginPage();
                            },
                          ),
                      );
      
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      foregroundColor: Color(0xFF272727),
                      side: BorderSide(color: Color(0xFF272727)),
                      padding: EdgeInsets.symmetric(vertical:30),
                  ), child: const Text("Login")),),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) {
                          return SignupPage();
                        },
                        ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(),
                        foregroundColor: Color(0xFF434343),
                        backgroundColor: Color(0XFFb7f2f1),
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