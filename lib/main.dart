import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab/cubits/auth_cubit.dart';
import 'package:flutter_lab/cubits/station_cubit.dart';
import 'package:flutter_lab/data/repositories/api_auth_repository.dart';
import 'package:flutter_lab/data/repositories/api_meteostation_repository.dart';
import 'package:flutter_lab/data/repositories/auth_repository.dart';
import 'package:flutter_lab/data/repositories/meteostation_repository.dart';
import 'package:flutter_lab/data/services/api_service.dart';
import 'package:flutter_lab/pages/splash.dart';
import 'package:flutter_lab/providers/connectivity_provider.dart';
import 'package:flutter_lab/providers/mqtt_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.init();
  runApp(
    FlutterLab(
      authRepository: ApiAuthRepository(),
      stationRepository: ApiMeteostationRepository(),
    ),
  );
}

class FlutterLab extends StatelessWidget {
  const FlutterLab({
    required this.authRepository,
    required this.stationRepository,
    super.key,
  });

  final AuthRepository authRepository;
  final MeteostationRepository stationRepository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => MqttProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthCubit(authRepository)..checkAuth(),
          ),
          BlocProvider(
            create: (_) => StationCubit(stationRepository),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
            ),
          ),
          home: const SplashPage(),
        ),
      ),
    );
  }
}
