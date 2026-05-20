import 'package:flutter/material.dart';
import '../theme.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final bool showNumber;
  final double size;

  const RatingWidget({
    super.key,
    required this.rating,
    this.showNumber = false,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, size: size, color: AppTheme.accent),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(fontSize: size, fontWeight: FontWeight.w600, color: AppTheme.accent),
        ),
        if (showNumber)
          Text(
            ' ($rating)',
            style: TextStyle(fontSize: size - 2, color: Colors.grey),
          ),
      ],
    );
  }
}