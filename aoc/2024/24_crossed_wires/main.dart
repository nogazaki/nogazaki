import 'dart:io';

final input = "input.txt";

void main() async {
  final sections = File(input).readAsStringSync().split("\n\n");
  final wires = {};

  wires.addEntries(RegExp(r"([xy]\d+): ([01])").allMatches(sections[0]).map((input) {
    return MapEntry(input.group(1)!, input.group(2)! == "1");
  }));

  wires.addEntries(RegExp(r"(.+) (AND|OR|XOR) (.+) -> (.+)").allMatches(sections[1]).map((gate) {
    return MapEntry(gate.group(4)!, (a: gate.group(1)!, b: gate.group(3)!, op: gate.group(2)!));
  }));

  while (true) {
    final current = wires.entries.where((e) {
      if (e.value is bool) return false;
      return wires[e.value.a] is bool && wires[e.value.b] is bool;
    }).firstOrNull;

    if (current == null) break;
    final [a, b] = [current.value.a, current.value.b].map((e) => wires[e]! as bool).toList();

    wires[current.key] = switch (current.value.op) {
      "AND" => a && b,
      "XOR" => a ^ b,
      "OR" => a || b,
      _ => false,
    };
  }

  final result1 = wires.entries.where((e) => e.key.startsWith("z")).fold(0, (value, wire) {
    return value + ((wire.value ? 1 : 0) << int.parse(wire.key.replaceAll("z", "")));
  });

  /// Magic (TODO: automate this ???)
  ///
  /// But seriously, just draw the "circuit" and then check for nodes that doesn't seems to be a functioning full adder.
  /// To find which adder is wrong, see where `x + y` and the result of the circuit differ first, from least to most significant bit.
  /// Rinse and repeat until all adders are correct.
  final swaps = [("z06", "fkp"), ("z11", "ngr"), ("z31", "mfm"), ("krj", "bpt")];
  final result2 = (swaps.expand((e) => [e.$1, e.$2]).toList()..sort()).join(",");

  print("Part 1: ${result1}");
  print("Part 2: ${result2}");
}
