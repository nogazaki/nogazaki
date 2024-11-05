const INPUT: &str = include_str!("input.txt");
const DIGITS: [&str; 9] = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];

fn calculate<'input, T>(line_to_digits: impl Fn(&'input str) -> T) -> u32
where
    T: Iterator<Item = char> + 'input,
{
    INPUT
        .lines()
        .map(line_to_digits)
        .map(|mut digits| {
            let tens = digits.next().and_then(|t| t.to_digit(10)).unwrap_or_default();
            let unit = digits.last().and_then(|u| u.to_digit(10)).unwrap_or(tens);

            tens * 10 + unit
        })
        .sum()
}

fn main() {
    let result_1 = calculate(|line| line.chars().filter(|c| c.is_numeric()));
    let result_2 = calculate(|line| {
        line.char_indices().filter_map(|(index, char)| {
            if let Some(num) = DIGITS.iter().position(|digit| line[index..].starts_with(digit)) {
                char::from_digit(num as u32 + 1, 10)
            } else {
                char.is_numeric().then_some(char)
            }
        })
    });

    println!("Part 1: {}", result_1);
    println!("Part 1: {}", result_2);
}
