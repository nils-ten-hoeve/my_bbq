import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'command.dart';

class Toolbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color backGroundColor = Theme.of(context).dialogBackgroundColor;

    List<Command> commands = [
      Command(
          name: 'Add',
          icon: Icons.add,
          action: () {
            //TODO
          }),
      Command(
          name: 'Export',
          icon: Icons.import_export,
          action: () {
            //TODO
          }),
      Command(
          name: 'import',
          icon: Icons.import_export,
          action: () {
            //TODO
          })
    ];

    List<Command> visibleCommands =
        commands.where((command) => command.visible).toList();
    return Visibility(
      visible: visibleCommands.isNotEmpty,
      child: Container(
        color: backGroundColor,
        height: 50,
        child: ButtonBar(
          children: [
            ...visibleCommands.map((action) => ToolbarButton(action)).toList()
          ],
        ),
      ),
    );
  }
}

class ToolbarButton extends StatelessWidget {
  final Command command;

  ToolbarButton(this.command);

  @override
  Widget build(BuildContext context) {
    Color foreGroundColor = Theme.of(context).textTheme.bodyText1!.color!;
    IconData? icon = command.icon;
    if (icon == null) {
      return TextButton(
        child: Text(
          command.name,
          style: TextStyle(color: foreGroundColor),
        ),
        onPressed: () {
          command.action();
        },
      );
    } else {
      return TextButton.icon(
        label: Text(
          command.name,
          style: TextStyle(color: foreGroundColor),
        ),
        icon: Icon(icon, color: foreGroundColor),
        onPressed: () {
          //TODO
        },
      );
    }
  }
}
