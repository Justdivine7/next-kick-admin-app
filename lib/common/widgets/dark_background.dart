import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';

class DarkBackground extends StatelessWidget {
  final Widget child;
  const DarkBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.blackColor,
        image: DecorationImage(
          image: AssetImage('assets/images/man-logo-dark.png'),
          fit: BoxFit.cover,

          alignment: Alignment.center,
        ),
      ),
      child: child,
    );
  }
}
