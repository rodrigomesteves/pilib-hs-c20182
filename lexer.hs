{-# OPTIONS_GHC -fno-warn-unused-binds -fno-warn-missing-signatures #-}
{-# LANGUAGE CPP #-}
{-# LINE 1 "lexer.x" #-}

module Lexer where
import Data.Bool

#if __GLASGOW_HASKELL__ >= 603
#include "ghcconfig.h"
#elif defined(__GLASGOW_HASKELL__)
#include "config.h"
#endif
#if __GLASGOW_HASKELL__ >= 503
import Data.Array
import Data.Array.Base (unsafeAt)
#else
import Array
#endif
{-# LINE 1 "templates/wrappers.hs" #-}
-- -----------------------------------------------------------------------------
-- Alex wrapper code.
--
-- This code is in the PUBLIC DOMAIN; you may copy it freely and use
-- it for any purpose whatsoever.






import Data.Word (Word8)
















import Data.Char (ord)
import qualified Data.Bits

-- | Encode a Haskell String to a list of Word8 values, in UTF8 format.
utf8Encode :: Char -> [Word8]
utf8Encode = map fromIntegral . go . ord
 where
  go oc
   | oc <= 0x7f       = [oc]

   | oc <= 0x7ff      = [ 0xc0 + (oc `Data.Bits.shiftR` 6)
                        , 0x80 + oc Data.Bits..&. 0x3f
                        ]

   | oc <= 0xffff     = [ 0xe0 + (oc `Data.Bits.shiftR` 12)
                        , 0x80 + ((oc `Data.Bits.shiftR` 6) Data.Bits..&. 0x3f)
                        , 0x80 + oc Data.Bits..&. 0x3f
                        ]
   | otherwise        = [ 0xf0 + (oc `Data.Bits.shiftR` 18)
                        , 0x80 + ((oc `Data.Bits.shiftR` 12) Data.Bits..&. 0x3f)
                        , 0x80 + ((oc `Data.Bits.shiftR` 6) Data.Bits..&. 0x3f)
                        , 0x80 + oc Data.Bits..&. 0x3f
                        ]



type Byte = Word8

-- -----------------------------------------------------------------------------
-- The input type
















































































-- -----------------------------------------------------------------------------
-- Token positions

-- `Posn' records the location of a token in the input text.  It has three
-- fields: the address (number of chacaters preceding the token), line number
-- and column of a token within the file. `start_pos' gives the position of the
-- start of the file and `eof_pos' a standard encoding for the end of file.
-- `move_pos' calculates the new position after traversing a given character,
-- assuming the usual eight character tab stops.














-- -----------------------------------------------------------------------------
-- Default monad
















































































































-- -----------------------------------------------------------------------------
-- Monad (with ByteString input)







































































































-- -----------------------------------------------------------------------------
-- Basic wrapper


type AlexInput = (Char,[Byte],String)

alexInputPrevChar :: AlexInput -> Char
alexInputPrevChar (c,_,_) = c

-- alexScanTokens :: String -> [token]
alexScanTokens str = go ('\n',[],str)
  where go inp__@(_,_bs,s) =
          case alexScan inp__ 0 of
                AlexEOF -> []
                AlexError _ -> error "lexical error"
                AlexSkip  inp__' _ln     -> go inp__'
                AlexToken inp__' len act -> act (take len s) : go inp__'

alexGetByte :: AlexInput -> Maybe (Byte,AlexInput)
alexGetByte (c,(b:bs),s) = Just (b,(c,bs,s))
alexGetByte (_,[],[])    = Nothing
alexGetByte (_,[],(c:s)) = case utf8Encode c of
                             (b:bs) -> Just (b, (c, bs, s))
                             [] -> Nothing



-- -----------------------------------------------------------------------------
-- Basic wrapper, ByteString version
































-- -----------------------------------------------------------------------------
-- Posn wrapper

-- Adds text positions to the basic model.













-- -----------------------------------------------------------------------------
-- Posn wrapper, ByteString version














-- -----------------------------------------------------------------------------
-- GScan wrapper

-- For compatibility with previous versions of Alex, and because we can.














alex_tab_size :: Int
alex_tab_size = 8
alex_base :: Array Int Int
alex_base = listArray (0 :: Int, 41)
  [ -8
  , -55
  , -54
  , -116
  , -29
  , 4
  , 70
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , -51
  , -50
  , 0
  , 0
  , 0
  , 0
  , 80
  , 155
  , 0
  , 0
  , 0
  , 230
  , 305
  , 380
  , 455
  , 530
  , 605
  , 680
  , 755
  , 830
  , 905
  , 980
  , 1055
  , 1130
  , 1205
  , 1280
  ]

alex_table :: Array Int Int
alex_table = listArray (0 :: Int, 1535)
  [ 0
  , 5
  , 5
  , 5
  , 5
  , 5
  , 7
  , 8
  , 21
  , 20
  , 18
  , 19
  , 0
  , 5
  , 5
  , 5
  , 5
  , 5
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 5
  , 15
  , 0
  , 0
  , 0
  , 0
  , 4
  , 0
  , 13
  , 14
  , 11
  , 9
  , 5
  , 10
  , 0
  , 12
  , 6
  , 6
  , 6
  , 6
  , 6
  , 6
  , 6
  , 6
  , 6
  , 6
  , 1
  , 26
  , 17
  , 2
  , 16
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 36
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 39
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 30
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 38
  , 37
  , 37
  , 37
  , 24
  , 3
  , 25
  , 6
  , 6
  , 6
  , 6
  , 6
  , 6
  , 6
  , 6
  , 6
  , 6
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 37
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 37
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 37
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 37
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 37
  , 0
  , 37
  , 37
  , 37
  , 37
  , 22
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 37
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 23
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 37
  , 0
  , 37
  , 37
  , 37
  , 37
  , 27
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 37
  , 0
  , 37
  , 37
  , 37
  , 37
  , 28
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 37
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 31
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 37
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 32
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 37
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 41
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 37
  , 0
  , 40
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 37
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 37
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 35
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 37
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 34
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 37
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 33
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 37
  , 0
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 29
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 37
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  , 0
  ]

alex_check :: Array Int Int
alex_check = listArray (0 :: Int, 1535)
  [ -1
  , 9
  , 10
  , 11
  , 12
  , 13
  , 61
  , 61
  , 124
  , 38
  , 61
  , 61
  , -1
  , 9
  , 10
  , 11
  , 12
  , 13
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 32
  , 33
  , -1
  , -1
  , -1
  , -1
  , 38
  , -1
  , 40
  , 41
  , 42
  , 43
  , 32
  , 45
  , -1
  , 47
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , 58
  , 59
  , 60
  , 61
  , 62
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 123
  , 124
  , 125
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , 48
  , 49
  , 50
  , 51
  , 52
  , 53
  , 54
  , 55
  , 56
  , 57
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , 65
  , 66
  , 67
  , 68
  , 69
  , 70
  , 71
  , 72
  , 73
  , 74
  , 75
  , 76
  , 77
  , 78
  , 79
  , 80
  , 81
  , 82
  , 83
  , 84
  , 85
  , 86
  , 87
  , 88
  , 89
  , 90
  , -1
  , -1
  , -1
  , -1
  , 95
  , -1
  , 97
  , 98
  , 99
  , 100
  , 101
  , 102
  , 103
  , 104
  , 105
  , 106
  , 107
  , 108
  , 109
  , 110
  , 111
  , 112
  , 113
  , 114
  , 115
  , 116
  , 117
  , 118
  , 119
  , 120
  , 121
  , 122
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  ]

alex_deflt :: Array Int Int
alex_deflt = listArray (0 :: Int, 41)
  [ -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  , -1
  ]

alex_accept = listArray (0 :: Int, 41)
  [ AlexAccNone
  , AlexAccNone
  , AlexAccNone
  , AlexAccNone
  , AlexAccNone
  , AlexAccSkip
  , AlexAcc 35
  , AlexAcc 34
  , AlexAcc 33
  , AlexAcc 32
  , AlexAcc 31
  , AlexAcc 30
  , AlexAcc 29
  , AlexAcc 28
  , AlexAcc 27
  , AlexAcc 26
  , AlexAcc 25
  , AlexAcc 24
  , AlexAcc 23
  , AlexAcc 22
  , AlexAcc 21
  , AlexAcc 20
  , AlexAcc 19
  , AlexAcc 18
  , AlexAcc 17
  , AlexAcc 16
  , AlexAcc 15
  , AlexAcc 14
  , AlexAcc 13
  , AlexAcc 12
  , AlexAcc 11
  , AlexAcc 10
  , AlexAcc 9
  , AlexAcc 8
  , AlexAcc 7
  , AlexAcc 6
  , AlexAcc 5
  , AlexAcc 4
  , AlexAcc 3
  , AlexAcc 2
  , AlexAcc 1
  , AlexAcc 0
  ]

alex_actions = array (0 :: Int, 36)
  [ (35,alex_action_1)
  , (34,alex_action_2)
  , (33,alex_action_3)
  , (32,alex_action_4)
  , (31,alex_action_5)
  , (30,alex_action_6)
  , (29,alex_action_7)
  , (28,alex_action_8)
  , (27,alex_action_9)
  , (26,alex_action_10)
  , (25,alex_action_11)
  , (24,alex_action_12)
  , (23,alex_action_13)
  , (22,alex_action_14)
  , (21,alex_action_15)
  , (20,alex_action_16)
  , (19,alex_action_17)
  , (18,alex_action_18)
  , (17,alex_action_19)
  , (16,alex_action_20)
  , (15,alex_action_21)
  , (14,alex_action_22)
  , (13,alex_action_23)
  , (12,alex_action_24)
  , (11,alex_action_24)
  , (10,alex_action_24)
  , (9,alex_action_24)
  , (8,alex_action_24)
  , (7,alex_action_24)
  , (6,alex_action_24)
  , (5,alex_action_24)
  , (4,alex_action_24)
  , (3,alex_action_24)
  , (2,alex_action_24)
  , (1,alex_action_24)
  , (0,alex_action_24)
  ]

{-# LINE 40 "lexer.x" #-}

-- Each action has type :: String -> Token

-- The token type:
data Token = TokenVarId String
           | TokenAssign
           | TokenEq
           | TokenPlus
           | TokenMinus
           | TokenTimes
           | TokenDiv
           | TokenLParen
           | TokenRParen
           | TokenNot 
           | TokenInt Int
           | TokenMaior
           | TokenMenor
           | TokenMaiorIgual
           | TokenMenorIgual
		   | TokenAnd
		   | TokenOr
		   | TokenWhile
		   | TokenDo
		   | TokenLBrace
		   | TokenRBrace
		   | TokenSemiComma
		   | TokenTrue
           | TokenFalse	deriving (Eq,Show)

scanTokens = alexScanTokens

{-
main::IO ()
main = do
  s <- getContents
  let x = alexScanTokens s
  mapM_ print x
-}

alex_action_1 =  \s -> TokenInt(read s)
alex_action_2 =  \s -> TokenAssign
alex_action_3 =  \s -> TokenEq 
alex_action_4 =  \s -> TokenPlus 
alex_action_5 =  \s -> TokenMinus 
alex_action_6 =  \s -> TokenTimes 
alex_action_7 =  \s -> TokenDiv 
alex_action_8 =  \s -> TokenLParen 
alex_action_9 =  \s -> TokenRParen 
alex_action_10 =  \s -> TokenNot 
alex_action_11 =  \s -> TokenMaior 
alex_action_12 =  \s -> TokenMenor 
alex_action_13 =  \s -> TokenMaiorIgual 
alex_action_14 =  \s -> TokenMenorIgual 
alex_action_15 =  \s  -> TokenAnd
alex_action_16 =  \s  -> TokenOr
alex_action_17 =  \s  -> TokenWhile
alex_action_18 =  \s  -> TokenDo
alex_action_19 =  \s  -> TokenLBrace
alex_action_20 =  \s  -> TokenRBrace
alex_action_21 =  \s   -> TokenSemiComma
alex_action_22 =  \s -> TokenFalse
alex_action_23 =  \s -> TokenTrue
alex_action_24 =  \s -> TokenVarId s
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- -----------------------------------------------------------------------------
-- ALEX TEMPLATE
--
-- This code is in the PUBLIC DOMAIN; you may copy it freely and use
-- it for any purpose whatsoever.

-- -----------------------------------------------------------------------------
-- INTERNALS and main scanner engine































































alexIndexInt16OffAddr arr off = arr ! off




















alexIndexInt32OffAddr arr off = arr ! off











quickIndex arr i = arr ! i


-- -----------------------------------------------------------------------------
-- Main lexing routines

data AlexReturn a
  = AlexEOF
  | AlexError  !AlexInput
  | AlexSkip   !AlexInput !Int
  | AlexToken  !AlexInput !Int a

-- alexScan :: AlexInput -> StartCode -> AlexReturn a
alexScan input__ (sc)
  = alexScanUser undefined input__ (sc)

alexScanUser user__ input__ (sc)
  = case alex_scan_tkn user__ input__ (0) input__ sc AlexNone of
  (AlexNone, input__') ->
    case alexGetByte input__ of
      Nothing ->



                                   AlexEOF
      Just _ ->



                                   AlexError input__'

  (AlexLastSkip input__'' len, _) ->



    AlexSkip input__'' len

  (AlexLastAcc k input__''' len, _) ->



    AlexToken input__''' len (alex_actions ! k)


-- Push the input through the DFA, remembering the most recent accepting
-- state it encountered.

alex_scan_tkn user__ orig_input len input__ s last_acc =
  input__ `seq` -- strict in the input
  let
  new_acc = (check_accs (alex_accept `quickIndex` (s)))
  in
  new_acc `seq`
  case alexGetByte input__ of
     Nothing -> (new_acc, input__)
     Just (c, new_input) ->



      case fromIntegral c of { (ord_c) ->
        let
                base   = alexIndexInt32OffAddr alex_base s
                offset = (base + ord_c)
                check  = alexIndexInt16OffAddr alex_check offset

                new_s = if (offset >= (0)) && (check == ord_c)
                          then alexIndexInt16OffAddr alex_table offset
                          else alexIndexInt16OffAddr alex_deflt s
        in
        case new_s of
            (-1) -> (new_acc, input__)
                -- on an error, we want to keep the input *before* the
                -- character that failed, not after.
            _ -> alex_scan_tkn user__ orig_input (if c < 0x80 || c >= 0xC0 then (len + (1)) else len)
                                                -- note that the length is increased ONLY if this is the 1st byte in a char encoding)
                        new_input new_s new_acc
      }
  where
        check_accs (AlexAccNone) = last_acc
        check_accs (AlexAcc a  ) = AlexLastAcc a input__ (len)
        check_accs (AlexAccSkip) = AlexLastSkip  input__ (len)

        check_accs (AlexAccPred a predx rest)
           | predx user__ orig_input (len) input__
           = AlexLastAcc a input__ (len)
           | otherwise
           = check_accs rest
        check_accs (AlexAccSkipPred predx rest)
           | predx user__ orig_input (len) input__
           = AlexLastSkip input__ (len)
           | otherwise
           = check_accs rest


data AlexLastAcc
  = AlexNone
  | AlexLastAcc !Int !AlexInput !Int
  | AlexLastSkip     !AlexInput !Int

data AlexAcc user
  = AlexAccNone
  | AlexAcc Int
  | AlexAccSkip

  | AlexAccPred Int (AlexAccPred user) (AlexAcc user)
  | AlexAccSkipPred (AlexAccPred user) (AlexAcc user)

type AlexAccPred user = user -> AlexInput -> Int -> AlexInput -> Bool

-- -----------------------------------------------------------------------------
-- Predicates on a rule

alexAndPred p1 p2 user__ in1 len in2
  = p1 user__ in1 len in2 && p2 user__ in1 len in2

--alexPrevCharIsPred :: Char -> AlexAccPred _
alexPrevCharIs c _ input__ _ _ = c == alexInputPrevChar input__

alexPrevCharMatches f _ input__ _ _ = f (alexInputPrevChar input__)

--alexPrevCharIsOneOfPred :: Array Char Bool -> AlexAccPred _
alexPrevCharIsOneOf arr _ input__ _ _ = arr ! alexInputPrevChar input__

--alexRightContext :: Int -> AlexAccPred _
alexRightContext (sc) user__ _ _ input__ =
     case alex_scan_tkn user__ input__ (0) input__ sc AlexNone of
          (AlexNone, _) -> False
          _ -> True
        -- TODO: there's no need to find the longest
        -- match when checking the right context, just
        -- the first match will do.

