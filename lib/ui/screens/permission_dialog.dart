import 'package:flutter/material.dart';
import 'package:dinte_albastru/helper.dart';
import 'package:dinte_albastru/navigator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'main_screen.dart';

class PermissionDialog extends StatefulWidget {
  const PermissionDialog({super.key});

  @override
  State<StatefulWidget> createState() => _PermissionDialogState();
}

class _PermissionDialogState extends State<PermissionDialog> {
  bool _locationGranted = false;

  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Permission required"),
      content:
          const Text("This app needs your permission to access your location"),
      actions: [
        TextButton(
          onPressed: () => {requestPermission(Permission.location)},
          child: const Text("Grant"),
        ),
      ],
    );
  }

  Future<void> checkPermissions() async {
    _locationGranted = await Permission.location.isGranted;
    setState(() {});
    if (_locationGranted) {
      navigateBack(context);
    }
  }

  Future<void> requestPermission(Permission permission) async {
    await permission.request();
    await checkPermissions();
    if (!_locationGranted) {
      handleDeniedPermission();
    } else {
      navigateTo(const MainScreen(), context);
      Helper().startTrackingSpeed();
    }
  }

  Future<void> handleDeniedPermission() async {
    if (await Permission.location.isPermanentlyDenied) {
      showSettingsDialog();
    }
  }

  void showSettingsDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: const Text("Permission required"),
              content: const Text(
                  "You have permanently denied permissions. Please go to settings to enable them."),
              actions: [
                TextButton(
                  onPressed: () => requestPermission(Permission.location),
                  child: const Text("Retry"),
                ),
                TextButton(
                  onPressed: () {
                    openAppSettings();
                  },
                  child: const Text("Open Settings"),
                ),
              ],
            ));
  }
}
