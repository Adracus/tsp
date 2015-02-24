library tsp.tour;

import 'dart:math' show Point, sqrt, pow;

import 'package:quiver/core.dart';

class Tour {
  final List<Edge<int>> edges;
  int _hashCode;

  Tour(this.edges);

  Tour.from(List<Point<int>> points)
      : edges = createEdges(points);

  double get length => edges.fold(.0, (double acc, Edge edge) => acc += edge.length);

  static Set<Tour> permute(Set<Point<int>> points) {
    var result = new Set<Tour>();

    Tour.streamPermute(points, (Tour tour) {
      result.add(tour);
    });

    return result;
  }

  static List<Edge> createEdges(List<Point<int>> points) {
    if (points.length <= 1) return [];
    var result = [];
    var current = points.first;
    points.sublist(1).forEach((point) {
      result.add(new Edge(current, point));
      current = point;
    });
    return result..add(new Edge(points.last, points.first));
  }

  static void streamPermute(Set<Point> points, void onTour(Tour tour)) {
    if (points.length < 2) throw new ArgumentError("Points has to contain at least two points");

    innerPermute(List<Point> proto, Set<Point> points) {
      if (1 == points.length) {
        var tour = new Tour.from(proto..add(points.single));
        onTour(tour);
        return;
      }

      points.forEach((point) {
        var clone = new Set.from(points);
        clone.remove(point);
        innerPermute(new List.from(proto, growable: true)..add(point), clone);
      });
    }

    innerPermute([], points);
  }

  static Tour bestTour(Set<Point> points) {
    if (points.length < 2) throw new ArgumentError("Points has to contain at least two points");
    Tour best;

    Tour.streamPermute(points, (tour) {
      if (null == best || best.length > tour.length) best = tour;
    });

    return best;
  }

  List<Edge> get sortedEdges => new List.from(edges)..sort();

  bool operator ==(other) {
    if (other is! Tour) return false;
    if (this.edges.length != other.edges.length) return false;
    var selfSorted = this.sortedEdges;
    var otherSorted = other.sortedEdges;

    for (int i = 0; i < selfSorted.length; i++) {
      if (selfSorted[i] != otherSorted[i]) return false;
    }
    return true;
  }

  int get hashCode {
    if (null == _hashCode) _hashCode = hashObjects(sortedEdges);
    return _hashCode;
  }

  toString() => edges.map((edge) => edge.toString()).join(" -> ");
}

class Edge<E extends num> implements Comparable {
  final Point start;
  final Point end;

  Edge(this.start, this.end);

  double get length => start.distanceTo(end);

  bool operator ==(other) {
    if (other is! Edge) return false;
    return this.smaller == other.smaller && this.bigger == other.bigger;
  }

  int get hashCode => hash2(smaller, bigger);

  List<Point> get points => [start, end];

  toString() => "$start -> $end";

  static int comparePoints(Point p1, Point p2) {
    var xCompare = p1.x.compareTo(p2.x);
    if (0 != xCompare) return xCompare;
    return p1.y.compareTo(p2.y);
  }

  Point get smaller => comparePoints(start, end) < 0 ? start : end;
  Point get bigger => comparePoints(start, end) >= 0 ? start : end;

  int compareTo(Edge other) {
    var startCompare = comparePoints(this.smaller, other.smaller);
    if (0 != startCompare) return startCompare;
    return comparePoints(this.bigger, other.bigger);
  }
}
