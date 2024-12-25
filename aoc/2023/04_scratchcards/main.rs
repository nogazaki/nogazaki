use std::collections::{HashMap, HashSet};

const INPUT: &str = include_str!("input.txt");

fn main() {
    let matcher = regex::Regex::new(r"^Card\s*\d+:\s*(.*)\s\|\s*(.*)$").unwrap();
    let card_scores = INPUT
        .lines()
        .map(|line| {
            let match_result = matcher.captures(line).unwrap();
            let mut numbers = match_result.iter().skip(1).map(|group| {
                let group = group.unwrap().as_str().split(" ");
                group.filter_map(|n| n.parse::<u32>().ok()).collect::<HashSet<_>>()
            });

            let winning_numbers = numbers.next().unwrap();
            let my_numbers = numbers.next().unwrap();

            winning_numbers.intersection(&my_numbers).count()
        })
        .collect::<Vec<_>>();

    let result_1 = card_scores
        .iter()
        .fold(0, |total, &score| total + if score == 0 { 0 } else { 1 << (score - 1) });

    let mut all_cards = HashMap::from([(0, 1)]);
    let cards_count = card_scores.clone().len();

    for (card_number, card_score) in card_scores.iter().enumerate() {
        let copies_count = *all_cards.entry(card_number).or_insert(1);

        let lower_index = card_number + 1;
        let upper_index = card_number + 1 + card_score;

        for new_card in lower_index..upper_index.min(cards_count - 1) {
            let entry = all_cards.entry(new_card).or_insert(1);
            *entry += copies_count;
        }
    }

    let result_2 = all_cards.values().sum::<u32>();

    println!("Part 1: {}", result_1);
    println!("Part 2: {}", result_2);
}
