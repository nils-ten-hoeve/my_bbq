import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HeaterMeterService extends ChangeNotifier {
  HeaterMeter? _selectedHeaterMeter;

  HeaterMeter? get connectedHeaterMeter => _selectedHeaterMeter;

  set connectedHeaterMeter(HeaterMeter? selectedHeaterMeter) {
    _selectedHeaterMeter = selectedHeaterMeter;
    notifyListeners();
  }

  get isConnected => connectedHeaterMeter != null;

  Future<List<HeaterMeter>> findHeaterMeters() async {
    //String jsonString= '{"ip":"86.95.190.210","guess":"192.168.2.42","total":{"all":4529,"week":251,"month":697},"devices":[{"device_id":"4002","model":"BCM2835","revision":"a020d3","serial":"0000000025ec6378","hostname":"LEDE","seen":"1623586507","uptime":"7343","interfaces":[{"name":"eth0","addr":"192.168.200.1","packets":"0"},{"name":"wlan0","addr":"192.168.2.42","packets":"23536"}]}]}';
    /// returns {"ip":"86.95.190.210","guess":"192.168.2.42","total":{"all":4529,"week":251,"month":697},"devices":[{"device_id":"4002","model":"BCM2835","revision":"a020d3","serial":"0000000025ec6378","hostname":"LEDE","seen":"1623586507","uptime":"7343","interfaces":[{"name":"eth0","addr":"192.168.200.1","packets":"0"},{"name":"wlan0","addr":"192.168.2.42","packets":"23536"}]}]}
    Response response =
        await http.get(Uri.parse('https://heatermeter.com/devices/?fmt=json'));

    if (response.statusCode != 200) {
      throw Exception(
          'Could not connect to https://heatermeter.com: Http error code: ${response.statusCode}');
    } else {
      print(response.body);
      var json = jsonDecode(response.body);
      var devicesJson = json['devices'];
      if (devicesJson == null) {
        throw new Exception('Could not find any HeaterMeters on the network!');
      }

      List<HeaterMeter> heaterMeters = List<HeaterMeter>.from(
          devicesJson.map((deviceJson) => HeaterMeter.fromJson(deviceJson)));

      if (heaterMeters.isEmpty) {
        throw Exception("No HeaterMeter's found in your local network.");
      }

      return heaterMeters;
    }
  }
}

class HeaterMeter {
  final String ipAddress;

  HeaterMeter.fromJson(Map<String, dynamic> deviceJson)
      : ipAddress = findIpAddress(deviceJson);

  @override
  String toString() {
    return ipAddress;
  }

  static findIpAddress(var deviceJson) {
    var interfaces = List.from(deviceJson['interfaces']);
    for (var interface in interfaces) {
      if (interface['name'] == 'wlan0') return interface['addr'];
    }
    throw ('Could not find ip address of HeaterMeter');
  }
}
