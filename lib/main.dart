import 'package:flutter/material.dart';
import 'package:my_bbq/page/connect.dart';
import 'package:my_bbq/page/navigation.dart';
import 'package:my_bbq/page/recipe.dart';
import 'package:provider/provider.dart';

import 'domain/heater_meter.dart';
import 'domain/recipe.dart';

void main() {
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Navigation()),
        ChangeNotifierProvider(create: (context) => RecipeService()),
        ChangeNotifierProvider(create: (context) => HeaterMeterService()),
        //Provider(create: (context) => SomeOtherClass()),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      //home: ConnectPage(),
      home: MainScaffold(),
    );
  }
}

class MainScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HeaterMeterService heaterMeterService =
        Provider.of<HeaterMeterService>(context);
    return Scaffold(
        appBar: AppBar(
            title: (heaterMeterService.isConnected)
                ? Text(
                    'HeaterMeter ${heaterMeterService.connectedHeaterMeter!.ipAddress}')
                : Text('HeaterMeter not connected')),
        drawer: DrawerMenu(),
        body: Provider.of<Navigation>(context).currentPage);
  }
}

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isConnected=Provider.of<HeaterMeterService>(context).isConnected;
    return Drawer(
        child: Scaffold(
          appBar: AppBar(title: Text('Menu')),
          body: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  title: Text('Connect'),
                  leading: Icon(Icons.settings_ethernet),
                  onTap: () {
                    openNewPage(context, ConnectPage());
                    closeMenu(context);
                  },
                ),
                if (isConnected) //Menu item Temperatures only visible when connected
                ListTile(
                  title: Text('Temperatures'),
                  leading: Icon(Icons.thermostat),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                if (isConnected) //Menu item Graph only visible when connected
                ListTile(
                  title: Text('Graph'),
                  leading: Icon(Icons.auto_graph),
                  onTap: () {
                    openNewPage(context, RecipeListPage());
                    closeMenu(context);
                  },
                ),
                if (isConnected) //Menu item Settings only visible when connected
                ListTile(
                  title: Text('Settings'),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  title: Text('Recipes'),
                  leading: Icon(Icons.book_outlined),
                  onTap: () {
                    openNewPage(context, RecipeListPage());
                    closeMenu(context);
                  },
                ),
              ]),
        ),
      );
  }

  void closeMenu(BuildContext context) => Navigator.pop(context);
}

