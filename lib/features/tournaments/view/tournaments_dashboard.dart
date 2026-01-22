import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_back_button.dart';
import 'package:nextkick_admin/common/widgets/app_button.dart';
import 'package:nextkick_admin/common/widgets/dark_background.dart';
import 'package:nextkick_admin/features/standings/view/create_standings_view.dart';
import 'package:nextkick_admin/features/tournaments/view/create_tournament_view.dart';
import 'package:nextkick_admin/features/fixtures/views/create_fixtures_view.dart';
import 'package:nextkick_admin/features/fixtures/views/fixtures_list_view.dart';
import 'package:nextkick_admin/features/registered_teams/view/registered_teams_view.dart';
import 'package:nextkick_admin/features/standings/view/standings_view.dart';
import 'package:nextkick_admin/features/tournaments/view/tournaments_list_view.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';

class TournamentsDashboard extends StatelessWidget {
  static const routeName = '/tournaments-dashboard';
  const TournamentsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        toolbarHeight: 40,
        leading: AppBackButton(),
      ),
      body: DarkBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsGeometry.all(16),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Text(
                      'TOURNAMENT SETTINGS',
                      style: context.textTheme.displayMedium?.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                    SizedBox(height: 16),

                    AppButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),

                      label: AppTextStrings.createTournamment,
                      backgroundColor: AppColors.whiteColor,
                      textColor: AppColors.blackColor,
                      onButtonPressed: () => Navigator.pushNamed(
                        context,
                        CreateTournamentView.routeName,
                      ),
                    ),
                    SizedBox(height: 16),
                    AppButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),

                      label: AppTextStrings.tournaments,
                      backgroundColor: AppColors.whiteColor,
                      textColor: AppColors.blackColor,
                      onButtonPressed: () => Navigator.pushNamed(
                        context,
                        TournamentsListView.routeName,
                      ),
                    ),
                    SizedBox(height: 16),
                    AppButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),

                      label: AppTextStrings.registeredTeams,
                      backgroundColor: AppColors.whiteColor,
                      textColor: AppColors.blackColor,
                      onButtonPressed: () => Navigator.pushNamed(
                        context,
                        RegisteredTeamsView.routeName,
                      ),
                    ),
                    SizedBox(height: 16),

                    AppButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),

                      label: AppTextStrings.createFixture,
                      backgroundColor: AppColors.whiteColor,
                      textColor: AppColors.blackColor,
                      onButtonPressed: () => Navigator.pushNamed(
                        context,
                        CreateFixturesView.routeName,
                      ),
                    ),
                    SizedBox(height: 16),

                    AppButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),

                      label: AppTextStrings.fixtures,
                      backgroundColor: AppColors.whiteColor,
                      textColor: AppColors.blackColor,
                      onButtonPressed: () => Navigator.pushNamed(
                        context,
                        FixturesListView.routeName,
                      ),
                    ),
                    SizedBox(height: 16),
                    AppButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),

                      label: AppTextStrings.createStanding,
                      backgroundColor: AppColors.whiteColor,
                      textColor: AppColors.blackColor,
                      onButtonPressed: () => Navigator.pushNamed(
                        context,
                        CreateStandingsView.routeName,
                      ),
                    ),
                    SizedBox(height: 16),

                    AppButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),

                      label: AppTextStrings.standings,
                      backgroundColor: AppColors.whiteColor,
                      textColor: AppColors.blackColor,
                      onButtonPressed: () =>
                          Navigator.pushNamed(context, StandingsView.routeName),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
