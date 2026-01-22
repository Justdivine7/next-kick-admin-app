import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';
import 'package:nextkick_admin/common/widgets/app_text_form_field.dart';
import 'package:nextkick_admin/utilities/constants/app_text_strings.dart';
import 'package:nextkick_admin/utilities/extensions/app_extensions.dart';
import 'package:nextkick_admin/utilities/helpers/ui_helpers.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;

  const DatePickerField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
  });

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBackgroundGradient,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        DateTime selectedDate = DateTime.now();

        return CupertinoTheme(
           data: CupertinoThemeData(
            brightness: Brightness.dark, // or Brightness.light
            primaryColor: AppColors.whiteColor,
            textTheme: CupertinoTextThemeData(
              dateTimePickerTextStyle: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 14,
              ),
            ),
          ),

          child: Container(
            height: 300,
            padding: const EdgeInsets.all(12),
            color: AppColors.darkBackgroundGradient,
            child: Column(
              children: [
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    minimumDate: DateTime(2000),
                    maximumDate: DateTime(2100),
                    backgroundColor: AppColors.darkBackgroundGradient,
                    onDateTimeChanged: (DateTime newDate) {
                      selectedDate = newDate;
                    },
                  ),
                ),
                CupertinoButton(
                  color: AppColors.blackColor,
                  borderRadius: BorderRadius.circular(14),
                  child: Text(
                    'Done',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.appBGColor,
                    ),
                  ),
                  onPressed: () {
                    controller.text = DateFormat(
                      'yyyy-MM-dd',
                    ).format(selectedDate);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDatePicker(context),
      child: AbsorbPointer(
        child: AppTextFormField(
          textController: controller,
          hintText: label,
          obscure: false,
          validator: (value) =>
              validateField(value: value, fieldName: AppTextStrings.date),
          suffixIcon: const Icon(
            Icons.calendar_today_rounded,
            color: AppColors.blackColor,
          ),
        ),
      ),
    );
  }
}
