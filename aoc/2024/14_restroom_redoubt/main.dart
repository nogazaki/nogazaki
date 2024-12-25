import 'dart:io';

final input = "input.txt";

void main() async {
  final inp = File(input).readAsStringSync();

  final [width, height] = RegExp(r"(\d+) \* (\d+)").firstMatch(inp)!.groups([1, 2]).map((e) => int.parse(e!)).toList();
  final robots = RegExp(r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)").allMatches(inp).map((robot) {
    final [sx, sy, vx, vy] = robot.groups([1, 2, 3, 4]).map((n) => int.parse(n!)).toList();
    return ((sx, sy), (vx, vy));
  }).toList();

  move(int times) {
    for (var i = 0; i < robots.length; ++i) {
      final robot = robots[i];

      final (sx, sy) = robot.$1;
      final (vx, vy) = robot.$2;

      final dx = (sx + times * vx) % width;
      final dy = (sy + times * vy) % height;

      robots[i] = ((dx, dy), (vx, vy));
    }
  }

  move(100);
  final splitted = robots.fold(<(bool, bool), int>{}, (splitted, robot) {
    final (x, y) = robot.$1;
    if ((x == width ~/ 2) || (y == height ~/ 2)) return splitted;

    splitted.update((x < width ~/ 2, y < height ~/ 2), (i) => i + 1, ifAbsent: () => 1);
    return splitted;
  });

  final result1 = splitted.values.reduce((a, b) => a * b);

  move(-100);
  int continuous = 0;
  int result2 = 0;

  findEasterEgg:
  while (result2 < 1000000) {
    result2 += 1;
    move(1);

    final positions = robots.map((e) => e.$1).toSet();

    for (var h = 0; h < height; ++h) {
      for (var w = 0; w < width; ++w) {
        if (positions.contains((w, h)))
          continuous += 1;
        else
          continuous = 0;

        // What is this number ???
        if (continuous >= 10) break findEasterEgg;
      }
    }
  }

  print("Part 1: ${result1}");
  print("Part 2: ${result2}");
}
