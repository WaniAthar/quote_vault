import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final IconData? prefixIcon;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;
  String? _errorText;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Focus(
            onFocusChange: (hasFocus) {
              setState(() {
                _isFocused = hasFocus;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: _isFocused
                      ? [
                          Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          Theme.of(
                            context,
                          ).colorScheme.secondary.withOpacity(0.05),
                        ]
                      : [
                          Theme.of(context).colorScheme.surface,
                          Theme.of(context).colorScheme.surfaceContainerHighest
                              .withOpacity(0.3),
                        ],
                ),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.shadow.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                border: Border.all(
                  color: _errorText != null
                      ? Theme.of(context).colorScheme.error
                      : _isFocused
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  width: _errorText != null
                      ? 2
                      : _isFocused
                      ? 2
                      : 1,
                ),
              ),
              child: TextFormField(
                controller: widget.controller,
                obscureText: widget.obscureText && !_isPasswordVisible,
                keyboardType: widget.keyboardType,
                maxLines: widget.maxLines,
                enabled: widget.enabled,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText: widget.hintText,
                  labelStyle: TextStyle(
                    color: _errorText != null
                        ? Theme.of(context).colorScheme.error
                        : _isFocused
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    fontSize: _isFocused || _errorText != null ? 14 : 16,
                  ),
                  hintStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withOpacity(0.6),
                    fontSize: 16,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(
                          widget.prefixIcon,
                          color: _errorText != null
                              ? Theme.of(context).colorScheme.error
                              : _isFocused
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 20,
                        )
                      : null,
                  suffixIcon: widget.obscureText
                      ? IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  filled: false,
                  errorStyle: const TextStyle(
                    height: 0,
                    fontSize: 0,
                  ), // Hide default error
                ),
                validator: (value) {
                  final error = widget.validator?.call(value);
                  setState(() {
                    _errorText = error;
                  });
                  return error;
                },
              ),
            ),
          ),
          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 6, right: 20),
              child: Text(
                _errorText!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
