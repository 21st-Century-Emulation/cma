module Main where

import Data.Bits (complement)
import Cpu (Cpu (..), CpuState (..))
import Web.Scotty ( json, jsonData, post, scotty )

main :: IO ()
main = do
  scotty 8080 $ do
    post "/api/v1/execute" $
      do
        cpu <- jsonData
        let updatedCpu = cma cpu
        json updatedCpu

cma :: Cpu -> Cpu
cma cpu = Cpu (opcode cpu) (CpuState newA (b s) (c s) (d s) (e s) (h s) (l s) (stackPointer s) (programCounter s) newCycles (flags s))
  where
    s = state cpu
    newCycles = cycles s + 4
    newA = complement (a s)
