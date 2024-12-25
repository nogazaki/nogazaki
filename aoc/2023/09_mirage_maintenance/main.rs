const INPUT: &str = include_str!("input.txt");

fn main() {
    let histories_str = INPUT.lines().map(|line| line.split(" "));
    let histories = histories_str.map(|line| line.map(|num| num.parse::<isize>().unwrap()));

    let differences = histories.map(|record| {
        let record = record.collect::<Vec<_>>();
        let mut layers = vec![record];

        loop {
            let previous = layers.last().unwrap();
            let next = previous.windows(2).map(|window| window[1] - window[0]);

            if next.clone().all(|v| v == 0) {
                break;
            } else {
                layers.push(next.collect());
            }
        }

        layers.reverse();
        layers.into_iter().map(|layer| (layer[layer.len() - 1], layer[0]))
    });

    let (result_1, result_2) = differences
        .map(|history| history.fold((0, 0), |last, layer| (layer.0 + last.0, layer.1 - last.1)))
        .fold((0, 0), |(a, b), (c, d)| (a + c, b + d));

    println!("Part 1: {}", result_1);
    println!("Part 2: {}", result_2);
}
