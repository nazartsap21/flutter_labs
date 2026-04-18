import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_lab/data/services/connectivity_service.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isConnected = true;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool get isConnected => _isConnected;

  ConnectivityProvider() {
    _init();
  }

  Future<void> _init() async {
    _isConnected = await ConnectivityService.isConnected();
    notifyListeners();

    _subscription =
        ConnectivityService.onConnectivityChanged.listen((results) {
      final connected = results.any((r) => r != ConnectivityResult.none);
      if (connected != _isConnected) {
        _isConnected = connected;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
