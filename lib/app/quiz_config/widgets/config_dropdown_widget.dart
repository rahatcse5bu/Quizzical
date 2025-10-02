import 'package:flutter/material.dart';

class ConfigDropdownWidget<T> extends StatelessWidget {
  final String label;
  final T selectedValue;
  final List<T> options;
  final String Function(T) getDisplayText;
  final void Function(T) onChanged;

  const ConfigDropdownWidget({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.options,
    required this.getDisplayText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              dropdownColor: Colors.white,
              value: selectedValue,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF2E8B57),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              items: options.map((T option) {
                return DropdownMenuItem<T>(
                  
                  value: option,
                  child: Text(
                    getDisplayText(option),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (T? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}