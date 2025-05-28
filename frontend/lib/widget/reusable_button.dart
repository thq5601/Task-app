import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final bool isLoading;
  final bool isEnable;

  const ReusableButton({
    super.key,
    required this.text,
    this.onPressed,
    required this.backgroundColor,
    this.isLoading = false,
    this.isEnable = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}
