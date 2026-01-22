import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_back_button.dart';
import 'package:nextkick_admin/common/widgets/app_button.dart';
import 'package:nextkick_admin/common/widgets/app_text_form_field.dart';
import 'package:nextkick_admin/common/widgets/app_toast/app_toast.dart';
import 'package:nextkick_admin/common/widgets/dark_background.dart';
import 'package:nextkick_admin/common/widgets/error_and_reload_widget.dart';
import 'package:nextkick_admin/common/widgets/pull_to_refresh.dart';
import 'package:nextkick_admin/common/widgets/shimmer_loading_overlay.dart';
import 'package:nextkick_admin/data/models/team_model.dart';
import 'package:nextkick_admin/features/dashboard/bloc/team/team_bloc.dart';
import 'package:nextkick_admin/features/dashboard/view/widgets/user_card.dart';
import 'package:nextkick_admin/features/team/widgets/nigerian_state_list.dart';

import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/constants/enums/shimmer_enum.dart';
import 'package:nextkick_admin/utilities/constants/enums/toast_enum.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';

class ManageTeamView extends StatefulWidget {
  static const routeName = '/manage-team';
  const ManageTeamView({super.key});

  @override
  State<ManageTeamView> createState() => _ManageTeamViewState();
}

class _ManageTeamViewState extends State<ManageTeamView> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String?> selectedLocation = ValueNotifier(null);
  final locations = nigeriaStates;

  @override
  void initState() {
    super.initState();
    context.read<TeamBloc>().add(const FetchTeamsEvent(userType: 'team'));
  }

  Future<void> _handleRefresh() async {
    final completer = Completer<void>();
    final subscription = context.read<TeamBloc>().stream.listen((state) {
      if (state is TeamLoaded || state is TeamError) {
        if (!completer.isCompleted) completer.complete();
      }
    });

    context.read<TeamBloc>().add(
      const FetchTeamsEvent(userType: 'team', forceRefresh: true),
    );

    await completer.future;
    subscription.cancel();
  }

  void _onSearch() {
    final query = _searchController.text.trim();

    context.read<TeamBloc>().add(
      FetchTeamsEvent(
        userType: 'team',
        teamName: query.isNotEmpty ? query : null,
        location: selectedLocation.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeamBloc, TeamState>(
      buildWhen: (previous, current) =>
          current is TeamLoading ||
          current is TeamLoaded ||
          current is TeamError,
      listener: (context, teamState) {
        if (teamState is TeamError) {
          AppToast.show(
            context,
            message: teamState.error,
            style: ToastStyle.error,
          );
        }
      },
      builder: (context, teamState) {
        if (teamState is TeamLoading) {
          return Scaffold(
            backgroundColor: AppColors.blackColor,
            appBar: _appBar(),
            body: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: const ShimmerLoadingOverlay(
                pageType: ShimmerEnum.registeredTeams,
              ),
            ),
          );
        }

        if (teamState is TeamLoaded) {
          final teams = teamState.teams;

          return Scaffold(
            backgroundColor: AppColors.blackColor,
            appBar: _appBar(),
            body: DarkBackground(
              child: PullToRefresh(
                onRefresh: _handleRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            AppTextStrings.searchTeam,
                            style: context.textTheme.titleLarge?.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                          const SizedBox(height: 16),

                          /// Search field
                          AppTextFormField(
                            hintText: 'Search by name',
                            textController: _searchController,
                            obscure: false,
                          ),
                          const SizedBox(height: 12),

                          ValueListenableBuilder<String?>(
                            valueListenable: selectedLocation,
                            builder: (_, value, __) => _buildDropdown(
                              'Select Location',
                              locations,
                              value,
                              (val) => selectedLocation.value = val,
                            ),
                          ),
                          const SizedBox(height: 20),

                          /// Search button
                          AppButton(
                            label: AppTextStrings.search,
                            backgroundColor: AppColors.whiteColor,
                            textColor: AppColors.blackColor,
                            onButtonPressed: _onSearch,
                          ),
                          const SizedBox(height: 30),

                          /// Results
                          if (teams.isEmpty)
                            Center(
                              child: Text(
                                'No team found',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.whiteColor.withOpacity(0.8),
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemCount: teams.length,
                              itemBuilder: (context, index) {
                                final player = teams[index];
                                return EntityCard<TeamModel>(
                                  entity: player,
                                  onTap: () {},
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

        if (teamState is TeamError) {
          return Scaffold(
            backgroundColor: AppColors.blackColor,
            appBar: _appBar(),
            body: ErrorAndReloadWidget(
              errorTitle: 'Unable to load teams',
              errorDetails: 'Check your internet connection and try again',
              labelText: 'Retry',
              buttonPressed: () => context.read<TeamBloc>().add(
                const FetchTeamsEvent(userType: 'team', forceRefresh: true),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.blackColor,
          appBar: _appBar(),
          body: const ShimmerLoadingOverlay(
            pageType: ShimmerEnum.registeredTeams,
          ),
        );
      },
    );
  }

  PreferredSizeWidget _appBar() => AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leadingWidth: 80,
    toolbarHeight: 40,
    leading: const AppBackButton(),
  );

  Widget _buildDropdown(
    String hint,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: selectedValue,
      dropdownColor: AppColors.whiteColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.whiteColor,
        labelStyle: context.textTheme.bodyMedium?.copyWith(
          color: AppColors.subTextcolor,
        ),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      hint: Text(
        hint,
        style: context.textTheme.bodyMedium?.copyWith(
          color: AppColors.subTextcolor,
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.blackColor,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  void dispose() {
    selectedLocation.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
