import 'dart:io';

final input = "input.txt";

void main() {
  final [section1, section2] = File(input).readAsStringSync().trim().split("\n\n");

  final comesAfter = RegExp(r"(\d+)\|(\d+)").allMatches(section1).fold(<String, List<String>>{}, (order, rule) {
    return order..putIfAbsent(rule.group(1)!, () => []).add(rule.group(2)!);
  });

  int result1 = 0;
  int result2 = 0;

  for (final line in section2.split("\n")) {
    final update = line.split(",");

    final scores = Map.fromEntries(update.map((page) {
      final score = (update.toSet()..remove(page)).where((other) => comesAfter[other]!.contains(page)).length;
      return MapEntry(page, score);
    }));

    final inOrder = update..sort((a, b) => scores[a]! - scores[b]!);
    final middle = int.parse(inOrder[inOrder.length ~/ 2]);

    if (line == inOrder.join(",")) {
      result1 += middle;
    } else {
      result2 += middle;
    }
  }

  print("Part 1: ${result1}");
  print("Part 2: ${result2}");
}
