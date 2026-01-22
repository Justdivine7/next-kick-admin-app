import 'package:flutter/material.dart';
 
extension StringCasingExtension on String {
  /// Capitalizes only the first letter of the string.
  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Converts all letters to uppercase.
  String capitalizeAll() => toUpperCase();

  /// Converts all letters to lowercase.
  String toLowerCased() => toLowerCase();
}

extension ContextTextTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}


