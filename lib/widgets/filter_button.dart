import 'package:flutter/material.dart';

// Reusable filter button that matches the small rounded design used in penerimaanWarga
class FilterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;

  const FilterButton({Key? key, required this.onPressed, this.label = 'Filter', this.icon = Icons.filter_list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
