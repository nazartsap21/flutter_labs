import 'package:flutter/material.dart';
import 'package:flutter_lab/providers/connectivity_provider.dart';
import 'package:provider/provider.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (_, c, _) {
        if (c.isConnected) return const SizedBox.shrink();
        return ColoredBox(
          color: Colors.orange.shade100,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.wifi_off, color: Colors.orange, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No internet connection',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
