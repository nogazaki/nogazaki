import 'dart:io';

final input = "input.txt";

List<String> transpose(List<String> lines) {
  final result = List<List<String>>.generate(lines[0].length, (i) => []);
  for (final line in lines) {
    for (var i = 0; i < line.length; ++i) {
      result[i].add(line[i]);
    }
  }

  return result.map((list) => list.join()).toList();
}

List<String> shift(List<String> lines, bool direction) => lines.indexed.map((line) {
      final left = direction ? line.$1 : (line.$2.length - line.$1 - 1);
      final right = direction ? (line.$2.length - line.$1 - 1) : line.$1;
      return ["." * left, line.$2, "." * right].join();
    }).toList();

int wordCounter(List<String> lines) {
  final counts = lines.map((line) {
    final forward = RegExp("XMAS").allMatches(line).length;
    final backward = RegExp("SAMX").allMatches(line).length;

    return forward + backward;
  });

  return counts.fold(0, (sum, line) => sum + line);
}

void main() async {
  final horizontal = File(input).readAsLinesSync();
  final vertical = transpose(horizontal);
  final diagonal1 = transpose(shift(horizontal, true));
  final diagonal2 = transpose(shift(horizontal, false));

  final result1 = [horizontal, vertical, diagonal1, diagonal2].map(wordCounter).fold(0, (sum, count) => sum + count);

  int result2 = 0;
  for (var r = 1; r < horizontal.length - 1; ++r) {
    for (var c = 1; c < horizontal[0].length - 1; ++c) {
      if (horizontal[r][c] != "A") {
        continue;
      }

      final diag1 = (horizontal[r + 1][c + 1], horizontal[r - 1][c - 1]);
      final diag2 = (horizontal[r + 1][c - 1], horizontal[r - 1][c + 1]);

      if ((diag1 == ("S", "M") || diag1 == ("M", "S")) && (diag2 == ("S", "M") || diag2 == ("M", "S"))) {
        result2 += 1;
      }
    }
  }

  print("Part 1: ${result1}");
  print("Part 2: ${result2}");
}
