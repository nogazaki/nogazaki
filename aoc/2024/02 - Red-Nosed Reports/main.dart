import 'dart:io';

final input = "input.txt";

bool isSafe(Iterable<int> report) {
  final sign = (report.elementAt(1) - report.elementAt(0)).sign;
  bool ret = true;

  for (var i = 0; i < report.length - 1; ++i) {
    final diff = report.elementAt(i + 1) - report.elementAt(i);
    ret &= (diff.sign == sign && 1 <= diff.abs() && diff.abs() <= 3);
  }

  return ret;
}

void main() async {
  final reports = File(input).readAsLinesSync().map((line) => line.split(" ").map(int.parse));

  final result1 = reports.where(isSafe).length;

  final result2 = reports
      .where((report) => List<int>.generate(report.length, (i) => i)
          .map((index) => [...report.take(index), ...report.skip(index + 1)])
          .any(isSafe))
      .length;

  print("Part 1: ${result1}");
  print("Part 2: ${result2}");
}
