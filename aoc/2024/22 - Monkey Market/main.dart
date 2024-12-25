import 'dart:io';

final input = "input.txt";

int generate(int current) {
  current ^= (current * 64);
  current %= 16777216;

  current ^= (current ~/ 32);
  current %= 16777216;

  current ^= (current * 2048);
  current %= 16777216;

  return current;
}

void main() async {
  final seeds = File(input).readAsLinesSync().map(int.parse).toList();

  final allSequences = <String, int>{};

  final generated = seeds.map((seed) {
    final sequences = <String, int>{};

    final changes = [];
    for (var i = 0; i < 2000; ++i) {
      final before = seed % 10;
      seed = generate(seed);

      changes.add((seed % 10) - before);
      if (changes.length > 4) {
        changes.removeAt(0);
        sequences.putIfAbsent(changes.join(","), () => seed % 10);
      }
    }

    for (final sequence in sequences.entries) {
      allSequences.update(sequence.key, (count) => count + sequence.value, ifAbsent: () => sequence.value);
    }

    return seed;
  });

  final result1 = generated.reduce((a, b) => a + b);
  final result2 = (allSequences.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first.value;

  print("Part 1: ${result1}");
  print("Part 2: ${result2}");
}
