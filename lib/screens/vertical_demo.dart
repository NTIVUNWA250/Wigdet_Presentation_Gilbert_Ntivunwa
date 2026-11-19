import 'package:material_ui/material_ui.dart';
import 'package:reorderable_list_demo/data/demo_lists.dart';
import 'package:reorderable_list_demo/logic/move_item.dart';
import 'package:reorderable_list_demo/models/list_entry.dart';
import 'package:reorderable_list_demo/widgets/demo_pieces.dart';

class VerticalDemo extends StatefulWidget {
  const VerticalDemo({super.key});

  @override
  State<VerticalDemo> createState() => _VerticalDemoState();
}

class _VerticalDemoState extends State<VerticalDemo> {
  final TextEditingController _titleController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final List<ListEntry> _items = List<ListEntry>.of(kStudySteps);
  int _nextId = kStudySteps.length;
  String _status = 'Ready to drag.';
  String _callback = 'onReorderStart and onReorderEnd will report here.';

  @override
  void dispose() {
    _titleController.dispose();
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

  void _addStep() {
    final String title = _titleController.text.trim();
    if (title.isEmpty) {
      return;
    }
    setState(() {
      _nextId += 1;
      _items.add(
        ListEntry(
          id: _nextId,
          title: title,
          detail: 'Added in this session.',
        ),
      );
      _status = 'Added a row at position ${_items.length}.';
      _titleController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _remove(int id) {
    setState(() {
      _items.removeWhere((ListEntry entry) => entry.id == id);
      _status = 'Removed a row. ${_items.length} left.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SectionBanner(
          text:
              'Drag a handle to move a row. The header and footer stay fixed. '
              'onReorderItem reports the new index already adjusted, and each '
              'row keeps its own key.',
        ),
        StatusLine(primary: _status, secondary: _callback),
        Expanded(
          child: ReorderableListView(
            scrollController: _scrollController,
            primary: false,
            buildDefaultDragHandles: false,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(bottom: 12),
            restorationId: 'vertical-steps',
            header: const FixedBand(label: 'Header (not reorderable)'),
            footer: FixedBand(
              label: 'Footer (not reorderable). ${_items.length} rows.',
            ),
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
                _row(context, index),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  key: const Key('add-step-field'),
                  controller: _titleController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addStep(),
                  decoration: const InputDecoration(
                    hintText: 'Add a step',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(onPressed: _addStep, child: const Text('Add')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _row(BuildContext context, int index) {
    final ListEntry entry = _items[index];
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      key: ValueKey<String>('v-${entry.id}'),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 18,
              child: Text('${index + 1}', style: textTheme.labelLarge),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(entry.title, style: textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(entry.detail, style: textTheme.bodySmall),
                ],
              ),
            ),
            IconButton(
              key: ValueKey<String>('v-remove-${entry.id}'),
              tooltip: 'Remove',
              onPressed: () => _remove(entry.id),
              icon: const Icon(Icons.delete_outline),
            ),
            DragHandle(index: index, handleKey: 'v-handle-${entry.id}'),
          ],
        ),
      ),
    );
  }
}
