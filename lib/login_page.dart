import 'package:flutter/material.dart';
import 'package:ctrl_alt_defeat/signup_page.dart';



class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  final String loginImage = "assets/login_Image/Workout_ClipArt.jpg";


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("LOGIN"),
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back)),
          ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage(loginImage), height: height * 0.2,),
                const Text("MyFit", style: TextStyle(fontSize: 35),),
                const Text("please login", style: TextStyle(fontSize: 15),),

                Form(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person_outline_outlined),
                              labelText: "E-mail",
                              hintText: "Enter you e-mail",
                              border: OutlineInputBorder(),
                        ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.fingerprint),
                              labelText: "Password",
                              hintText: "Enter your password",
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: null,
                                icon: Icon(Icons.remove_red_eye_sharp),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: (){},
                                child: const Text("Forgot Password"),
                                style: TextButton.styleFrom(foregroundColor: Colors.blueAccent)
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (){},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black54,
                                  foregroundColor: Colors.white),
                              child: Text("Let Me In")
                              ),
                          ),
                        ],
                      ),
                    ),
                ),
                const Text("OR"),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                      icon: Image(image: AssetImage("assets/login_Image/Google_Logo.png"), width: 25.0),
                      onPressed: (){},
                      label: Text("Google sign-in")),
                ),

                SizedBox(
                  height: 30.0,
                ),

                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context) {
                        return SignupPage();
                      },
                      ),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an Account? ",
                        style: Theme.of(context).textTheme.bodySmall,
                        children: const [
                          TextSpan(
                            text: "Signup",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}