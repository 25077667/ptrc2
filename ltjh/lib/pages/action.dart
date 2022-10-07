import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

// import 'package:flutter/foundation.dart';

enum _LeftRightState { left, right }

@immutable
class MotorAction extends StatefulWidget {
  final BluetoothDevice device;
  const MotorAction({Key? key, required this.device}) : super(key: key);

  @override
  State<MotorAction> createState() => _MotorActionState();
}

class _MotorActionState extends State<MotorAction> {
  // late Timer timer;
  bool hasInit = false;

  // Operation value:
  // It is an 8-bits' value, each bit means an orientation of that motor
  // A coupled adjacent bits are controlling the same motor, in other words,
  // there are four motors would be controlled.
  // Each coupled bits could not be set at the same time.
  //
  // It would be represented as the following chart:
  // 00|00|00|00 => all motors stop
  // 10|00|00|00 => the left most side motor turns positive side.
  // 01|00|00|00 => the left most side motor turns negative side.
  // 01|00|00|10 => the left most side motor turns negative side,
  //                and the right most side motor turns positive side.
  // y1|x1|y2|x2
  //
  // We use an int to represent that '8-bits' value, and called it operation.
  int operation = 0;
  // It seems having race condition here.

  void _setOperation(StickDragDetails details, _LeftRightState state) {
    int isSignificant(double val) => (val.abs() > 0.5) ? 1 : 0;
    int isPositive(double val) => (val >= 0) ? 1 : 0;

    // Casting into 4 bits, naming as code:
    // 00|00
    // y | x
    int code = (isSignificant(details.y) << isPositive(details.y) << 2) |
        isSignificant(details.x) << isPositive(details.x);

    if (state == _LeftRightState.left) {
      // Clean the upper 4 bits and remain the lower 4 bits
      operation &= 15; // 0b1111
      operation |= (code << 4); // Set the upper 4 bits
    } else {
      // Clean the lower 4 bits and remain the upper 4 bits
      operation &= 240; // 0b11110000
      operation |= code;
    }

    // Update the state as we computed.
    setState(() {
      operation = operation;
    });
  }

  @override
  void initState() {
    // Turn landscape orientation only
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    super.initState();

    // // Set a timer to send operation periodically
    // timer = Timer.periodic(const Duration(milliseconds: 1), (timer) async {
    //   if (hasInit == false) {
    //     List<BluetoothService> allServices =
    //         await widget.device.discoverServices();
    //     for (BluetoothService s in allServices) {
    //       for (BluetoothCharacteristic c in s.characteristics) {
    //         debugPrint(c.properties.);
    //       }
    //     }
    //     hasInit = true;
    //   }

    //   // Send operation
    //   characteristicTX.write([operation]);
    //   // Clean the operation
    //   operation = 0;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue,
      child: Row(
        children: <Widget>[
          // Left hand side
          Expanded(
            child: Align(
              alignment: const Alignment(0, 0),
              child: Joystick(
                mode: JoystickMode.all,
                listener: ((details) {
                  _setOperation(details, _LeftRightState.left);
                }),
              ),
            ),
          ),
          Text(operation.toString()),
          // Right hand side
          Expanded(
            child: Align(
              alignment: const Alignment(0, 0),
              child: Joystick(
                mode: JoystickMode.all,
                listener: ((details) {
                  _setOperation(details, _LeftRightState.right);
                }),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
  }
}
