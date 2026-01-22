import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_back_button.dart';
import 'package:nextkick_admin/common/widgets/app_button.dart';
import 'package:nextkick_admin/common/widgets/app_loading_overlay.dart';
import 'package:nextkick_admin/common/widgets/app_text_form_field.dart';
import 'package:nextkick_admin/common/widgets/app_toast/app_toast.dart';
import 'package:nextkick_admin/common/widgets/dark_background.dart';
import 'package:nextkick_admin/common/widgets/description_box.dart';
import 'package:nextkick_admin/features/tournaments/bloc/tournament_bloc.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/constants/enums/toast_enum.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';
import 'package:nextkick_admin/utilities/helpers/ui_helpers.dart';

class CreateTournamentView extends StatefulWidget {
  static const routeName = '/create-tournament';
  const CreateTournamentView({super.key});

  @override
  State<CreateTournamentView> createState() => _CreateTournamentViewState();
}

class _CreateTournamentViewState extends State<CreateTournamentView> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _locationController = TextEditingController();

  final TextEditingController _detailsController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _createTournament() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      context.read<TournamentBloc>().add(
        CreateTournament(
          title: _titleController.text.trim(),
          description: _detailsController.text.trim(),
          location: _locationController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TournamentBloc, TournamentState>(
      listener: (context, tournamentState) {
        if (tournamentState is CreateTournamentFailure) {
          AppToast.show(
            context,
            message: tournamentState.error,
            style: ToastStyle.error,
          );
        }
        if (tournamentState is CreateTournamentSuccessful) {
          AppToast.show(
            context,
            message: tournamentState.message,
            style: ToastStyle.success,
          );
          Navigator.pop(context);
        }
      },
      builder: (context, tournamentState) {
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
            child: SafeArea(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(16),
                      child: Column(
                        children: [
                          SizedBox(height: getScreenHeight(context, 0.2)),
                          Text(
                            AppTextStrings.createTournamment,
                            style: context.textTheme.displayMedium?.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                          SizedBox(height: 20),
                          AppTextFormField(
                            hintText: AppTextStrings.tournamentName,
                            textController: _titleController,
                            obscure: false,
                            validator: (value) => validateField(
                              value: value,
                              fieldName: AppTextStrings.tournamentName,
                            ),
                            hintColor: AppColors.subTextcolor,
                          ),
                          SizedBox(height: 10),

                          AppTextFormField(
                            hintText: AppTextStrings.location,
                            textController: _locationController,
                            obscure: false,
                            validator: (value) => validateField(
                              value: value,
                              fieldName: AppTextStrings.location,
                            ),
                            hintColor: AppColors.subTextcolor,
                          ),
                          SizedBox(height: 10),

                          DescriptionBox(
                            hintText: AppTextStrings.details,
                            obscure: false,
                            validator: (value) => validateField(
                              value: value,
                              fieldName: AppTextStrings.details,
                            ),
                            hintColor: AppColors.subTextcolor,
                            textController: _detailsController,
                          ),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              width: getScreenWidth(context, 0.3),
                              child: AppButton(
                                label: AppTextStrings.upload,
                                backgroundColor: AppColors.whiteColor,
                                textColor: AppColors.blackColor,
                                onButtonPressed: () => _createTournament(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        if (tournamentState is CreateTournamentLoading) {
          return Stack(children: [scaffoldContent, AppLoadingOverlay()]);
        } else {
          return scaffoldContent;
        }
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _detailsController.dispose();
    super.dispose();
  }
}
