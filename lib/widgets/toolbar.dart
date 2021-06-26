import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:overflow_view/overflow_view.dart';

import 'command.dart';

class CommandToolbar extends StatelessWidget {
  final List<Command> commands;

  CommandToolbar(this.commands);

  @override
  Widget build(BuildContext context) {
    Color backGroundColor = Theme.of(context).dialogBackgroundColor;

    List<Command> visibleCommands =
        commands.where((command) => command.visible).toList();
    return Visibility(
        visible: visibleCommands.isNotEmpty,
        child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            color: backGroundColor,
            height: 50,
            child: Align(
              alignment: Alignment.centerRight,
              child: OverflowView.flexible(
                  spacing: 20,
                  children: visibleCommands
                      .map((command) => CommandToolbarButton(command))
                      .toList(),
                  builder: (context, remaining) {
                    return CommandToolBarMoreButton(visibleCommands, remaining);
                  }),
            )));
  }
}

class CommandToolBarMoreButton extends StatelessWidget {
  final List<Command> visibleCommands;
  final int remaining;
  final buttonKey = GlobalKey();

  CommandToolBarMoreButton(this.visibleCommands, this.remaining);

  @override
  Widget build(BuildContext context) {
    Color foreGroundColor = Theme.of(context).textTheme.bodyText1!.color!;

    return TextButton(
      key: buttonKey,
      style: TextButton.styleFrom(
          padding: EdgeInsets.all(20),
          primary: foreGroundColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)))),
      child: Icon(Icons.more_horiz),
      onPressed: () {
        CommandPopupMenu(
          context,
          visibleCommands.skip(visibleCommands.length - remaining).toList(),
          position: calculatePopUpMenuPosition(),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0))),
        );
      },
    );
  }

  RelativeRect? calculatePopUpMenuPosition() {
    var buttonKeyContext = buttonKey.currentContext;
    if (buttonKeyContext != null) {
      final RenderBox box = buttonKeyContext.findRenderObject() as RenderBox;
      Offset buttonPosition = box.localToGlobal(Offset.zero);
      Size buttonSize = box.size;
      Size screenSize = MediaQuery.of(buttonKeyContext).size;
      return RelativeRect.fromLTRB(screenSize.width,
          buttonPosition.dy + buttonSize.height+2, 0, screenSize.height);
    }
    return null;
  }
}

final iconPlaceholder = Icon(
  Icons.adjust,
  color: Colors.transparent,
);

Icon? createCommandIcon(Command command, Color foreGroundColor,
    {bool isIconPlaceholder = false}) {
  IconData? icon = command.icon;
  if (icon == null) {
    if (isIconPlaceholder) {
      return iconPlaceholder;
    } else {
      return null;
    }
  } else {
    return Icon(
      command.icon,
      color: foreGroundColor,
    );
  }
}

class CommandIconAndText extends StatelessWidget {
  final Command command;

  CommandIconAndText(this.command);

  @override
  Widget build(BuildContext context) {
    Color foreGroundColor = Theme.of(context).textTheme.bodyText1!.color!;
    return Row(children: [
      createCommandIcon(command, foreGroundColor, isIconPlaceholder: true)!,
      SizedBox(
        width: 10,
      ),
      Text(command.name, style: TextStyle(color: foreGroundColor))
    ]);
  }
}

class CommandPopupMenu {
  final List<Command> commands;

  CommandPopupMenu(
    BuildContext context,
    this.commands, {
    Command? selectedCommand,
    RelativeRect? position,
    double? elevation,
    ShapeBorder? shape,
    Color? color,
    bool useRootNavigator = false,
  }) {
    if (position == null) {
      position = positionInMiddleOfScreen(context);
    }
    List<Command> visibleCommands =
        commands.where((command) => command.visible).toList();

    showMenu<Command>(
            context: context,
            position: position,
            initialValue: selectedCommand,
            elevation: elevation,
            color: color,
            shape: (shape == null) ? createDefaultShape() : shape,
            items: visibleCommands
                .map((command) => CommandPopupMenuItem(command))
                .toList())
        .then((command) => command!.action());
  }

  RelativeRect positionInMiddleOfScreen(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double assumedPopUpWidth = 220;
    return RelativeRect.fromLTRB(
        (screenWidth - assumedPopUpWidth) / 2, 100, screenWidth, 100);
  }

  ShapeBorder createDefaultShape() => RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)));
}

class CommandPopupMenuItem extends PopupMenuItem<Command> {
  CommandPopupMenuItem(Command command)
      : super(value: command, child: CommandIconAndText(command));
}

class CommandToolbarButton extends StatelessWidget {
  final Command command;

  CommandToolbarButton(this.command);

  @override
  Widget build(BuildContext context) {
    Color foreGroundColor = Theme.of(context).textTheme.bodyText1!.color!;

    Icon? icon = createCommandIcon(command, foreGroundColor);
    if (icon == null) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 50,
        ),
        child: TextButton(
          child: Text(
            command.name,
          ),
          style: TextButton.styleFrom(
              padding: EdgeInsets.all(20),
              primary: foreGroundColor,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)))),
          onPressed: () {
            command.action();
          },
        ),
      );
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 50,
        ),
        child: TextButton.icon(
          style: TextButton.styleFrom(
              primary: foreGroundColor,
              padding: EdgeInsets.all(20),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)))),
          label: Text(
            command.name,
          ),
          icon: icon,
          onPressed: () {
            command.action();
          },
        ),
      );
    }
  }
}
