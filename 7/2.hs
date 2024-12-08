import Data.List
import Data.Char
import Common

-- Add "1" to the operator list as if it were a ternary number where Add = 0 and Concat = 1 and Multiply = 2,
-- wrapping back around if overflow.
incrementOperators :: [Token] -> [Token]
incrementOperators tokens = reverse (incrementHelper (reverse tokens) True)
    where
        incrementHelper [] _ = [] -- We never want to extend the length of the list; this implements integer roll over
        incrementHelper (OperatorAdd:bs) True = OperatorConcat:bs  -- Bit is 0, just increment it and quit carrying
        incrementHelper (OperatorConcat:bs) True = OperatorMultiply:bs -- Bit is 1, same as above
        incrementHelper (OperatorMultiply:bs) True = OperatorAdd : incrementHelper bs True -- Carry the next bit
        incrementHelper (b:bs) False = b:bs -- No carry

main = do
  rawInput <- getContents
  let parsed = parseInput rawInput

  print $ sumPossiblyTrue parsed incrementOperators
