library tsp.list_utils;

/// Combines lists and sublists into a single list
List flatten(List input) {
  return input.fold([], (List acc, current) {
    if (current is! List) return acc..add(current);
    return acc..addAll(flatten(current));
  });
}

/// Returns a list containing all possible permutations of [input]
List<List> permuteList(List input) {
  if (input.length <= 1) return [input];
  var result = [];
  for (int i = 0; i < input.length; i++) {
    var clone = new List.from(input);
    var removed = clone.removeAt(i);
    
    var permutations = permuteList(clone);
    result.addAll(permutations.map((permutation) =>
                                  [removed]..addAll(permutation))
                              .toList());
  }
  return result;
}