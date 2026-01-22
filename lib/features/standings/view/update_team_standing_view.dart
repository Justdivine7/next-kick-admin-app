import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_back_button.dart';
import 'package:nextkick_admin/common/widgets/app_button.dart';
import 'package:nextkick_admin/common/widgets/app_loading_overlay.dart';
import 'package:nextkick_admin/common/widgets/app_text_form_field.dart';
import 'package:nextkick_admin/common/widgets/app_toast/app_toast.dart';
import 'package:nextkick_admin/common/widgets/dark_background.dart';
import 'package:nextkick_admin/common/widgets/error_and_reload_widget.dart';
import 'package:nextkick_admin/common/widgets/shimmer_loading_overlay.dart';
import 'package:nextkick_admin/data/models/standing_model.dart';
import 'package:nextkick_admin/features/standings/bloc/standings_bloc.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/constants/enums/shimmer_enum.dart';
import 'package:nextkick_admin/utilities/constants/enums/toast_enum.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';
import 'package:nextkick_admin/utilities/helpers/ui_helpers.dart';

class UpdateTeamStandingView extends StatefulWidget {
  final StandingModel standing;
  static const routeName = 'update-standing';
  const UpdateTeamStandingView({super.key, required this.standing});

  @override
  State<UpdateTeamStandingView> createState() => _UpdateTeamStandingViewState();
}

class _UpdateTeamStandingViewState extends State<UpdateTeamStandingView> {
  final TextEditingController _pointController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    context.read<StandingsBloc>().add(
      FetchStandingDetails(forceRefresh: true, standingId: widget.standing.id),
    );
  }

  void _updateStanding() async {
    if (_pointController.text.isEmpty) {
      return AppToast.show(
        context,
        message: 'point cannot be empty',
        style: ToastStyle.warning,
      );
    }
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<StandingsBloc>().add(
        UpdateStanding(
          point: int.parse(_pointController.text.trim()),
          teamId: widget.standing.id,
        ),
      );
    }
  }

  void _populateControllers(StandingModel standing) {
    if (_controllersInitialized) return;
    _pointController.text = standing.points.toString();

    setState(() {
      _controllersInitialized = true;
    });
    debugPrint('✅ Controllers populated successfully');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StandingsBloc, StandingsState>(
      listener: (context, standingState) {
        if (standingState is FetchStandingDetailsError ||
            standingState is UpdateStandingsError) {
          final error = standingState is FetchStandingDetailsError
              ? standingState.error
              : (standingState as UpdateStandingsError).error;
          AppToast.show(context, message: error, style: ToastStyle.error);
        }
        if (standingState is UpdateStandingsSuccessful) {
          _populateControllers(standingState.standing);
          AppToast.show(
            context,
            message: 'Update successful',
            style: ToastStyle.success,
          );
          context.read<StandingsBloc>().add(FetchStandings(forceRefresh: true));
          Future.delayed(const Duration(milliseconds: 300), () {
            Navigator.pop(context);
          });
        }
        if (standingState is FetchStandingDetailsSuccessful) {
          _populateControllers(standingState.standings);
        }
      },
      builder: (context, standingState) {
        if (standingState is FetchStandingDetailsLoading) {
          return Scaffold(
            backgroundColor: AppColors.blackColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80,
              toolbarHeight: 40,
              leading: AppBackButton(),
            ),
            body: ShimmerLoadingOverlay(pageType: ShimmerEnum.registeredTeams),
          );
        }
        if (standingState is FetchStandingDetailsError) {
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
              errorTitle: 'Standing not found',
              errorDetails: 'Refresh the page to try again.',
              labelText: 'Retry',
              buttonPressed: () => context.read<StandingsBloc>().add(
                FetchStandingDetails(
                  standingId: widget.standing.id,
                  forceRefresh: true,
                ),
              ),
            ),
          );
        }
        final scaffoldContent = Scaffold(
          backgroundColor: AppColors.blackColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 80,
            toolbarHeight: 40,
            leading: const AppBackButton(),
          ),
          body: DarkBackground(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),

                        Center(
                          child: Text(
                            AppTextStrings.updateStanding,
                            style: context.textTheme.titleLarge?.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          widget.standing.team.capitalizeFirstLetter(),
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: AppColors.appBGColor,
                          ),
                        ),
                        SizedBox(height: 10),

                        AppTextFormField(
                          hintText: '',
                          textController: _pointController,
                          obscure: false,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              validateField(value: value, fieldName: 'point'),
                        ),

                        SizedBox(height: 24),

                        AppButton(
                          label: AppTextStrings.update,
                          backgroundColor: AppColors.whiteColor,
                          textColor: AppColors.blackColor,
                          onButtonPressed: () => _updateStanding(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        if (standingState is UpdateStandingsLoading) {
          return Stack(children: [scaffoldContent, AppLoadingOverlay()]);
        } else {
          return scaffoldContent;
        }
      },
    );
  }

  @override
  void dispose() {
    _pointController.dispose();
    super.dispose();
  }
}
