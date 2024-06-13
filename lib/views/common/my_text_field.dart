import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      this.hintText,
      this.suffix,
      this.prefix,
      this.isVisible,
      this.keyBoardType,
      this.onTap,
      this.controller,
      this.validator,
      this.error,
      this.onChanged});
  final String? hintText;
  final Widget? suffix;
  final Widget? prefix;
  final TextInputType? keyBoardType;
  final VoidCallback? onTap;
  final String? error;
  final bool? isVisible;
  final ValueChanged? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.068,
      width: size.width * 0.8,
      child: TextFormField(
        onTap: onTap,
        obscureText: isVisible ?? false,
        onChanged: onChanged,
        keyboardType: keyBoardType,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
            errorText: error,
            hintText: hintText,
            errorStyle: const TextStyle(height: 0.1,fontSize: 10),
            errorMaxLines: 2,
            labelText: hintText,
            prefixIcon: prefix,
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.only(
              top: 15,
            ),
            border: const OutlineInputBorder()),
      ),
    );
  }
}
