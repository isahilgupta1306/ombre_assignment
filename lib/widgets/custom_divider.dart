import 'package:flutter/material.dart';
import '../utils/themes/app_text_styles.dart';
import '../utils/themes/named_colors.dart';

class CustomDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final deviceSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 2,
          width: deviceSize.width * 0.35,
          decoration:
              BoxDecoration(color: NamedColors.shinyPurple.withOpacity(0.45)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            " O R ",
            style:
                AppTextStyles.heading.copyWith(color: NamedColors.shinyPurple),
          ),
        ),
        Container(
          height: 2,
          width: deviceSize.width * 0.35,
          decoration:
              BoxDecoration(color: NamedColors.shinyPurple.withOpacity(0.45)),
        ),
      ],
    );
  }
}
