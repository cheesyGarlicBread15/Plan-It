import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plan_it/Buttons/button1.dart';
import 'package:plan_it/create_event.dart';
import 'package:plan_it/event_details.dart';

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
    try {
      final data = onData.snapshot.value as Map?;
      if (data != null && data.isNotEmpty) {
        setState(() {
          markers.clear();
          data.forEach((key, value) {
            final name = value['name'];
            final description = value['description'];
            final coordinates = value['coordinates'];

            if (coordinates != null && coordinates.isNotEmpty) {
              final coordList = coordinates.split(',');

              if (coordList.length == 2) {
                final lat = double.tryParse(coordList[0]);
                final lng = double.tryParse(coordList[1]);

                if (lat != null && lng != null) {
                  markers.add(
                    Marker(
                      markerId: MarkerId(key),
                      position: LatLng(lat, lng),
                      infoWindow: InfoWindow(title: name, snippet: description),
                      onTap: () => _showEvent(key),
                    ),
                  );
                } else {
                  print("Invalid coordinates for event: $key");
                }
              }
            }
          });
        });
      } else {
        setState(() {
          markers.clear(); 
        });
        print("No events found in the database.");
      }
    } catch (e) {
      print("Error fetching events: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load events.')),
      );
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
      builder: (ctx) => Container(
        width: MediaQuery.of(context).size.width,
        child: FractionallySizedBox(
          heightFactor: 0.35,
          child: EventDetails(eventData: eventData),
        ),
      ),
    );
      
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: const CameraPosition(
              target: initPos,
              zoom: 13,
            ),
            onTap: markCoord ? _markEvent : null,
            markers: markers,
          ),
          Positioned(
            bottom: 20,
            right: 20,
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
                markCoord ? Button1(
                  func: () {
                    setState(() {
                      if (event != null) {
                        inputs.remove('eventCoordinates');
                        markers.remove(event);
                        event = null;
                      }
                      markCoord = false;
                    });
                  },
                  text: 'Cancel',
                ) : Container(),
                const SizedBox(width: 20,),
                markCoord ? Button1(
                  func: () {
                    if (event != null) {
                      inputs['eventCoordinates'] = "${event!.position.latitude.toStringAsFixed(6)}, ${event!.position.longitude.toStringAsFixed(6)}";
                    }
                    _createEvent();
                  },
                  text: 'Done',
                ) : Container()
              ],
            ),
          )
        ],
      ),
    );
  }
}