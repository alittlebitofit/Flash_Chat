import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    try {
      controller = AnimationController(
        duration: Duration(seconds: 1),
        vsync: this,
      );

      if (controller == null) {
        print('Goodnight everybody');
      } else {
        print('Hello everybody');
      }

      animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
          .animate(controller);

      // animation = CurvedAnimation(parent: controller, curve: Curves.bounceOut);

      controller.forward();

      int counter = 0;
      animation.addStatusListener((status) {
        print(status);
        print(counter);
      });

      controller.addListener(() {
        setState(() {});
        // print(animation.value);
        ++counter;
      });

      CircularProgressIndicator();
    } catch (e) {
      print('YOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO');
      print(e.toString());
    }

    print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      print('controller seems to be null in build()');
      return null;
    }

    print('controller seems to not be null in build()');


    return Scaffold(
      backgroundColor: animation.value,
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
                // SizedBox(
                //   width: 250,
                //   child: Container(
                //     color: Colors.red,
                //     child: TypewriterAnimatedTextKit(
                //       onTap: () {
                //         print('Tap Event');
                //       },
                //       text: [
                //         'Discipline is the best tool',
                //         'Design first, then code',
                //         'Do not patch bugs out, rewrite them',
                //         'Do not test bugs out, design them out',
                //       ],
                //       textStyle: TextStyle(
                //         fontSize: 30.0,
                //         fontFamily: 'Agne',
                //         color: Colors.grey.shade600,
                //       ),
                //     ),
                //   ),
                // ),
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Log In',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
