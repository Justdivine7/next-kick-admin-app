import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_back_button.dart';
import 'package:nextkick_admin/common/widgets/app_button.dart';
import 'package:nextkick_admin/common/widgets/dark_background.dart';
import 'package:nextkick_admin/common/widgets/field_and_validator.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';
import 'package:nextkick_admin/utilities/helpers/ui_helpers.dart';

class PlayerProfileView extends StatefulWidget {
  static const routeName = '/player-profile';
  const PlayerProfileView({super.key});

  @override
  State<PlayerProfileView> createState() => _PlayerProfileViewState();
}

class _PlayerProfileViewState extends State<PlayerProfileView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _activeBundleController = TextEditingController();
  final TextEditingController _videoLinkController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: EdgeInsetsGeometry.all(16),
            child: Column(
              children: [
                Text(
                  AppTextStrings.playerProfile,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
                SizedBox(height: 16),

                CircleAvatar(radius: 30),
                SizedBox(height: 16),
                buildProfileField(
                  AppTextStrings.firstName,
                  _firstNameController,
                ),
                SizedBox(height: 16),
                buildProfileField(AppTextStrings.lastName, _lastNameController),
                SizedBox(height: 16),
                buildProfileField(
                  AppTextStrings.emailAddress,
                  _emailController,
                ),
                buildProfileField(AppTextStrings.age, _ageController),

                SizedBox(height: 16),
                buildProfileField(AppTextStrings.height, _heightController),
                buildProfileField(
                  AppTextStrings.playerCountry,
                  _countryController,
                ),
                SizedBox(height: 16),
                buildProfileField(
                  AppTextStrings.activePlayerBundle,
                  _activeBundleController,
                ),
                SizedBox(height: 16),
                buildProfileField(
                  AppTextStrings.performanceVideo,
                  _videoLinkController,
                ),
              ],
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
    _emailController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _countryController.dispose();
    _activeBundleController.dispose();
    _videoLinkController.dispose();

    super.dispose();
  }
}
