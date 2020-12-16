// material package
import 'package:flutter/material.dart';

// screens
import 'login_screen.dart';
import 'registration_screen.dart';

// flutter package
import 'package:animated_text_kit/animated_text_kit.dart';

// component
import 'package:flash_chat/components/signing_button.dart';

// code
class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _setUpAnimation();
  }

  void _setUpAnimation() {
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(_animationController);
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 200),
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            SigningButton(
              buttonColor: Colors.lightBlueAccent,
              onPressed: (){
                Navigator.pushNamed(context, LoginScreen.id);
              },
              buttonText: 'Log In',
            ),
            SigningButton(
              buttonColor: Colors.blueAccent,
              onPressed: (){
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              buttonText: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}