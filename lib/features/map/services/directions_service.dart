import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/google_keys.dart';

class DirectionsService {
  static const String _base =
      'https://maps.googleapis.com/maps/api/directions/json';

  static Future<Polyline?> getRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final uri = Uri.parse(
      '$_base?origin=${origin.latitude},${origin.longitude}'
      '&destination=${destination.latitude},${destination.longitude}'
      '&mode=driving&key=$googleMapsApiKey',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return null;

    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;

    final List routes = data['routes'] as List? ?? [];
    if (routes.isEmpty) return null;

    final Map<String, dynamic> route = routes.first as Map<String, dynamic>;

    final Map<String, dynamic> overview =
        route['overview_polyline'] as Map<String, dynamic>;

    final String encodedPoints = overview['points'] as String;

    final decodedPoints = _decodePolyline(encodedPoints);

    return Polyline(
      polylineId: const PolylineId('route'),
      width: 5,
      color: const Color(0xFF1E88E5),
      points: decodedPoints,
    );
  }

  // 🔹 Polyline decoder
  static List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, lat = 0, lng = 0;

    while (index < encoded.length) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      lat += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      lng += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }
}
