import 'dart:io';

final input = "input.txt";

void main() async {
  final inp = File(input).readAsStringSync().split("\n\n");

  final [width, height] = RegExp(r"(\d+) \* (\d+)").firstMatch(inp[0])!.groups([1, 2]).map((e) {
    return int.parse(e!);
  }).toList();
  final corrupted = inp[1].trim().split("\n").fold(<(int, int)>[], (list, coord) {
    final [x, y] = coord.split(",").map(int.parse).toList();
    return list..add((x, y));
  });

  int traverse(int time) {
    final corruptedSet = corrupted.take(time).toSet();
    final visited = <(int, int)>{};
    final queue = [((0, 0), 0)];

    while (queue.isNotEmpty) {
      final (pos, length) = queue.removeAt(0);

      if (visited.contains(pos)) continue;
      visited.add(pos);

      if (pos == (height - 1, width - 1)) return length;

      for (final move in [(0, -1), (0, 1), (-1, 0), (1, 0)]) {
        final (nr, nc) = (pos.$1 + move.$1, pos.$2 + move.$2);
        if (nr < 0 || height <= nr || nc < 0 || width <= nc) continue;
        if (corruptedSet.contains((nr, nc))) continue;

        queue.add(((nr, nc), length + 1));
      }
    }

    return -1;
  }

  final result1 = await traverse(1024);

  int low = 1025;
  int high = corrupted.length;

  while (low <= high) {
    final time = (low + high) ~/ 2;
    final blocked = traverse(time) == -1;

    if (blocked)
      high = time - 1;
    else
      low = time + 1;
  }

  final result2 = corrupted[low - 1];

  print("Part 1: ${result1}");
  print("Part 2: ${result2}");
}
