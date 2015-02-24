library tsp.test.tour;

import 'dart:math' show Point;

import 'package:tsp/src/tsp_tour.dart';

import 'package:unittest/unittest.dart';


defineTourTests() {
  group("Tour", () {
    test("bestTour", () {
      var tour = Tour.bestTour(new Set.from([
          new Point(0, 0), new Point(0, 1),
          new Point(1, 0), new Point(1, 1)
      ]));
      
      expect(tour.length, equals(4));
    });
    
    test("permuteTours", () {
      var tours = Tour.permute(new Set.from([
          new Point(0, 0), new Point(0, 1),
          new Point(1, 0), new Point(1, 1)
      ]));
      
      expect(tours.length, equals(3));
      var t1 = new Tour.from([
          new Point(0, 0), new Point(0, 1),
          new Point(1, 0), new Point(1, 1)
      ]);
      var t2 = new Tour.from([
          new Point(0, 0), new Point(0, 1),
          new Point(1, 1), new Point(1, 0)
      ]);
      var t3 = new Tour.from([
          new Point(0, 0), new Point(1, 0),
          new Point(0, 1), new Point(1, 1)
      ]);
      expect(tours, contains(t1));
      expect(tours, contains(t2));
      expect(tours, contains(t3));
      tours.removeAll([t1, t2, t3]);
      expect(tours, isEmpty);
    });
    
    test("createEdges", () {
      var edges = Tour.createEdges([
          new Point(0, 0), new Point(0, 1),
          new Point(1, 0), new Point(1, 1)
      ]);
      
      expect(edges.length, equals(4));
      expect(edges[0], equals(new Edge(new Point(0, 0), new Point(0, 1))));
      expect(edges[1], equals(new Edge(new Point(0, 1), new Point(1, 0))));
      expect(edges[2], equals(new Edge(new Point(1, 0), new Point(1, 1))));
      expect(edges[3], equals(new Edge(new Point(1, 1), new Point(0, 0))));
    });
    
    test("equals", () {
      var t1 = new Tour.from([
          new Point(0, 0), new Point(0, 1),
          new Point(1, 0), new Point(1, 1)
      ]);
      
      var t2 = new Tour.from([
          new Point(1, 1), new Point(0, 0),
          new Point(0, 1), new Point(1, 0)
      ]);
      
      var t3 = new Tour.from([
          new Point(0, 0), new Point(0, 5),
          new Point(3, 0), new Point(1, 5)
      ]);
      
      var t4 = new Tour.from([
          new Point(1, 0), new Point(1, 1),
          new Point(0, 0), new Point(0, 1)
      ]);
      
      expect(t1, equals(t2));
      expect(t2, equals(t1));
      expect(t1, equals(t1));
      expect(t1, equals(t4));
      expect(t2, equals(t4));
      expect(t1.hashCode, equals(t2.hashCode));
      expect(t3, isNot(equals(t1)));
      expect(t1.hashCode, isNot(equals(t3.hashCode)));
    });
  });
  
  group("Edge", () {
    test("compareTo", () {
      var e1 = new Edge(new Point(0, 0), new Point(1, 1));
      var e2 = new Edge(new Point(0, 0), new Point(2, 2));
      var e3 = new Edge(new Point(3, 5), new Point(-3, 2));
      
      expect(e1.compareTo(e2), equals(-1));
      expect(e1.compareTo(e3), equals(1));
      expect(e2.compareTo(e3), equals(1));
      expect(e1.compareTo(e1), equals(0));
    });
    
    test("comparePoints", () {
      var p1 = new Point(4, 10);
      var p2 = new Point(4, 12);
      var p3 = new Point(0, 4);
      var p4 = new Point(10, 10);
      
      expect(Edge.comparePoints(p1, p1), equals(0));
      expect(Edge.comparePoints(p1, p2), equals(-1));
      expect(Edge.comparePoints(p1, p3), equals(1));
      expect(Edge.comparePoints(p1, p4), equals(-1));
    });
  });
}