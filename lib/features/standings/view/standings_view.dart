import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_back_button.dart';
import 'package:nextkick_admin/common/widgets/app_toast/app_toast.dart';
import 'package:nextkick_admin/common/widgets/dark_background.dart';
import 'package:nextkick_admin/common/widgets/error_and_reload_widget.dart';
import 'package:nextkick_admin/common/widgets/pull_to_refresh.dart';
import 'package:nextkick_admin/common/widgets/shimmer_loading_overlay.dart';
import 'package:nextkick_admin/features/standings/bloc/standings_bloc.dart';
import 'package:nextkick_admin/features/standings/view/update_team_standing_view.dart';
import 'package:nextkick_admin/utilities/constants/enums/shimmer_enum.dart';
import 'package:nextkick_admin/utilities/constants/enums/toast_enum.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';
import 'package:nextkick_admin/utilities/helpers/ui_helpers.dart';

class StandingsView extends StatefulWidget {
  static const routeName = '/standings-view';
  const StandingsView({super.key});

  @override
  State<StandingsView> createState() => _StandingsViewState();
}

class _StandingsViewState extends State<StandingsView> {
  @override
  void initState() {
    super.initState();
    context.read<StandingsBloc>().add(FetchStandings(forceRefresh: true));
  }

  Future<void> _handleRefresh() async {
    final completer = Completer<void>();

    // Listen for the completion of the fetch operation
    final subscription = context.read<StandingsBloc>().stream.listen((state) {
      if (state is FetchStandingsSuccessful || state is FetchStandingsError) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    // Trigger the refresh
    context.read<StandingsBloc>().add(FetchStandings(forceRefresh: true));

    // Wait for completion
    await completer.future;

    // Clean up subscription
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StandingsBloc, StandingsState>(
      buildWhen: (previous, current) {
        return current is FetchStandingsError ||
            current is FetchStandingsLoading ||
            current is FetchStandingsSuccessful;
      },
      listener: (context, standingState) {
        if (standingState is FetchStandingsError) {
          AppToast.show(
            context,
            message: standingState.error,
            style: ToastStyle.error,
          );
        }
      },
      builder: (context, standingState) {
        if (standingState is FetchStandingsLoading) {
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
              
              physics: NeverScrollableScrollPhysics(),
              child: ShimmerLoadingOverlay(
                pageType: ShimmerEnum.registeredTeams,
              ),
            ),
          );
        }

        if (standingState is FetchStandingsSuccessful) {
          final standings = standingState.standings;

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
                onRefresh: _handleRefresh,
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(16),
                      child: Column(
                        children: [
                          SizedBox(height: getScreenHeight(context, 0.05)),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Team',
                                  style: context.textTheme.displayMedium
                                      ?.copyWith(color: AppColors.whiteColor),
                                ),
                              ),
                              Text(
                                'Points',
                                style: context.textTheme.displayMedium
                                    ?.copyWith(color: AppColors.whiteColor),
                              ),
                            ],
                          ),
                          if (standings.isEmpty)
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
                                      "No standing available",
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
                            SizedBox(height: getScreenHeight(context, 0.02)),
                          ListView.separated(
                            separatorBuilder: (_, _) => SizedBox(height: 16),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: standings.length, // Example count
                            itemBuilder: (context, index) {
                              final standing = standings[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    UpdateTeamStandingView.routeName,
                                    arguments: standing,
                                  );
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        standing.team.capitalizeFirstLetter(),
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(
                                              color: AppColors.whiteColor,
                                            ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      standing.points.toString(),
                                      style: context.textTheme.titleMedium
                                          ?.copyWith(
                                            color: AppColors.whiteColor,
                                          ),
                                    ),
                                  ],
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
        if (standingState is FetchStandingsError) {
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
              errorTitle: 'Unable to load standings',
              errorDetails: 'Check your internet connection and try again',
              labelText: 'Retry',
              buttonPressed: () => context.read<StandingsBloc>().add(
                FetchStandings(forceRefresh: true),
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
          body: ShimmerLoadingOverlay(pageType: ShimmerEnum.registeredTeams),
        );
      },
    );
  }
}
