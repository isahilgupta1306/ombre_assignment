import 'package:flutter/material.dart';
import '../providers/google_signin.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          height: deviceSize.height * 0.09,
          width: deviceSize.width * 0.35,
          child: ElevatedButton(
            child: const Text(
              "SIGN IN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogIn();
            },
          ),
        ),
      ),
    );
  }
}
