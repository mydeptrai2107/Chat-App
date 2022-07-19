import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/screens/home_screen.dart';
import 'package:chatapp/services/firebase_service.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Center(
          child: Column(
            children: [
              // image chat
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/chat.png"),
                          )
                        ),
                      ),
                    ),
      
                    // text flutter chat app
                    const Expanded(
                      child: Text(
                        "Flutter Chat App",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      
              
      
              //button login
      
              GestureDetector(
                onTap: () async {
                    await FirebaseService().signInFunction();
                    UserModel usermodel = await FirebaseService().getUserCurrent();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomeScreen(usermodel)), 
                      (route) => false
                    );
                  },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                            color: Colors.black54,
                            blurRadius: 15.0,
                            offset: Offset(0.0, 0.75)
                        )
                    ]
                  ),
      
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/google.png"),
                              fit: BoxFit.cover
                            )
                          ),
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 10,),
                        const Text("Sign in With Google", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ),
              ),
      
              // Button sign in with Facebook
              GestureDetector(
                onTap: () async {
                    await FirebaseService().signInFunction();
                    UserModel usermodel = await FirebaseService().getUserCurrent();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomeScreen(usermodel)), 
                      (route) => false
                    );
                  },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.blue,                 
                  ),
      
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/facebook.png"),
                              fit: BoxFit.cover
                            )
                          ),
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 10,),
                        const Text("Sign in With Facebook", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}