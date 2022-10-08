import 'package:flutter/material.dart';
import 'package:ombre_assignment/utils/themes/named_colors.dart';

class SolidButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Size deviceSize;
  final TextStyle labelTextStyle;
  final IconData icon;
  const SolidButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.deviceSize,
    required this.labelTextStyle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: deviceSize.width * 0.87,
      height: deviceSize.width * 0.14,
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(
            label,
            style: labelTextStyle,
          )),
    );
  }
}
