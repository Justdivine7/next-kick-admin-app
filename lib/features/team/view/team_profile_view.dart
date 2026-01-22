import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_back_button.dart';
import 'package:nextkick_admin/common/widgets/app_button.dart';
import 'package:nextkick_admin/common/widgets/dark_background.dart';
import 'package:nextkick_admin/common/widgets/field_and_validator.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';
import 'package:nextkick_admin/utilities/helpers/ui_helpers.dart';

class TeamProfileView extends StatefulWidget {
  static const routeName = '/team-profile';
  const TeamProfileView({super.key});

  @override
  State<TeamProfileView> createState() => _TeamProfileViewState();
}

class _TeamProfileViewState extends State<TeamProfileView> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _ageGroupController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    AppTextStrings.teamName,
                    style: context.textTheme.displayMedium?.copyWith(
                      color: AppColors.appBGColor,
                    ),
                  ),
                  SizedBox(height: 30),
                  buildProfileField(
                    AppTextStrings.teamName,
                    _teamNameController,
                  ),
                  SizedBox(height: 16),
                  buildProfileField(
                    AppTextStrings.location,
                    _locationController,
                  ),
                  SizedBox(height: 16),
                  buildProfileField(
                    AppTextStrings.ageGroup,
                    _ageGroupController,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileField(
    String label,
    TextEditingController textController, {
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FieldAndValidator(
          fieldName: label,
          textController: textController,
          obscure: obscure,
        ),
        SizedBox(height: 8),
        SizedBox(
          width: getScreenWidth(context, 0.3),
          child: AppButton(
            label: AppTextStrings.update,
            backgroundColor: AppColors.whiteColor,
            textColor: AppColors.blackColor,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _locationController.dispose();
    _ageGroupController.dispose();
    super.dispose();
  }
}
