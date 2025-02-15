import 'package:ctrl_alt_defeat/models/user_model.dart';
import 'package:flutter/material.dart';
import 'presenter/signup_presenter.dart';
import 'package:get/get.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Sign Up", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
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
                  signupInputFields(),
                ]
              )
            )
          )
        ),
    );
  }
}


class signupForm extends StatelessWidget {
  final String appLogo = "assets/login_Image/Workout_ClipArt.png";

  const signupForm ({super.key});

@override
Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(image: AssetImage(appLogo)),
        Text("All fields are required", style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onPrimary),),
      ],
    );
}
}


class signupInputFields extends StatelessWidget {
  const signupInputFields ({super.key});

  @override
  Widget build(BuildContext context) {

     final authControl = Get.put(signupPresenter());
     final _formKey = GlobalKey<FormState>();


    return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: authControl.name,
                decoration: InputDecoration(
                    label: Text("Name", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                    prefixIcon: Icon(
                        Icons.person_outline_rounded,
                        color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.7, color: Colors.grey),
                    )
                ),
              ),

              TextFormField(
                controller: authControl.email,
                decoration: InputDecoration(
                    label: Text("Email", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                    prefixIcon: Icon(
                        Icons.mail_outline_sharp,
                        color: Colors.grey
                    ),
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.7, color: Colors.grey),
                    )
                ),
              ),

              TextFormField(
                obscureText: true,
                controller: authControl.password,
                decoration: InputDecoration(
                      label: Text("Password", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                      prefixIcon: Icon(
                          Icons.key,
                          color: Colors.grey
                      ),
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.7, color: Colors.grey),
                      )
                  )
              ),

              SizedBox(
                height: 25,
              ),

              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 150,
                  child: OutlinedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          // signupPresenter.instance.registerUser(authControl.name.text.trim(), authControl.email.text.trim(), authControl.password.text.trim());

                          final user = UserModel(
                              name: authControl.name.text.trim(),
                              email: authControl.email.text.trim(),
                              password: authControl.password.text.trim(),
                          );

                          signupPresenter.instance.signupAndCreateUser(user);

                        }
                      },
                      child: Text("Sign up", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary))
                  ),
                ),
              ),

            ],
          ),
        )
    );
  }
}