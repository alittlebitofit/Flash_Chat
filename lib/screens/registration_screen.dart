import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

import '../components/signing_button.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  FirebaseAuth _auth;

  String _email;
  String _password;

  bool _showSpinner = false;

  bool _isEmailValid = true;

  // bool _isEmailEmpty = false;

  bool _isPasswordValid = true;
  bool _isPasswordEmpty = false;

  bool _isCredentialsValid = true;
  bool _isEmailAlreadyUsed = false;

  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firebaseInitializeApp();
  }

  void _firebaseInitializeApp() async {
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
              Column(
                children: [
                  _isCredentialsValid
                      ? Container()
                      : Text(
                          'Invalid email or password',
                          style: TextStyle(color: Colors.red.shade600),
                        ),
                  TextField(
                    controller: _emailEditingController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      _email = value;
                    },
                    decoration: kTextFiledDecoration.copyWith(
                      hintText: 'Enter you email',
                    ),
                  ),
                  _isEmailValid
                      ? Container()
                      : Text(
                          'Invalid email',
                          style: TextStyle(
                            color: Colors.red.shade600,
                          ),
                        ),
                  _isEmailAlreadyUsed
                      ? Text(
                    'Email already used',
                    style: TextStyle(color: Colors.red.shade600),
                  )
                      : Container(),
                  // _isEmailEmpty
                  //     ? Text(
                  //         'Email cannot be empty',
                  //         style: TextStyle(
                  //           color: Colors.red.shade600,
                  //         ),
                  //       )
                  //     : Container(),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Column(
                children: [
                  TextField(
                    controller: _passwordEditingController,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      _password = value;
                    },
                    decoration: kTextFiledDecoration.copyWith(
                      hintText: 'Enter you password',
                    ),
                  ),
                  _isPasswordEmpty
                      ? Text(
                          'Password cannot be empty',
                          style: TextStyle(color: Colors.red.shade600),
                        )
                      : Container(),
                  _isPasswordValid
                      ? Container()
                      : Text(
                          'Password cannot be less than 6 characters',
                          style: TextStyle(color: Colors.red),
                        ),
                ],
              ),
              SizedBox(
                height: 24.0,
              ),
              SigningButton(
                buttonColor: Colors.blueAccent,
                onPressed: () async {
                  print(_email);
                  print(_password);

                  if (_email == null) {
                    print('Invalid email');
                    // Also show some kind of red warning
                    setState(() {
                      _isEmailValid = false;
                      // _isEmailEmpty =
                      //     false; // false because it shouldn't appear when email is invalid
                    });
                    return;
                  }

                  // if (_email.isEmpty) {
                  //   print('Email cannot be empty');
                  //   // Also show some kind of red warning
                  //   setState(() {
                  //     _isEmailValid =
                  //         true; // true because it shouldn't appear when email is empty
                  //     // _isEmailEmpty = true;
                  //   });
                  //   return;
                  // }

                  if (_password == null) {
                    print('Password cannot be empty');
                    // Also show some kind of red warning
                    setState(() {
                      _isPasswordEmpty = true;
                      _isPasswordValid =
                          true; // true because it shouldn't appear when password is empty
                    });
                    return;
                  }

                  if (_password.length < 6) {
                    print('Password length cannot be less than 6');
                    // Also show some kind of red warning
                    setState(() {
                      _isPasswordEmpty =
                          false; // false because it shouldn't appear when password is entered but invalid
                      _isPasswordValid = false;
                    });
                    return;
                  }

                  setState(() {
                    _showSpinner = true;
                    // _isEmailEmpty = false;
                    _isEmailValid = true;
                    _isPasswordEmpty = false;
                    _isPasswordValid = true;
                  });

                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: _email, password: _password);
                    if (newUser != null) {
                      print('registration success');
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      _showSpinner = false;
                      _isCredentialsValid = true;
                      _isEmailAlreadyUsed = false;
                      // _isEmailValid = true;

                      // OKAY SO THE CODE HAS BECOME MESSY WITH IMPLEMENTING MINOR VALIDATION DETAILS, bleh

                      _emailEditingController.clear();
                      _passwordEditingController.clear();
                    });
                  } catch (e) {
                    print(
                        '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`registration_screen exception`');

                    if (e.toString() ==
                        '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
                      print('Email address already used');
                      _isEmailAlreadyUsed = true;
                      _isCredentialsValid = true;
                    } else {
                      _isCredentialsValid = false;
                    }

                    if (e.toString() ==
                        '[firebase_auth/invalid-email] The email address is badly formatted.') {
                      print('Invalid email.');
                      _isEmailValid = false;
                      _isCredentialsValid = true;
                      _isEmailAlreadyUsed = false;
                    }
                    _showSpinner = false;
                    setState(() {});
                    print(e);
                  }
                },
                buttonText: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
