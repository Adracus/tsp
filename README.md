# tsp

Ever wanted to solve the symmetric TSP (Travelling Salesperson Problem) exactly?
Well then: Here you go!

With this dart library, permutations of tours, finding the ideal tour
and comparing tours is easy as pie! To import the library, just write

```dart
import 'package:tsp/tsp.dart';
```

and you can use the tsp library.

## Prerequisites

This library builds upon nodes being represented as Points in a two dimensional
coordinate system. The connection between two nodes is called `Edge`. In this
implementation (due to the symmetric constraint) an edge has no specific
direction. In code, this expresses as the following:

```
var e1 = new Edge(new Point(0, 0), new Point(1, 1));
var e2 = new Edge(new Point(1, 1), new Point(0, 0));

assert(e1 == e2);
```

That's also why permutations of tours are direction independent, which means
no duplicates for you to handle.

## Usage

If you want to create a tour from some points (in a specific order), use
the `Tour.from` constructor. This creates a tour with edges starting at the
first point and ending at the first point with the remaining points in between.

To permute possible tours, call `Tour.permute`, which returns a Set consisting
of all possible tours with the given nodes. _CAUTION_: Due to the problem
itself, the number of possibilities increases dramatically with the number
of nodes given. If you want streaming-like usage (but not duplicate free)
for performance or memory reasons, use the `Tour.streamPermute` method.


If there are problems or you want to add something:
Pull requests and help are always appreciated :)
