use aoc_2024_part2::{is_row_ok, is_row_ok_tolerant, read_input};
use std::path::Path;

fn compute(input: &[Vec<i32>], check: fn(&[i32]) -> bool) -> Result<(), std::io::Error> {
    let safe: i32 = input.iter().map(|row| check(row) as i32).sum();

    println!("{}", safe);

    Ok(())
}

fn main() -> Result<(), std::io::Error> {
    let input = read_input(Path::new("2.txt"))?;

    compute(&input, is_row_ok)?;
    compute(&input, is_row_ok_tolerant)
}
