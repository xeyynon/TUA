import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'controllers/map_controller.dart';
import 'services/places_service.dart';
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

  // ===============================
  // SEARCH PLACE → SET LATLNG
  // ===============================
  Future<void> _searchAndSetLocation({
    required MapController controller,
    required String query,
    required bool isFrom,
  }) async {
    final latLng = await PlacesService.getLatLngFromQuery(query);
    if (latLng == null) return;

    if (isFrom) {
      controller.fromLatLng = latLng;
    } else {
      controller.toLatLng = latLng;
    }

    controller.markers.add(
      Marker(
        markerId: MarkerId(isFrom ? 'from' : 'to'),
        position: latLng,
      ),
    );

    controller.notifyListeners();
  }

  // ===============================
  // DRAW ROUTE POLYLINE
  // ===============================
  Future<void> _drawRoute(MapController controller) async {
    if (controller.fromLatLng == null || controller.toLatLng == null) return;

    final polyline = await DirectionsService.getRoute(
      origin: controller.fromLatLng!,
      destination: controller.toLatLng!,
    );

    if (polyline == null) return;

    controller.polylines.clear();
    controller.polylines.add(polyline);

    controller.mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            controller.fromLatLng!.latitude <
                    controller.toLatLng!.latitude
                ? controller.fromLatLng!.latitude
                : controller.toLatLng!.latitude,
            controller.fromLatLng!.longitude <
                    controller.toLatLng!.longitude
                ? controller.fromLatLng!.longitude
                : controller.toLatLng!.longitude,
          ),
          northeast: LatLng(
            controller.fromLatLng!.latitude >
                    controller.toLatLng!.latitude
                ? controller.fromLatLng!.latitude
                : controller.toLatLng!.latitude,
            controller.fromLatLng!.longitude >
                    controller.toLatLng!.longitude
                ? controller.fromLatLng!.longitude
                : controller.toLatLng!.longitude,
          ),
        ),
        80,
      ),
    );

    controller.notifyListeners();
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
                // ================= FROM → TO BAR =================
                FromToBar(
                  controller: c,
                  onFromSearch: () => _searchAndSetLocation(
                    controller: c,
                    query: c.fromController.text,
                    isFrom: true,
                  ),
                  onToSearch: () => _searchAndSetLocation(
                    controller: c,
                    query: c.toController.text,
                    isFrom: false,
                  ),
                  onRoutePressed: () => _drawRoute(c),
                ),

                // ================= GOOGLE MAP =================
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

                // ================= CHALLANS =================
                Expanded(
                  flex: 4,
                  child: ChallanTabs(controller: c),
                ),
              ],
            ),
          ),

          // ================= PAYMENT SHEET =================
          if (c.showPaymentSheet) ...[
            GlassBackdrop(onClose: c.closePayment),
            PaymentSheet(onClose: c.closePayment),
          ],
        ],
      ),
    );
  }
}
