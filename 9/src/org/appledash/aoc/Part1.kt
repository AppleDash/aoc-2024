package org.appledash.aoc

import java.nio.file.Files
import java.nio.file.Paths

data class Block(val id: Int, val free: Boolean, var moved: Boolean = false)

fun parseInput(): ArrayList<Block> {
    val rawInput = Files.readString(Paths.get("input.txt"))
    val blocks = ArrayList<Block>(rawInput.length)
    var id = 0

    rawInput.forEachIndexed { index, c ->
        val size = c - '0'

        if (index % 2 == 0) {
            for (i in 0..<size) {
                blocks.add(Block(id, false))
            }
            id++
        } else {
            for (i in 0..<size) {
                blocks.add(Block(-1, true))
            }
        }
    }

    return blocks
}

/**
 * Find the first free block in the given list of blocks,
 * starting at the start and moving towards the end.
 *
 * @param blocks List of Blocks to consider
 * @param start Index in the List to start searching at
 * @return Index of free block, or null if none found
 */
fun findFreeBlock(blocks: List<Block>, start: Int): Int? {
    for (i in start..<blocks.size) {
        val block = blocks[i]

        if (block.free) {
            return i
        }
    }

    return null
}

/**
 * Find the first used block in the given list of blocks,
 * starting at the start and moving backwards towards the beginning.
 *
 * @param blocks List of Blocks to consider
 * @param start Index in the List to start searching at
 * @return Index of used block, or null if none found
 */
fun findUsedBlock(blocks: List<Block>, start: Int): Int? {
    for (i in start downTo 0) {
        if (blocks[i].id != 0 && !blocks[i].free) {
            return i
        }
    }

    return null
}

// This uses a Long because the checksum can overflow an int!
fun calculateChecksum(blocks: List<Block>): Long {
    return blocks.filterNot { it.free }
        .mapIndexed { i, it -> i.toLong() * it.id.toLong() }
        .sum()
}

fun compact(blocks: ArrayList<Block>) {
    var lastBlock = blocks.size - 1
    var firstBlock = 0

    while (true) {
        val blockIndex = findUsedBlock(blocks, lastBlock)

        if (blockIndex == null) {
            println("Done compacting: no more blocks to move!")
            break
        }

        val freeIndex = findFreeBlock(blocks, firstBlock)

        if (freeIndex == null) {
            println("Done compacting: no more free blocks!")
            break
        }

        if (freeIndex > blockIndex) {
            println("Done compacting: first free index is after the last block!")
            break
        }

        val freeBlock = blocks[freeIndex]

        // Mark the block as moved
        blocks[blockIndex].moved = true
        // Actually move the block
        blocks[freeIndex] = blocks[blockIndex]
        // Move the free space to the old position of the block
        blocks[blockIndex] = freeBlock

        // Shrink the window on both sides so we don't have to consider blocks that will never
        // match the tests.
        firstBlock = freeIndex + 1
        lastBlock = blockIndex - 1
    }
}

/**
 * Debug function to show the current block map
 */
fun printBlocks(blocks: List<Block>) {
    for (block in blocks) {
        if (block.free) {
            print(".")
        } else {
            print(block.id)
            print(",")
        }
    }
    println()
}

fun main() {
    val blocks = parseInput()

    // printBlocks(blocks)

    compact(blocks)

    // printBlocks(blocks)
    println(calculateChecksum(blocks))
}