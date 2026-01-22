import 'package:flutter/material.dart';
import 'package:nextkick_admin/common/colors/app_colors.dart';

class DescriptionBox extends StatefulWidget {
  final String hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? textController;
  final bool obscure;
  final Color? hintColor;
  final String? Function(String?)? validator;

  const DescriptionBox({
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.textController,
    required this.obscure,
    this.validator,
    this.hintColor,
  });

  @override
  State<DescriptionBox> createState() => _DescriptionBoxState();
}

class _DescriptionBoxState extends State<DescriptionBox> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return TextFormField(
      validator: widget.validator,
      controller: widget.textController,
      style: TextStyle(color: AppColors.blackColor, fontSize: 14),
      obscureText: widget.obscure,
      maxLines: 5,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: AppColors.whiteColor),

        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        fillColor: AppColors.appBGColor,
        filled: true,
        hintText: widget.hintText,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: widget.hintColor ?? AppColors.subTextcolor,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.solidOrange,
          ), // removes red border
        ),
        suffixIcon: widget.suffixIcon,
        prefixIcon: widget.prefixIcon,
      ),
    );
  }
}
