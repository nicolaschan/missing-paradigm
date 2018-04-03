data Expression a = Value a | Application (Expression a) (Expression a) 
data Type = Mapping Type Type | IntType deriving (Eq, Show)
data Token = Function Type Type (Token -> Token) | Primitive Type String

type Error = String

instance Show a => Show (Expression a) where
    show (Value v) = show v
    show (Application e1 e2) = "(" ++ show e1 ++ " " ++ show e2 ++ ")"

instance Show Token where
    show (Primitive t s) = "(" ++ show t ++ ": " ++ show s ++ ")"
    show (Function t1 t2 _) = "(" ++ show t1 ++ " -> " ++ show t2 ++ ")"

apply :: Token -> Token -> Token
apply (Function _ _ f) t = f t

eval :: Expression Token -> Token
eval (Value token) = token 
eval (Application e1 e2) = apply (eval e1) (eval e2)

checkType :: Expression Token -> Bool
checkType (Value _) = True
checkType (Application (Value (Function t1 _ _)) (Value (Primitive t _))) = t == t1
checkType (Application (Value (Function t1 _ _)) nested@(Application (Value (Function _ t2 _)) _)) = 
    t1 == t2 && checkType nested
