import 'package:material_ui/material_ui.dart';
import 'package:reorderable_list_demo/data/demo_lists.dart';
import 'package:reorderable_list_demo/logic/move_item.dart';
import 'package:reorderable_list_demo/models/list_entry.dart';
import 'package:reorderable_list_demo/widgets/demo_pieces.dart';

class HorizontalDemo extends StatefulWidget {
  const HorizontalDemo({super.key});

  @override
  State<HorizontalDemo> createState() => _HorizontalDemoState();
}

class _HorizontalDemoState extends State<HorizontalDemo> {
  late final List<ListEntry> _items = List<ListEntry>.of(kPhases);
  bool _reverse = false;
  String _status = 'Ready to drag.';
  String _callback = 'onReorderStart and onReorderEnd will report here.';

  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      moveItem(_items, oldIndex, newIndex);
      _status =
          'Moved from position ${oldIndex + 1} to position ${newIndex + 1}.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final String order = _items
        .map((ListEntry entry) => entry.title)
        .join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionBanner(
          text:
              'scrollDirection is horizontal. reverse only flips the start '
              'edge. It does not reverse the data. The order line is index 0 '
              'first.',
        ),
        StatusLine(primary: _status, secondary: _callback),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SwitchListTile(
            title: const Text('Reverse'),
            value: _reverse,
            onChanged: (bool value) {
              setState(() {
                _reverse = value;
              });
            },
          ),
        ),
        OrderReadout(order: 'Order: $order'),
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 230,
              child: ReorderableListView(
                scrollDirection: Axis.horizontal,
                reverse: _reverse,
                primary: false,
                buildDefaultDragHandles: false,
                restorationId: 'horizontal-steps',
                padding: const EdgeInsets.symmetric(horizontal: 8),
                header: const FixedBand(label: 'Start', horizontal: true),
                footer: const FixedBand(label: 'End', horizontal: true),
                proxyDecorator: liftProxy,
                onReorderStart: (int index) {
                  setState(() {
                    _callback = 'onReorderStart index $index';
                  });
                },
                onReorderEnd: (int index) {
                  setState(() {
                    _callback = 'onReorderEnd index $index';
                  });
                },
                onReorderItem: _reorder,
                children: <Widget>[
                  for (int index = 0; index < _items.length; index += 1)
                    _card(context, index),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _card(BuildContext context, int index) {
    final ListEntry entry = _items[index];
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SizedBox(
      key: ValueKey<String>('h-${entry.id}'),
      width: 176,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Step ${index + 1}', style: textTheme.labelLarge),
              const SizedBox(height: 8),
              Text(entry.title, style: textTheme.titleLarge),
              const SizedBox(height: 6),
              Expanded(child: Text(entry.detail, style: textTheme.bodyMedium)),
              Align(
                alignment: Alignment.center,
                child: DragHandle(
                  index: index,
                  handleKey: 'h-handle-${entry.id}',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
