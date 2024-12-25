import 'dart:io';

final input = "input.txt";

int minTickets((int, int) buttonA, (int, int) buttonB, (int, int) prize, bool needOffset) {
  if (needOffset) prize = (prize.$1 + 10000000000000, prize.$2 + 10000000000000);

  final denominator = buttonA.$1 * buttonB.$2 - buttonB.$1 * buttonA.$2;
  final a = prize.$1 * buttonB.$2 - buttonB.$1 * prize.$2;
  final b = buttonA.$1 * prize.$2 - prize.$1 * buttonA.$2;

  if ((denominator != 0) && (a % denominator == 0) && (b % denominator == 0)) {
    final (aa, bb) = (a ~/ denominator, b ~/ denominator);
    if (needOffset || (aa <= 100 && bb <= 100)) return 3 * aa + bb;
  }

  return 0;
}

void main() async {
  final pattern = r"Button A: X\+(\d+), Y\+(\d+)\nButton B: X\+(\d+), Y\+(\d+)\nPrize: X=(\d+), Y=(\d+)";
  final matcher = RegExp(pattern);

  int result1 = 0;
  int result2 = 0;

  final machines = matcher.allMatches(File(input).readAsStringSync());
  for (final machine in machines) {
    final buttonA = (int.parse(machine.group(1)!), int.parse(machine.group(2)!));
    final buttonB = (int.parse(machine.group(3)!), int.parse(machine.group(4)!));
    final prize = (int.parse(machine.group(5)!), int.parse(machine.group(6)!));

    result1 += minTickets(buttonA, buttonB, prize, false);
    result2 += minTickets(buttonA, buttonB, prize, true);
  }

  print("Part 1: ${result1}");
  print("Part 2: ${result2}");
}
