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
import 'package:nextkick_admin/features/tournaments/bloc/tournament_bloc.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/constants/enums/shimmer_enum.dart';
import 'package:nextkick_admin/utilities/constants/enums/toast_enum.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';

class TournamentsListView extends StatefulWidget {
  static const routeName = '/tournaments-list-view';
  const TournamentsListView({super.key});

  @override
  State<TournamentsListView> createState() => _TournamentsListViewState();
}

class _TournamentsListViewState extends State<TournamentsListView> {
  @override
  void initState() {
    super.initState();
    context.read<TournamentBloc>().add(FetchTournament());
  }

  Future<void> _handleRefresh() async {
    final completer = Completer<void>();

    // Listen for the completion of the fetch operation
    final subscription = context.read<TournamentBloc>().stream.listen((state) {
      if (state is FetchTournamentsSuccessful ||
          state is FetchTournamentsFailure) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    // Trigger the refresh
    context.read<TournamentBloc>().add(FetchTournament());

    // Wait for completion
    await completer.future;

    // Clean up subscription
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TournamentBloc, TournamentState>(
      listener: (context, tournamentState) {
        if (tournamentState is FetchTournamentsFailure) {
          AppToast.show(
            context,
            message: tournamentState.error,
            style: ToastStyle.error,
          );
        }
      },
      builder: (context, tournamentState) {
        if (tournamentState is FetchTournamentsLoading) {
          Scaffold(
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
        if (tournamentState is FetchRegisteredTeamsFailure) {
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
              errorTitle: 'Unable to load tournaments',
              errorDetails: '',
              labelText: 'Retry',
              buttonPressed: () =>
                  context.read<TournamentBloc>().add(FetchTournament()),
            ),
          );
        }
        if (tournamentState is FetchTournamentsSuccessful) {
          final tournaments = tournamentState.tournaments;
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
                  physics: AlwaysScrollableScrollPhysics(),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(height: 16),

                          Text(
                            AppTextStrings.tournaments,
                            style: context.textTheme.titleLarge?.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                          SizedBox(height: 30),

                          if (tournaments.isEmpty)
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
                                      "No tournaments available",
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
                          // SizedBox(height: 16),
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder: (_, _) => SizedBox(height: 12),
                              itemCount: tournamentState.tournaments.length,
                              itemBuilder: (context, index) {
                                final tournament =
                                    tournamentState.tournaments[index];
                                return Material(
                                  color: Colors.transparent,
                                  child: ListTile(
                                    // onTap: () => Navigator.pushNamed(
                                    //   context,
                                    //   TeamProfileView.routeName,
                                    // ),
                                    tileColor: AppColors.whiteColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),

                                    title: Text(
                                      tournament.title!,
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
            leading: AppBackButton(),
          ),
          body: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: ShimmerLoadingOverlay(pageType: ShimmerEnum.registeredTeams),
          ),
        );
      },
    );
  }
}
