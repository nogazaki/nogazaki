import 'dart:io';

final input = "input.txt";

void main() async {
  final lines = File(input).readAsLinesSync().map((line) {
    final [testValueString, numbersString] = line.split(":");
    final testValue = int.parse(testValueString);
    final numbers = numbersString.trim().split(" ").map(int.parse).toList();

    bool p1 = false;
    bool p2 = false;
    final queue = [(testValue, numbers.length - 1, true)];
    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);

      /// Reached the first number
      if (current.$2 == 0) {
        if (current.$1 == numbers.first) {
          p1 |= current.$3;
          p2 = true;
        }

        continue;
      }

      final number = numbers[current.$2];
      final newIndex = current.$2 - 1;

      /// The three operations guarantee a number larger than both
      if (current.$1 < number) {
        continue;
      }

      /// Add is always possible here
      queue.add((current.$1 - number, newIndex, current.$3));

      /// All numbers are integer, so the number has to be divisible by current value for it to take this path
      if (current.$1 % number == 0) {
        queue.add((current.$1 ~/ number, newIndex, current.$3));
      }

      /// There has to be something to concat with, hence "\d+"
      /// Must match the whole sequence, hence "^...$"
      final prefix = RegExp("^(\\d+)${number}\$").firstMatch("${current.$1}");
      if (prefix != null) {
        queue.add((int.parse(prefix.group(1)!), newIndex, false));
      }
    }

    return (value: testValue, p1: p1, p2: p2);
  });

  final result1 = lines.where((e) => e.p1).fold(0, (total, e) => total + e.value);
  final result2 = lines.where((e) => e.p2).fold(0, (total, e) => total + e.value);

  print("Part 1: ${result1}");
  print("Part 2: ${result2}");
}
