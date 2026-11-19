import 'package:material_ui/material_ui.dart';
import 'package:reorderable_list_demo/data/demo_lists.dart';
import 'package:reorderable_list_demo/logic/move_item.dart';
import 'package:reorderable_list_demo/models/list_entry.dart';
import 'package:reorderable_list_demo/widgets/demo_pieces.dart';

class BuilderDemo extends StatefulWidget {
  const BuilderDemo({super.key});

  @override
  State<BuilderDemo> createState() => _BuilderDemoState();
}

class _BuilderDemoState extends State<BuilderDemo> {
  final ScrollController _scrollController = ScrollController();
  late final List<ListEntry> _items = builderRows();
  String _status = 'Ready to drag.';
  String _callback = 'onReorderStart and onReorderEnd will report here.';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      moveItem(_items, oldIndex, newIndex);
      _status =
          'Moved from position ${oldIndex + 1} to position ${newIndex + 1}.';
    });
  }

  void _jumpToTop() {
    if (!_scrollController.hasClients) {
      return;
    }
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SectionBanner(
          text:
              'ReorderableListView.builder builds a row when it scrolls into '
              'view. The label stays with the item. The badge on the left is '
              'the position. itemExtent keeps every row the same height.',
        ),
        Row(
          children: <Widget>[
            Expanded(child: StatusLine(primary: _status, secondary: _callback)),
            TextButton.icon(
              onPressed: _jumpToTop,
              icon: const Icon(Icons.vertical_align_top),
              label: const Text('Top'),
            ),
            const SizedBox(width: 8),
          ],
        ),
        Expanded(
          child: ReorderableListView.builder(
            scrollController: _scrollController,
            primary: false,
            itemCount: _items.length,
            itemExtent: 92,
            buildDefaultDragHandles: false,
            padding: const EdgeInsets.only(bottom: 12),
            restorationId: 'builder-rows',
            header: FixedBand(label: 'Builder header. ${_items.length} rows.'),
            footer: const FixedBand(label: 'Builder footer (not reorderable)'),
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
            itemBuilder: (BuildContext context, int index) {
              return _row(context, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _row(BuildContext context, int index) {
    final ListEntry entry = _items[index];
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      key: ValueKey<String>('b-${entry.id}'),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 36,
              child: Text(
                '${index + 1}',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(entry.title, style: textTheme.titleMedium),
                  Text(
                    entry.detail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            DragHandle(index: index, handleKey: 'b-handle-${entry.id}'),
          ],
        ),
      ),
    );
  }
}
