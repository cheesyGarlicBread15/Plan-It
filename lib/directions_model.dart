import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;

  const Directions({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    // if ((map['routes'] as List).isEmpty) return null;

    final data = Map<String, dynamic>.from(map['routes'][0]);

    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      southwest: LatLng(southwest['lat'], southwest['lng']), 
      northeast: LatLng(northeast['lat'], northeast['lng'])
    );

    String distance = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
    }

    return Directions(
      bounds: bounds, 
      polylinePoints: PolylinePoints().decodePolyline(data['overview_polyline']['points']), 
      totalDistance: distance
      );
  }

}