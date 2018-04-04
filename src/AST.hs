data Expression a = Value a | Application (Expression a) (Expression a) 
data Type = Mapping Type Type | IntType deriving (Eq, Show)
data Token = Function String Type Type (Token -> Token) | Primitive Type String

type Error = String

instance Show a => Show (Expression a) where
    show (Value v) = show v
    show (Application e1 e2) = "(" ++ show e1 ++ " " ++ show e2 ++ ")"

instance Show Token where
    show (Primitive t s) = "(" ++ show t ++ ": " ++ show s ++ ")"
    show (Function n t1 t2 _) = "(" ++ n ++ ": " ++ show t1 ++ " -> " ++ show t2 ++ ")"

parse :: Read a => Token -> a
parse (Primitive IntType s) = read s

apply :: Token -> Token -> Token
apply (Function _ _ _ f) t = f t

($=) :: Token -> Token -> Token
f $= t = apply f t

($:) :: Expression Token -> Token -> Expression Token
f $: t = Application f (Value t)

int :: Int -> Token
int i = Primitive IntType (show i)

eval :: Expression Token -> Token
eval (Value token) = token 
eval (Application e1 e2) = apply (eval e1) (eval e2)

finalType :: Type -> Type
finalType (Mapping _ t) = finalType t
finalType t = t

assertRT :: Type -> Token -> Bool
assertRT rt (Function _ _ t _) = rt == finalType t
assertRT rt (Primitive t _) = rt == t

filterByRT :: Type -> [Token] -> [Token]
filterByRT rt ts = filter (assertRT rt) ts

allFunctions :: Int -> Type -> [Token] -> [Expression Token]
allFunctions 0 _ _ = []
allFunctions n rt fs = map Value $ filterByRT rt fs

typeCheck :: Expression Token -> Bool
typeCheck (Value _) = True
typeCheck (Application (Value (Function _ t1 _ _)) (Value (Primitive t _))) = t == t1
typeCheck (Application (Value (Function _ t1 _ _)) nested@(Application (Value (Function _ _ t2 _)) _)) = 
    t1 == t2 && typeCheck nested

tokenMul :: Token
tokenMul = Function "mul" IntType (Mapping IntType IntType) tokenMul1

tokenMul1 :: Token -> Token
tokenMul1 t = Function ("mul#" ++ show (parse t :: Int)) IntType IntType (tokenMul2 t)

tokenMul2 :: Token -> Token -> Token
tokenMul2 t1 t2 = Primitive IntType $ show $ ((parse t1) :: Int) * ((parse t2) :: Int)

tokenAdd :: Token
tokenAdd = Function "add" IntType (Mapping IntType IntType) tokenAdd1

tokenAdd1 :: Token -> Token
tokenAdd1 t = Function ("add#" ++ show (parse t :: Int)) IntType IntType (tokenAdd2 t)

tokenAdd2 :: Token -> Token -> Token
tokenAdd2 t1 t2 = Primitive IntType $ show $ ((parse t1) :: Int) + ((parse t2) :: Int)
