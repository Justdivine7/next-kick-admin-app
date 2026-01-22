import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_back_button.dart';
import 'package:nextkick_admin/common/widgets/app_toast/app_toast.dart';
import 'package:nextkick_admin/common/widgets/ball_widget.dart';
import 'package:nextkick_admin/common/widgets/dark_background.dart';
import 'package:nextkick_admin/common/widgets/error_and_reload_widget.dart';
import 'package:nextkick_admin/common/widgets/pull_to_refresh.dart';
import 'package:nextkick_admin/common/widgets/shimmer_loading_overlay.dart';
import 'package:nextkick_admin/features/fixtures/bloc/fixtures_bloc.dart';
import 'package:nextkick_admin/features/fixtures/views/update_fixture_view.dart';
import 'package:nextkick_admin/features/fixtures/views/widget/team_card.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/constants/enums/shimmer_enum.dart';
import 'package:nextkick_admin/utilities/constants/enums/toast_enum.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';

class FixturesListView extends StatefulWidget {
  static const routeName = '/fixtures-list-view';
  const FixturesListView({super.key});

  @override
  State<FixturesListView> createState() => _FixturesListViewState();
}

class _FixturesListViewState extends State<FixturesListView> {
  @override
  void initState() {
    super.initState();
    context.read<FixturesBloc>().add(FetchFixtures(forceRefresh: true));
  }

  Future<void> _handleRefresh() async {
    final completer = Completer<void>();

    // Listen for the completion of the fetch operation
    final subscription = context.read<FixturesBloc>().stream.listen((state) {
      if (state is FetchFixturesSuccessful || state is FetchFixturesError) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    // Trigger the refresh
    context.read<FixturesBloc>().add(FetchFixtures(forceRefresh: true));

    // Wait for completion
    await completer.future;

    // Clean up subscription
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FixturesBloc, FixturesState>(
      buildWhen: (previous, current) {
        return current is FetchFixturesError ||
            current is FetchFixturesLoading ||
            current is FetchFixturesSuccessful;
      },
      listener: (context, fixtureState) {
        if (fixtureState is FetchFixturesError) {
          AppToast.show(
            context,
            message: fixtureState.error,
            style: ToastStyle.error,
          );
        }
      },
      builder: (context, fixtureState) {
        if (fixtureState is FetchFixturesLoading) {
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
        if (fixtureState is FetchFixturesSuccessful) {
          final fixtures = fixtureState.fixture;

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
                      padding: EdgeInsetsGeometry.all(16),
                      child: Column(
                        children: [
                          SizedBox(height: 16),

                          Text(
                            AppTextStrings.fixtures,
                            style: context.textTheme.titleLarge?.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                          SizedBox(height: 24),
                          if (fixtures.isEmpty)
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
                                      "No fixtures available",
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
                              itemCount: fixtureState.fixture.length,
                              itemBuilder: (context, index) {
                                final fixture = fixtureState.fixture[index];
                                return GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    UpdateFixtureView.routeName,
                                    arguments: fixture.id,
                                  ),
                                  child: Row(
                                    children: [
                                      TeamCard(fixture: fixture),
                                      SizedBox(width: 8),
                                      BallWidget(),
                                      SizedBox(width: 8),

                                      Expanded(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: ListTile(
                                            leading: Text(
                                              fixture.teamTwoScore.toString(),
                                              style: context
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: AppColors.blackColor,
                                                  ),
                                            ),
                                            tileColor: AppColors.whiteColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),

                                            title: Text(
                                              fixture.teamTwoName
                                                  .capitalizeFirstLetter(),
                                              style: context
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color:
                                                        AppColors.boldTextColor,
                                                  ),
                                            ),
                                          ),
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
        if (fixtureState is FetchFixturesError) {
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
              errorTitle: 'Unable to load fixtures',
              errorDetails: 'Check your internet connection and try again',
              labelText: 'Retry',
              buttonPressed: () => context.read<FixturesBloc>().add(
                FetchFixtures(forceRefresh: true),
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
