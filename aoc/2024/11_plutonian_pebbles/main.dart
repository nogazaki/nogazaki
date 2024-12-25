import 'dart:io';

final input = "input.txt";

void main() async {
  final stones = Map.fromEntries(File(input).readAsStringSync().trim().split(" ").map((e) => MapEntry(e, 1)));

  final split = () {
    final newArrangement = <String, int>{};

    for (final (stone) in stones.entries) {
      final keys = [];
      if (stone.key == "0") {
        keys.add("1");
      } else if (stone.key.length % 2 == 0) {
        keys.add(int.parse(stone.key.substring(0, stone.key.length ~/ 2)).toString());
        keys.add(int.parse(stone.key.substring(stone.key.length ~/ 2)).toString());
      } else {
        keys.add((int.parse(stone.key) * 2024).toString());
      }

      for (final key in keys) {
        newArrangement.update(key, (i) => i + stone.value, ifAbsent: () => stone.value);
      }
    }

    stones.clear();
    stones.addAll(newArrangement);
  };

  for (var i = 0; i < 25; ++i) split();
  final result1 = stones.values.reduce((a, b) => a + b);

  for (var i = 0; i < 50; ++i) split();
  final result2 = stones.values.reduce((a, b) => a + b);

  print("Part 1: ${result1}");
  print("Part 2: ${result2}");
}
