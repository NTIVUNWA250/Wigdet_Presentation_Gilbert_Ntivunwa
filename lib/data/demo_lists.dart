import 'package:reorderable_list_demo/models/list_entry.dart';

const List<ListEntry> kStudySteps = <ListEntry>[
  ListEntry(
    id: 1,
    title: 'Open the widget docs',
    detail: 'The Material class is ReorderableListView.',
  ),
  ListEntry(
    id: 2,
    title: 'Give every child a key',
    detail: 'ValueKey stays with the item, not the slot.',
  ),
  ListEntry(
    id: 3,
    title: 'Keep the list in State',
    detail: 'setState writes the order after a drop.',
  ),
  ListEntry(
    id: 4,
    title: 'Use onReorderItem',
    detail: 'The new index is already adjusted.',
  ),
  ListEntry(
    id: 5,
    title: 'Draw your own handle',
    detail: 'ReorderableDragStartListener starts the drag.',
  ),
  ListEntry(
    id: 6,
    title: 'Style the dragged row',
    detail: 'proxyDecorator builds the floating proxy.',
  ),
  ListEntry(
    id: 7,
    title: 'Pin a header',
    detail: 'The header is not part of the reorder.',
  ),
  ListEntry(
    id: 8,
    title: 'Pin a footer',
    detail: 'The footer stays after the last row.',
  ),
  ListEntry(
    id: 9,
    title: 'Hear the drag start',
    detail: 'onReorderStart receives the old index.',
  ),
  ListEntry(
    id: 10,
    title: 'Hear the drag end',
    detail: 'onReorderEnd runs even if the row stays put.',
  ),
];

const List<ListEntry> kPhases = <ListEntry>[
  ListEntry(
    id: 1,
    title: 'Keys',
    detail: 'Every child needs a key.',
  ),
  ListEntry(
    id: 2,
    title: 'State',
    detail: 'The order lives in State.',
  ),
  ListEntry(
    id: 3,
    title: 'Drag',
    detail: 'The handle starts the gesture.',
  ),
  ListEntry(
    id: 4,
    title: 'Drop',
    detail: 'onReorderItem moves the data.',
  ),
  ListEntry(
    id: 5,
    title: 'Proxy',
    detail: 'The lifted card is a proxy.',
  ),
  ListEntry(
    id: 6,
    title: 'Header',
    detail: 'The end caps stay fixed.',
  ),
];

const List<ListEntry> kLabItems = <ListEntry>[
  ListEntry(id: 1, title: 'Alpha', detail: 'Index 0 at the start.'),
  ListEntry(id: 2, title: 'Bravo', detail: 'Drag to change the index.'),
  ListEntry(id: 3, title: 'Charlie', detail: 'Keys keep identity.'),
  ListEntry(id: 4, title: 'Delta', detail: 'Header and footer stay.'),
  ListEntry(id: 5, title: 'Echo', detail: 'Reverse flips the edge.'),
  ListEntry(
    id: 6,
    title: 'Foxtrot',
    detail: 'Direction can be horizontal.',
  ),
];

List<ListEntry> builderRows() {
  return List<ListEntry>.generate(36, (int index) {
    final int id = index + 1;
    final String number = id.toString().padLeft(2, '0');
    return ListEntry(
      id: id,
      title: 'Row $number',
      detail: 'Built only while this row is visible.',
    );
  });
}
