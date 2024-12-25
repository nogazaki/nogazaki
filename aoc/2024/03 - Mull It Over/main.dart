import 'dart:io';

final input = "input.txt";

void main() async {
  final instructionsMatcher = RegExp(r"mul\((\d+),(\d+)\)|do\(\)|don\'t\(\)");
  final rawInput = File(input).readAsStringSync().trim();
  final instructions = instructionsMatcher.allMatches(rawInput);

  bool enabled = true;

  int result1 = 0;
  int result2 = 0;

  for (final ins in instructions) {
    if (ins.group(0) == "do()") {
      enabled = true;
    } else if (ins.group(0) == "don't()") {
      enabled = false;
    } else {
      final value = int.parse(ins.group(1)!) * int.parse(ins.group(2)!);
      result1 += value;
      result2 += enabled ? value : 0;
    }
  }

  print("Part 1: ${result1}");
  print("Part 2: ${result2}");
}
