import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SigningButton extends StatelessWidget {
  SigningButton({
    @required this.buttonColor,
    @required this.onPressed,
    @required this.buttonText,
  });

  final Color buttonColor;
  final Function onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
