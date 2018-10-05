module Main where
import Parser
import Lexer
import Data.Dynamic
import Data.Maybe
import System.IO
import qualified Data.Map.Strict as Map


{- |
 - Automata definition
 -}
 
data Location = L Int 
        | Sto Storable deriving (Show, Eq, Ord) 

data Storable = N Int 
        | B Bool deriving (Show, Eq, Ord)

type ValueStack = [Value]
type ControlStack = [Expr]
type Loc = Integer

--[(Value,Expr)] identifier -> location
--[(Expr,Value)] location -> value
data CmdPiAut = CmdPiAut { env :: Map.Map Identifier Location,
                           sto :: Map.Map Location Value, -- TODO: mudar para Storable
                           val :: ValueStack,
                           cnt :: ControlStack
                         } deriving Show

lookup' :: Ord k => k -> Map.Map k a -> a
lookup' k m = fromJust $ Map.lookup k m

eval :: CmdPiAut -> CmdPiAut
eval cpa@(CmdPiAut {cnt = []}) = cpa
eval cpa@(CmdPiAut e s v c)    = eval $ case (head c) of
                                         Comm (Assign idtf exp) -> cpa{cnt = exp : Kw KWAssign : tail c, val = Idt idtf : v, env = Map.insert idtf (L $ Map.size e + 1) e} -- TODO: check for "S' = S/[I->T]"
                                         Comm (CSeq cmd1 cmd2)  -> cpa{cnt = Comm cmd1 : Comm cmd2 : tail c}
                                         Comm (Loop bexp cmd)   -> cpa{cnt = Bexp bexp : Kw KWLoop : tail c, val = Comd cmd : Lp bexp cmd : v}
                                         Aexp (Sum aex1 aex2)   -> cpa{cnt = Aexp aex1 : Aexp aex2 : Kw KWSum : tail c} 
                                         Aexp (Sub aex1 aex2)   -> cpa{cnt = Aexp aex2: Aexp aex1: Kw KWSub : tail c}
                                         Aexp (Mul aex1 aex2)   -> cpa{cnt = Aexp aex1 : Aexp aex2 : Kw KWMul : tail c}
                                         Bexp (Eq  exp1 exp2)   -> cpa{cnt = Bexp exp1 : Bexp exp2 : Kw KWEq  : tail c} 
                                         Bexp (Or  exp1 exp2)   -> cpa{cnt = Bexp exp1 : Bexp exp2 : Kw KWOr  : tail c} 
                                         Bexp (And exp1 exp2)   -> cpa{cnt = Bexp exp1 : Bexp exp2 : Kw KWAnd : tail c} 
                                         Bexp (Lt  exp1 exp2)   -> cpa{cnt = Aexp exp2: Aexp exp1: Kw KWLt  : tail c} 
                                         Bexp (Le  exp1 exp2)   -> cpa{cnt = Aexp exp2: Aexp exp1: Kw KWLe  : tail c} 
                                         Bexp (Ge  exp1 exp2)   -> cpa{cnt = Aexp exp2: Aexp exp1: Kw KWGe  : tail c} 
                                         Bexp (Gt  exp1 exp2)   -> cpa{cnt = Aexp exp2: Aexp exp1: Kw KWGt  : tail c} 
                                         Bexp (Not ex)          -> cpa{cnt = Bexp ex : Kw KWNot : tail c}
                                         Aexp (Num ival)        -> cpa{cnt = tail c, val = In ival : v}
                                         Bexp (Boo bval)        -> cpa{cnt = tail c, val = Bo bval : v}
                                         Idtf (Id str)          -> cpa{cnt = tail c, val = lookup' (lookup' (Id str) e) s : v}
                                         Kw KWNot               -> cpa{cnt = tail c, val = Bo (not (bval (head v))) : tail v}
                                         x -> let (va:vb:vs) = v in
                                                            case x of 
                                                            Kw KWAssign -> cpa{cnt = tail c, val = vs, sto = Map.insert (lookup' (idval vb) e) va s } -- This lookup can't find anything because it has not been there yet!
                                                            Kw KWLoop -> cpa{cnt = if(bval $ va) then (Comm $ Loop (beval vb) (cmdval vb)) : tail c 
                                                                                                 else tail c
                                                                            , val = vs}
                                                            Kw KWSum -> cpa{cnt = tail c, val = In (ival va + ival vb) : vs}
                                                            Kw KWSub -> cpa{cnt = tail c, val = In (ival va - ival vb) : vs}
                                                            Kw KWMul -> cpa{cnt = tail c, val = In (ival va * ival vb) : vs}
                                                            Kw KWEq  -> cpa{cnt = tail c, val = Bo (bval va == bval vb) : vs}
                                                            Kw KWLe  -> cpa{cnt = tail c, val = Bo (ival va >= ival vb) : vs}
                                                            Kw KWLt  -> cpa{cnt = tail c, val = Bo (ival va > ival vb) : vs}
                                                            Kw KWGe  -> cpa{cnt = tail c, val = Bo (ival va <= ival vb) : vs}
                                                            Kw KWGt  -> cpa{cnt = tail c, val = Bo (ival va < ival vb) : vs}
                                                            Kw KWOr  -> cpa{cnt = tail c, val = Bo (bval va || bval vb) : vs}
                                                            Kw KWAnd -> cpa{cnt = tail c, val = Bo (bval va && bval vb) : vs}
main :: IO ()
main = do	
    --s <- readFile "C:\\Users\\rodri\\OneDrive\\Documentos\\compiladores\\program.txt"
    --print s
    --let ast = parseCalc (scanTokens s)
    let ast = Aexp $ Sum (Num 1) (Num 1)
    --let ast = Comm (Assign (Id "Meu ID") (Aexp $ Sum (Num 1) (Num 1)))
    --let ast = Comm (CSeq (Assign (Id "Meu ID") (Aexp $ Sum (Num 1) (Num 1))) (Assign (Id "Meu ID Denovo!") (Aexp $ Sum (Num 1) (Num 1))))
    --let ast = Comm (Loop (Eq (Boo False) (Boo False)) (Assign (Id "Meu ID") (Aexp $ Sum (Num 1) (Num 1))))
    let aut = CmdPiAut (Map.fromList []) (Map.fromList []) [] [ast]
    let result =  eval aut
    print ast
    print result

{- Example expressions
Num 2
Sum (Num 1) (Num 1)
Sub (Num 1) (Num 1)
Mul (Num 1) (Num 1)
Boo True
Eq (Boo True) (Boo False)
Not (Boo True)
Gt (Num 2) (Num 1)
Ge (Num 2) (Num 2)
Lt (Num 1) (Num 2)
Le (Num 2) (Num 2)
And (Boo True) (Boo True)
Or (Boo True) (Boo False)
-- at� aqui, tudo OK
Id "Meu ID"
Idtf (Id "Meu ID")
Assign (Id "Meu ID") (Sum (Num 1) (Num 1))
Comm (Assign (Id "Meu ID") (Sum (Num 1) (Num 1)))
Aexp (Sum (Num 1) (Num 1))
Bexp (Eq (Boo True) (Boo False))
Exp (Aexp (Sum (Num 1) (Num 1)))
Command (Assign (Id "Meu ID") (Sum (Num 1) (Num 1)))
Loop (Eq (Boo True) (Boo False)) (Assign (Id "Meu ID") (Sum (Num 1) (Num 1)))
CSeq (Assign (Id "Meu ID") (Sum (Num 1) (Num 1))) (Assign (Id "Meu ID denovo") (Sum (Num 1) (Num 1))

let exp = Sum (Num 5) (Num 2)

-}
