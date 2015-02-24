library tsp.model.tspgrid;

import 'dart:math' show Point, Random, max, min;


class Grid {
  final Set<Point<int>> nodes;
  final ViewPort viewPort;
  
  Grid(Set<Point<int>> nodes)
      : nodes = nodes,
        viewPort = computeViewPort(nodes);
  
  Grid.random(int noOfNodes, ViewPort viewPort)
      : nodes = randomPoints(noOfNodes, viewPort),
        viewPort = viewPort;
  
  static Set<Point<int>> randomPoints(int count, ViewPort viewPort, {Random random}) {
    if (count > viewPort.noOfPossibilities)
      throw new ArgumentError("Cannot generate $count " +
          "unique points in specified ViewPort");
    
    if (null == random) random = new Random();
    
    var values = <int, int>{}; // X values mapped to Y values
    var result = new Set<Point<int>>();
    
    while(result.length < count) {
      var x = randRange(viewPort.xMin, viewPort.xMax, random);
      var y = randRange(viewPort.yMin, viewPort.yMax, random);
      
      if (values[x] == y) continue;
      result.add(new Point<int>(x, y));
    }
    
    return result;
  }
  
  static ViewPort computeViewPort(Set<Point<int>> points) {
    if (points.isEmpty) throw new ArgumentError("Points cannot be empty");
    int xMin, xMax, yMin, yMax;
    xMin = xMax = points.first.x;
    yMin = yMax = points.first.y;
    points.forEach((point) {
      xMin = min(point.x, xMin);
      xMax = max(point.x, xMax);
      yMin = min(point.y, yMin);
      yMax = max(point.y, yMax);
    });
    return new ViewPort.values(xMin, xMax, yMin, yMax);
  }
  
  /// Produces new int in range from [min] to [max] (max exclusive)
  static int randRange(int min, int max, Random random) {
    return min + random.nextInt(max - min);
  }
}


class Range<E extends num> {
  final E start;
  final E end;
  
  Range(E start, E end)
      : start = min(start, end),
        end = max(start, end);
  
  /// Returns true if min <= [value] < end, false otherwise
  bool isInRange(E value) => value >= start && value < end;
  
  E get distance => end - start;
  
  bool operator==(other) {
    if (other is! Range) return false;
    return other.start == start && other.end == end;
  }
  
  int get hashCode => toString().hashCode;
  
  toString() => "$start : $end";
}


class ViewPort {
  final Range<int> xRange;
  final Range<int> yRange;
  
  ViewPort(this.xRange, this.yRange);
  
  ViewPort.values(int xMin, int xMax, int yMin, int yMax)
      : xRange = new Range(xMin, xMax),
        yRange = new Range(yMin, yMax);
  
  int get noOfPossibilities => xRange.distance * yRange.distance;
  
  int get xMin => xRange.start;
  int get xMax => xRange.end;
  int get yMin => yRange.start;
  int get yMax => yRange.end;
  int get xDistance => xRange.distance;
  int get yDistance => yRange.distance;
  
  bool isInViewPort(int x, int y) =>
      xRange.isInRange(x) && yRange.isInRange(y);
  
  bool isInXRange(int x) => xRange.isInRange(x);
  bool isInYRange(int y) => yRange.isInRange(y);
  
  bool operator==(other) {
    if (other is! ViewPort) return false;
    return other.xRange == xRange && other.yRange == yRange;
  }
  
  int get hashCode => toString().hashCode;
  
  toString() => "$xRange - $yRange";
}