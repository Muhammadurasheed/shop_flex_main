import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shop_flex/views/screens/main_screen.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  late GoogleMapController mapController;

  getUserCurrentPosition() async {
    await Geolocator.checkPermission();

    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        forceAndroidLocationManager: true);
        LatLng determinedPosition = LatLng(position.latitude, position.longitude);
        CameraPosition cameraPosition = CameraPosition(target: determinedPosition, zoom: 16);
        mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            padding: EdgeInsets.only(bottom: 200),
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);

              mapController = controller;

              getUserCurrentPosition();
            },
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 70,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.offAll(MainScreen());
                      },
                      label: Text(
                        'Shop Now',
                        style: TextStyle(letterSpacing: 4),
                      ),
                      icon: Icon(CupertinoIcons.cart),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
