import 'package:material_ui/material_ui.dart';
import 'package:reorderable_list_demo/screens/builder_demo.dart';
import 'package:reorderable_list_demo/screens/horizontal_demo.dart';
import 'package:reorderable_list_demo/screens/lab_demo.dart';
import 'package:reorderable_list_demo/screens/vertical_demo.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ReorderableListView')),
      body: IndexedStack(
        index: _index,
        sizing: StackFit.expand,
        children: const <Widget>[
          VerticalDemo(),
          HorizontalDemo(),
          BuilderDemo(),
          LabDemo(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (int index) {
          setState(() {
            _index = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.format_list_bulleted),
            label: 'List',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz),
            label: 'Horizontal',
          ),
          NavigationDestination(
            icon: Icon(Icons.dynamic_feed),
            label: 'Builder',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune),
            label: 'Lab',
          ),
        ],
      ),
    );
  }
}
