import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_button.dart';

class ErrorAndReloadWidget extends StatelessWidget {
  final String errorTitle;
  final String errorDetails;
  final String? labelText;
  final void Function()? buttonPressed;
  const ErrorAndReloadWidget({
    super.key,

    required this.errorTitle,
    required this.errorDetails,
    this.labelText,
    this.buttonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              errorTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.subTextcolor),
            ),
            const SizedBox(height: 8),
            Text(
              errorDetails,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.subTextcolor),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: labelText ?? 'Retry',
              backgroundColor: AppColors.appBGColor,
              textColor: AppColors.blackColor,

              onButtonPressed: buttonPressed,
            ),
          ],
        ),
      ),
    );
  }
}
