import 'dart:io';

final input = "input.txt";

void main() async {
  final columns = (await File(input).readAsLines()).fold((<int>[], <int>[]), (ret, line) {
    final values = line.split('   ');
    return (ret.$1..add(int.parse(values.first)), ret.$2..add(int.parse(values.last)));
  });

  columns.$1.sort();
  columns.$2.sort();

  int result1 = 0;
  for (var index = 0; index < columns.$1.length; ++index) {
    result1 += (columns.$2[index] - columns.$1[index]).abs();
  }

  int result2 = 0;
  final frequencies = columns.$2.fold(<int, int>{}, (f, e) => f..update(e, (curr) => curr + 1, ifAbsent: () => 0));
  for (final l in columns.$1) {
    result2 += l * frequencies.putIfAbsent(l, () => 0);
  }

  print("Part 1: ${result1}");
  print("Part 2: ${result2}");
}
