import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';

class BallWidget extends StatelessWidget {
  const BallWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.lightLogoBorder, width: 2),
          color: AppColors.whiteColor,
        ),
        child: Icon(Icons.sports_soccer, color: AppColors.boldTextColor),
      ),
    );
  }
}
