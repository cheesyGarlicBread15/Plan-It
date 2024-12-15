import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'directions_model.dart';

class DirectionsRepository {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json?';
  final Dio _dio;
  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirections ({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin' : '${origin.latitude}, ${origin.longitude}',
        'destination' : '${destination.latitude}, ${destination.longitude}',
        'key' : 'AIzaSyD72qL18ghy5_v2e0ogyFbTpnhzfxmZdqs'
      }
    );

    return Directions.fromMap(response.data);

  }
}