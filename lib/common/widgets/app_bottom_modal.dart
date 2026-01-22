 import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';

Future<T?> appBottomModal<T>({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet(
    backgroundColor: AppColors.appBGColor,
    context: context,
    // enableDrag: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      // Add rounded corners to the sheet itself
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder:
        (context) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [child],
          ),
        ),
  );
}
