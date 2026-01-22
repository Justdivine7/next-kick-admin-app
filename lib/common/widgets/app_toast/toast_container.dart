import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/custom_rounded_edge_container.dart';
import 'package:nextkick_admin/utilities/constants/enums/toast_enum.dart';

class ToastContainer extends StatelessWidget {
  final String message;
  final ToastStyle style;
  const ToastContainer({super.key, required this.message, required this.style});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return CustomRoundedEdgedContainer(
      color: style.backgroundColor,
      padding: EdgeInsets.all(8),
      boxShadow: [
        BoxShadow(
          color: style.shadowColor,
          blurRadius: 6,
          offset: Offset(0, 4),
        ),
      ],
      child: Text(
        message,
        style: textTheme.bodySmall?.copyWith(color: AppColors.boldTextColor),
      ),
    );
  }
}
