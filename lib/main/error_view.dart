import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_back_button.dart';

class ErrorView extends StatelessWidget {
  static const String routeName = '/error';
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 100,
        leading: AppBackButton(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, size: 40, color: AppColors.whiteColor),
            SizedBox(height: 20),
            Text(
              'This page does not exist',
              style: TextStyle(color: AppColors.whiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
