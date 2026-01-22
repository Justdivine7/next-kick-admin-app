import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_back_button.dart';
import 'package:nextkick_admin/common/widgets/app_button.dart';
import 'package:nextkick_admin/common/widgets/app_loading_overlay.dart';
import 'package:nextkick_admin/common/widgets/app_toast/app_toast.dart';
import 'package:nextkick_admin/common/widgets/ball_widget.dart';
import 'package:nextkick_admin/common/widgets/dark_background.dart';
import 'package:nextkick_admin/common/widgets/date_picker.dart';
import 'package:nextkick_admin/common/widgets/error_and_reload_widget.dart';
import 'package:nextkick_admin/common/widgets/field_and_validator.dart';
import 'package:nextkick_admin/common/widgets/shimmer_loading_overlay.dart';
import 'package:nextkick_admin/common/widgets/time_picker.dart';
import 'package:nextkick_admin/data/models/fixture_model.dart';
import 'package:nextkick_admin/features/fixtures/bloc/fixtures_bloc.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/constants/enums/shimmer_enum.dart';
import 'package:nextkick_admin/utilities/constants/enums/toast_enum.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';
import 'package:nextkick_admin/utilities/helpers/ui_helpers.dart';

class UpdateFixtureView extends StatefulWidget {
  final String fixtureId;
  static const routeName = '/update-fixture';
  const UpdateFixtureView({super.key, required this.fixtureId});

  @override
  State<UpdateFixtureView> createState() => _UpdateFixtureViewState();
}

class _UpdateFixtureViewState extends State<UpdateFixtureView> {
  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _firstTeamController = TextEditingController();

  final TextEditingController _secondTeamController = TextEditingController();
  final TextEditingController _firstTeamScoreController =
      TextEditingController();

