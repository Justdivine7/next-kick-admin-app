import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_back_button.dart';
import 'package:nextkick_admin/common/widgets/dark_background.dart';
import 'package:nextkick_admin/common/widgets/error_and_reload_widget.dart';
import 'package:nextkick_admin/common/widgets/pull_to_refresh.dart';
import 'package:nextkick_admin/common/widgets/shimmer_loading_overlay.dart';
import 'package:nextkick_admin/features/registered_teams/view/registered_team_profile_view.dart';
import 'package:nextkick_admin/features/tournaments/bloc/tournament_bloc.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/constants/enums/shimmer_enum.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';

class RegisteredTeamsView extends StatefulWidget {
  static const routeName = '/registered-teams-view';
  const RegisteredTeamsView({super.key});

  @override
  State<RegisteredTeamsView> createState() => _RegisteredTeamsViewState();
}

class _RegisteredTeamsViewState extends State<RegisteredTeamsView> {
  @override
  void initState() {
    super.initState();
    context.read<TournamentBloc>().add(
      FetchRegisteredTeams(forceRefresh: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TournamentBloc, TournamentState>(
      buildWhen: (previous, current) {
        return current is FetchRegisteredTeamsLoading ||
            current is FetchRegisteredTeamsSuccessful ||
            current is FetchRegisteredTeamsFailure;
      },
      builder: (context, registeredState) {
        if (registeredState is FetchRegisteredTeamsLoading) {
          return Scaffold(
            backgroundColor: AppColors.blackColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80,
              toolbarHeight: 40,
              leading: AppBackButton(),
            ),
            body: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: ShimmerLoadingOverlay(
                pageType: ShimmerEnum.registeredTeams,
              ),
            ),
          );
        }
        if (registeredState is FetchRegisteredTeamsSuccessful) {
          final registeredTeams = registeredState.teams;
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
              child: PullToRefresh(
                onRefresh: () async {
                  context.read<TournamentBloc>().add(
                    FetchRegisteredTeams(forceRefresh: true),
                  );
                },

                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(16),
                      child: Column(
                        children: [
                          SizedBox(height: 16),

                          Text(
                            AppTextStrings.registeredTeams,
                            style: context.textTheme.titleLarge?.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                          SizedBox(height: 16),
                          if (registeredTeams.isEmpty)
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.emoji_events_outlined,
                                      color: AppColors.whiteColor.withOpacity(
                                        0.6,
                                      ),
                                      size: 64,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "No Registered teams ",
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: AppColors.whiteColor
                                                .withOpacity(0.8),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder: (_, _) => SizedBox(height: 12),
                              itemCount: registeredTeams.length,
                              itemBuilder: (context, index) {
                                final team = registeredTeams[index];
                                return Material(
                                  color: Colors.transparent,
                                  child: ListTile(
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      RegisteredTeamProfileView.routeName,
                                      arguments: {'teamId': team.id},
                                    ),
                                    tileColor: AppColors.whiteColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),

                                    title: Text(
                                      team.teamName.capitalizeFirstLetter(),
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: AppColors.boldTextColor,
                                          ),
                                    ),
                                  ),
                                );
                              },
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
        return Scaffold(
          backgroundColor: AppColors.blackColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 80,
            toolbarHeight: 40,
            leading: const AppBackButton(),
          ),
          body: ErrorAndReloadWidget(
            errorTitle: 'Unable to load registered teams',
            errorDetails: '',
            labelText: 'Retry',
            buttonPressed: () => context.read<TournamentBloc>().add(
              FetchRegisteredTeams(forceRefresh: true),
            ),
          ),
        );
      },
    );
  }
}
