import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_button.dart';
import 'package:nextkick_admin/common/widgets/app_loading_overlay.dart';
import 'package:nextkick_admin/common/widgets/app_toast/app_toast.dart';
import 'package:nextkick_admin/common/widgets/dark_background.dart';
import 'package:nextkick_admin/common/widgets/exit_alert.dart';
import 'package:nextkick_admin/common/widgets/label_and_text_field.dart';
import 'package:nextkick_admin/features/auth/bloc/auth_bloc.dart';
import 'package:nextkick_admin/features/dashboard/view/dashboard_view.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/constants/enums/toast_enum.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';
import 'package:nextkick_admin/utilities/helpers/ui_helpers.dart';

class LoginView extends StatefulWidget {
  static const routeName = '/login';
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> showPassword = ValueNotifier<bool>(true);

  void _submitForm() {
    FocusScope.of(context).unfocus();
    final password = _passwordController.text.trim();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (password.length < 6) {
      AppToast.show(
        context,
        message: 'Password must be at least 6 characters',
        style: ToastStyle.warning,
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        LoginDetailsSubmitted(
          email: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, loginState) {
        if (loginState is LoginFailure) {
          AppToast.show(
            context,
            message: loginState.error,
            style: ToastStyle.error,
          );
        }
        if (loginState is LoginSuccessful) {
          Navigator.pushReplacementNamed(context, DashboardView.routeName);
          AppToast.show(
            context,
            message: 'Login Successful',
            style: ToastStyle.success,
          );
        }
      },
      builder: (context, loginState) {
        final scaffoldContent = PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            final shouldExit = await showDialog<bool>(
              context: context,
              builder: (context) => ExitAlert(),
            );

            if (shouldExit == true) {
              SystemNavigator.pop();
            }
          },
          child: Scaffold(
            body: DarkBackground(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            AppTextStrings.login,
                            style: context.textTheme.displayLarge?.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 24),
                          Container(
                            padding: EdgeInsets.all(25),

                            width: getScreenWidth(context, 0.8),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                LabelAndTextField(
                                  label: AppTextStrings.email,
                                  labelColor: AppColors.boldTextColor,
                                  textController: _usernameController,
                                  hintText: AppTextStrings.email,
                                  obscure: false,
                                  errorColor: AppColors.boldTextColor,
                                  errorBorder: BorderSide(
                                    color: AppColors.boldTextColor,
                                  ),
                                  validator: (value) => validateEmail(
                                    value: value,
                                    fieldName: AppTextStrings.email,
                                  ),
                                ),

                                SizedBox(height: 15),

                                ValueListenableBuilder<bool>(
                                  valueListenable: showPassword,
                                  builder: (context, value, child) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: LabelAndTextField(
                                        label: AppTextStrings.password,
                                        labelColor: AppColors.boldTextColor,
                                        textController: _passwordController,
                                        hintText: AppTextStrings.password,
                                        obscure: value,
                                        errorColor: AppColors.boldTextColor,
                                        errorBorder: BorderSide(
                                          color: AppColors.boldTextColor,
                                        ),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            showPassword.value =
                                                !showPassword.value;
                                          },
                                          child: Icon(
                                            value
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: AppColors.borderColor,
                                          ),
                                        ),
                                        validator: (value) => validatePassword(
                                          value: value,
                                          fieldName: AppTextStrings.password,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 20),
                                AppButton(
                                  onButtonPressed: () => _submitForm(),
                                  label: AppTextStrings.login,
                                  backgroundColor: AppColors.blackColor,
                                  textColor: AppColors.whiteColor,
                                ),
                              ],
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
        if (loginState is LoginLoading) {
          return Stack(children: [scaffoldContent, AppLoadingOverlay()]);
        } else {
          return scaffoldContent;
        }
      },
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
