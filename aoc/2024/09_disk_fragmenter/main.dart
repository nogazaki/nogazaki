import 'dart:io';

final input = "input.txt";

List<(int, int)> parseBlocks(String input) {
  return input.split("").map(int.parse).indexed.fold([], (blocks, section) {
    blocks.add((section.$2, section.$1 % 2 == 0 ? section.$1 ~/ 2 : -1));
    return blocks;
  });
}

void compactBlockWise(List<(int, int)> blocks) {
  int leftIndex = 0;
  int rightIndex = blocks.length - 1;

  while (true) {
    while (blocks[leftIndex].$2 != -1) {
      leftIndex += 1;
    }

    while (blocks[rightIndex].$2 == -1) {
      rightIndex -= 1;
    }

    if (leftIndex > rightIndex) {
      break;
    }

    final left = blocks[leftIndex];
    final right = blocks[rightIndex];

    if (left.$1 >= right.$1) {
      blocks[leftIndex] = right;
      blocks[rightIndex] = (right.$1, -1);
      blocks.insert(leftIndex + 1, (left.$1 - right.$1, -1));
    } else {
      blocks[leftIndex] = (left.$1, right.$2);
      blocks[rightIndex] = (right.$1 - left.$1, right.$2);
    }
  }
}

void compactFileWise(List<(int, int)> blocks) {
  int rightIndex = blocks.length - 1;

  while (rightIndex >= 0) {
    final right = blocks[rightIndex];

    if (right.$2 != -1) {
      for (var leftIndex = 0; leftIndex < rightIndex; ++leftIndex) {
        final left = blocks[leftIndex];
        if (left.$2 != -1) {
          continue;
        }

        if (left.$1 >= right.$1) {
          blocks[leftIndex] = right;
          blocks[rightIndex] = (right.$1, -1);
          blocks.insert(leftIndex + 1, (left.$1 - right.$1, -1));

          break;
        }
      }
    }

    rightIndex -= 1;
  }
}

int calculateChecksum(List<(int, int)> blocks) {
  return blocks.fold((0, 0), (total, section) {
    final values = section.$2 == -1 ? [0] : List.generate(section.$1, (i) => (total.$1 + i) * section.$2);
    return (total.$1 + section.$1, total.$2 + values.fold(0, (a, b) => a + b));
  }).$2;
}

void main() async {
  final map = File(input).readAsStringSync().trim();

  final blocks1 = parseBlocks(map);
  final blocks2 = parseBlocks(map);

  compactBlockWise(blocks1);
  compactFileWise(blocks2);

  final result1 = calculateChecksum(blocks1);
  final result2 = calculateChecksum(blocks2);

  print("Part 1: ${result1}");
  print("Part 1: ${result2}");
}
