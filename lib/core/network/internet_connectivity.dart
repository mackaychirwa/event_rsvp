import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isConnected = true;
  final Connectivity _connectivity = Connectivity();

  ConnectivityProvider() {
    _checkConnectivity();
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results.first); 
    });
  }

  bool get isConnected => _isConnected;

  Future<void> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result.first);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    _isConnected = (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi);
    notifyListeners();
  }
}
