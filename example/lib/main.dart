import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_places_dialog/flutter_places_dialog.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PlaceDetails _place;

  @override
  void initState() {
    super.initState();
    FlutterPlacesDialog
        .setGoogleApiKey(/*"AIzaSyBVJ6DGEqQv4lRicySx0siZTCk-9lXY6lY" */"");
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  showPlacePicker() async {
    PlaceDetails place;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      place = await FlutterPlacesDialog.getPlacesDialog();
    } on PlatformException {
      place = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    print("$place");
    setState(() {
      _place = place;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_place == null) {
      body = new Center(
        child: new Text('No place picked'),
      );
    } else {
      body = new ListView(
        children: <Widget>[
          new Text(_place.address),
          new Text(_place.name),
          new Text(_place.placeid),
          new Text(_place.location.latitude.toString() +
              ", " +
              _place.location.longitude.toString())
        ],
      );
    }
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
          actions: <Widget>[
            new FlatButton(
              onPressed: showPlacePicker,
              child: new Text("Pick"),
            ),
          ],
        ),
        body: body,
      ),
    );
  }
}
