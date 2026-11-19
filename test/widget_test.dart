import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:reorderable_list_demo/logic/move_item.dart';
import 'package:reorderable_list_demo/main.dart';

void main() {
  test('moveItem inserts at the index from onReorderItem', () {
    final List<String> items = <String>['a', 'b', 'c', 'd'];
    moveItem(items, 0, 2);
    expect(items, <String>['b', 'c', 'a', 'd']);
  });

  test('moveItem can move an item toward the start', () {
    final List<String> items = <String>['a', 'b', 'c', 'd'];
    moveItem(items, 3, 1);
    expect(items, <String>['a', 'd', 'b', 'c']);
  });

  testWidgets('vertical list can add and remove a step', (WidgetTester tester) async {
    await _pumpApp(tester);
    expect(find.text('Open the widget docs'), findsOneWidget);
    expect(find.text('Header (not reorderable)'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('add-step-field')),
      'Write the notes',
    );
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    expect(find.text('Write the notes'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey<String>('v-remove-1')),
      -250,
      scrollable: find.byType(Scrollable).hitTestable().first,
    );
    await tester.tap(find.byKey(const ValueKey<String>('v-remove-1')));
    await tester.pumpAndSettle();
    expect(find.text('Open the widget docs'), findsNothing);
  });

  testWidgets('dragging a handle reorders the vertical list', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    final Finder handle = find.byKey(const ValueKey<String>('v-handle-1'));
    expect(handle, findsOneWidget);
    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(handle),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await gesture.moveBy(const Offset(0, 280));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.textContaining('Moved from position 1'), findsOneWidget);
  });

  testWidgets('navigation opens the other ReorderableListView demos', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Horizontal'));
    await tester.pumpAndSettle();
    expect(find.text('Keys'), findsOneWidget);
    expect(
      find.text('Order: Keys, State, Drag, Drop, Proxy, Header'),
      findsOneWidget,
    );

    await tester.tap(find.text('Builder'));
    await tester.pumpAndSettle();
    expect(find.text('Row 01'), findsOneWidget);
    expect(find.textContaining('itemExtent'), findsOneWidget);

    await tester.tap(find.text('Lab'));
    await tester.pumpAndSettle();
    expect(find.text('Alpha'), findsOneWidget);
    expect(find.textContaining('Direction: vertical'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, 'Reverse'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Reverse is on'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, 'Horizontal axis'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Direction: horizontal'), findsOneWidget);
  });
}

Future<void> _pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const ReorderableListApp());
  await tester.pumpAndSettle();
}
