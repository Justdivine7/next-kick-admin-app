import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_back_button.dart';
import 'package:nextkick_admin/common/widgets/app_button.dart';
import 'package:nextkick_admin/common/widgets/app_text_form_field.dart';
import 'package:nextkick_admin/common/widgets/dark_background.dart';
import 'package:nextkick_admin/common/widgets/app_toast/app_toast.dart';
import 'package:nextkick_admin/common/widgets/pull_to_refresh.dart';
import 'package:nextkick_admin/common/widgets/shimmer_loading_overlay.dart';
import 'package:nextkick_admin/common/widgets/error_and_reload_widget.dart';
import 'package:nextkick_admin/data/models/player_model.dart';
import 'package:nextkick_admin/features/dashboard/bloc/player/player_bloc.dart';
import 'package:nextkick_admin/features/dashboard/view/widgets/user_card.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/constants/enums/shimmer_enum.dart';
import 'package:nextkick_admin/utilities/constants/enums/toast_enum.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';

class ManagePlayerView extends StatefulWidget {
  static const routeName = '/manage-player';
  const ManagePlayerView({super.key});

  @override
  State<ManagePlayerView> createState() => _ManagePlayerViewState();
}

class _ManagePlayerViewState extends State<ManagePlayerView> {
  final TextEditingController _searchController = TextEditingController();

  // Replace selected values with ValueNotifiers
  final ValueNotifier<String?> selectedPosition = ValueNotifier(null);
  final ValueNotifier<String?> selectedLevel = ValueNotifier(null);
  final ValueNotifier<String?> selectedLocation = ValueNotifier(null);

  final positions = ['forward', 'midfielder', 'defender', 'goalkeeper'];
  final levels = ['beginner', 'intermediate', 'professional'];
  final locations = [
    'Lagos',
    'Abuja',
    'Port Harcourt',
    'Ekiti',
    'Akure',
    'Abuja',
  ];

  @override
  void initState() {
    super.initState();
    context.read<PlayerBloc>().add(const FetchPlayersEvent(userType: 'player'));
  }

  Future<void> _handleRefresh() async {
    final completer = Completer<void>();
    final subscription = context.read<PlayerBloc>().stream.listen((state) {
      if (state is PlayerLoaded || state is PlayerError) {
        if (!completer.isCompleted) completer.complete();
      }
    });

    context.read<PlayerBloc>().add(
      const FetchPlayersEvent(userType: 'player', forceRefresh: true),
    );

    await completer.future;
    subscription.cancel();
  }

  void _onSearch() {
    final query = _searchController.text.trim().toLowerCase();

    context.read<PlayerBloc>().add(
      FetchPlayersEvent(
        userType: 'player',
        fullName: query.isNotEmpty ? query : null,
        playerPosition: selectedPosition.value,
        location: selectedLocation.value,
        level: selectedLevel.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayerBloc, PlayerState>(
      buildWhen: (previous, current) =>
          current is PlayerLoading ||
          current is PlayerLoaded ||
          current is PlayerError,
      listener: (context, playerState) {
        if (playerState is PlayerError) {
          AppToast.show(
            context,
            message: playerState.error,
            style: ToastStyle.error,
          );
        }
      },
      builder: (context, playerState) {
        if (playerState is PlayerLoading) {
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

        if (playerState is PlayerLoaded) {
          final players = playerState.players;

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
                            AppTextStrings.searchPlayer,
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

                          /// Filters using ValueListenableBuilder
                          ValueListenableBuilder<String?>(
                            valueListenable: selectedPosition,
                            builder: (_, value, __) => _buildDropdown(
                              'Select Position',
                              positions,
                              value,
                              (val) => selectedPosition.value = val,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ValueListenableBuilder<String?>(
                            valueListenable: selectedLevel,
                            builder: (_, value, __) => _buildDropdown(
                              'Select Level',
                              levels,
                              value,
                              (val) => selectedLevel.value = val,
                            ),
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
                          if (players.isEmpty)
                            Center(
                              child: Text(
                                'No players found',
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
                              itemCount: players.length,
                              itemBuilder: (context, index) {
                                final player = players[index];
                                return EntityCard<PlayerModel>(
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

        if (playerState is PlayerError) {
          return Scaffold(
            backgroundColor: AppColors.blackColor,
            appBar: _appBar(),
            body: ErrorAndReloadWidget(
              errorTitle: 'Unable to load players',
              errorDetails: 'Check your internet connection and try again',
              labelText: 'Retry',
              buttonPressed: () => context.read<PlayerBloc>().add(
                const FetchPlayersEvent(userType: 'player', forceRefresh: true),
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
    selectedPosition.dispose();
    selectedLevel.dispose();
    selectedLocation.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
