import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_back_button.dart';
import 'package:nextkick_admin/common/widgets/app_button.dart';
import 'package:nextkick_admin/common/widgets/app_loading_overlay.dart';
import 'package:nextkick_admin/common/widgets/app_toast/app_toast.dart';
import 'package:nextkick_admin/common/widgets/dark_background.dart';
import 'package:nextkick_admin/common/widgets/error_and_reload_widget.dart';
import 'package:nextkick_admin/common/widgets/field_and_validator.dart';
import 'package:nextkick_admin/common/widgets/shimmer_loading_overlay.dart';
import 'package:nextkick_admin/data/models/registered_team_model.dart';
import 'package:nextkick_admin/features/tournaments/bloc/tournament_bloc.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/constants/enums/shimmer_enum.dart';
import 'package:nextkick_admin/utilities/constants/enums/toast_enum.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';

class RegisteredTeamProfileView extends StatefulWidget {
  static const routeName = '/registered-team-profile';
  final String teamId;

  const RegisteredTeamProfileView({super.key, required this.teamId});

  @override
  State<RegisteredTeamProfileView> createState() =>
      _RegisteredTeamProfileViewState();
}

class _RegisteredTeamProfileViewState extends State<RegisteredTeamProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamLocationController = TextEditingController();
  final TextEditingController _noOfPlayersController = TextEditingController();
  final TextEditingController _tournamentNameController =
      TextEditingController();
  final TextEditingController _tournamentLocationController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    context.read<TournamentBloc>().add(
      FetchRegisteredTeamDetails(widget.teamId),
    );
  }

  void _populateControllers(RegisteredTeamModel team) {
    if (_controllersInitialized) return;
    debugPrint('📝 Populating controllers with registered team details');
    _teamNameController.text = team.teamName;
    _teamLocationController.text = team.teamLocation;
    _noOfPlayersController.text = team.numberOfPlayers;
    _tournamentNameController.text = team.tournamentTitle;
    _tournamentLocationController.text = team.tournamentLocation;
    _amountController.text = team.amount;
    setState(() {
      _controllersInitialized = true;
    });
    debugPrint('✅ Controllers populated successfully');
  }

  void updateRegisteredTeam() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<TournamentBloc>().add(
        UpdateRegisteredTeam(
          id: widget.teamId,
          teamName: _teamNameController.text.trim(),
          teamLocation: _teamLocationController.text.trim(),
          noOfPlayers: _noOfPlayersController.text.trim(),
          amount: _amountController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TournamentBloc, TournamentState>(
      listener: (context, teamState) {
        if (teamState is RegisteredTeamProfileFailure ||
            teamState is UpdateRegisteredTeamsFailure) {
          final message = teamState is RegisteredTeamProfileFailure
              ? teamState.error
              : (teamState as UpdateRegisteredTeamsFailure).error;
          AppToast.show(context, message: message, style: ToastStyle.error);
        }
        if (teamState is UpdateRegisteredTeamsSuccessful) {
          AppToast.show(
            context,
            message: 'Details updated successfully',
            style: ToastStyle.success,
          );
        }
        if (teamState is RegisteredTeamProfileSuccessful) {
          _populateControllers(teamState.team);
        }
      },
      builder: (context, teamState) {
        if (teamState is RegisteredTeamProfileLoading) {
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
        if (teamState is RegisteredTeamProfileFailure) {
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
              errorTitle: 'Drills not found',
              errorDetails: 'Refresh the page to try again.',
              labelText: 'Retry',
              buttonPressed: () => context.read<TournamentBloc>().add(
                FetchRegisteredTeamDetails(widget.teamId),
              ),
            ),
          );
        }
        final scaffoldContent = Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors.blackColor,

          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 80,
            toolbarHeight: 40,
            leading: AppBackButton(),
          ),
          body: DarkBackground(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // SizedBox(height: getScreenHeight(context, 0.1),),
                        Text(
                          AppTextStrings.detailsUpper,
                          style: context.textTheme.titleLarge?.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        FieldAndValidator(
                          fieldName: AppTextStrings.teamName,
                          textController: _teamNameController,
                          obscure: false,
                        ),
                        FieldAndValidator(
                          fieldName: AppTextStrings.teamLocation,
                          textController: _teamLocationController,
                          obscure: false,
                        ),
                        FieldAndValidator(
                          fieldName: AppTextStrings.numberOfPlayers,
                          textController: _noOfPlayersController,
                          obscure: false,
                        ),
                        AbsorbPointer(
                          child: FieldAndValidator(
                            fieldName: AppTextStrings.tournamentName,
                            textController: _tournamentNameController,
                            obscure: false,
                          ),
                        ),
                        AbsorbPointer(
                          child: FieldAndValidator(
                            fieldName: AppTextStrings.location,
                            textController: _tournamentLocationController,
                            obscure: false,
                          ),
                        ),
                        FieldAndValidator(
                          fieldName: AppTextStrings.amount,
                          textController: _amountController,
                          obscure: false,
                        ),

                        SizedBox(height: 30),
                        AppButton(
                          label: AppTextStrings.update,
                          backgroundColor: AppColors.whiteColor,
                          textColor: AppColors.blackColor,
                          onButtonPressed:
                              teamState is UpdateRegisteredTeamsLoading
                              ? null
                              : () => updateRegisteredTeam(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        if (teamState is UpdateRegisteredTeamsLoading) {
          return Stack(children: [scaffoldContent, AppLoadingOverlay()]);
        } else {
          return scaffoldContent;
        }
      },
    );
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _teamLocationController.dispose();
    _noOfPlayersController.dispose();
    _tournamentNameController.dispose();
    _tournamentLocationController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
