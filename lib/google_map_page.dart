import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plan_it/create_event.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  static const initPos = LatLng(37.4223, -122.0848);

  void _createEvent() {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context, 
      builder: (ctx) => CreateEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: initPos,
          zoom: 13
        ),
        markers: {
          const Marker(
            markerId: MarkerId('eventId'),
            icon: BitmapDescriptor.defaultMarker,
            position: initPos
          )
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createEvent,
        child: const Icon(Icons.add),
      ),
    );
  }
}