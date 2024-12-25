import 'dart:io';

final input = "input.txt";

void main() {
  final lines = File(input).readAsLinesSync();
  final height = lines.length;
  final width = lines[0].length;

  final antennas = lines.indexed.fold(<String, List<({int x, int y})>>{}, (mapped, iLine) {
    for (final iCell in iLine.$2.split("").indexed.where((e) => e.$2 != ".")) {
      mapped.putIfAbsent(iCell.$2, () => []).add((x: iLine.$1, y: iCell.$1));
    }
    return mapped;
  });

  final antiNodes = antennas.values.fold(<(int, int), bool>{}, (antiNodes, frequency) {
    for (var i = 0; i < frequency.length; ++i) {
      for (var j = i + 1; j < frequency.length; ++j) {
        final (x: x1, y: y1) = frequency[i];
        final (x: x2, y: y2) = frequency[j];

        final (dx, dy) = (x2 - x1, y2 - y1);

        for (var x = 0; x < width; ++x) {
          final dx2 = x1 - x;
          final y = ((dx * y1 - dx2 * dy) / dx).round();
          final picked = (dx2 * dy == dx * (y1 - y)) && (0 <= y && y < height);

          if (picked) {
            final close = {1, -2}.contains(dx2 ~/ dx);
            antiNodes.update((x, y), (v) => v || close, ifAbsent: () => close);
          }
        }
      }
    }

    return antiNodes;
  });

  final result1 = antiNodes.values.where((v) => v).length;
  final result2 = antiNodes.length;

  print("Part 1: ${result1}");
  print("Part 2: ${result2}");
}
