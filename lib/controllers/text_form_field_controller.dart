import 'package:flutter/material.dart';

class CreateTextFormField extends StatelessWidget {
   CreateTextFormField({
    required this.fieldIcon,
    required this.label,
    required this.hintText,
    required this.validationWarning,
    required this.onChanged,
    // this.fieldType,
    super.key,
  });
  final Icon fieldIcon;
  final String label;
  final String hintText;
  final String validationWarning;
   Function(String) onChanged;
  // String? fieldType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (inputText) {
        if(inputText!.isEmpty) {
          return validationWarning;
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        prefixIcon: fieldIcon,
        labelText: label,
        hintText: hintText,
      ),
      onChanged: onChanged,
    );
  }
}
