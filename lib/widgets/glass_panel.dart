import 'dart:ui';

import 'package:flutter/material.dart';

import 'design_system.dart';

/// Reusable frosted-glass surface.
///
/// Blurs whatever is painted behind it and renders a translucent
/// navy/white surface with a soft border, subtle top highlight and
/// layered shadow.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.blur = 16,
    this.tint = kNavyDeep,
    this.opacity = 0.46,
    this.borderColor = Colors.white,
    this.borderOpacity = 0.16,
    this.padding = EdgeInsets.zero,
    this.glow = false,
    this.glowColor = kChampagne,
    this.shadow = 24,
    this.topHighlight = true,
  });

  final Widget child;
  final double borderRadius;
  final double blur;
  final Color tint;
  final double opacity;
  final Color borderColor;
  final double borderOpacity;
  final EdgeInsetsGeometry padding;
  final bool glow;
  final Color glowColor;
  final double shadow;
  final bool topHighlight;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          if (glow)
            BoxShadow(
              color: glowColor.withValues(alpha: 0.16),
              blurRadius: 28,
              spreadRadius: 1,
            ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: shadow,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: padding,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor.withValues(alpha: borderOpacity),
              ),
            ),
            child: Stack(
              children: [
                child,
                if (topHighlight)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: 56,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.05),
                              Colors.white.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
