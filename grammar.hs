{-# LANGUAGE RecordWildCards #-}

import Data.Typeable
import Data.Maybe

{- |
 - Pi-lib expressions. 
 -
 - These will be used futurely by the parser, and will be returned according to the tokens found in the imp program.
-}
data Identifier = Id String deriving (Show, Eq)
data Expr = Aexp Aexpr | Bexp Bexpr | Idtf Identifier | Kw Keyword | Comm Cmd deriving (Show, Eq)
data Aexpr = Num Int | Sum Aexpr Aexpr | Sub Aexpr Aexpr | Mul Aexpr Aexpr deriving (Show, Eq)
data Bexpr = Boo Bool | Eq Bexpr Bexpr | Not Bexpr | Gt Bexpr Bexpr | Ge Bexpr Bexpr 
           | Lt Bexpr Bexpr | Le Bexpr Bexpr | And Bexpr Bexpr | Or Bexpr Bexpr deriving (Show, Eq)
data Statement = Exp Expr | Command Cmd deriving Show
data Cmd = Assign Identifier Expr | Loop Bexpr Cmd | CSeq Cmd Cmd deriving (Show, Eq)
data Keyword = KWSum | KWMul | KWSub 
             | KWEq | KWNot | KWOr | KWAnd | KWLt | KWLe | KWGt | KWGe 
             | KWAssign | KWLoop deriving (Show, Eq)
data Value = Bo { bval :: Bool } | In { ival :: Int } | Idt { idval :: Identifier } deriving (Show, Eq)
{- |
 - Automata definition
 -}
type ValueStack = [Value]
type ControlStack = [Expr]
{-data ExpPiAut = ExpPiAut { val :: ValueStack,
                           cnt :: ControlStack
                         } deriving Show-}

type Loc = Integer
type Env = [(Value,Expr)]
type Sto = [(Expr,Value)]
data CmdPiAut = CmdPiAut { env :: Env,
                           sto :: Sto,
                           loc :: Loc,
                           val :: ValueStack,
                           cnt :: ControlStack
                         }
{- |
 - automata functions evaluation
eval :: ExpPiAut -> ExpPiAut
eval (ExpPiAut v []) = ExpPiAut v []
eval (ExpPiAut v c) = case (head c) of
                           Aexp (Sum aex1 aex2) -> eval ExpPiAut {cnt = Aexp aex1 : Aexp aex2 : Kw KWSum : tail c, val = v} 
                           Aexp (Sub aex1 aex2) -> eval ExpPiAut {cnt = Aexp aex1 : Aexp aex2 : Kw KWSub : tail c, val = v}
                           Aexp (Mul aex1 aex2) -> eval ExpPiAut {cnt = Aexp aex1 : Aexp aex2 : Kw KWMul : tail c, val = v}
                           Bexp (Eq  exp1 exp2) -> eval ExpPiAut {cnt = Bexp exp1 : Bexp exp2 : Kw KWEq  : tail c, val = v} 
                           Bexp (Or  exp1 exp2) -> eval ExpPiAut {cnt = Bexp exp1 : Bexp exp2 : Kw KWOr  : tail c, val = v} 
                           Bexp (And exp1 exp2) -> eval ExpPiAut {cnt = Bexp exp1 : Bexp exp2 : Kw KWAnd  : tail c, val = v} 
                           Bexp (Lt  exp1 exp2) -> eval ExpPiAut {cnt = Bexp exp1 : Bexp exp2 : Kw KWLt  : tail c, val = v} 
                           Bexp (Le  exp1 exp2) -> eval ExpPiAut {cnt = Bexp exp1 : Bexp exp2 : Kw KWLe  : tail c, val = v} 
                           Bexp (Ge  exp1 exp2) -> eval ExpPiAut {cnt = Bexp exp1 : Bexp exp2 : Kw KWGe  : tail c, val = v} 
                           Bexp (Gt  exp1 exp2) -> eval ExpPiAut {cnt = Bexp exp1 : Bexp exp2 : Kw KWGt  : tail c, val = v} 
                           Bexp (Not ex)        -> eval ExpPiAut {cnt = Bexp ex : Kw KWNot : tail c, val = v}
                           Aexp (Num ival)      -> eval ExpPiAut {cnt = tail c, val = In ival : v}
                           Bexp (Boo bval)      -> eval ExpPiAut {cnt = tail c, val = Bo bval : v}
                           Kw KWSum             -> eval ExpPiAut {cnt = tail c, val = In (ival (head v) + ival (head (tail v))) : tail (tail v)}
                           Kw KWSub             -> eval ExpPiAut {cnt = tail c, val = In (ival (head v) - ival (head (tail v))) : tail (tail v)}
                           Kw KWMul             -> eval ExpPiAut {cnt = tail c, val = In (ival (head v) * ival (head (tail v))) : tail (tail v)}
                           Kw KWEq              -> eval ExpPiAut {cnt = tail c, val = Bo (bval (head v) == bval (head (tail v))) : tail (tail v)}
                           Kw KWLe              -> eval ExpPiAut {cnt = tail c, val = Bo (bval (head v) <= bval (head (tail v))) : tail (tail v)}
                           Kw KWLt              -> eval ExpPiAut {cnt = tail c, val = Bo (bval (head v) < bval (head (tail v))) : tail (tail v)}
                           Kw KWGe              -> eval ExpPiAut {cnt = tail c, val = Bo (bval (head v) >= bval (head (tail v))) : tail (tail v)}
                           Kw KWGt              -> eval ExpPiAut {cnt = tail c, val = Bo (bval (head v) > bval (head (tail v))) : tail (tail v)}
                           Kw KWOr              -> eval ExpPiAut {cnt = tail c, val = Bo (bval (head v) || bval (head (tail v))) : tail (tail v)}
                           Kw KWAnd             -> eval ExpPiAut {cnt = tail c, val = Bo (bval (head v) && bval (head (tail v))) : tail (tail v)}
                           Kw KWNot             -> eval ExpPiAut {cnt = tail c, val = Bo (not (bval (head v))) : tail v}

-}
-- TODO: rewrite fromJust lookup key map to only a lookup as composition of both fns
eval :: CmdPiAut -> CmdPiAut
eval cpa@(CmdPiAut e s l v c) = case (head c) of
                                 Comm (Assign idtf exp) -> eval cpa{val = Idt idtf : v, cnt = exp : Kw KWAssign : tail c} 
                                 Comm (CSeq cmd1 cmd2)  -> eval cpa{cnt = Comm cmd1 : Comm cmd2 : tail c}
                                 Idtf (Id str)          -> eval cpa{cnt = tail c, val = fromJust (lookup (fromJust (lookup (Idt (Id str)) e)) s) : v }
                                 Kw KWAssign            -> eval cpa{cnt = tail c, val = tail (tail v), sto = (fromJust (lookup (head (tail v)) e), head v) : s }
{- 
evalSum aut exp exp = aut&cnt 
aut@(ExpPiAut { cnt = cnts@(ControlStack) }) = aut {cnt = cnt ++ exp1 ++ exp2}
-}

{- Example expressions
ExpPiAut [] [Sum (Num 5) (Num 2)]

-}
