import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/features/auth/view/login_view.dart';
import 'package:nextkick_admin/utilities/constants/app_image_strings.dart';

class AppSplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const AppSplashScreen({super.key});

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen> {
  bool _showContent = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
    });
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, LoginView.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double slideOffset = _showContent ? 0 : screenSize.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: AppColors.blackColor),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          transform: Matrix4.translationValues(slideOffset, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      AppImageStrings.mainLogo,
                      width: 150,
                      height: 200,
                      fit: BoxFit.contain,
                    ),

                    Image.asset(
                      AppImageStrings.binalSportsLogo,
                      width: 40,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
