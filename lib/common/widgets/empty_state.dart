import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/utilities/helpers/ui_helpers.dart';

class EmptyState extends StatelessWidget {
  final String image;
  final String notifierText;
  final String descriptionText;
  const EmptyState({
    super.key,
    required this.image,
    required this.notifierText,
    required this.descriptionText,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image),
          Text(
            notifierText,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.boldTextColor,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: getScreenWidth(context, 0.7),
            child: Text(
              descriptionText,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.subTextcolor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
