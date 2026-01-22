import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_bottom_modal.dart';
import 'package:nextkick_admin/common/widgets/app_text_form_field.dart';
import 'package:nextkick_admin/data/models/registered_team_model.dart';
import 'package:nextkick_admin/features/tournaments/bloc/tournament_bloc.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';

class RegisteredTeamBottomModal extends StatelessWidget {
  final TextEditingController textController;
  final String? Function(String?)? validator;
  final void Function(String teamnId) onTeamSelected;

  const RegisteredTeamBottomModal({
    super.key,
    required this.textController,
    this.validator,
    required this.onTeamSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTeamsModal(context),
      child: AbsorbPointer(
        child: AppTextFormField(
          hintText: AppTextStrings.team,
          textController: textController,
          obscure: false,
          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
          validator: validator,
        ),
      ),
    );
  }

  void _showTeamsModal(BuildContext context) {
    appBottomModal(
      context: context,
      child: _ProductTypeList(
        textController: textController,
        onTeamSelected: onTeamSelected,
      ),
    );
  }
}

class _ProductTypeList extends StatelessWidget {
  final TextEditingController textController;
  final void Function(String teamnId) onTeamSelected;

  const _ProductTypeList({
    required this.textController,
    required this.onTeamSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TournamentBloc, TournamentState>(
      builder: (context, state) {
        if (state is FetchRegisteredTeamsLoading) {
          return _buildTeamsShimmer();
        }
        if (state is FetchRegisteredTeamsFailure) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text(state.error)),
          );
        }
        if (state is FetchRegisteredTeamsSuccessful) {
          final teams = state.teams;
          if (teams.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text('No registered team available')),
            );
          }
          return _buildTeamsList(context, teams);
        }
        context.read<TournamentBloc>().add(
          FetchRegisteredTeams(forceRefresh: true),
        );
        return _buildTeamsShimmer();
      },
    );
  }

  Widget _buildTeamsList(
    BuildContext context,
    List<RegisteredTeamModel> teams,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        return ListTile(
          title: Text(
            team.teamName,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.boldTextColor),
          ),
          onTap: () {
            textController.text = team.teamName;
            onTeamSelected(team.teamId);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget _buildTeamsShimmer() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (_, index) {
        final delay = index * 300;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildShimmerBox(250, 30, delay)],
        );
      },
      separatorBuilder: (_, _) => SizedBox(height: 16),
      itemCount: 5,
    );
  }

  Widget _buildShimmerBox(
    double width,
    double height,
    int delay, {
    double radius = 4,
  }) {
    return FadeShimmer(
      width: width,
      height: height,
      radius: radius,
      millisecondsDelay: delay,
      fadeTheme: FadeTheme.light,
    );
  }
}
