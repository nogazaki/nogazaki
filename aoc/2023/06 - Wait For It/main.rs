const INPUT: &str = include_str!("input.txt");

fn main() {
    let result_1 = calculate(|line| {
        let parts = line.split(" ");
        parts.filter_map(|s| s.parse().ok()).collect()
    });
    let result_2 = calculate(|line| {
        let numbers = line.chars().filter(|c| c.is_numeric());
        vec![numbers.collect::<String>().parse().unwrap()]
    });

    println!("Part 1: {}", result_1);
    println!("Part 2: {}", result_2);
}

fn calculate(parser: impl Fn(&str) -> Vec<u64>) -> u64 {
    let mut lines = INPUT.lines().map(parser);

    let times = lines.next().unwrap();
    let distances = lines.next().unwrap();

    let counts = std::iter::zip(times, distances).map(|(time, distance)| {
        // Let the time to hold be `x`
        // Then the distance the boat goes is `x * (time - x)`
        // Solve for x in `x * (time - x) = distance`
        let delta = time * time - 4 * distance;
        let x1 = 0.5 * (time as f64 + (delta as f64).sqrt());
        let x2 = 0.5 * (time as f64 - (delta as f64).sqrt());

        let (x1, x2) = (x1.min(x2), x1.max(x2));

        // The winning range
        // - starts from the smallest integer larger than x1
        // - ends with the largest integer smaller than x2
        let (start, end) = (x1.floor() as u64 + 1, x2.ceil() as u64 - 1);

        end - start + 1
    });

    counts.product()
}
