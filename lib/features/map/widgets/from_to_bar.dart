import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/map_controller.dart';
import '../services/places_autocomplete_service.dart';
import '../services/places_service.dart';

class FromToBar extends StatefulWidget {
  final MapController controller;
  final VoidCallback onRoutePressed;

  const FromToBar({
    super.key,
    required this.controller,
    required this.onRoutePressed,
  });

  @override
  State<FromToBar> createState() => _FromToBarState();
}

class _FromToBarState extends State<FromToBar> {
  Timer? _debounce;

  void _onChanged(String value, bool isFrom) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final suggestions = await PlacesAutocompleteService.getSuggestions(value);

      if (!mounted) return;

      isFrom
          ? widget.controller.setFromSuggestions(suggestions)
          : widget.controller.setToSuggestions(suggestions);
    });
  }

  Future<void> _onSuggestionTap(
    Map<String, String> item,
    bool isFrom,
  ) async {
    final latLng = await PlacesService.getLatLngFromQuery(item['description']!);

    if (!mounted || latLng == null) return;

    if (isFrom) {
      widget.controller.fromLatLng = latLng;
      widget.controller.fromController.text = item['description']!;
      widget.controller.setFromSuggestions([]);
    } else {
      widget.controller.toLatLng = latLng;
      widget.controller.toController.text = item['description']!;
      widget.controller.setToSuggestions([]);
    }

    widget.controller.markers.add(
      Marker(
        markerId: MarkerId(isFrom ? 'from' : 'to'),
        position: latLng,
      ),
    );

    widget.controller.notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel(); // ✅ stop timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: c.fromController,
                  decoration: const InputDecoration(hintText: "From"),
                  onChanged: (v) => _onChanged(v, true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: c.toController,
                  decoration: const InputDecoration(hintText: "To"),
                  onChanged: (v) => _onChanged(v, false),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: widget.onRoutePressed,
                child: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
        if (c.fromSuggestions.isNotEmpty)
          _suggestionList(c.fromSuggestions, true),
        if (c.toSuggestions.isNotEmpty) _suggestionList(c.toSuggestions, false),
      ],
    );
  }

  Widget _suggestionList(
    List<Map<String, String>> list,
    bool isFrom,
  ) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (_, i) {
          final item = list[i];
          return ListTile(
            title: Text(item['description']!),
            onTap: () => _onSuggestionTap(item, isFrom),
          );
        },
      ),
    );
  }
}
