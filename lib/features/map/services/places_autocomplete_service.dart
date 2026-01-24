import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/config/google_keys.dart';

class PlacesAutocompleteService {
  static const String _base =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  static Future<List<Map<String, String>>> getSuggestions(
    String input,
  ) async {
    if (input.trim().isEmpty) return [];

    final uri = Uri.parse(
      '$_base?input=${Uri.encodeComponent(input)}'
      '&components=country:in'
      '&key=$googleMapsApiKey',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return [];

    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;

    final List predictions = data['predictions'] as List? ?? [];

    return predictions
        .map<Map<String, String>>((p) => {
              'description': p['description'] as String,
              'place_id': p['place_id'] as String,
            })
        .toList();
  }
}
