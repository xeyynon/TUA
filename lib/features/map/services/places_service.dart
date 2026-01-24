import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/google_keys.dart';

class PlacesService {
  // ✅ DEFINE BASE URL
  static const String _base =
      'https://maps.googleapis.com/maps/api/place/textsearch/json';

  static Future<LatLng?> getLatLngFromQuery(String query) async {
    if (query.trim().isEmpty) return null;

    final uri = Uri.parse(
      '$_base?query=${Uri.encodeComponent(query)}&key=$googleMapsApiKey',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return null;

    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;

    final List results = data['results'] as List? ?? [];
    if (results.isEmpty) return null;

    final Map<String, dynamic> geometry =
        results.first['geometry'] as Map<String, dynamic>;
    final Map<String, dynamic> location =
        geometry['location'] as Map<String, dynamic>;

    return LatLng(
      (location['lat'] as num).toDouble(),
      (location['lng'] as num).toDouble(),
    );
  }
}
