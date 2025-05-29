import 'package:flutter/material.dart';

class ReusableTextForm extends StatefulWidget {
  final TextEditingController controller;
  final InputDecoration? decoration;
  final bool isPassword;
  final String hintText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final bool enabled;

  const ReusableTextForm({
    super.key,
    required this.controller,
    this.decoration,
    this.isPassword = false,
    required this.hintText,
    this.prefixIcon,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.onSaved,
    this.enabled = true,
  });

  @override
  State<ReusableTextForm> createState() => _ReusableTextFormState();
}

class _ReusableTextFormState extends State<ReusableTextForm> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });

                  // Reset to hidden after 1 second
                  if (!_obscureText) {
                    Future.delayed(const Duration(seconds: 1), () {
                      setState(() {
                        _obscureText = true;
                      });
                    });
                  }
                },
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
      obscureText: widget.isPassword ? _obscureText : false,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      enabled: widget.enabled,
    );
  }
}
