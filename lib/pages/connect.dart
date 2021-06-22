import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_bbq/domain/heater_meter.dart';
import 'package:provider/provider.dart';

import 'graph.dart';
import 'navigation.dart';

class ConnectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO try, catch and display errors and set HeaterMeterService.selectedHeaterMeter=null
    Provider.of<HeaterMeterService>(context, listen: false)
        .findHeaterMeters()
        .then((heaterMeters) {
      if (heaterMeters.length == 1) {
        Provider.of<HeaterMeterService>(context, listen: false)
            .connectedHeaterMeter = heaterMeters.first;
        openNewPage(context, GraphPage());
      } else {
        HeaterMeter selectedHeaterMeter = heaterMeters.first;
        //TODO Select a heater meter from heaterMeters list
        Provider.of<HeaterMeterService>(context, listen: false)
            .connectedHeaterMeter = selectedHeaterMeter;
        openNewPage(context, GraphPage());
      }
    });

    return ProgressIndicator();
  }
}

class ProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: 200,
              height: 200,
              child: new CircularProgressIndicator(
                strokeWidth: 15,
              ),
            ),
          ),
          Center(child: Text("Searching...")),
        ],
      ),
    );
  }
}
