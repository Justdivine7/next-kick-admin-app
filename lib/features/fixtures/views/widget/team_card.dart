import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/data/models/fixture_model.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';

class TeamCard extends StatelessWidget {
  final FixtureModel fixture;
  const TeamCard({super.key, required this.fixture});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          tileColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

          title: Text(
            fixture.teamOneName.capitalizeFirstLetter(),
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.boldTextColor,
            ),
          ),
          trailing: Text(
            fixture.teamOneScore.toString(),
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.blackColor,
            ),
          ),
        ),
      ),
    );
  }
}
