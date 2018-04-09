import 'dart:async';
import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:location/location.dart' as locasion;

var defaultTargetPlatform;
void main() {
  defaultTargetPlatform == TargetPlatform.iOS
      ? MapView.setApiKey("AIzaSyDP3b1uwZfcHSIZz_5_w19bEOXA7zQZgPA")
      : MapView.setApiKey("AIzaSyChWsUeFh6eZpiYPksGVMrfL2Ni1ZH9bj0");
  runApp(MaterialApp(
    home: MyMap(),
  ));
}

class MyMap extends StatefulWidget {
  @override
  MyMapState createState() => new MyMapState();
}

class MyMapState extends State<MyMap> {
  final formKey = new GlobalKey<FormState>();
  final TextEditingController _controller = new TextEditingController();

  var mapView = new MapView();
  var tapLocation;
  CameraPosition cameraPosition;

  locasion.Location userLocation = new locasion.Location();

  String _name;
  String _city;
  String _fatherName;

  void _submit() {
    final form = formKey.currentState;
    // if (form.validate()) {
    form.save();
    setState(() {
      _name;
      _city;
      _fatherName;
    });
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Alert'),
          content:
              Text('Name: $_name, FathersName: $_fatherName, city: $_city'),
        ));
    // }
  }

  Future _pickPlaceOfBirth() async {
    var getPresentLocation = await userLocation.getLocation;
    print('location ${getPresentLocation}');
    mapView.show(
        MapOptions(
          showUserLocation: true,
          title: "Choose a place",
          initialCameraPosition: CameraPosition(
              Location(getPresentLocation["latitude"],
                  getPresentLocation['longitude']),
              15.0),
        ),
        toolbarActions: <ToolbarAction>[
          ToolbarAction("Close", 1),
        ]);

    mapView.onToolbarAction.listen((id) {
      if (id == 1) {
        print('1');
        mapView.dismiss();
      }
    });

    mapView.onMapTapped.listen((location) {
      print("Touched location ${location.latitude}");
      tapLocation = location;
      addMarkerToMap(location);
      // setState(() {
      //   tapLocation;
      // });
    });

    mapView.onTouchAnnotation.listen((marker) {
      print("marker tapped");

      mapView.setMarkers(<Marker>[]);
      // showDialog(
      //     context: context,
      //     child: AlertDialog(
      //       title: Text('Confirm birth place'),
      //       content: Text(''),
      //       actions: <Widget>[
      //         FlatButton(
      //           child: Text('Regret'),
      //           onPressed: () {
      //             mapView.setMarkers(<Marker>[]);
      //           },
      //         ),
      //         FlatButton(
      //           child: Text('yes'),
      //           onPressed: () {
      //             mapView.dismiss();
      //           },
      //         )
      //       ],
      //     ));
    });
  }

  addMarkerToMap(location) {
    mapView.addMarker(Marker(
        "1", "panda", location.latitude, location.longitude,
        color: Colors.purple));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Astrology'),
        backgroundColor: Colors.black45,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      // validator: (value) =>
                      //     !value.contains('@') ? 'Not a valid email.' : null,
                      onSaved: (val) => _name = val,
                      decoration: const InputDecoration(
                        hintText: 'Enter your Name',
                        labelText: 'Name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      // validator: (value) =>
                      //     !value.contains('@') ? 'Not a valid email.' : null,
                      onSaved: (val) => _fatherName = val,
                      decoration: const InputDecoration(
                        hintText: 'Enter your Father Name',
                        labelText: 'Father Name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      // validator: (value) =>
                      //     !value.contains('@') ? 'Not a valid email.' : null,
                      onSaved: (val) => _city = val,
                      decoration: const InputDecoration(
                        hintText: 'Enter your City of Birth',
                        labelText: 'City',
                      ),
                    ),
                  ),
                  Divider(
                    height: 50.0,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: RaisedButton(
                          onPressed: _submit,
                          child: Text('Submit'),
                        ),
                      ),
                      RaisedButton(
                        onPressed: _pickPlaceOfBirth,
                        child: Text('Location'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
