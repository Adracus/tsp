library tsp.test.mock;

import 'dart:math' show Random;

import 'package:mock/mock.dart';

@proxy
class MockRandom extends Mock implements Random {
  noSuchMethod(inv) => super.noSuchMethod(inv);
}