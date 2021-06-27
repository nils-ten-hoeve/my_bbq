import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'command.dart';


final _iconPlaceholder = CommandIcon._(
  Icons.adjust,
  color: Colors.transparent,
);

class CommandIcon extends Icon {
  CommandIcon._(IconData icon,
      {Key? key,
        double? size,
        Color? color,
        String? semanticLabel,
        TextDirection? textDirection})
      : super(icon,
      key: key,
      size: size,
      color: color,
      semanticLabel: semanticLabel,
      textDirection: textDirection);

  factory CommandIcon(Command command, Color foreGroundColor) {
    //TODO get foreGroundColor from Theme
    IconData? iconData = command.icon;
    if (iconData == null) {
      return _iconPlaceholder;
    } else {
      return CommandIcon._(
        iconData,
        color: foreGroundColor,
      );
    }
  }
}

class CommandIconAndText extends StatelessWidget {
  final Command command;

  CommandIconAndText(this.command);

  @override
  Widget build(BuildContext context) {
    Color foreGroundColor = Theme.of(context).textTheme.bodyText1!.color!;
    return Row(children: [
      CommandIcon(command, foreGroundColor),
      SizedBox(
        width: 10,
      ),
      Text(command.name, style: TextStyle(color: foreGroundColor))
    ]);
  }
}