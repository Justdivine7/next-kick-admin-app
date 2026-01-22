 import 'package:flutter/cupertino.dart';
 import 'package:nextkick_admin/common/colors/app_colors.dart';

enum ToastStyle {
  success(
    'Success',
    CupertinoIcons.check_mark_circled,
    AppColors.lightGreenBackground,
    AppColors.lightGreenShadowColor,
    AppColors.appPrimaryColor,
  ),
  warning(
    'Warning',
    CupertinoIcons.exclamationmark_circle,
    AppColors.lightOrangeBackground,
    AppColors.lightOrangeShadowColor,
    AppColors.solidOrange,
  ),
  error(
    'Something went wrong',
    CupertinoIcons.exclamationmark,

    AppColors.lightRedBackground,
    AppColors.lightRedShadowColor,
    AppColors.pastelRed,
  );

  final String title;
  final IconData iconData;
  final Color backgroundColor;
  final Color shadowColor;
  final Color iconContainerColor;
  const ToastStyle(
    this.title,
    this.iconData,
    this.backgroundColor,
    this.shadowColor,
    this.iconContainerColor,
  );
}
