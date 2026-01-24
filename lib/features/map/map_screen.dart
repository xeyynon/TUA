import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'controllers/map_controller.dart';
import 'services/directions_service.dart';

import 'widgets/from_to_bar.dart';
import 'widgets/challan_tabs.dart';
import 'widgets/payment_sheet.dart';
import 'widgets/glass_backdrop.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapController()..init(),
      child: const _MapView(),
    );
  }
}

class _MapView extends StatelessWidget {
  const _MapView();

  Future<void> _drawRoute(MapController c) async {
    if (c.fromLatLng == null || c.toLatLng == null) return;

    final polyline = await DirectionsService.getRoute(
      origin: c.fromLatLng!,
      destination: c.toLatLng!,
    );

    if (polyline == null) return;

    c.polylines
      ..clear()
      ..add(polyline);

    c.mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            c.fromLatLng!.latitude < c.toLatLng!.latitude
                ? c.fromLatLng!.latitude
                : c.toLatLng!.latitude,
            c.fromLatLng!.longitude < c.toLatLng!.longitude
                ? c.fromLatLng!.longitude
                : c.toLatLng!.longitude,
          ),
          northeast: LatLng(
            c.fromLatLng!.latitude > c.toLatLng!.latitude
                ? c.fromLatLng!.latitude
                : c.toLatLng!.latitude,
            c.fromLatLng!.longitude > c.toLatLng!.longitude
                ? c.fromLatLng!.longitude
                : c.toLatLng!.longitude,
          ),
        ),
        80,
      ),
    );

    c.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<MapController>();

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                FromToBar(
                  controller: c,
                  onRoutePressed: () => _drawRoute(c),
                ),
                Expanded(
                  flex: 5,
                  child: GoogleMap(
                    onMapCreated: (m) => c.mapController = m,
                    initialCameraPosition: CameraPosition(
                      target:
                          c.currentLocation ?? const LatLng(28.6139, 77.2090),
                      zoom: 14,
                    ),
                    myLocationEnabled: true,
                    trafficEnabled: true,
                    markers: c.markers,
                    polylines: c.polylines,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ChallanTabs(controller: c),
                ),
              ],
            ),
          ),
          if (c.showPaymentSheet) ...[
            GlassBackdrop(onClose: c.closePayment),
            PaymentSheet(onClose: c.closePayment),
          ],
        ],
      ),
    );
  }
}
