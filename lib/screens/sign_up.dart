import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ombre_assignment/utils/themes/app_text_styles.dart';
import 'package:ombre_assignment/utils/themes/named_colors.dart';
import 'package:ombre_assignment/widgets/solid_inverse_button.dart';
import '../providers/google_signin.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: NamedColors.bgColorDark,
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: deviceSize.height * 0.15,
          ),
          SvgPicture.asset(
            'assets/images/ombre-logo-white.svg',
            width: deviceSize.width * 0.60,
            fit: BoxFit.fitWidth,
          ),
          const Text(
            "Assignment",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
          ),
          const Divider(
            height: 40,
            endIndent: 40,
            indent: 40,
            thickness: 2,
            color: NamedColors.ombrePink,
          ),
          SizedBox(
            height: deviceSize.height * 0.2,
          ),
          SolidInverseButton(
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogIn();
            },
            label: "Google Sign In",
            deviceSize: deviceSize,
            labelTextStyle: AppTextStyles.SolidInverseButttonTextStyle,
            icon: Icons.person,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Click on the Button to Login",
            style: AppTextStyles.solidButttonTextStyle.copyWith(
                fontSize: 17, color: NamedColors.white.withOpacity(0.6)),
          )
        ],
      )),
    );
  }
}
