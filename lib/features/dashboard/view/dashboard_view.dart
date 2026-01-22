import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_button.dart';
import 'package:nextkick_admin/common/widgets/dark_background.dart';
import 'package:nextkick_admin/common/widgets/exit_alert.dart';
import 'package:nextkick_admin/common/widgets/pull_to_refresh.dart';
import 'package:nextkick_admin/data/dependencies/dependencies_injector.dart';
import 'package:nextkick_admin/data/local_storage/app_local_storage_service.dart';
import 'package:nextkick_admin/features/auth/view/login_view.dart';
import 'package:nextkick_admin/features/dashboard/bloc/player/player_bloc.dart';
import 'package:nextkick_admin/features/dashboard/bloc/team/team_bloc.dart';
import 'package:nextkick_admin/features/drills/view/drill_submissions.dart';
import 'package:nextkick_admin/features/notifications/view/create_notifications_view.dart';
import 'package:nextkick_admin/features/player/view/manage_player_view.dart';
import 'package:nextkick_admin/features/team/view/manage_team_view.dart';
import 'package:nextkick_admin/features/tournaments/view/tournaments_dashboard.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';

class DashboardView extends StatefulWidget {
  static const routeName = '/dashboard';
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  // Cache the last known counts
  int? _cachedPlayerCount;
  int? _cachedTeamCount;

  void _logout() async {
    await getIt<AppLocalStorageService>().completeLogout();
  }

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  Future<void> _handleRefresh() async {
    // Trigger the refresh
    context.read<PlayerBloc>().add(FetchPlayersCount(forceRefresh: true));
    context.read<TeamBloc>().add(FetchTeamCount(forceRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => ExitAlert(),
        );

        if (shouldExit == true) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.blackColor,
        body: DarkBackground(
          child: Center(
            child: PullToRefresh(
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(height: 60),
                      Text(
                        AppTextStrings.admin,
                        style: context.textTheme.displayLarge?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                AppTextStrings.players,
                                style: context.textTheme.titleLarge?.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              BlocBuilder<PlayerBloc, PlayerState>(
                                builder: (context, state) {
                                  if (state is FetchPlayersCountLoading) {
                                    return CircularProgressIndicator.adaptive(
                                      backgroundColor: AppColors.whiteColor,
                                    );
                                  } else if (state is FetchPlayersCountLoaded) {
                                    // Cache the count when loaded
                                    _cachedPlayerCount = state.count;
                                    return Text(
                                      '[${state.count}]',
                                      style: context.textTheme.displayMedium
                                          ?.copyWith(
                                            color: AppColors.whiteColor,
                                          ),
                                    );
                                  } else if (state is FetchPlayersCountError) {
                                    return Text(
                                      'Error',
                                      style: context.textTheme.displayMedium
                                          ?.copyWith(
                                            color: AppColors.pastelRed,
                                          ),
                                    );
                                  }
                                  // Show cached count if available
                                  return Text(
                                    '[${_cachedPlayerCount ?? 0}]',
                                    style: context.textTheme.displayMedium
                                        ?.copyWith(color: AppColors.whiteColor),
                                  );
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                AppTextStrings.teams,
                                style: context.textTheme.titleLarge?.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              BlocBuilder<TeamBloc, TeamState>(
                                builder: (context, state) {
                                  if (state is FetchTeamsCountLoading) {
                                    return CircularProgressIndicator.adaptive(
                                      backgroundColor: AppColors.whiteColor,
                                    );
                                  } else if (state is FetchTeamsCountLoaded) {
                                    // Cache the count when loaded
                                    _cachedTeamCount = state.count;
                                    return Text(
                                      '[${state.count}]',
                                      style: context.textTheme.displayMedium
                                          ?.copyWith(
                                            color: AppColors.whiteColor,
                                          ),
                                    );
                                  } else if (state is FetchTeamsCountError) {
                                    return Text(
                                      'Error',
                                      style: context.textTheme.displayMedium
                                          ?.copyWith(
                                            color: AppColors.pastelRed,
                                          ),
                                    );
                                  }
                                  // Show cached count if available
                                  return Text(
                                    '[${_cachedTeamCount ?? 0}]',
                                    style: context.textTheme.displayMedium
                                        ?.copyWith(color: AppColors.whiteColor),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 20,
                              ),
                              label: AppTextStrings.managePlayers,
                              backgroundColor: AppColors.whiteColor,
                              textColor: AppColors.blackColor,
                              onButtonPressed: () => Navigator.pushNamed(
                                context,
                                ManagePlayerView.routeName,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: AppButton(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 20,
                              ),
                              label: AppTextStrings.manageTeams,
                              backgroundColor: AppColors.whiteColor,
                              textColor: AppColors.blackColor,
                              onButtonPressed: () => Navigator.pushNamed(
                                context,
                                ManageTeamView.routeName,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      AppButton(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        label: AppTextStrings.manageTournaments,
                        backgroundColor: AppColors.whiteColor,
                        textColor: AppColors.blackColor,
                        onButtonPressed: () => Navigator.pushNamed(
                          context,
                          TournamentsDashboard.routeName,
                        ),
                      ),
                      SizedBox(height: 24),
                      AppButton(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        label: AppTextStrings.notification,
                        backgroundColor: AppColors.whiteColor,
                        textColor: AppColors.blackColor,
                        onButtonPressed: () => Navigator.pushNamed(
                          context,
                          CreateNotificationsView.routeName,
                        ),
                      ),
                      SizedBox(height: 24),
                      AppButton(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        label: AppTextStrings.drillSubmissions,
                        backgroundColor: AppColors.whiteColor,
                        textColor: AppColors.blackColor,
                        onButtonPressed: () => Navigator.pushNamed(
                          context,
                          DrillSubmissions.routeName,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            color: AppColors.blackColor,
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
            height: 60,
            child: AppButton(
              label: AppTextStrings.logout,
              backgroundColor: AppColors.whiteColor,
              textColor: AppColors.blackColor,
              onButtonPressed: () {
                _logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginView.routeName,
                  (Route<dynamic> route) => false,
                );
                Navigator.pushReplacementNamed(context, LoginView.routeName);
              },
            ),
          ),
        ),
      ),
    );
  }
}
