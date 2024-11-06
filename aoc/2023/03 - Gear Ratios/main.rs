use std::collections::HashMap;

const INPUT: &str = concat!("\n", include_str!("input.txt"), "\n");

fn main() {
    let number_matcher = regex::Regex::new(r"(\d+)").unwrap();

    let lines = INPUT
        .lines()
        .enumerate()
        .map(|(r, line)| {
            let numbers = number_matcher
                .captures_iter(line)
                .map(|c| {
                    let match_result = c.get(1).unwrap();
                    let value = match_result.as_str().parse::<u32>().unwrap();

                    ((match_result.start(), match_result.end()), value)
                })
                .collect::<Vec<_>>();

            let symbols = line
                .char_indices()
                .filter_map(|(c, s)| (!(s.is_numeric() || s == '.')).then_some(((r, c), s)))
                .collect::<Vec<_>>();

            (numbers, symbols)
        })
        .collect::<Vec<_>>();

    let mut part_numbers = Vec::new();
    let mut potential_gears = HashMap::new();

    for window in lines.windows(3) {
        for &((start, end), number) in window[1].0.iter() {
            let range = start.saturating_sub(1)..end.saturating_add(1);

            for &(pos, symbol) in window
                .iter()
                .flat_map(|line| line.1.iter())
                .filter(|((_, c), _)| range.contains(c))
            {
                part_numbers.push(number);

                if symbol != '*' {
                    continue;
                };

                let entry = potential_gears.entry(pos).or_insert(Vec::new());
                entry.push(number);
            }
        }
    }

    let result_1 = part_numbers.iter().sum::<u32>();
    let result_2 = potential_gears
        .iter()
        .filter_map(|(_, gear)| (gear.len() == 2).then_some(gear.iter().product::<u32>()))
        .sum::<u32>();

    println!("Part 1: {}", result_1);
    println!("Part 2: {}", result_2);
}
