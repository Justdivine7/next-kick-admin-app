import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';

class BottomModalHeadingColumn extends StatelessWidget {
  final String heading;
  final String? subHeading;
  const BottomModalHeadingColumn({
    super.key,
    required this.heading,
    this.subHeading,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              heading,
              style: textTheme.headlineSmall?.copyWith(
                fontSize: 18,
                color: AppColors.boldTextColor,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close_rounded, color: AppColors.subTextcolor),
            ),
          ],
        ),
        SizedBox(height: 4),
        if (subHeading != null)
          Text(
            subHeading!,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.subTextcolor,
            ),
          ),
      ],
    );
  }
}
