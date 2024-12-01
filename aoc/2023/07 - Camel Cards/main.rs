use std::collections::HashMap;

const INPUT: &str = include_str!("input.txt");

fn main() {
    let result_1 = calculate("23456789TJQKA", |map| map.into_values().collect());
    let result_2 = calculate("J23456789TQKA", |mut map| {
        let jokers_counts = map.remove(&0).unwrap_or(0);
        let mut counts = map.into_values().collect::<Vec<_>>();
        counts.sort();

        if let Some(count) = counts.last_mut() {
            *count += jokers_counts;
        } else {
            counts.push(jokers_counts);
        }

        counts
    });

    println!("Part 1: {}", result_1);
    println!("Part 2: {}", result_2);
}

fn calculate(label_maps: &str, cards_count_process: impl Fn(HashMap<usize, usize>) -> Vec<usize>) -> usize {
    let lines = INPUT.lines();
    let parsed_lines = lines.map(|line| {
        let mut parts = line.split(" ");

        let content = parts.next().unwrap().chars();
        let bid = parts.next().unwrap().parse::<usize>().unwrap();

        let cards = content.map(|c| label_maps.find(c).unwrap()).collect::<Vec<_>>();
        let cards_count = cards.iter().fold(HashMap::new(), |mut state, &value| {
            *state.entry(value).or_insert(0) += 1;
            state
        });

        let mut cards_count = cards_count_process(cards_count);
        cards_count.sort();

        let cards_type = match cards_count[..] {
            [5] => 6,          // Five of a kind
            [1, 4] => 5,       // Four of a kind
            [2, 3] => 4,       // Full house
            [1, 1, 3] => 3,    // Three of a kind
            [1, 2, 2] => 2,    // Two pair
            [1, 1, 1, 2] => 1, // One pair
            _ => 0,            // High card
        };

        (cards_type, cards, bid)
    });

    let mut hands = parsed_lines.collect::<Vec<_>>();
    hands.sort();

    let winning_map = hands.iter().enumerate().map(|(rank, &(_, _, bid))| (rank + 1) * bid);

    winning_map.sum()
}
