package org.appledash.aoc.part2

import java.nio.file.Files
import java.nio.file.Paths

data class Block(val id: Int, val free: Boolean, var size: Int, var considered: Boolean = false)

fun parseInput(): ArrayList<Block> {
    val rawInput = Files.readString(Paths.get("input.txt"))
    val blocks = ArrayList<Block>(rawInput.length)
    var id = 0

    rawInput.forEachIndexed { index, c ->
        val size = c - '0'

        if (index % 2 == 0) {
            blocks.add(Block(id, false, size))
            id++
        } else {
            blocks.add(Block(-1, true, size))
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
fun findFreeBlock(blocks: List<Block>, minSize: Int): Pair<Int, Block>? {
    for (i in blocks.indices) {
        val block = blocks[i]

        if (block.free && block.size >= minSize) {
            return i to block
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
fun findUsedBlock(blocks: List<Block>, start: Int): Pair<Int, Block>? {
    for (i in start downTo 0) {
        if (blocks[i].id != 0 && !blocks[i].free && !blocks[i].considered) {
            return i to blocks[i]
        }
    }

    return null
}

// This uses a Long because the checksum can overflow an int!
fun calculateChecksum(blocks: List<Block>): Long {
    return blocks
        .flatMap { block -> (0..<block.size).map { block } }
        .mapIndexed { i, it -> (if (it.free) 0 else (i.toLong() * it.id.toLong())) }
        .sum()
}

fun compact(blocks: ArrayList<Block>) {
    var lastBlock = blocks.size - 1

    while (true) {
        val usedBlockInfo = findUsedBlock(blocks, lastBlock)

        if (usedBlockInfo == null) {
            println("Done compacting: no more blocks to move!")
            break
        }

        val (usedBlockIndex, usedBlock) = usedBlockInfo

        usedBlock.considered = true
        // No need to consider blocks after the one we just considered anymore
        lastBlock = usedBlockIndex - 1

        // No free block available, skip this one
        val freeBlockInfo = findFreeBlock(blocks, usedBlock.size) ?: continue

        val (freeIndex, freeBlock) = freeBlockInfo

        if (freeIndex > usedBlockIndex) {
            continue
        }

        // Quick optimization to avoid inserting into the array
        if (freeBlock.size == usedBlock.size) {
            blocks[freeIndex] = usedBlock
            blocks[usedBlockIndex] = freeBlock
        } else {
            freeBlock.size -= usedBlock.size
            blocks[usedBlockIndex] = Block(-1, true, usedBlock.size)
            blocks.add(freeIndex, usedBlock)
        }
    }
}

/**
 * Debug function to show the current block map
 */
fun printBlocks(blocks: List<Block>) {
    for (block in blocks) {
        if (block.free) {
            print(".".repeat(block.size))
        } else {
            print(block.id.toString().repeat(block.size))
            //print(",")
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