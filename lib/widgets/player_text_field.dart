import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerTextField extends StatelessWidget {
  const PlayerTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.minLines,
    this.maxLines,
    this.textAlignVertical,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final int? maxLines;
  final TextAlignVertical? textAlignVertical;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      minLines: minLines ?? 1,
      maxLines: maxLines ?? 1,
      textAlignVertical:
          textAlignVertical ??
          ((maxLines != null && maxLines! > 1)
              ? TextAlignVertical.top
              : TextAlignVertical.center),
      decoration: InputDecoration(
        labelText: label.toUpperCase(),
        hintText: hint,
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
