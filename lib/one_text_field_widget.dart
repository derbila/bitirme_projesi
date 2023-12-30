import 'package:flutter/material.dart';

class OneTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  const OneTextFieldWidget({super.key, required this.controller, required this.labelText, this.validator});

  @override
  State<OneTextFieldWidget> createState() => _OneTextFieldWidgetState();
}

class _OneTextFieldWidgetState extends State<OneTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
      child: TextFormField(
        validator: widget.validator,
        controller: widget.controller,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            // labelText: widget.labelText,
            focusColor: Colors.blue,
            // disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            focusedBorder:
                OutlineInputBorder(borderSide: const BorderSide(color: Colors.blueAccent, width: 2), borderRadius: BorderRadius.circular(8)),
            fillColor: Colors.red,
            label: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.labelText,
                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
            ),
            // contentPadding: const EdgeInsets.fromLTRB(8, 0, 0, 27),
            isDense: false,
            border: const OutlineInputBorder()),
      ),
    );
  }
}
