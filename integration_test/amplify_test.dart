import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:second_chance/amplify.dart';
import 'package:mockito/mockito.dart';
import 'package:integration_test/integration_test.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  AmplifyState state = AmplifyState();
  MockBuildContext _mockContext = MockBuildContext();
  test('Amplify Configured Successfully', () {

    //state.configureAmplify();
    //Future.delayed(const Duration(milliseconds: 1000), () {
    //  expect(state.isAmplifyConfigured, true);
    //});

  });
}