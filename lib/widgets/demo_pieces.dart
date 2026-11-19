import 'dart:ui' show lerpDouble;

import 'package:material_ui/material_ui.dart';

Widget liftProxy(Widget child, int _, Animation<double> animation) {
  return AnimatedBuilder(
    animation: animation,
    builder: (BuildContext context, Widget? child) {
      final double t = Curves.easeOut.transform(animation.value);
      final double elevation = lerpDouble(1, 12, t)!;
      final double scale = lerpDouble(1, 1.04, t)!;
      return Transform.scale(
        scale: scale,
        child: Material(
          elevation: elevation,
          color: Colors.transparent,
          shadowColor: const Color(0x66000000),
          borderRadius: BorderRadius.circular(12),
          child: child,
        ),
      );
    },
    child: child,
  );
}

class SectionBanner extends StatelessWidget {
  const SectionBanner({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSecondaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}

class StatusLine extends StatelessWidget {
  const StatusLine({
    super.key,
    required this.primary,
    required this.secondary,
  });

  final String primary;
  final String secondary;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(primary, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 2),
          Text(
            secondary,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderReadout extends StatelessWidget {
  const OrderReadout({super.key, required this.order});

  final String order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Text(order, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class FixedBand extends StatelessWidget {
  const FixedBand({
    super.key,
    required this.label,
    this.horizontal = false,
  });

  final String label;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Widget band = DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: scheme.onTertiaryContainer,
          ),
        ),
      ),
    );

    if (horizontal) {
      return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: band,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: band,
    );
  }
}

class DragHandle extends StatelessWidget {
  const DragHandle({
    super.key,
    required this.index,
    required this.handleKey,
  });

  final int index;
  final String handleKey;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Drag to reorder',
      child: ReorderableDragStartListener(
        index: index,
        child: Padding(
          key: ValueKey<String>(handleKey),
          padding: const EdgeInsets.all(8),
          child: const Icon(Icons.drag_handle),
        ),
      ),
    );
  }
}
