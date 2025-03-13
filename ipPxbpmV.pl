sudoku(Sudoku,Solution):-
    resolver(Sudoku),
    Solution=Sudoku.
    /*Teste: sudoku([[5, 3, 0, 0, 7, 8, 0, 0, 0], 
[6, 0, 2, 1, 9, 5, 3, 4, 8], 
[1, 9, 0, 3, 4, 0, 5, 6, 7], 
[8, 0, 9, 7, 6, 1, 4, 2, 3], 
[4, 2, 6, 8, 5, 3, 0, 9, 1], 
[7, 0, 3, 9, 0, 4, 8, 5, 6], 
[9, 6, 1, 5, 3, 7, 2, 8, 4], 
[2, 8, 7, 4, 1, 9, 0, 3, 5], 
[0, 0, 5, 2, 0, 6, 1, 7, 9]],  
Solução).*/ 

resolver(Sudoku):-
    validar_linhas(Sudoku),
    transpor(Sudoku,Colunas),
    validar_linhas(Colunas),
    sub_matrizes(Sudoku,SubMatrizes),
    validar_linhas(SubMatrizes),
    

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
%sub_matrizes(

%Substitui os zeros NAO TESTADO
substituir_zeros([],[]).
substituir_zeros([H|T],[H|T2]):- %se não é 0 então nao faz nada e continua
    H \= 0,
    substituir_zeros(T,T2).
substituir_zeros([0|T],[N|T2]):-  % se estiver 0
   nao_existe_na_linha(N,T),
    substituir_zeros(T,T2).

%Verificações

%Validar as linhas
validar_linhas([]).
validar_linhas([H|T]):- %valida linha a linha H=linha e T=linhas restantes
        nao_tem_repetidos(H),
        validar_linhas(T).
        
%Validar se ao adicionar numero, este nao se repete na linha
nao_tem_repetidos([]).  
nao_tem_repetidos([H | T]) :-  
    \+ member(H,T), %verifica se H não está no restante da lista 
    nao_tem_repetidos(T).

%Validar se os numeros estão todos entre 1 e 9
validar_numeros([]).
validar_numeros([H|T]):-
    H>=1,
    H=<9,
    validar_numeros(T).
