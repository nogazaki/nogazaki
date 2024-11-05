const INPUT: &str = include_str!("input.txt");

pub fn main() {
    let line_regex = regex::Regex::new(r"^Game (\d+): (.*)$").unwrap();
    let set_regex = regex::Regex::new(r"\s*(\d+) (\w)").unwrap();

    let bag = (12_u32, 13_u32, 14_u32); // (red, green, blue)

    let game_content = INPUT.lines().map(|line| {
        let content = line_regex.captures(line).unwrap();

        let id = content.get(1).unwrap().as_str().parse::<u32>().unwrap();
        let game = content
            .get(2)
            .unwrap()
            .as_str()
            .replace(",", ";")
            .split(";")
            .map(|set| {
                let set_content = set_regex.captures(set).unwrap();

                let count = set_content.get(1).unwrap().as_str().parse::<u32>().unwrap();
                let color = set_content.get(2).unwrap().as_str();

                (color, count)
            })
            .fold((0, 0, 0), |mut current, set| {
                let pos = match set.0 {
                    "r" => &mut current.0,
                    "g" => &mut current.1,
                    "b" => &mut current.2,

                    _ => panic!(),
                };

                *pos = set.1.max(*pos);
                current
            });

        (id, game)
    });

    let result_1 = game_content
        .clone()
        .filter_map(|(id, game)| (game.0 <= bag.0 && game.1 <= bag.1 && game.2 <= bag.2).then_some(id))
        .sum::<u32>();

    let result_2 = game_content.clone().map(|(_, (r, g, b))| r * g * b).sum::<u32>();

    println!("Part 1: {}", result_1);
    println!("Part 2: {}", result_2);
}
