%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sudoku 9x9 que valida linhas, colunas e sub-matrizes 3x3 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sudoku(Sudoku, Solution) :-
    resolver(Sudoku, Solution). 

resolver(Sudoku, Solution) :- 
    validar_matriz(Sudoku), 
    preencher(Sudoku, Preenchido),  
    Solution = Preenchido, 
    transpor(Preenchido, Colunas), 
    validar_linhas(Colunas), 
    sub_matrizes(Preenchido, SubMatrizes),  
    validar_linhas(SubMatrizes). 


%Verificar se a matriz é válida
validar_matriz(Sudoku) :- 
    linhas(Sudoku),
    colunas(Sudoku).

linhas(Sudoku) :- %se tem 9 linhas
    contar(Sudoku, 9).

colunas([]).
colunas([H|T]) :- %se cada linha tem 9 elementos, ou seja, tem 9 colunas
    contar(H, 9),
    colunas(T).

contar([], 0).
contar([_|T], N) :-
    N > 0,
    N1 is N - 1,
    contar(T, N1).    
    
%Tranpor a matriz para obter as colunas
transpor([[]|_],[]).
transpor(M,[H|T]) :-
    primeira_coluna(M,H,Mr),
    transpor(Mr,T).

primeira_coluna([],[],[]).
primeira_coluna([[X|Xs]|R], [X|C], [Xs|N]) :-
    primeira_coluna(R, C, N).

%Listas das matrizes 3x3
sub_matrizes([],[]).
sub_matrizes([L1, L2, L3 | L],[B1, B2, B3 |B]):- % pega 3 linhas de cada vez 
    blocos(L1,L2,L3, B1,B2,B3),
    sub_matrizes(L,B).

blocos([],[],[],[],[],[]).
blocos([L11,L12,L13 |L1],[L21,L22,L23|L2],[L31,L32,L33|L3],[L11,L12,L13,L21,L22,L23,L31,L32,L33],B2,B3):-
 blocos(L1,L2,L3,B2,B3,_).


%Substitui os zeros 
preencher([], []).
preencher([H|T], [H2|T2]) :-
    guardar_linha(H, Usados),
    substituir_zeros(H, Usados, H2),
    preencher(T, T2).
  

guardar_linha([], []).
guardar_linha([H|T], [H|Usados]) :-  % guarda os numeros diferentes de 0 que estão na linha
    H \= 0,
    guardar_linha(T, Usados).
guardar_linha([0|T], Usados) :-
    guardar_linha(T, Usados).

substituir_zeros([], _,[]). %1ºparametro:linha original, 2º numeros guardados, 3º linha com os zeros substituidos
substituir_zeros([H|T], Usados, [H|T2]):- %se não é 0 então nao faz nada e continua
    H \= 0,
    substituir_zeros(T, [H|Usados], T2).
substituir_zeros([0|T], Usados, [N|T2]):-  
  	member(N, [1, 2, 3, 4, 5, 6, 7, 8, 9]),  % escolhe um numero de 1 a 9
    nao_existe_na_linha(N, Usados),  
    substituir_zeros(T, [N|Usados], T2).

nao_existe_na_linha(_, []).
nao_existe_na_linha(N, [H|T]) :-
    N \= H, %para e dá false se o numero estiver na lista de usados
    nao_existe_na_linha(N, T).

%Verificações

%Validar as linhas
validar_linhas([]).
validar_linhas([H|T]):- %valida linha a linha H=linha e T=linhas restantes
        nao_tem_repetidos(H),
        validar_linhas(T).
        
%Validar se ao adicionar numero, este não se repete na linha
nao_tem_repetidos([]).  
nao_tem_repetidos([H | T]) :-  
    \+ member(H,T), %verifica se H não está no restante da lista 
    nao_tem_repetidos(T).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Sudoku nxn que valida linhas e colunas         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sudoku_geral(Sudoku, Solution) :-
    resolve_sudoku(Sudoku, Solution).
             
resolve_sudoku(Sudoku, Solution) :- 
    matriz_quadrada(Sudoku), %valida se a matriz é nxn 
    preencher(Sudoku, Preenchido),  
    Solution = Preenchido, 
    transpor(Preenchido, Colunas), 
    validar_linhas(Colunas).

%Validar se a matriz é quadrada
matriz_quadrada([]).
matriz_quadrada([Linha|T]) :-
    length([Linha|T], N), % N é o numero de linhas
    todas_linhas_tamanho([Linha|T], N). % Confirma que todas as linhas têm tamanho N.

todas_linhas_tamanho([], _).% valida que todas as linhas têm N colunas
todas_linhas_tamanho([Linha|T], N) :-
    length(Linha, N),
    todas_linhas_tamanho(T, N). 
     
%Numeros validos
numeros_validos(N, Lista) :- 
    gerar_numeros(1, N, Lista).

gerar_numeros(N, N, [N]). 
gerar_numeros(I, N, [I|T]) :- 
    I < N,
    I1 is I + 1,
    gerar_numeros(I1, N, T).

%Preencher zeros





             
             
             
             
             
             
