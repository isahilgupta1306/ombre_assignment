import 'package:flutter/material.dart';
import 'named_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const heading = TextStyle(
    color: Color.fromARGB(255, 93, 52, 168),
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const SolidInverseButttonTextStyle =
      TextStyle(color: NamedColors.white, fontWeight: FontWeight.bold);
  static final detailCardMetaDetaTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: NamedColors.codGrey.withOpacity(0.7));

  static const solidButttonTextStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

  static const subHeading = TextStyle(
    color: NamedColors.grey,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const cautionHeadingTextStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: NamedColors.shinyPurple);
}
