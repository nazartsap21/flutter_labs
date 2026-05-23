import 'package:flutter_lab/data/repositories/local_auth_repository.dart';
import 'package:flutter_lab/data/repositories/local_meteostation_repository.dart';
import 'package:flutter_lab/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      FlutterLab(
        authRepository: LocalAuthRepository(),
        stationRepository: LocalMeteostationRepository(),
      ),
    );
    await tester.pump();
  });
}
