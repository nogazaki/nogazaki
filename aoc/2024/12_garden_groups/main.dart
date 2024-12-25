import 'dart:io';

final input = "input.txt";

void main() async {
  final grid = File(input).readAsLinesSync().indexed.fold(<(int, int), String>{}, (g1, row) {
    return row.$2.split("").indexed.fold(g1, (g2, plot) {
      return g2..addAll({(row.$1, plot.$1): plot.$2});
    });
  });

  final queue = grid.keys.toSet();
  int result1 = 0;
  int result2 = 0;

  while (queue.isNotEmpty) {
    final start = queue.first;
    queue.remove(start);

    final region = {start};

    final regionType = grid[start];
    final regionQueue = [start];

    int perimeter = 0;
    int corners = 0;

    while (regionQueue.isNotEmpty) {
      final plot = regionQueue.removeAt(0);

      final neighbors = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 0), (0, 1), (1, -1), (1, 0), (1, 1)]
          .map((move) => (plot.$1 + move.$1, plot.$2 + move.$2))
          .toList();
      final others = neighbors.map((coord) => grid[coord] == regionType).toList();

      for (final i in [1, 3, 5, 7]) {
        if (!others[i]) {
          perimeter += 1;
          continue;
        }

        final neighbor = neighbors[i];
        queue.remove(neighbor);
        if (region.add(neighbor)) regionQueue.add(neighbor);
      }

      for (final (i, j, x) in [(1, 3, 0), (1, 5, 2), (3, 7, 6), (5, 7, 8)]) {
        if ((others[i] == others[j]) && (!others[j] || !others[x])) corners += 1;
      }
    }

    result2 += region.length * corners;
    result1 += region.length * perimeter;
  }

  print("Part 1: ${result1}");
  print("Part 2: ${result2}");
}
