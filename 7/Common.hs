module Common where
import Data.List

data Token = OperatorAdd | OperatorConcat | OperatorMultiply | Literal Integer deriving Show

-- https://stackoverflow.com/questions/4978578/how-to-split-a-string-in-haskell
wordsWhen     :: (Char -> Bool) -> String -> [String]
wordsWhen p s =  case dropWhile p s of
                      "" -> []
                      s' -> w : wordsWhen p s''
                            where (w, s'') = break p s'

-- Interleave the operators in between the Literal tokens
insertOperators :: [Token] -> [Token] -> [Token]
insertOperators literals operators = concat (transpose [literals, operators])

-- Evaluate an expression as a stream of Literal and Operator tokens and return the result.
evaluate :: [Token] -> Integer
evaluate [Literal n] = n
evaluate ((Literal n1):OperatorAdd:(Literal n2):tokens) = evaluate (Literal (n1 + n2):tokens)
evaluate ((Literal n1):OperatorConcat:(Literal n2):tokens) = evaluate (Literal (concatNumbers n1 n2):tokens)
    where concatNumbers n1 n2 = (n1 * (10 ^ numberLength n2)) + n2
          numberLength n = length (show n)
evaluate ((Literal n1):OperatorMultiply:(Literal n2):tokens) = evaluate (Literal (n1 * n2):tokens)
evaluate _ = error "Too many or too few tokens in token list!"

-- Generate all sequences/permutations of operators for a list of length n
allOperatorSequences :: Int -> ([Token] -> [Token]) -> [[Token]]
allOperatorSequences len (incr) = sequenceHelper incr [replicate len OperatorAdd]
    where isAllOperatorMul [] = True
          isAllOperatorMul (OperatorMultiply:ops) = isAllOperatorMul ops
          isAllOperatorMul (_:ops) = False
          sequenceHelper incr (lst:rest)
            | isAllOperatorMul lst = lst:rest
            | otherwise = sequenceHelper incr ((incr lst):lst:rest)

-- The function that actually solves the problem.
-- Given an equation result and a list of Literal tokens, figure out if there's any way
-- we can stick operators in them in order to make the equation true.
-- The incr function is used to generate the list of operators to insert.
canEquationBeTrue :: Integer -> [Token] -> ([Token] -> [Token]) -> Bool
canEquationBeTrue i toks incr = canPermutationBeTrue i (map (insertOperators toks) (allOperatorSequences ((length toks) - 1) incr))
    where canPermutationBeTrue _ [] = False
          canPermutationBeTrue i (toks:rest)
            | evaluate toks == i = True
            | otherwise = canPermutationBeTrue i rest

-- Sum the results of all the equations in the input list that are possibly true.
-- The incr function is used to generate the list of operators to insert.
sumPossiblyTrue :: [(Integer, [Token])] -> ([Token] -> [Token]) -> Integer
sumPossiblyTrue equations incr = countHelper 0 equations
    where countHelper n [] = n
          countHelper n (eq:rest)
            | canEquationBeTrue (fst eq) (snd eq) incr = countHelper (n + (fst eq)) rest
            | otherwise = countHelper n rest

-- Parse a space-separated list of numbers into a list of Literal tokens.
parseNumbers :: String -> [Token]
parseNumbers input = map toToken (wordsWhen (== ' ') input)
  where toToken s = Literal (read s)

-- Parse the raw line-delimited input into a list of tuples each representing one equation.
parseInput :: String -> [(Integer, [Token])]
parseInput rawInput = map parseLine (wordsWhen (== '\n') rawInput)
  where parseLine line = let split = wordsWhen (== ':') line
                          in (read (head split), parseNumbers (last split))
