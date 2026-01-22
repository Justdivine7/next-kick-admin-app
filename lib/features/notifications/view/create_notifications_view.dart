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
import 'package:nextkick_admin/features/notifications/bloc/notification_bloc.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/constants/enums/toast_enum.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';
import 'package:nextkick_admin/utilities/helpers/ui_helpers.dart';

class CreateNotificationsView extends StatefulWidget {
  static const routeName = '/create-notifications-view';

  const CreateNotificationsView({super.key});

  @override
  State<CreateNotificationsView> createState() =>
      _CreateNotificationsViewState();
}

class _CreateNotificationsViewState extends State<CreateNotificationsView> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _sendNotificationToPlayers() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<NotificationBloc>().add(
        CreateNotificationEvent(
          userType: 'player',
          title: _titleController.text.trim(),
          message: _messageController.text.trim(),
        ),
      );
    }
  }

  void _sendNotificationToTeams() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<NotificationBloc>().add(
        CreateNotificationEvent(
          userType: 'team',
          title: _titleController.text.trim(),
          message: _messageController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, notificationState) {
        if (notificationState is CreateNotificationFailure) {
          AppToast.show(
            context,
            message: notificationState.error,
            style: ToastStyle.error,
          );
        }
        if (notificationState is CreateNotificationSuccessful) {
          AppToast.show(
            context,
            message: notificationState.message,
            style: ToastStyle.success,
          );
        }
      },
      builder: (context, notificationState) {
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
              child: Padding(
                padding: EdgeInsetsGeometry.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: getScreenHeight(context, 0.05)),
                      Text(
                        AppTextStrings.notification,
                        style: context.textTheme.titleLarge?.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
                      SizedBox(height: getScreenHeight(context, 0.05)),
                      buildNotification(context, _messageController),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        if (notificationState is CreateNotificationLoading) {
          return Stack(children: [scaffoldContent, AppLoadingOverlay()]);
        } else {
          return scaffoldContent;
        }
      },
    );
  }

  Widget buildNotification(
    BuildContext context,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextFormField(
          hintText: 'Title',
          textController: _titleController,
          obscure: false,
          validator: (value) => validateField(value: value, fieldName: 'Title'),
        ),
        SizedBox(height: 10),
        DescriptionBox(
          hintText: AppTextStrings.details,
          obscure: false,
          textController: _messageController,
          validator: (value) =>
              validateField(value: value, fieldName: 'message'),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: getScreenWidth(context, 0.3),
                child: AppButton(
                  label: AppTextStrings.sendToPlayer,
                  backgroundColor: AppColors.whiteColor,
                  textColor: AppColors.blackColor,
                  onButtonPressed: () => _sendNotificationToPlayers(),
                ),
              ),
            ),
            SizedBox(width: 10),

            Expanded(
              child: SizedBox(
                width: getScreenWidth(context, 0.3),
                child: AppButton(
                  label: AppTextStrings.sendToTeams,
                  backgroundColor: AppColors.whiteColor,
                  textColor: AppColors.blackColor,
                  onButtonPressed: () => _sendNotificationToTeams(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _titleController.dispose();
    super.dispose();
  }
}
