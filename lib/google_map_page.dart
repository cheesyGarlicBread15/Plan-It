import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  

  void _getMarkCoord(LatLng pos) {
    print("put marker");
    setState(() {
      event = Marker(
        markerId: const MarkerId('event'),
        infoWindow: const InfoWindow(title: 'event'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        position: pos
      );
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
                infoWindow: InfoWindow(title: name),
                onTap: _showEvent
              ),
            );
          }
        });
      });
    }
    });
  }

  void _showEvent() {
    // include parameters event details and pass to EventDetails
    showModalBottomSheet(
      isScrollControlled: true,
      context: context, 
      builder: (ctx) => const EventDetails());
  }

  void _createEvent() {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context, 
      builder: (ctx) => CreateEvent(
        onCoordMark: () {
          setState(() {
            markCoord = true;
          });
          Navigator.pop(context);
        },
      ));
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
            onTap: markCoord ? _getMarkCoord : null,
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
                markCoord ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      event = null;
                      markCoord = false;
                    });
                  },
                  child: const Text('Cancel'),
                ) : Container(),
                markCoord ? ElevatedButton(
                  onPressed: () {
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