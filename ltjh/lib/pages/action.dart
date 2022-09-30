import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class MotorAction extends StatelessWidget {
  final BluetoothDevice device;
  const MotorAction({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Turn landscape orientation only
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Container(
      color: Colors.lightBlue,
      child: Row(
        children: <Widget>[
          // Left hand side
          Expanded(
            child: Container(
              color: Colors.black,
              child: const Text("left"),
            ),
          ),
          Expanded(
            // Right hand side
            child: Container(
              color: Colors.white,
              child: const Text("right"),
            ),
          )
        ],
      ),
    );
  }
}
