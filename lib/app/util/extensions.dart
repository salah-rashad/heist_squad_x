import 'package:bonfire/bonfire.dart';

extension DirectionExtensions on Direction {
  String getName() {
    return this.toString().replaceAll('Direction.', '');
  }
}

extension StringExtensions on String {
  Direction getDirectionEnum() {
    switch (this) {
      case 'left':
        return Direction.left;
      case 'right':
        return Direction.right;
      case 'top':
        return Direction.up;
      case 'bottom':
        return Direction.down;
      default:
        return Direction.left;
    }
  }
}
