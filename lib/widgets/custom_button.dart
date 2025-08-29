import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool busy;
  const PrimaryButton({required this.label, required this.onPressed, this.busy = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: busy ? null : onPressed,
      child: busy ? SizedBox(height:16, width:16, child: CircularProgressIndicator(strokeWidth:2, color: Colors.white)) : Text(label),
      style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(48)),
    );
  }
}
