RegExp emailRegex = RegExp(
  r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
  caseSensitive: false,
  multiLine: false,
);

RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d\W_]{6,}$');

extension FirstWhereExt<T> on List<T> {
  T? firstWhereOrNull(bool Function(T e) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