  final TextEditingController _secondTeamScoreController =
      TextEditingController();

  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    context.read<FixturesBloc>().add(
      FetchSelectedFixture(fixtureId: widget.fixtureId),
    );
  }

  void _updateFixture() async {
    if (_dateController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _venueController.text.isEmpty ||
        _statusController.text.isEmpty ||
        _firstTeamController.text.isEmpty ||
        _secondTeamController.text.isEmpty ||
        _firstTeamScoreController.text.isEmpty ||
        _secondTeamScoreController.text.isEmpty) {
      return AppToast.show(
        context,
        message: 'no field can be empty',
        style: ToastStyle.warning,
      );
    }
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<FixturesBloc>().add(
        UpdateSelectedFixture(
          fixtureId: widget.fixtureId,
          matchDate: _dateController.text.trim(),
          matchTime: _timeController.text.trim(),
          venue: _venueController.text.trim(),
          status: _statusController.text.trim(),
          teamOneScore: int.parse(_firstTeamScoreController.text.trim()),
          teamTwoScore: int.parse(_secondTeamScoreController.text.trim()),
        ),
      );
    }
  }

  void _deleteFixture() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<FixturesBloc>().add(
        DeleteSelectedFixture(fixtureId: widget.fixtureId),
      );
    }
  }

  void _populateControllers(FixtureModel fixture) {
    if (_controllersInitialized) return;
    _dateController.text = fixture.matchDate;
    _timeController.text = fixture.matchTime;
    _venueController.text = fixture.venue;
    _statusController.text = fixture.status;
    _firstTeamController.text = fixture.teamOneName;
    _secondTeamController.text = fixture.teamTwoName;
    _firstTeamScoreController.text = fixture.teamOneScore.toString();
    _secondTeamScoreController.text = fixture.teamTwoScore.toString();
    setState(() {
      _controllersInitialized = true;
    });
    debugPrint('✅ Controllers populated successfully');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FixturesBloc, FixturesState>(
      listener: (context, fixtureState) {
        if (fixtureState is FetchFixturesError ||
            fixtureState is UpdateSelectedFixtureError ||
            fixtureState is DeleteSelectedFixtureError) {
          final message = fixtureState is FetchFixturesError
              ? fixtureState.error
              : fixtureState is UpdateSelectedFixtureError
              ? (fixtureState).error
              : (fixtureState as DeleteSelectedFixtureError).error;
          AppToast.show(context, message: message, style: ToastStyle.error);
        }
        if (fixtureState is DeleteSelectedFixtureSuccesful) {
          AppToast.show(
            context,
            message: fixtureState.message,
            style: ToastStyle.success,
          );
          context.read<FixturesBloc>().add(FetchFixtures(forceRefresh: true));

          Future.delayed(const Duration(milliseconds: 300), () {
            Navigator.pop(context);
          });
        }
        if (fixtureState is UpdateSelectedFixtureSuccesful) {
          _populateControllers(fixtureState.fixture);

          AppToast.show(
            context,
            message: 'Update successful',
            style: ToastStyle.success,
          );
          context.read<FixturesBloc>().add(FetchFixtures(forceRefresh: true));

          Future.delayed(const Duration(milliseconds: 300), () {
            Navigator.pop(context);
          });
        }
        if (fixtureState is FetchSelectedFixtureSuccessful) {
          _populateControllers(fixtureState.fixture);
        }
      },
      builder: (context, fixtureState) {
        if (fixtureState is FetchSelectedFixtureLoading) {
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
        if (fixtureState is FetchSelectedFixtureError) {
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
              buttonPressed: () => context.read<FixturesBloc>().add(
                FetchSelectedFixture(fixtureId: widget.fixtureId),
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
            leading: AppBackButton(),
          ),
          body: DarkBackground(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(16),
                    child: Column(
                      children: [
                        SizedBox(height: 16),

                        Text(
                          AppTextStrings.updateFixture,
                          style: context.textTheme.titleLarge?.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),

                        SizedBox(height: 16),
                        buildProfileField(
                          context,
                          dateController: _dateController,
                          firstTeamController: _firstTeamController,
                          secondTeamController: _secondTeamController,
                          venueController: _venueController,
                          statusController: _statusController,
                          timeController: _timeController,
                          firstTeamScoreController: _firstTeamScoreController,
                          secondTeamScoreController: _secondTeamScoreController,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        if (fixtureState is UpdateSelectedFixtureLoading ||
            fixtureState is DeleteSelectedFixtureLoading) {
          return Stack(children: [scaffoldContent, AppLoadingOverlay()]);
        } else {
          return scaffoldContent;
        }
      },
    );
  }

  Widget buildProfileField(
    BuildContext context, {
    required TextEditingController dateController,
    required TextEditingController firstTeamController,
    required TextEditingController secondTeamController,
    required TextEditingController venueController,
    required TextEditingController statusController,
    required TextEditingController timeController,
    required TextEditingController firstTeamScoreController,
    required TextEditingController secondTeamScoreController,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        AbsorbPointer(
          child: FieldAndValidator(
            fieldName: AppTextStrings.firstTeam,
            textController: firstTeamController,
            obscure: obscure,
          ),
        ),
        SizedBox(height: 8),

        AbsorbPointer(
          child: FieldAndValidator(
            fieldName: AppTextStrings.secondTeam,
            textController: secondTeamController,
            obscure: obscure,
          ),
        ),
        FieldAndValidator(
          fieldName: AppTextStrings.firstTeamScore,
          textController: firstTeamScoreController,
          obscure: obscure,
        ),
        FieldAndValidator(
          fieldName: AppTextStrings.secondTeamScore,
          textController: secondTeamScoreController,
          obscure: obscure,
        ),
        SizedBox(height: 8),
        BallWidget(),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            AppTextStrings.date,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.appBGColor,
            ),
          ),
        ),
        SizedBox(height: 8),

        DatePickerField(controller: dateController, label: 'Select date'),
        SizedBox(height: 8),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            AppTextStrings.time,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.appBGColor,
            ),
          ),
        ),
        SizedBox(height: 16),
        TimePickerField(controller: timeController, label: 'Select time'),
        SizedBox(height: 16),

        FieldAndValidator(
          fieldName: AppTextStrings.venue,
          textController: venueController,
          obscure: obscure,
        ),
        SizedBox(height: 16),

        FieldAndValidator(
          fieldName: AppTextStrings.status,
          textController: statusController,
          obscure: obscure,
        ),
        SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: AppTextStrings.update,
                backgroundColor: AppColors.whiteColor,
                textColor: AppColors.blackColor,
                onButtonPressed: () => _updateFixture(),
              ),
            ),
            SizedBox(width: getScreenWidth(context, 0.1)),
            Expanded(
              child: AppButton(
                label: AppTextStrings.delete,
                backgroundColor: AppColors.whiteColor,
                textColor: AppColors.pastelRed,
                onButtonPressed: () => _deleteFixture(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _firstTeamController.dispose();
    _secondTeamController.dispose();
    _timeController.dispose();
    _venueController.dispose();
    _statusController.dispose();
    _firstTeamScoreController.dispose();
    _secondTeamScoreController.dispose();
    super.dispose();
  }
}
