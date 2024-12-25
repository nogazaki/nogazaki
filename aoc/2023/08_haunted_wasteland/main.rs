use num::integer::lcm;
use std::collections::HashMap;

const INPUT: &str = include_str!("input.txt");

fn main() {
    let mut groups = INPUT.split("\n\n");

    let instructions = groups.next().unwrap().chars();
    let instructions = instructions.map(|c| "LR".find(c).unwrap());

    let network = groups.next().unwrap().lines();
    let network = network.fold(HashMap::new(), |mut network, line| {
        let line_matcher = regex::Regex::new(r"(...) = \((...), (...)\)").unwrap();

        let nodes = line_matcher.captures(line).unwrap();
        let (_, [current, left, right]) = nodes.extract();

        network.insert(current, [left, right]);
        network
    });

    let path_finder = network.keys().filter(|node| node.ends_with("A")).map(|node| {
        let mut current = *node;
        let mut steps = instructions.clone().cycle().enumerate();

        let path = steps.find_map(|(step, instruction)| {
            current = network.get(&current).unwrap()[instruction];
            current.ends_with("Z").then_some((node, step + 1))
        });

        path.unwrap()
    });

    let result_1 = path_finder.clone().find(|(&s, _)| s == "AAA").unwrap().1;
    let result_2 = path_finder.clone().fold(1, |x, (_, y)| lcm(x, y));

    println!("Part 1: {}", result_1);
    println!("Part 2: {}", result_2);
}
