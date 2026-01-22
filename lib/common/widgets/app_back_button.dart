import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_button.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: SizedBox(
          width: 90,

          child: AppButton(
            // padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 10.w),
            label: 'Back',
            backgroundColor: AppColors.whiteColor,
            textColor: AppColors.blackColor,
          ),
        ),
      ),
    );
  }
}
