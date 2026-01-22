import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_back_button.dart';
import 'package:nextkick_admin/common/widgets/app_button.dart';
import 'package:nextkick_admin/common/widgets/app_loading_overlay.dart';
import 'package:nextkick_admin/common/widgets/app_toast/app_toast.dart';
import 'package:nextkick_admin/common/widgets/dark_background.dart';
import 'package:nextkick_admin/common/widgets/field_and_validator.dart';
import 'package:nextkick_admin/features/standings/bloc/standings_bloc.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/constants/enums/toast_enum.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';

class CreateStandingsView extends StatefulWidget {
  static const routeName = 'create-standings';
  const CreateStandingsView({super.key});

  @override
  State<CreateStandingsView> createState() => _CreateStandingsViewState();
}

class _CreateStandingsViewState extends State<CreateStandingsView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _teamController = TextEditingController();
  final TextEditingController _teamPointController = TextEditingController();

  void _createStanding() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<StandingsBloc>().add(
        CreateStanding(
          point: int.parse(_teamPointController.text.trim()),
          teamName: _teamController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StandingsBloc, StandingsState>(
      listener: (context, standingState) {
        if (standingState is CreateStandingsSuccessful) {
          AppToast.show(
            context,
            message: 'Standing created successfully',
            style: ToastStyle.success,
          );
          Navigator.pop(context);
        }
        if (standingState is CreateStandingsError) {
          AppToast.show(
            context,
            message: standingState.error,
            style: ToastStyle.error,
          );
        }
      },
      builder: (context, standingState) {
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
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        Text(
                          AppTextStrings.createStanding,
                          style: context.textTheme.titleLarge?.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),

                        SizedBox(height: 16),
                        FieldAndValidator(
                          fieldName: AppTextStrings.team,
                          textController: _teamController,
                          obscure: false,
                        ),
                        SizedBox(height: 8),

                        FieldAndValidator(
                          fieldName: AppTextStrings.pointsLowercase,
                          textController: _teamPointController,
                          obscure: false,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        AppButton(
                          label: AppTextStrings.createStandingLowercase,
                          backgroundColor: AppColors.whiteColor,
                          textColor: AppColors.blackColor,
                          onButtonPressed: () => _createStanding(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        if (standingState is CreateStandingsLoading) {
          return Stack(children: [scaffoldContent, AppLoadingOverlay()]);
        } else {
          return scaffoldContent;
        }
      },
    );
  }
}
