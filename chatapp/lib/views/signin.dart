import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/views/chatrooms.dart';

import 'chatrooms.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  AuthMethods authMethods = new AuthMethods();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authMethods
          .signInWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((result) async {
        if (result != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              passwordEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(
              emailEditingController.text);

          print("signed in ");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val)
                                ? null
                                : "Please Enter Correct Email";
                          },
                          controller: emailEditingController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                              color: Colors.black38,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo[900]),
                            ),
                          ),
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (val) {
                            return val.length > 3
                                ? null
                                : "Enter Password 3+ characters";
                          },
                          controller: passwordEditingController,
                          decoration: InputDecoration(
                            hintText: "password",
                            hintStyle: TextStyle(
                              color: Colors.black38,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigo[900]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Text("Forgot Password? "),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      signIn();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.indigo, Colors.blue])),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.blue[200], Colors.purple[100]]),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.black, fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 250,
                  ),
                ],
              ),
            ),
    );
  }
}
