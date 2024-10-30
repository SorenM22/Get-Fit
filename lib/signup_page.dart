import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);
  final String loginImage = "assets/login_Image/Workout_ClipArt.jpg";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Sign Up"),
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back)),
          ),

          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  signupForm(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              label: Text("Name"),
                              prefixIcon: Icon(
                                  Icons.person_outline_rounded,
                                  color: Colors.grey),
                              labelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1.7, color: Colors.grey),
                              )
                            ),
                        )
                        ],
                      ),
                    )
                  )
                ]
              )
            )
          )
        ),
    );
  }
}


class signupForm extends StatelessWidget {
  const signupForm ({super.key});

@override
Widget build(BuildContext context) {

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(image: AssetImage("assets/login_Image/Workout_ClipArt.jpg")),
        Text("test"),
      ],
    );
}
}