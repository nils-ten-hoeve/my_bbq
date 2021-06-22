import 'package:flutter/widgets.dart';

class Command {
  String Function() _nameFunction;
  IconData? Function() _iconFunction;
  bool Function() _visibleFunction;
  void Function() action;

  Command({
    required String name,
    IconData? icon,
    bool visible = true,
    required this.action,
  })  : _nameFunction = stringFunction(name),
        _iconFunction = iconFunction(icon),
        _visibleFunction = booleanFunction(visible);

  Command.dynamic({
    required String Function() nameFunction,
    required IconData? Function() iconFunction,
    required bool Function() visibleFunction,
    required this.action,
  })  : _nameFunction = nameFunction,
        _iconFunction = iconFunction,
        _visibleFunction = visibleFunction;

  static String Function() stringFunction(String value) => () => value;

  static bool Function() booleanFunction(bool value) => () => value;

  static IconData? Function() iconFunction(IconData? value) => () => value;

  String get name => _nameFunction();

  IconData? get icon => _iconFunction();

  bool get visible => _visibleFunction();

  void execute() {
    action();
  }
}