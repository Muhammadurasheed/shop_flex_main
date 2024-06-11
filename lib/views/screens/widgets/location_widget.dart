import 'package:flutter/material.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key});

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: Row(
          children: [
            Image.asset(
              'assets/icons/store-1.png',
              width: 30,
            ),
            SizedBox(
              width: 15,
            ),
            Image.asset(
              'assets/icons/pickicon.png',
              width: 30,
            ),
             SizedBox(
              width: 10,
            ),
            Flexible(
              child: SizedBox(
                width: 300,
                child: TextFormField(
                  decoration: InputDecoration(
                    label: Text('Current location'),
                    hintText: 'Current location',
                    isDense: true
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
