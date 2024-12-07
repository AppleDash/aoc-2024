import { readFile } from 'fs/promises';

export async function readInput() {
  const rawInput = await readFile('input.txt', { encoding: 'utf-8' });
  const pageOrderings = [];
  const printedPages = [];
  let state = 'orderings';

  for (const line of rawInput.split("\n")) {
    if (line === '') {
      state = 'printed';
    } else if (state === 'orderings') {
      const [before, after] = line.split('|').map(n => parseInt(n));

      if (after in pageOrderings) {
        pageOrderings[after].push(before);
      } else {
        pageOrderings[after] = [before];
      }
    } else {
      printedPages.push(line.split(',').map(n => parseInt(n)));
    }
  }

  return { pageOrderings, printedPages };
}

// @return true if the pages in this batch are in the right order according to pageOrderings.
function checkBatch(batch: number[], pageOrderings: Record<number, number[]>) {
  const encountered = [];

  for (const page of batch) {
    encountered.push(page);

    const befores = pageOrderings[page];

    if (!befores) {
      continue;
    }

    for (const before of befores) {
      if (batch.indexOf(before) === -1) {
        continue;
      }

      if (encountered.indexOf(before) === -1) {
        return false;
      }
    }
  }

  return true;
}

async function main() {
  const { pageOrderings, printedPages } = await readInput();

  let total = 0;

  for (const batch of printedPages) {
    if (checkBatch(batch, pageOrderings)) {
      const middleNumber = batch[Math.floor(batch.length / 2)];

      total += middleNumber;
    }
  }

  console.log(total);
}

// main().catch(e => console.error(e));
