import 'dart:io';

final input = "input.txt";

void main() async {
  final starts = <(int, int)>[];
  final grid = File(input).readAsLinesSync().indexed.map((line) {
    return line.$2.split("").indexed.map((cell) {
      final value = int.parse(cell.$2);
      if (value == 0) starts.add((line.$1, cell.$1));
      return value;
    }).toList();
  }).toList();

  final mapped = starts.map((start) {
    final peaks = <(int, int)>{};
    int times = 0;

    final queue = [start];
    while (queue.isNotEmpty) {
      final (r, c) = queue.removeAt(0);
      final height = grid[r][c];
      if (height == 9) {
        peaks.add((r, c));
        times += 1;
      }

      for (final (dr, dc) in [(0, 1), (0, -1), (1, 0), (-1, 0)]) {
        final (nextR, nextC) = (r + dr, c + dc);
        if (nextR < 0 || grid.length <= nextR || nextC < 0 || grid[0].length <= nextC) {
          continue;
        }

        final nextHeight = grid[nextR][nextC];
        if (nextHeight != height + 1) {
          continue;
        }

        queue.add((nextR, nextC));
      }
    }

    return (peaks.length, times);
  });

  final (result1, result2) = mapped.fold((0, 0), (ret, num) => (ret.$1 + num.$1, ret.$2 + num.$2));

  print("Part 1: ${result1}");
  print("Part 2: ${result2}");
}
