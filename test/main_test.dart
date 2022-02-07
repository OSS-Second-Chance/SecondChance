import 'package:flutter_test/flutter_test.dart';
import 'package:second_chance/main.dart';

void main() {


  test('Counter Initialized', () {
    final app = MyHomePageState();

    expect(app.counter, 0);

  });
}
