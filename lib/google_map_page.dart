import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plan_it/create_event.dart';
import 'package:plan_it/directions_repository.dart';
import 'package:plan_it/event_details.dart';
import 'directions_model.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});


  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  static const initPos = LatLng(7.850129, 125.047322);
  bool markCoord = false;
  GoogleMapController ?googleMapController;
  Marker ?event;
  final dbRef = FirebaseDatabase.instance.ref().child('events');
  Set<Marker> markers = {};
  Map<String, dynamic> inputs = {};
  Directions? _info;

  void _markEvent(LatLng pos) {
    print("put marker");
    setState(() {
      if (event != null) {
        markers.remove(event);
      }
      event = Marker(
        markerId: const MarkerId('event'),
        infoWindow: const InfoWindow(title: 'event'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        position: pos
      );
      markers.add(event!);
      print(markers);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  void _fetchEvents() {
    dbRef.onValue.listen((onData) {
    final data = onData.snapshot.value as Map?;
    if (data != null) {
      setState(() {
        markers.clear();
        data.forEach((key, value) {
          final name = value['name'];
          final description = value['description'];
          final coordinates = value['coordinates'];
          final coordList = coordinates.split(',');

          if (coordList.length == 2) {
            final lat = double.parse(coordList[0]);
            final lng = double.parse(coordList[1]);
            markers.add(
              Marker(
                markerId: MarkerId(key),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(title: name, snippet: description),
                onTap: () => _showEvent(key),
              ),
            );
          }
        });
      });
    }
    });
  }

  void _showEvent(String eventId) async {
    print(eventId);
    Map<dynamic, dynamic> eventData = {};
    // reader
    final snapshot = await dbRef.child(eventId).get();
    if (snapshot.exists) {
      eventData = snapshot.value as Map;
    }
    print(eventData);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context, 
      builder: (ctx) => EventDetails(eventData: eventData,));
  }

  void _createEvent() {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context, 
      builder: (ctx) => CreateEvent(
        onMarkEvent: _onMarkEvent,
        inputs: inputs,
      ));
  }

  void _onMarkEvent(bool val) {
    setState(() {
      markCoord = val;
    });
  }

  void getDirections(LatLng origin, LatLng destination) async {
    final directions = await DirectionsRepository().getDirections(origin: origin, destination: destination);
    setState(() => _info = directions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: initPos,
              zoom: 13,
            ),
            onTap: markCoord ? _markEvent : null,
            markers: markers,
            polylines: {
              if (_info != null) 
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.blue,
                  width: 5,
                  points: _info.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                )
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: !markCoord ? FloatingActionButton(
              onPressed: _createEvent,
              child: const Icon(Icons.add),
            ) : Container(),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                markCoord ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (event != null) {
                        inputs.remove('eventCoordinates');
                        markers.remove(event);
                        event = null;
                      }
                      markCoord = false;
                    });
                  },
                  child: const Text('Cancel'),
                ) : Container(),
                markCoord ? ElevatedButton(
                  onPressed: () {
                    if (event != null) {
                      inputs['eventCoordinates'] = "${event!.position.latitude.toStringAsFixed(6)}, ${event!.position.longitude.toStringAsFixed(6)}";
                    }
                    _createEvent();
                  },
                  child: const Text('Done'),
                ) : Container()
              ],
            ),
          )
        ],
      ),
    );
  }
}