// import 'package:flutter/material.dart';
// import 'package:overflow_view/overflow_view.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class Avatar {
//   const Avatar(this.initials, this.color);
//   final String initials;
//   final Color color;
// }
//
// const List<Avatar> avatars = <Avatar>[
//   Avatar('AD', Colors.green),
//   Avatar('JG', Colors.pink),
//   Avatar('DA', Colors.blue),
//   Avatar('JA', Colors.black),
//   Avatar('CB', Colors.amber),
//   Avatar('RR', Colors.deepPurple),
//   Avatar('JD', Colors.pink),
//   Avatar('MB', Colors.amberAccent),
//   Avatar('AA', Colors.blueAccent),
//   Avatar('BA', Colors.tealAccent),
//   Avatar('CR', Colors.yellow),
// ];
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 1;
//   double ratio = 1;
//
//   void _incrementCounter() {
//     setState(() {
//       _counter = (_counter + 1).clamp(0, avatars.length - 1);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'People',
//                 style: TextStyle(fontSize: 20),
//               ),
//               SizedBox(height: 20),
//               OverflowView.flexible(
//                 spacing: -40,
//                 children: <Widget>[
//                   for (int i = 0; i < _counter; i++)
//                     AvatarWidget(
//                       text: avatars[i].initials,
//                       color: avatars[i].color,
//                     )
//                 ],
//                 builder: (context, remaining) {
//                   return AvatarWidget(
//                     text: '+$remaining',
//                     color: Colors.red,
//                   );
//                 },
//               ),
//               SizedBox(height: 20),
//               FractionallySizedBox(
//                 widthFactor: ratio,
//                 child: CommandBar(),
//               ),
//               SizedBox(height: 20),
//               Expanded(
//                 child: OverflowView(
//                   direction: Axis.vertical,
//                   spacing: 4,
//                   children: <Widget>[
//                     for (int i = 0; i < _counter; i++)
//                       AvatarWidget(
//                         text: avatars[i].initials,
//                         color: avatars[i].color,
//                       )
//                   ],
//                   builder: (context, remaining) {
//                     return SizedBox(
//                       height: 80,
//                       width: 80,
//                       child: Stack(
//                         fit: StackFit.expand,
//                         children: [
//                           if (remaining > 0)
//                             AvatarOverview(
//                               position: 0,
//                               remaining: remaining,
//                               counter: _counter,
//                             ),
//                           if (remaining > 1)
//                             AvatarOverview(
//                               position: 1,
//                               remaining: remaining,
//                               counter: _counter,
//                             ),
//                           if (remaining > 2)
//                             AvatarOverview(
//                               position: 2,
//                               remaining: remaining,
//                               counter: _counter,
//                             ),
//                           if (remaining > 3)
//                             AvatarOverview(
//                               position: 3,
//                               remaining: remaining,
//                               counter: _counter,
//                             ),
//                           Positioned.fill(
//                             child: Center(
//                               child: FractionallySizedBox(
//                                 alignment: Alignment.center,
//                                 widthFactor: 0.5,
//                                 heightFactor: 0.5,
//                                 child: FittedBox(
//                                   child: AvatarWidget(
//                                     text: '+$remaining',
//                                     color: Colors.black.withOpacity(0.9),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               // Slider(
//               //   value: ratio,
//               //   min: 0,
//               //   max: 1,
//               //   divisions: 100,
//               //   onChanged: (value) {
//               //     setState(() {
//               //       ratio = value;
//               //     });
//               //   },
//               // ),
//               SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
//
// class AvatarOverview extends StatelessWidget {
//   AvatarOverview({
//     Key? key,
//     required int remaining,
//     required int position,
//     required int counter,
//   })  : index = counter - remaining + position,
//         alignment = _getAlignment(position),
//         super(key: key);
//
//   final int index;
//   final Alignment alignment;
//
//   @override
//   Widget build(BuildContext context) {
//     final Avatar avatar = avatars[index];
//     return FractionallySizedBox(
//       key: ValueKey(index),
//       alignment: alignment,
//       widthFactor: 0.5,
//       heightFactor: 0.5,
//       child: FittedBox(
//         child: AvatarWidget(
//           text: avatar.initials,
//           color: avatar.color,
//         ),
//       ),
//     );
//   }
//
//   static Alignment _getAlignment(int position) {
//     switch (position) {
//       case 0:
//         return Alignment.topLeft;
//       case 1:
//         return Alignment.topRight;
//       case 2:
//         return Alignment.bottomLeft;
//       default:
//         return Alignment.bottomRight;
//     }
//   }
// }
//
// class AvatarWidget extends StatelessWidget {
//   const AvatarWidget({
//     Key?  key,
//     required this.text,
//     required this.color,
//   }) : super(key: key);
//
//   final String text;
//   final Color color;
//
//   @override
//   Widget build(BuildContext context) {
//     return CircleAvatar(
//       radius: 40,
//       backgroundColor: color,
//       foregroundColor: Colors.white,
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 30),
//       ),
//     );
//   }
// }
//
// class CommandBar extends StatelessWidget {
//   const CommandBar({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final List<MenuItemData> commands = <MenuItemData>[
//       MenuItemData(id: 'a', label: 'File'),
//       MenuItemData(id: 'b', icon: Icons.save, label: 'Save'),
//       MenuItemData(id: 'c', label: 'Edit'),
//       MenuItemData(id: 'd', label: 'View'),
//       MenuItemData(id: 'e', icon: Icons.exit_to_app),
//       MenuItemData(id: 'f', label: 'Long Command'),
//       MenuItemData(id: 'f', label: 'Very Long Command'),
//       MenuItemData(id: 'f', label: 'Very very Long Command'),
//       MenuItemData(id: 'f', label: 'Help'),
//     ];
//
//     return OverflowView.flexible(
//       spacing: -2,
//       children: [...commands.map((e) => _MenuItem(data: e))],
//       builder: (context, remaining) {
//         return PopupMenuButton<String>(
//           icon: Icon(Icons.menu),
//           itemBuilder: (context) {
//             return commands
//                 .skip(commands.length - remaining)
//                 .map((e) => PopupMenuItem<String>(
//               value: e.id,
//               child: _MenuItem(data: e),
//             ))
//                 .toList();
//           },
//         );
//       },
//     );
//   }
// }
//
// class MenuItemData {
//   const MenuItemData({
//     required this.id,
//     this.label,
//     this.icon,
//   });
//
//   final String id;
//   final String? label;
//   final IconData? icon;
// }
//
// class _MenuItem extends StatelessWidget {
//   const _MenuItem({
//     Key? key,
//     required this.data,
//   }) : super(key: key);
//
//   final MenuItemData data;
//
//   @override
//   Widget build(BuildContext context) {
//     return FlatButton(
//       onPressed: () {},
//       child: Row(
//         children: [
//           if (data.icon != null) Icon(data.icon),
//           if (data.icon != null && data.label != null) SizedBox(width: 8),
//           if (data.label != null) Text(data.label!),
//         ],
//       ),
//     );
//   }
// }
