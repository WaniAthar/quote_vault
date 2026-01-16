import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.width,
    this.height = 56,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTapDown: (_) {
        if (!isDisabled) {
          setState(() => _isPressed = true);
        }
      },
      onTapUp: (_) {
        if (!isDisabled) {
          setState(() => _isPressed = false);
        }
      },
      onTapCancel: () {
        if (!isDisabled) {
          setState(() => _isPressed = false);
        }
      },
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width ?? double.infinity,
        height: widget.height,
        margin: const EdgeInsets.symmetric(vertical: 8),
        transform: Matrix4.translationValues(0, _isPressed ? 2 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isDisabled
              ? LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                  ],
                )
              : LinearGradient(
                  colors: [
                    widget.backgroundColor ??
                        Theme.of(context).colorScheme.primary,
                    widget.backgroundColor?.withOpacity(0.8) ??
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    widget.backgroundColor?.withOpacity(0.6) ??
                        Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color:
                        (widget.backgroundColor ??
                                Theme.of(context).colorScheme.primary)
                            .withOpacity(_isPressed ? 0.3 : 0.4),
                    blurRadius: _isPressed ? 8 : 12,
                    offset: Offset(0, _isPressed ? 2 : 4),
                  ),
                  BoxShadow(
                    color:
                        (widget.backgroundColor ??
                                Theme.of(context).colorScheme.primary)
                            .withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: -2,
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(16),
            splashColor: Colors.white.withOpacity(0.1),
            highlightColor: Colors.white.withOpacity(0.05),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: widget.isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              widget.textColor ??
                                  Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            color:
                                widget.textColor ??
                                Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color:
                                widget.textColor ??
                                Theme.of(context).colorScheme.onPrimary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.text,
                          style: TextStyle(
                            color:
                                widget.textColor ??
                                Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
