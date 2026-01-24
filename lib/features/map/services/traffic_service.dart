import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// ===============================
/// JUNCTION MODEL
/// ===============================
class Junction {
  final String id; // Supabase-safe (UUID / TEXT)
  final LatLng position;
  String congestion; // Low | Medium | High

  Junction({
    required this.id,
    required this.position,
    this.congestion = 'Low',
  });

  factory Junction.fromMap(Map<String, dynamic> map) {
    final coords = (map['location'] as String).split(',');

    return Junction(
      id: map['id'].toString(),
      position: LatLng(
        double.parse(coords[0].trim()),
        double.parse(coords[1].trim()),
      ),
      congestion: (map['congestion'] as String?) ?? 'Low',
    );
  }
}

/// ===============================
/// TRAFFIC SERVICE
/// ===============================
class TrafficService {
  final SupabaseClient _supabase = Supabase.instance.client;

  final List<Junction> _junctions = [];

  final StreamController<List<Junction>> _streamController =
      StreamController<List<Junction>>.broadcast();

  Stream<List<Junction>> get stream => _streamController.stream;

  /// ===============================
  /// 1️⃣ INITIAL FETCH
  /// ===============================
  Future<void> fetchJunctions() async {
    final res = await _supabase.from('junctions').select();

    _junctions
      ..clear()
      ..addAll(
        (res as List)
            .map(
              (e) => Junction.fromMap(e as Map<String, dynamic>),
            )
            .toList(),
      );

    _streamController.add(_junctions);
  }

  /// ===============================
  /// 2️⃣ REALTIME UPDATES
  /// ===============================
  void subscribe() {
    _supabase
        .channel('traffic')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'traffic_logs',
          callback: (payload) {
            final record = payload.newRecord;

            final String id = record['junction_id'].toString();
            final String level = record['congestion_level'] as String;

            final j = _junctions.firstWhere(
              (e) => e.id == id,
              orElse: () {
                final newJunction = Junction(
                  id: id,
                  position: const LatLng(0, 0),
                );
                _junctions.add(newJunction);
                return newJunction;
              },
            );

            j.congestion = level;
            _streamController.add(_junctions);
          },
        )
        .subscribe();
  }

  /// ===============================
  /// 3️⃣ CONGESTION MARKERS
  /// ===============================
  Set<Marker> getCongestionMarkers() {
    return _junctions.map((j) {
      double hue;

      switch (j.congestion) {
        case 'High':
          hue = BitmapDescriptor.hueRed;
          break;
        case 'Medium':
          hue = BitmapDescriptor.hueOrange;
          break;
        default:
          hue = BitmapDescriptor.hueGreen;
      }

      return Marker(
        markerId: MarkerId('junction_${j.id}'),
        position: j.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(hue),
        infoWindow: InfoWindow(
          title: 'Traffic: ${j.congestion}',
        ),
      );
    }).toSet();
  }

  /// ===============================
  /// 4️⃣ REROUTE DECISION LOGIC
  /// ===============================
  bool shouldReroute(List<LatLng> routePoints) {
    const radius = 500; // meters

    for (final j in _junctions) {
      if (j.congestion != 'High') continue;

      for (final p in routePoints) {
        final distance = Geolocator.distanceBetween(
          p.latitude,
          p.longitude,
          j.position.latitude,
          j.position.longitude,
        );

        if (distance < radius) {
          return true;
        }
      }
    }
    return false;
  }

  /// ===============================
  /// CLEANUP
  /// ===============================
  void dispose() {
    _streamController.close();
  }
}
