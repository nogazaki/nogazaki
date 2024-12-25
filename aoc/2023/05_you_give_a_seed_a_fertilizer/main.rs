const INPUT: &str = include_str!("input.txt");

fn main() {
    let mut groups = INPUT.split("\n\n");

    let seeds_str = groups.next().unwrap().split(" ");
    let seeds = seeds_str.skip(1).map(|n| n.parse().unwrap());

    let maps = groups.map(|group| {
        let ranges = group.lines().skip(1); // skip the header "<a>-to-<b> map"
        ranges.map(|map_str| {
            let mut numbers = map_str.split(" ").map(|n| n.parse().unwrap());

            let s_dest = numbers.next().unwrap();
            let s_source = numbers.next().unwrap();

            let offset = s_source - s_dest;
            let length = numbers.next().unwrap();

            let e_source = s_source + length;

            let single_map = move |value: i64| (s_source..e_source).contains(&value).then_some(value - offset);

            let range_map = move |((mut start, mut end), mapped): ((i64, i64), bool)| {
                if start > e_source || end < s_source || mapped {
                    return vec![((start, end), mapped)];
                }

                let map_range = s_source..e_source;
                let mut ranges = Vec::new();

                if !map_range.contains(&start) {
                    ranges.push(((start, s_source), false));
                    start = s_source;
                }

                if !map_range.contains(&(end - 1)) {
                    ranges.push(((e_source, end), false));
                    end = e_source;
                }

                ranges.push(((start - offset, end - offset), true));
                ranges
            };

            (single_map, range_map)
        })
    });

    let values_map = seeds.clone().map(|seed| {
        maps.clone().fold(seed, |value, mut map| {
            map.find_map(|(single_map, _)| single_map(value)).unwrap_or(value)
        })
    });

    let starts = seeds.clone().step_by(2);
    let lengths = seeds.clone().skip(1).step_by(2);
    let ranges_map = std::iter::zip(starts, lengths).flat_map(|(start, length)| {
        let maps = maps.clone();
        maps.fold(vec![(start, start + length)], |ranges, map| {
            let ranges = ranges.into_iter().map(|range| (range, false));
            let mapped_ranges = ranges.flat_map(|range| {
                let mut splitted = vec![range];
                for (_, range_map) in map.clone() {
                    splitted = splitted.into_iter().flat_map(range_map).collect()
                }

                splitted
            });

            mapped_ranges.map(|r| r.0).collect()
        })
    });

    println!("Part 1: {}", values_map.min().unwrap());
    println!("Part 2: {}", ranges_map.min().unwrap().0);
}
