const INPUT: &str = include_str!("input.txt");

fn center_line_diff_count(grid: Vec<Vec<char>>) -> (usize, usize) {
    let mut ret_0 = 0;
    let mut ret_1 = 0;

    for index in 1..grid.len() {
        let (above, below) = grid.split_at(index);
        let diff = std::iter::zip(above.iter().rev(), below.iter())
            .map(|(a, b)| std::iter::zip(a, b).filter(|(ac, bc)| ac != bc).count())
            .sum::<usize>();

        if diff == 0 {
            ret_0 = index;
        } else if diff == 1 {
            ret_1 = index;
        }
    }

    (ret_0, ret_1)
}

fn process_pattern(pattern: &str) -> (usize, usize) {
    let h_grid: Vec<Vec<char>> = pattern.lines().map(|line| line.chars().collect()).collect();

    let (rows, cols) = (h_grid.len(), h_grid[0].len());
    let v_grid: Vec<Vec<char>> = (0..cols).map(|c| (0..rows).map(|r| h_grid[r][c]).collect()).collect();

    let h = center_line_diff_count(h_grid);
    let v = center_line_diff_count(v_grid);

    (h.0 * 100 + v.0, h.1 * 100 + v.1)
}

fn main() {
    let sum_calc = |a: (usize, usize), b: (usize, usize)| (a.0 + b.0, a.1 + b.1);
    let (result_1, result_2) = INPUT.trim().split("\n\n").map(process_pattern).fold((0, 0), sum_calc);

    println!("Part 1: {}", result_1);
    println!("Part 2: {}", result_2);
}
