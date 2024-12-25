import 'dart:io';

final input = "input.txt";

(bool, Set<(int, int)>) traverse(List<List<String>> grid) {
  (int, int) guard = (-1, -1);
  final byRow = <int, List<int>>{};
  final byColumn = <int, List<int>>{};

  for (final row in grid.indexed) {
    for (final cell in row.$2.indexed) {
      if (cell.$2 == "#") {
        byRow.putIfAbsent(row.$1, () => []).add(cell.$1);
        byColumn.putIfAbsent(cell.$1, () => []).add(row.$1);
      }
      if (cell.$2 == "^") {
        guard = (row.$1, cell.$1);
      }
    }
  }

  final original = guard;

  bool isLoop = false;
  final visited = <(int, int), Set<int>>{};

  outer:
  for (var step = 0;; ++step) {
    if ((guard.$1 <= 0 || guard.$1 >= grid.length - 1) || (guard.$2 <= 0 || guard.$2 >= grid[0].length - 1)) {
      isLoop = false;
      break;
    }

    final isVertical = step % 2 == 0;
    final direction = (step % 4 == 0 || step % 4 == 3);
    final stop = switch (step % 4) {
      0 => byColumn[guard.$2]?.reversed.firstWhere((r) => r < guard.$1, orElse: () => -1) ?? -1,
      2 => byColumn[guard.$2]?.firstWhere((r) => r > guard.$1, orElse: () => grid.length) ?? grid.length,
      1 => byRow[guard.$1]?.firstWhere((c) => c > guard.$2, orElse: () => grid[0].length) ?? grid[0].length,
      3 => byRow[guard.$1]?.reversed.firstWhere((c) => c < guard.$2, orElse: () => -1) ?? -1,
      _ => null,
    };

    for (var i = isVertical ? guard.$1 : guard.$2;
        (direction && (i > stop!) || (!direction && (i < stop!)));
        i += direction ? -1 : 1) {
      final newlyAdded = isVertical
          ? visited.putIfAbsent((i, guard.$2), () => {}).add(step % 4)
          : visited.putIfAbsent((guard.$1, i), () => {}).add(step % 4);

      if (!newlyAdded) {
        isLoop = true;
        break outer;
      }
    }

    final coord = stop! + (direction ? 1 : -1);
    guard = isVertical ? (coord, guard.$2) : (guard.$1, coord);
  }

  return (isLoop, visited.keys.toSet()..remove(original));
}

void main() async {
  final grid = File(input).readAsLinesSync().map((line) => line.split("")).toList();

  final (_, visited) = traverse(grid);

  final result1 = visited.length + 1;
  print("Part 1: ${result1}");

  final result2 = visited.where((point) {
    grid[point.$1][point.$2] = "#";
    final (isLoop, _) = traverse(grid);
    grid[point.$1][point.$2] = ".";

    return isLoop;
  }).length;
  print("Part 2: ${result2}");
}
