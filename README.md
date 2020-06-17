Kamal El Hachmi			LP 19-20Q2

El joc està format per 3 "data" bàsics pel funcionament del joc.
El primer, "Jugador" de tipus enumerat igual que el segon, l'"Estratètagia". Finalment tenim Taula de tipus algebraic on el seu primer paràmetre és una llista de llistes de Jugador ([[Jugador]]). El segon i el tercer paràmetre del data són un Int, indican files i columnes (f x c). L'he afegit per tal de facilitar la canviabilitat de les dimensions de la taula.

>Funció "Empty", crea una matriu de Jugador [N] f x c.

>Funció "ShowTaula" converteixo tot a lista de Char ([Char]). Per evitar errors de compilació he tingut que crear la funció "showJugador" en comptes  d'afegir un deriving(Show), ja que ens interessa en format Char, i el show converteix en string. Després s'aplica el unlines per evitar els "[]"

>"Jugar", funció de gran importància que s'utilitza per iniciar la partida i passar els turns. Formada per 5 if's, primer es comprova si ha guanyat algun jugador o hi ha empat, si és el cas, el joc s'ha acabat. Si és el turn del jugar X, és a dir, l'usuari, indica quina columna a tirar, si és vàlida, s'actualitza la Taula i es pasa de turn utilitzant recursivitat + funció "seguent Jugador", i sino, es repeteix el turn fins que indiqui una columna vàlida. 

>Funcions "getCol" buscant per internet i manual de haskell he trobat la funció "transpose", la qual permet transformar una matriu per filas per una matriu per columnes.

>Funció "HaGuanyat" comprova si el Jugador pasat per paràmetre té 4 fitxes en ratlla. Per dur a terme aquesta comprovació, uneixo 4 matrius de Jugadors, una transposada (per columnes), una per files (tal com està) i per últim les dos diagonals. S'utilitza la funciona auxiliar "hasWon" que permet comprovar que hi ha 4 fitxes d'un jugar en ratlla.

>Funció "tornIA" és cridada cada cop que li toca jugar a la màquina. Allà es decideix depenen de l'estretègia quina columna tirar. 

>A les funcions *greedy* i *smart*: _col_, una llista on cada element indica quantes fitxes en ratlla del jugador O (accessibles = columna valida) verticalment, és a dir cada columna. _alertaV_, quantes fitxes en ratlla del Jugador X, verticalment. _alertaH_, fitxes en ratlla horitzontalment.

>Funció "fitxeSeguidesV", es busca quantes fitxes del mateix Jugador en ratlla hi ha verticalment. Si en aquella columna està plena, es torna -1.

>Funció "fitxeSeguidesH", 1r paràmentre: JugadorAnterior. 2n Par: columna actual. 3r Par: columna on s'ha de tirar la fitxa. 4rt Paràmetre comptador de quantes fitxes en ratlla del jugador X (l'usuari) comptant 1 de tipus N, buit.

>Funció "getIndexMax", es cerca la columna on hi ha més fitxes en ratlla del tipus 'O' (la màquina)
