use itertools::Itertools;

const INPUT: &str = include_str!("input.txt");

fn main() {
    let result_1 = calculate(2);
    let result_2 = calculate(1000000);

    println!("Part 1: {}", result_1);
    println!("Part 2: {}", result_2);
}

fn calculate(rate: usize) -> usize {
    let mut galaxies = INPUT
        .lines()
        .enumerate()
        .flat_map(|(ri, line)| {
            let chars = line.char_indices();
            chars.filter_map(move |(ci, c)| c.eq(&'#').then_some((ri, ci)))
        })
        .collect::<Vec<_>>();

    let expander = |offset: usize| match offset {
        0 => 0,
        n => rate * (n - 1) + 1,
    };

    let row_offsets = galaxies.windows(2).map(|w| w[1].0 - w[0].0);
    let expanded_row_offsets = row_offsets.map(expander).collect::<Vec<_>>();
    for i in 0..galaxies.len() - 1 {
        galaxies[i + 1].0 = galaxies[i].0 + expanded_row_offsets[i];
    }

    galaxies.sort_by(|a, b| Ord::cmp(&a.1, &b.1));
    let col_offsets = galaxies.windows(2).map(|w| w[1].1 - w[0].1);
    let expanded_col_offsets = col_offsets.map(expander).collect::<Vec<_>>();
    for i in 0..galaxies.len() - 1 {
        galaxies[i + 1].1 = galaxies[i].1 + expanded_col_offsets[i];
    }

    galaxies
        .iter()
        .combinations(2)
        .map(|pair| pair[0].0.abs_diff(pair[1].0) + pair[0].1.abs_diff(pair[1].1)) // Manhattan distance
        .sum()
}
