import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  const InputField({required this.controller, required this.label, this.obscure=false, super.key, required IconData prefixIcon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
    );
  }
}
