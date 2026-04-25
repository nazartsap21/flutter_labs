import 'package:flutter/material.dart';
import 'package:flutter_lab/data/services/api_service.dart';
import 'package:flutter_lab/pages/splash.dart';
import 'package:flutter_lab/providers/connectivity_provider.dart';
import 'package:flutter_lab/providers/mqtt_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.init();
  runApp(const FlutterLab());
}

class FlutterLab extends StatelessWidget {
  const FlutterLab({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => MqttProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
