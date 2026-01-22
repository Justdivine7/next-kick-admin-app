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
import 'package:nextkick_admin/common/widgets/field_and_validator.dart';
import 'package:nextkick_admin/common/widgets/time_picker.dart';
import 'package:nextkick_admin/features/fixtures/bloc/fixtures_bloc.dart';
import 'package:nextkick_admin/features/fixtures/views/widget/registered_team_bottom_modal.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/constants/enums/toast_enum.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';
import 'package:nextkick_admin/utilities/helpers/ui_helpers.dart';

class CreateFixturesView extends StatefulWidget {
  static const routeName = '/fixtures-view';

  const CreateFixturesView({super.key});

  @override
  State<CreateFixturesView> createState() => _CreateFixturesViewState();
}

class _CreateFixturesViewState extends State<CreateFixturesView> {
  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _firstTeamController = TextEditingController();

  final TextEditingController _secondTeamController = TextEditingController();

  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _teamOneId;
  String? _teamTwoId;

  void _createFixture() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      if (_teamOneId == null && _teamTwoId == null ||
          _teamOneId!.isEmpty && _teamTwoId!.isEmpty) {
        AppToast.show(
          context,
          message: 'Please select both teams before proceeding',
          style: ToastStyle.warning,
        );
        return;
      }
      context.read<FixturesBloc>().add(
        CreateFixture(
          firstTeam: _teamOneId!,
          secondTeam: _teamTwoId!,
          date: _dateController.text.trim(),
          time: _timeController.text.trim(),
          venue: _venueController.text.trim(),
          status: 'scheduled',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FixturesBloc, FixturesState>(
      listener: (context, fixturesState) {
        if (fixturesState is CreateFixturesError) {
          AppToast.show(
            context,
            message: fixturesState.error,
            style: ToastStyle.error,
          );
        }
        if (fixturesState is CreateFixturesSuccessful) {
          AppToast.show(
            context,
            message: 'Fixture created successfully',
            style: ToastStyle.success,
          );
          Navigator.pop(context);
        }
      },
      builder: (context, fixturesState) {
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
                          AppTextStrings.createFixture,
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
                          timeController: _timeController,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        if (fixturesState is CreateFixturesLoading) {
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
    required TextEditingController timeController,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppTextStrings.firstTeam,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(height: 8),

            RegisteredTeamBottomModal(
              textController: _firstTeamController,
              onTeamSelected: (id) {
                _teamOneId = id;
                debugPrint(id);
              },
            ),
          ],
        ),
        SizedBox(height: 8),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              AppTextStrings.secondTeam,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(height: 8),
            RegisteredTeamBottomModal(
              textController: _secondTeamController,
              onTeamSelected: (id) {
                _teamTwoId = id;
                debugPrint(id);
              },
            ),
          ],
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
        SizedBox(
          width: getScreenWidth(context, 0.4),
          child: AppButton(
            label: AppTextStrings.createFixtureLower,
            backgroundColor: AppColors.whiteColor,
            textColor: AppColors.blackColor,
            onButtonPressed: () => _createFixture(),
          ),
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

    super.dispose();
  }
}
