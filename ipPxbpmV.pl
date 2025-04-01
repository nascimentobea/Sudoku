%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sudoku 9x9 que valida linhas, colunas e sub-matrizes 3x3 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sudoku(Sudoku, Solution) :-
    resolver(Sudoku, Solution). 

resolver(Sudoku, Solution) :- 
    validar_matriz(Sudoku), 
    transpor(Sudoku, ColunasIniciais),
    preencher(Sudoku, ColunasIniciais, Preenchido),  
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

contar([], 0). % Conta os elementos de uma lista
contar([_|T], N) :-
    contar(T, N1),
    N is N1 + 1.  

% Tranpor a matriz para obter as colunas
transpor([[]|_],[]).
transpor(Matriz,[Linha|Resultado]) :-
    primeira_coluna(Matriz,Linha,MatrizRestante),
    transpor(MatrizRestante,Resultado).

primeira_coluna([],[],[]).
primeira_coluna([[Elemento|LinhaRestante] | MatrizRestante], [Elemento | ColunaRestante], [LinhaRestante | NovaMatriz]) :-  
    primeira_coluna(MatrizRestante, ColunaRestante, NovaMatriz).

%Listas das matrizes 3x3
sub_matrizes([],[]).
sub_matrizes([L1, L2, L3 | L],[B1, B2, B3 |B]):- % pega 3 linhas de cada vez 
    blocos(L1,L2,L3, B1,B2,B3),
    sub_matrizes(L,B).

blocos([],[],[],[],[],[]).
blocos([L11,L12,L13 |L1],[L21,L22,L23|L2],[L31,L32,L33|L3],[L11,L12,L13,L21,L22,L23,L31,L32,L33],B2,B3):-
 blocos(L1,L2,L3,B2,B3, _).

preencher([], _, []).

% Preenche uma linha e atualiza as colunas
preencher([Linha|Restante], Colunas, [LinhaPreenchida|Resultado]) :-
    guardar_linha(Linha, UsadosLinha),   
    candidatos(UsadosLinha, [1,2,3,4,5,6,7,8,9], PossiveisLinha), 
    substituir_zeros(Linha, PossiveisLinha, Colunas, LinhaPreenchida, NovasColunas),
    validar_linhas([LinhaPreenchida]),  
    preencher(Restante, NovasColunas, Resultado).

guardar_linha([], []).
guardar_linha([H|T], [H|Usados]) :-  % guarda os numeros diferentes de 0 que estão na linha
    H \= 0,
    guardar_linha(T, Usados).
guardar_linha([0|T], Usados) :-
    guardar_linha(T, Usados).

% Gera lista de números possíveis removendo os que já foram usados
candidatos([], Possiveis, Possiveis).
candidatos([H|T], Lista, Filtrado) :-
    remover(H, Lista, NovaLista),
    candidatos(T, NovaLista, Filtrado).

% Remove um elemento de uma lista
remover(_, [], []).
remover(X, [X|T], T).
remover(X, [H|T], [H|T2]) :-
    X \= H,
    remover(X, T, T2).

% Substitui zeros considerando linhas e colunas
substituir_zeros([], _, _, [], []).
substituir_zeros([H|T], Possiveis, [Coluna|Cols], [H|T2], [Coluna|NovasCols]) :-
    H \= 0,
    substituir_zeros(T, Possiveis, Cols, T2, NovasCols).
substituir_zeros([0|T], Possiveis, [Coluna|Cols], [N|T2], [[N|Coluna]|NovasCols]) :-
    member(N, Possiveis),  
    \+ member(N, Coluna),                 
    substituir_zeros(T, Possiveis, Cols, T2, NovasCols).

nao_existe_na_linha(_, []).
nao_existe_na_linha(N, [H|T]) :-
    N \= H, % para e dá false se o numero estiver na lista de usados
    nao_existe_na_linha(N, T).

%Verificações

%Validar as linhas
validar_linhas([]).
validar_linhas([Linha|LinhasRestantes]):- 
        nao_tem_repetidos(Linha),
        validar_linhas(LinhasRestantes).

%Validar se ao adicionar numero, este não se repete na linha
nao_tem_repetidos([]).  
nao_tem_repetidos([H | T]) :-  
    \+ member(H,T), %verifica se H não está no restante da lista 
    nao_tem_repetidos(T).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Sudoku nxn, n numero perfeito                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sudoku_geral(Sudoku, Solution) :-
    resolve_sudoku(Sudoku, Solution).
             
resolve_sudoku(Sudoku, Solution) :- 
    matriz_quadrada_perfeita(Sudoku), 
    contar(Sudoku, N),
    quadrado_perfeito(N, Raiz),
    preencher_matriz(Sudoku, N, Preenchido),  
    Solution = Preenchido, 
    transpor(Preenchido, Colunas), 
    validar_linhas(Colunas),
    sub_matrizes_geral(Preenchido, Raiz, SubMatrizes),  % extrai submatrizes
    validar_linhas(SubMatrizes).

% Valida se a matriz é um quadrado perfeito
matriz_quadrada_perfeita([]).
matriz_quadrada_perfeita([Linha|T]) :-
    contar([Linha|T], N), % N é o numero de linhas
    todas_linhas_tamanho([Linha|T], N), 
    quadrado_perfeito(N, _).

% Valida que todas as linhas têm N colunas
todas_linhas_tamanho([], _).
todas_linhas_tamanho([Linha|T], N) :-
    contar(Linha, N),
    todas_linhas_tamanho(T, N). 

