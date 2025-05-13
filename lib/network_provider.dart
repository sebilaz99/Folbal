import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dinte_albastru/model/network_status.dart';
import 'package:flutter/foundation.dart';

class NetworkProvider with ChangeNotifier {
  String _status = "Checking network...";

  String get status => _status;
  late Timer timer;

  NetworkProvider() {
    checkForNetworkConnection();

    timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      checkForNetworkConnection();
    });
  }

  Future<void> checkForNetworkConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result.first == ConnectivityResult.mobile) {
      _status = NetworkStatus.mobile.name;
    } else if (result.first == ConnectivityResult.wifi) {
      _status = NetworkStatus.wifi.name;
    } else {
      _status = NetworkStatus.none.name;
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
