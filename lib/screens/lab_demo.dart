import 'package:material_ui/material_ui.dart';
import 'package:reorderable_list_demo/data/demo_lists.dart';
import 'package:reorderable_list_demo/logic/move_item.dart';
import 'package:reorderable_list_demo/models/list_entry.dart';
import 'package:reorderable_list_demo/widgets/demo_pieces.dart';

class LabDemo extends StatefulWidget {
  const LabDemo({super.key});

  @override
  State<LabDemo> createState() => _LabDemoState();
}

class _LabDemoState extends State<LabDemo> {
  late final List<ListEntry> _items = List<ListEntry>.of(kLabItems);
  bool _horizontal = false;
  bool _reverse = false;
  bool _defaultHandles = false;
  bool _showHeader = true;
  bool _showFooter = true;
  String _status = 'Ready to drag.';

  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      moveItem(_items, oldIndex, newIndex);
      _status =
          'Moved from position ${oldIndex + 1} to position ${newIndex + 1}.';
    });
  }

  String get _hint {
    final String axis = _horizontal ? 'horizontal' : 'vertical';
    final String reverseLine = _reverse
        ? 'Reverse is on, so the list starts at the far edge.'
        : 'Reverse is off, so index 0 starts at the near edge.';
    final String handleLine = _defaultHandles
        ? 'Default handles are on. A phone uses a long press. Desktop draws the framework handle.'
        : 'Default handles are off. Drag the handle on each row.';
    return 'Direction: $axis. $reverseLine $handleLine';
  }

  @override
  Widget build(BuildContext context) {
    final String order = _items
        .map((ListEntry entry) => entry.title)
        .join(', ');
    final Widget list = ReorderableListView.builder(
      scrollDirection: _horizontal ? Axis.horizontal : Axis.vertical,
      reverse: _reverse,
      primary: _horizontal ? false : null,
      itemCount: _items.length,
      buildDefaultDragHandles: _defaultHandles,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      restorationId: 'lab-rows',
      header: _showHeader
          ? FixedBand(label: 'Lab header', horizontal: _horizontal)
          : null,
      footer: _showFooter
          ? FixedBand(label: 'Lab footer', horizontal: _horizontal)
          : null,
      proxyDecorator: liftProxy,
      onReorderItem: _reorder,
      itemBuilder: (BuildContext context, int index) {
        return _tile(context, index);
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionBanner(
          text:
              'Turn parameters on and off. The order line is the list after '
              'onReorderItem runs.',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              FilterChip(
                label: const Text('Horizontal axis'),
                selected: _horizontal,
                onSelected: (bool value) {
                  setState(() {
                    _horizontal = value;
                  });
                },
              ),
              FilterChip(
                label: const Text('Reverse'),
                selected: _reverse,
                onSelected: (bool value) {
                  setState(() {
                    _reverse = value;
                  });
                },
              ),
              FilterChip(
                label: const Text('Default handles'),
                selected: _defaultHandles,
                onSelected: (bool value) {
                  setState(() {
                    _defaultHandles = value;
                  });
                },
              ),
              FilterChip(
                label: const Text('Header'),
                selected: _showHeader,
                onSelected: (bool value) {
                  setState(() {
                    _showHeader = value;
                  });
                },
              ),
              FilterChip(
                label: const Text('Footer'),
                selected: _showFooter,
                onSelected: (bool value) {
                  setState(() {
                    _showFooter = value;
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(_hint, style: Theme.of(context).textTheme.bodySmall),
        ),
        StatusLine(
          primary: _status,
          secondary: 'Order: $order',
        ),
        Expanded(
          child: _horizontal
              ? Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(height: 180, child: list),
                )
              : list,
        ),
      ],
    );
  }

  Widget _tile(BuildContext context, int index) {
    final ListEntry entry = _items[index];
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Widget body = Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: _horizontal
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(entry.title, style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Expanded(child: Text(entry.detail, style: textTheme.bodySmall)),
                  if (!_defaultHandles)
                    Align(
                      alignment: Alignment.center,
                      child: DragHandle(
                        index: index,
                        handleKey: 'l-handle-${entry.id}',
                      ),
                    ),
                ],
              )
            : Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(entry.title, style: textTheme.titleMedium),
                        Text(entry.detail, style: textTheme.bodySmall),
                      ],
                    ),
                  ),
                  if (!_defaultHandles)
                    DragHandle(index: index, handleKey: 'l-handle-${entry.id}'),
                ],
              ),
      ),
    );

    return KeyedSubtree(
      key: ValueKey<String>('l-${entry.id}'),
      child: _horizontal ? SizedBox(width: 160, child: body) : body,
    );
  }
}
