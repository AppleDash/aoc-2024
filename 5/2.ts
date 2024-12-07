import { readInput } from './1.js';

// Check if the pages in the batch are in the right order.
// If they aren't in the right order, returns an object containing the index
// of the first page that's out of order, as well as the index of the page that was
// supposed to come after it.
function checkBatch(batch: number[], pageOrderings: Record<number, number[]>) {
  const encountered = [];

  for (let i = 0; i < batch.length; i++) {
    const page = batch[i];

    encountered.push(page);

    const befores = pageOrderings[page];

    if (!befores) {
      continue;
    }

    // Each page that must come before the current page.
    for (const before of befores) {
      const beforeIndex = batch.indexOf(before);

      if (beforeIndex === -1) {
        continue;
      }

      if (encountered.indexOf(before) === -1) {
        return {
          beforeIndex: beforeIndex,
          afterIndex: i
        };
      }
    }
  }

  return {
    beforeIndex: -1,
    afterIndex: -1
  };
}

async function main() {
  const { pageOrderings, printedPages } = await readInput();

  let total = 0;

  for (const batch of printedPages) {
    let swaps = 0;

    while (true) {
      const { beforeIndex, afterIndex } = checkBatch(batch, pageOrderings);

      // No pages out of order.
      if (beforeIndex === -1) {
        if (swaps > 0) {
          const middleNumber = batch[Math.floor(batch.length / 2)];

          total += middleNumber;
        }
        break;
      }

      // Page is out of order, swap the out-of-order pages into the right positions.
      const tmp = batch[beforeIndex];
      batch[beforeIndex] = batch[afterIndex];
      batch[afterIndex] = tmp;

      swaps++;
    }
  }

  console.log(total);
}

main().catch(e => console.error(e));