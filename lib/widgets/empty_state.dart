import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Empty state widget with icon and call-to-action.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SwoopTheme.space32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: SwoopTheme.forestGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(SwoopTheme.radiusXL),
              ),
              child: Icon(
                icon,
                size: 36,
                color: SwoopTheme.forestGreen.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: SwoopTheme.space20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: SwoopTheme.textPrimary,
              ),
            ),
            const SizedBox(height: SwoopTheme.space8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: SwoopTheme.textSecondary,
                height: 1.5,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: SwoopTheme.space24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
