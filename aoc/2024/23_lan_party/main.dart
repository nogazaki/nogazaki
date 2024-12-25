import 'dart:io';

final input = "input.txt";

void main() async {
  final pairs = File(input).readAsLinesSync().map((line) => line.split("-")).toList();
  final connections = pairs.fold(<String, Set<String>>{}, (connections, pair) {
    connections.putIfAbsent(pair[0], () => {}).add(pair[1]);
    connections.putIfAbsent(pair[1], () => {}).add(pair[0]);

    return connections;
  });

  final threeInterconnected = pairs.fold(<String>{}, (loops, pair) {
    final common = connections[pair[0]]!.where(connections[pair[1]]!.contains);
    for (final node in common) loops.add(([...pair, node]..sort()).join(","));

    return loops;
  });

  final allConnected = connections.entries.expand((entry) {
    final others = {entry.key, ...entry.value};
    return entry.value.map((node) => connections[node]!.where(others.contains).toList()..add(node));
  }).fold(<String, int>{}, (loops, curr) {
    loops.update((curr..sort()).join(","), (count) => count + 1, ifAbsent: () => 1);
    return loops;
  });

  final result1 = threeInterconnected.where((loop) => loop.split(",").any((comp) => comp.startsWith("t"))).length;
  final result2 = (allConnected.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first.key;

  print("Part 1: ${result1}");
  print("Part 2: ${result2}");
}
