use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

pub fn parse_line(line: &str) -> Vec<i32> {
    line.split(' ').map(|c| c.parse::<i32>().unwrap()).collect()
}

pub fn read_input(path: &Path) -> Result<Vec<Vec<i32>>, std::io::Error> {
    let file = File::open(path)?;
    let lines = io::BufReader::new(file)
        .lines()
        .map(|line| parse_line(&line.unwrap()))
        .collect();

    Ok(lines)
}

// Returns true if the row is safe, false otherwise.
pub fn is_row_ok(row: &[i32]) -> bool {
    let mut greater = None;

    for window in row.windows(2) {
        let [last, cur] = window else {
            panic!("Unreachable code")
        };
        let delta = (last - cur).abs();

        if delta < 1 || delta > 3 {
            return false;
        }

        match greater {
            None => greater = Some(cur > last),
            Some(g) => {
                if (cur > last) != g {
                    return false;
                }
            }
        }
    }

    true
}

// Returns true if the row is safe when removing between 0 and 1 elements, false otherwise.
pub fn is_row_ok_tolerant(row: &[i32]) -> bool {
    // Try removing each element and see if it's valid without that element.
    // Note that we don't need to first do a test with all the elements, because,
    // while a row could be valid without removing an element, we don't care about that case
    // since there's no way a row could become invalid by removing an element.
    (0..row.len())
        .map(|i| [&row[..i], &row[i + 1..]].concat())
        .any(|row_except_i| is_row_ok(&row_except_i))
}
