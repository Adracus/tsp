library tsp.test.model.tsp_grid;

import 'dart:math' show Random, Point;

import 'package:unittest/unittest.dart';
import 'package:mock/mock.dart';

import 'package:tsp/src/tsp_grid.dart';
import 'package:tsp/src/tsp_list_utils.dart';

import 'mock.dart';


defineGridTests() {
  group("flatten", () {
    test("empty list", () {
      expect(flatten([]), equals([]));
    });
    
    test("shallow list", () {
      expect(flatten([1, 2, 3, 4]), equals([1, 2, 3,4]));
    });
    
    test("nested lvl 1 list", () {
      expect(flatten([1, [2, 3, 4], 5]), equals([1, 2, 3, 4, 5]));
    });
    
    test("nested lvl 2 list", () {
      expect(flatten([1, [2, 3, [4, 5], []]]), equals([1, 2, 3, 4, 5]));
    });
  });
  
  group("permuteList", () {
    test("empty list", () {
      expect(permuteList([]), equals([[]]));
    });
    
    test("single element", () {
      expect(permuteList([1]), equals([[1]]));
    });
    
    test("two elements", () {
      expect(permuteList([1, 2]), equals([[1, 2], [2, 1]]));
    });
    
    test("three elements", () {
      expect(permuteList([1, 2, 3]), equals([
        [1, 2, 3], [1, 3, 2],
        [2, 1, 3], [2, 3, 1],
        [3, 1, 2], [3, 2, 1]]
      ));
    });
    
    test("four elements", () {
      expect(permuteList([1, 2, 3, 4]), equals([
        [1,2,3,4],[1,2,4,3],[1,3,2,4],[1,3,4,2],[1,4,2,3],[1,4,3,2],
        [2,1,3,4],[2,1,4,3],[2,3,1,4],[2,3,4,1],[2,4,1,3],[2,4,3,1],
        [3,1,2,4],[3,1,4,2],[3,2,1,4],[3,2,4,1],[3,4,1,2],[3,4,2,1],
        [4,1,2,3],[4,1,3,2],[4,2,1,3],[4,2,3,1],[4,3,1,2],[4,3,2,1]
      ]));
    });
  });
  
  group("Grid", () {
    group("randRange", () {
      test("Maximum value", () {
        var random = new MockRandom()
          ..when(callsTo("nextInt", 10)).thenReturn(9);
        
        expect(Grid.randRange(0, 10, random), equals(9));
        
        random.getLogs(callsTo("nextInt", 10)).verify(happenedOnce);
      });
      
      test("Minimum value", () {
        var random = new MockRandom()
          ..when(callsTo("nextInt", 10)).thenReturn(0);
        
        expect(Grid.randRange(0, 10, random), equals(0));
        
        random.getLogs(callsTo("nextInt", 10)).verify(happenedOnce);
      });
    });
    
    group("randomPoints", () {
      test("Throw if too many points expected", () {
        expect(() =>
            Grid.randomPoints(9, new ViewPort.values(0, 3, 0, 3)),
            returnsNormally);
        
        expect(() =>
            Grid.randomPoints(10, new ViewPort.values(0, 3, 0, 3)),
            throws);
      });
    });
    
    group("computeViewPort", () {
      test("Empty set", () {
        expect(() => Grid.computeViewPort(new Set()), throws);
      });
      
      test("Non empty set", () {
        var points = [new Point(0, 0), new Point(-1, -10), new Point(0, 10)];
        var viewPort = Grid.computeViewPort(new Set.from(points));
        
        expect(viewPort, equals(new ViewPort.values(-1, 0, -10, 10)));
      });
    });
  });
    
  group("Range", () {
    test("isInRange", () {
      var range = new Range(0, 10);
      
      expect(range.isInRange(0), equals(true));
      expect(range.isInRange(9), equals(true));
      expect(range.isInRange(-1), equals(false));
      expect(range.isInRange(10), equals(false));
      expect(range.isInRange(5), equals(true));
    });
  });
  
  group("ViewPort", () {
    test("noOfPossibilities", () {
      var viewPort = new ViewPort(new Range(0, 10), new Range(0, 10));
      
      expect(viewPort.noOfPossibilities, equals(100));
    });
    
    test("isInViewPort", () {
      var viewPort = new ViewPort(new Range(0, 10), new Range(0, 10));
      
      expect(viewPort.isInViewPort(5, 5), isTrue);
      expect(viewPort.isInViewPort(10, 10), isFalse);
      expect(viewPort.isInViewPort(0, 0), isTrue);
    });
  });
}