% Verifica se N é um quadrado perfeito e tamanho do lado de sub_matrizes
quadrado_perfeito(N, SqrtNInt) :-
    Raiz is sqrt(N),       % Calcular a raiz quadrada
    SqrtNInt is round(Raiz), % Arredondar a raiz quadrada
    SqrtNInt * SqrtNInt =:= N. % Verificar se o quadrado do inteiro arredondado é igual ao número original


% Numeros válidos
numeros_validos(N, Lista) :- 
    gerar_numeros(1, N, Lista).

gerar_numeros(N, N, [N]). 
gerar_numeros(Inicial, N, [Inicial|T]) :- 
    Inicial < N,
    I1 is Inicial + 1,
    gerar_numeros(I1, N, T).

% Preencher zeros
preencher_matriz([], _, []).
preencher_matriz([H|T], N, [H2|T2]) :-
    guardar_linha(H, Usados),
    numeros_validos(N, Validos),
    substituir_zero(H, Usados, Validos, H2),
    preencher_matriz(T, N, T2).

substituir_zero([], _, _, []).
substituir_zero([H|T], Usados, Validos, [H|T2]) :- %se não for 0 então
    H \= 0,
    substituir_zero(T, [H|Usados], Validos, T2).
substituir_zero([0|T], Usados, Validos, [N|T2]) :-
    member(N, Validos),
    nao_existe_na_linha(N, Usados),
    substituir_zero(T, [N|Usados], Validos, T2).

sub_matrizes_geral(Matriz, Raiz, SubMatrizes) :-
    extrair_todas_submatrizes(Matriz, Raiz, 0, SubMatrizes).

extrair_todas_submatrizes(Matriz, Raiz, InicioLinha, SubMatrizes) :-
    contar(Matriz, N),
    InicioLinha < N,
    extrair_submatrizes_linha(Matriz, Raiz, InicioLinha, 0, SubMatriz),
    ProximoInicio is InicioLinha + Raiz,
    extrair_todas_submatrizes(Matriz, Raiz, ProximoInicio, Restantes),
    append(SubMatriz, Restantes, SubMatrizes).
extrair_todas_submatrizes(Matriz, _, InicioLinha, []) :-
    contar(Matriz, N),
    InicioLinha >= N.

% Concatenar listas
append([], L, L).  
append([H|T], L, [H|R]) :-  
    append(T, L, R).

% Extrair submatrizes a partir de uma linha inicial
extrair_submatrizes_linha(Matriz, Raiz, InicioLinha, InicioColuna, SubMatrizes) :-
    contar(Matriz, N),
    InicioColuna < N,
    extrair_submatriz(Matriz, Raiz, InicioLinha, InicioColuna, SubMatriz),
    flatten(SubMatriz, SubFlat),  % Achatar a submatriz em uma lista
    ProximaColuna is InicioColuna + Raiz,
    extrair_submatrizes_linha(Matriz, Raiz, InicioLinha, ProximaColuna, Restantes),
    SubMatrizes = [SubFlat|Restantes].
extrair_submatrizes_linha(Matriz, _, _, InicioColuna, []) :-
    contar(Matriz, N),
    InicioColuna >= N.

% Converter uma lista de listas numa unica lista
flatten([], []).  
flatten([H|T], FlatList) :-  
    flatten(H, FlatH),      
    flatten(T, FlatT),    
    append(FlatH, FlatT, FlatList).  
flatten(X, [X]) :-
    X \= [],
    X \= [_|_].


% Extrair uma única submatriz de tamanho Raiz × Raiz
extrair_submatriz(Matriz, Raiz, InicioLinha, InicioColuna, SubMatriz) :-
    FimLinha is InicioLinha + Raiz - 1,
    extrair_linhas(Matriz, InicioLinha, FimLinha, Linhas),
    extrair_colunas_lista(Linhas, InicioColuna, Raiz, SubMatriz).

% Aplicar extrair_colunas a cada linha da lista recursivamente
extrair_colunas_lista([], _, _, []).
extrair_colunas_lista([Linha|Restantes], InicioColuna, Raiz, [Colunas|SubMatriz]) :-
    extrair_colunas(InicioColuna, Raiz, Linha, Colunas),
    extrair_colunas_lista(Restantes, InicioColuna, Raiz, SubMatriz).

% Extrair linhas da matriz 
extrair_linhas(Matriz, Inicio, Fim, Linhas) :-
    descartar_inicio(Matriz, Inicio, MatrizRestante),
    tomar_linhas(MatrizRestante, Fim - Inicio + 1, Linhas).

% Descartar as primeiras 'Inicio' linhas da matriz
descartar_inicio(Matriz, 0, Matriz).
descartar_inicio([_|Restante], Inicio, MatrizRestante) :-
    Inicio > 0,
    NovoInicio is Inicio - 1,
    descartar_inicio(Restante, NovoInicio, MatrizRestante).

% Tomar as primeiras N linhas da matriz
tomar_linhas(_, 0, []).
tomar_linhas([Linha|Restante], N, [Linha|Linhas]) :-
    N > 0,
    NovoN is N - 1,
    tomar_linhas(Restante, NovoN, Linhas).

% Extrair colunas de uma linha
extrair_colunas(InicioColuna, Raiz, Linha, Colunas) :-
    FimColuna is InicioColuna + Raiz - 1,
    tomar_elementos(Linha, InicioColuna, FimColuna, Colunas).

% Tomar elementos de uma lista entre índices
tomar_elementos(Linha, Inicio, Fim, Elementos) :-
    contar(Prefix, Inicio),
    append(Prefix, Restante, Linha),
    contar(Elementos, Tamanho),
    Tamanho is Fim - Inicio + 1,
    append(Elementos, _, Restante).
