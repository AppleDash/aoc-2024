import Data.List
import Data.Char
import Common
    ( Token(OperatorAdd, OperatorMultiply),
      sumPossiblyTrue,
      parseInput )

-- Add "1" to the operator list as if it were a binary number where Add = 0 and Multiply = 1,
-- wrapping back around if overflow.
incrementOperators :: [Token] -> [Token]
incrementOperators tokens = reverse (incrementHelper (reverse tokens) True)
    where
        incrementHelper [] _ = [] -- We never want to extend the length of the list; this implements integer roll over
        incrementHelper (OperatorAdd:bs) True = OperatorMultiply:bs  -- Bit is 0, just set it to 1 and quit carrying
        incrementHelper (OperatorMultiply:bs) True = OperatorAdd : incrementHelper bs True -- Carry the next bit
        incrementHelper (b:bs) False = b:bs -- No carry

main = do
  rawInput <- getContents
  let parsed = parseInput rawInput

  print $ sumPossiblyTrue parsed incrementOperators
