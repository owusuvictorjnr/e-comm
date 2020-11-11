import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:upgradeecomm/config/colors.dart';
import 'package:upgradeecomm/dialogs/policy_dialog.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        alignment: Alignment.centerLeft,
        child: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            text: "By clicking Sign Up, you are agreeing to our ",
            style: TextStyle(color: Colors.black45, fontSize: 14),
            children: [
              TextSpan(
                text: "Terms & Conditions ",
                style: TextStyle(
                    color: Palette.pinkAccent,
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showDialog(
                      context: context,
                      //configuration: FadeScaleTransitionConfiguration(),
                      builder: (context) {
                        return PolicyDialog(
                          mdFileName: 'terms_and_conditions.md',
                        );
                      },
                    );
                  },
              ),
              TextSpan(text: "and that you have read our ", style: TextStyle(color: Colors.black45)),
              TextSpan(
                text: "Privacy Policy",
                style: TextStyle(
                  color: Palette.pinkAccent,
                  fontWeight: FontWeight.bold,
                  // fontStyle: FontStyle.italic
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return PolicyDialog(
                          mdFileName: 'privacy_policy.md',
                        );
                      },
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
