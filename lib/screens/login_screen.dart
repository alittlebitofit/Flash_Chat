import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

import '../components/signing_button.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email;
  String _password;

  FirebaseAuth _auth;

  bool _showSpinner = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  void _initializeFirebase() async {
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  _email = value;
                },
                decoration: kTextFiledDecoration.copyWith(
                  hintText: 'Enter you email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  _password = value;
                },
                decoration: kTextFiledDecoration.copyWith(
                  hintText: 'Enter you password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              SigningButton(
                buttonColor: Colors.lightBlueAccent,
                onPressed: () async {
                  print(_email);
                  print(_password);

                  setState(() {
                    _showSpinner = true;
                  });

                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: _email, password: _password);
                    if (user != null) {
                      print('log in success');
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  } catch (e) {
                    print(
                        '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~login_screen exception');
                    print(e);
                  }

                  setState(() {
                    _showSpinner = false;
                  });

                },
                buttonText: 'Log In',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
