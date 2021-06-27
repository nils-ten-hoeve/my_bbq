import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_bbq/theme/extended_theme.dart';

import 'command.dart';
import 'command_icon_text.dart';

class CommandPopupMenu {
  final List<Command> commands;

  CommandPopupMenu(
    BuildContext context,
    this.commands, {
    String? title,
    Command? selectedCommand,
    RelativeRect? position,
    double? elevation,
    ShapeBorder? shape,
    Color? color,
    String? semanticLabel,
    bool useRootNavigator = false,
  }) {
    if (position == null) {
      position = positionInMiddleOfScreen(context);
    }

    List<Command> visibleCommands =
        commands.where((command) => command.visible).toList();

    if (visibleCommands.isNotEmpty) {
      showMenu<Command>(
              context: context,
              position: position,
              initialValue: selectedCommand,
              elevation: elevation,
              color: color,
              semanticLabel: semanticLabel,
              useRootNavigator: useRootNavigator,
              shape: (shape == null)
                  ? ExtendedTheme.roundedRectangleBorder
                  : shape,
              items: createItems(context, title, visibleCommands))
          .then((command) => command!.action());
    }
  }

  RelativeRect positionInMiddleOfScreen(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double assumedPopUpWidth = 220;
    return RelativeRect.fromLTRB(
        (screenWidth - assumedPopUpWidth) / 2, 100, screenWidth, 100);
  }

  List<PopupMenuItem<Command>> createItems(
      BuildContext context, String? title, List<Command> visibleCommands) {
    return [
      if (title != null && title.isNotEmpty) createTitle(context, title),
      ...visibleCommands
          .map((command) => CommandPopupMenuItem(command))
          .toList()
    ];
  }

  PopupMenuItem<Command> createTitle(BuildContext context, String title) =>
      PopupMenuItem(
        child: Text(title),
        enabled: false,
        textStyle: Theme.of(context).textTheme.headline6,
      );
}

class CommandPopupMenuItem extends PopupMenuItem<Command> {
  CommandPopupMenuItem(Command command)
      : super(value: command, child: CommandIconAndText(command));
}
