import System.Random
import Data.List

randInt :: Int -> Int -> IO Int
randInt low high = do
    random <- randomIO :: IO Int
    let result = low + random `mod` (high - low + 1)
    return result
    

data Jugador = N | X | O
    deriving (Eq, Show)


data Taula = Taula [[Jugador]] Int Int
    deriving (Eq)

    
data Estrategia = Random | Greedy | Smart 
    deriving (Eq, Show, Read)
    
seguent :: Jugador -> Jugador
seguent O = X
seguent X = O

empty :: Int -> Int -> Taula
empty f c = Taula (replicate f (replicate c N)) f c

showJugador :: Jugador -> Char
showJugador N = '.'
showJugador O = 'O'
showJugador X = 'X'
       
showTaula :: Taula -> IO()
showTaula (Taula x f c) = putStrLn("\n" ++ unlines (map showFila x ++ [linea] ++ [ncols]))
    where
        showFila = map $ showJugador
        linea    = replicate  c '-'
        ncols    = take c (['0'..])

update :: Jugador -> [Jugador] -> [Jugador]
update j f = init (takeWhile (== N) f) ++ [j] ++ dropWhile (== N) f

        
tirar :: Taula -> Jugador -> Int -> Taula
tirar (Taula t f c) j i = Taula (getCol(take i col ++ [update j (col !! i)] ++ drop (i + 1) col)) f c
    where col = getCol t

          
getCol :: [[Jugador]] -> [[Jugador]]
getCol = transpose

getFila :: [[Jugador]] -> [[Jugador]]
getFila = id

getDiag :: [[Jugador]] -> [[Jugador]]
getDiag []       = []
getDiag ([]:xss) = xss
getDiag xss      = zipWith (++) (map ((:[]) . head) xss ++ repeat [])
                                  ([]:(getDiag (map tail xss)))

colInvalida :: Taula -> Int -> Bool
colInvalida (Taula t f c) x = (0 > x) || (x >= c) || (head t) !! x /= N


fitxeSeguidesV :: Jugador -> [Jugador] -> Int
fitxeSeguidesV j a
    |(head a) /= N  = -1
    |otherwise = length $ takeWhile (== j) $ dropWhile (== N) a


fitxeSeguidesH :: Jugador -> Int -> Int -> Int -> [Jugador] -> Int
fitxeSeguidesH _ _ colRight 4 _ = colRight
fitxeSeguidesH _ _ _ _ []= -1
fitxeSeguidesH jAnt col colRight count (a:as) =
    if(a == N) then if(jAnt == N) then fitxeSeguidesH N (col+1) col 1 as
               else if(jAnt == X) then fitxeSeguidesH N (col+1) col (count+1) as
                                  else fitxeSeguidesH N (col+1) col 1 as
                                  else if(a == X) then fitxeSeguidesH X (col+1) colRight (count+1) as
                                                  else fitxeSeguidesH O (col+1) colRight 0 as

getColNum :: Taula -> Int
getColNum (Taula t f c) = c
                                
taulaPlena :: Taula -> Bool
taulaPlena (Taula t f c) = all (/= N) $ concat t

hasWon :: Jugador -> [Jugador] -> Bool
hasWon _ t | length t < 4 = False
hasWon j t = all (j==) (take 4 t) || hasWon j (tail t)

haGuanyat :: Jugador -> Taula -> Bool
haGuanyat j (Taula t f c) = any (hasWon j) (getFila t ++ getCol t ++ getDiag t ++ getDiag (reverse t))

getIndexMax :: [Int] -> Int -> Int -> Int
getIndexMax (a:as) mx indx = 
        if(a==mx) then indx
                  else getIndexMax as mx (indx+1)

greedy :: Taula -> Int
greedy (Taula t f c) = 
                let col = map (fitxeSeguidesV O) $ getCol t
                    alertaV = map (fitxeSeguidesV X) $ getCol t
                in 
                    if ((maximum col) == 3) then getIndexMax col (maximum col) 0
                                            else if((maximum alertaV) == 3) then getIndexMax alertaV (maximum alertaV) 0
                                                                            else getIndexMax col (maximum col) 0
                    

smart :: Taula -> Int
smart (Taula t f c) = 
                let col = map (fitxeSeguidesV O) $ getCol t
                    alertaV = map (fitxeSeguidesV X) $ getCol t
                    alertaH = map (fitxeSeguidesH N 0 0 0) $ getFila t
                in 
                    if((maximum col) == 3) then getIndexMax col (maximum col) 0
                                          else if((maximum alertaV) == 3) then getIndexMax alertaV (maximum alertaV) 0
                                               else if((maximum alertaH) /= -1) then (maximum alertaH)
                                                    else getIndexMax col (maximum col) 0

tornIA :: Estrategia -> Taula -> IO()
tornIA e t
    | e == Random   = do x <-randInt 0 $(getColNum t -1)
                         if(colInvalida t x) then do (tornIA e t) 
                         else do
                             let aux = tirar t O x
                             showTaula aux
                             jugar e aux X
    | e == Greedy   = do 
                        let aux = tirar t O $ greedy t
                        showTaula aux
                        jugar e aux X
    | e == Smart    = do 
                        let aux = tirar t O $ smart t
                        showTaula aux
                        jugar e aux X                    


jugar :: Estrategia ->  Taula ->  Jugador -> IO()
jugar e t j
    | haGuanyat X t = putStrLn(">>> Enhorabona Jugador X, has guanyat! <<<")
    | haGuanyat O t = putStrLn(">>> T'ha guanyat la IA amb l'estratègia " ++ show e ++ " <<<")
    | taulaPlena t  = putStrLn(">>> Heu empatat! <<<")
    | j == X        = do putStrLn $ "> Et toca a tú!" 
                         c <- getLine 
                         let col = ((read c) :: Int)
                         if(colInvalida t col) then do putStrLn("> Error: Columna invalida, tria una altra")
                                                       jugar e t j
                         else do
                             let aux = tirar t j col
                             showTaula aux
                             jugar e aux (seguent j)
     | j == O        = do putStrLn $ "> Turn de la IA"
                          tornIA e t      
                

main = do
    putStrLn $ "> Introdueix el número de files:"
    f <- getLine
    putStrLn $ "> Introdueix el número de columnes:"
    c <- getLine
    putStrLn $ "> Introdueix el tipus d'estretègia: Random, Greedy o Smart"
    e <- getLine
    let taula = empty (read f) (read c)
    showTaula taula
    putStrLn $ "> Ets el Jugador X" 
    jugar (read e) taula X
