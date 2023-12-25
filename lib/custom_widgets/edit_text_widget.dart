import 'package:flutter/material.dart';

class EditTextWidget extends StatelessWidget {
  final String label;
  final String? hint;
  final bool? isObscure;
  final TextEditingController controller;
  final double? width;
  final double? height;
  final int? maxLine;
  final TextInputType? inputType;

  const EditTextWidget(
      {key,
      required this.label,
      this.hint = '',
      required this.controller,
      this.isObscure = false,
      this.width = 300,
      this.height = 45,
      this.maxLine = 1,
      this.inputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(5)),
          child: TextFormField(
            keyboardType: inputType,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              border: InputBorder.none,
            ),
            maxLines: maxLine,
            obscureText: isObscure!,
            controller: controller,
          ),
        ),
      ],
    );
  }
}
