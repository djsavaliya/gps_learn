import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _position;
  String _address;
  var _speedInMps = "0.0";
  LocationOptions _locationOptions = LocationOptions(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 0,
    timeInterval: 0,
  );

  void _getSpeed() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _position = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
    geolocator.getPositionStream(_locationOptions).listen((Position position) {
      _speedInMps = "${position.speed}";
    });
    print(_speedInMps);
    setState(() {});
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _position.latitude, _position.longitude);

      Placemark place = p[0];

      setState(() {
        _address =
        "${place.name}, ${place.subLocality}, \n${place.locality}, \n${place.administrativeArea}, ${place.postalCode}, \n${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getSpeed());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*Timer.periodic(Duration(seconds: 1), (Timer t) {
      _getSpeed();
    });*/

    return Scaffold(
      appBar: AppBar(
        title: Text("GPS"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Text(_speedInMps),
            if (_position != null)
              Text("(${_position.latitude}\t,\t${_position.longitude})\n"+_address+"\n${_position.speed}"),
          ],
        ),
      ),
    );
  }

}


/*class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _position;
  String _address;
  var _speedInMps,_heading;
  LocationOptions _locationOptions = LocationOptions(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 0,
    timeInterval: 0,
  );

  @override
  void initState() {
    _getSpeed();
    _getCurrentLocation();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //_getSpeed(),
            Text(_speedInMps+"\t\t\t"+_heading),
            if (_position != null)
              Text("(${_position.latitude}\t,\t${_position.longitude})\n"+_address+"\n${_position.speed}"),
            FlatButton(
              child: Text("Refresh"),
              onPressed: () {
                _getCurrentLocation();
              },
            ),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _position = position;
      });

      //_getSpeed();
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getSpeed() {
    geolocator.getPositionStream(_locationOptions).listen((Position position) {
      _heading = "${position.heading}";
      _speedInMps = "${position.speed}";
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _position.latitude, _position.longitude);

      Placemark place = p[0];

      setState(() {
        _address =
        "${place.name}, ${place.subLocality}, \n${place.locality}, \n${place.administrativeArea}, ${place.postalCode}, \n${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
}*/