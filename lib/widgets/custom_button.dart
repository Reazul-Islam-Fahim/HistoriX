import 'package:flutter/material.dart';
import '../theme.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final ButtonVariant variant; // primary (filled accent), outline, secondary (filled primary)

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isFullWidth = false,
    this.variant = ButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final width = isFullWidth ? double.infinity : null;

    switch (variant) {
      case ButtonVariant.primary:
        return SizedBox(
          width: width,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.primary,
              minimumSize: const Size(0, 50),
            ),
            child: Text(label),
          ),
        );
      case ButtonVariant.secondary:
        return SizedBox(
          width: width,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 50),
            ),
            child: Text(label),
          ),
        );
      case ButtonVariant.outline:
        return SizedBox(
          width: width,
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 50),
            ),
            child: Text(label),
          ),
        );
    }
  }
}

enum ButtonVariant { primary, secondary, outline }