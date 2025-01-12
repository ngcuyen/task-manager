import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? label;
  final int maxLines;
  final int minLines;
  final Icon? icon;
  final TextEditingController? controller;
  final bool enabled;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const MyTextField({
    Key? key,
    this.label,
    this.maxLines = 1,
    this.minLines = 1,
    this.icon,
    this.controller,
    this.enabled = true,
    this.onTap,
    this.keyboardType,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      style: TextStyle(
        color: enabled ? Colors.black87 : Colors.grey,
      ),
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
        suffixIcon: icon,
        labelText: label,
        labelStyle: TextStyle(
          color: enabled ? Colors.black45 : Colors.grey,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}