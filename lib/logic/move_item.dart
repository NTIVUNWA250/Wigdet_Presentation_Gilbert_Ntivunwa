// onReorderItem already subtracts one when a row moves downward.
// Insert at newIndex directly. Do not adjust it again.
void moveItem<T>(List<T> items, int oldIndex, int newIndex) {
  final T item = items.removeAt(oldIndex);
  items.insert(newIndex, item);
}
