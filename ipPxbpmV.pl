sudoku(Sudoku,Solution):-
    resolver(Sudoko, Solução).
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

%resolver_sudoku(Sudoku):-

%Listas das Colunas
colunas([],[]).
colunas([L|R],Colunas):-
    colunas(R, R2),
    adicionar_numero_coluna(L,R2,Colunas).

adicionar_numero_coluna([],C,C).
adicionar_numero_coluna([H|T],[],[[H]|R2]):-
    adicionar_numero_coluna(T,[],R2).
adicionar_numero_coluna([H|T],[C|Cs],[[H|C]|R2]):-
    adicionar_numero_coluna(T,Cs,R2).

%Listas das matrizes 3x3
%Substitui os zeros NAO TESTADO
substituir_zeros([],[]).
substituir_zeros([H|T],[H|T2]):- %se não é 0 então nao faz nada e continua
    H \= 0,
    substituir_zeros(T,T2).
substituir_zeros([0|T],[N|T2]):-  % se estiver 0
   nao_existe_na_linha(N,T),
    substituir_zeros(T,T2).

%Verificações
%
%Validar se ao adicionar numero, este nao se repete na linha
nao_existe_na_linha(_, []).  
nao_existe_na_linha(N, [H | T]) :-  
    N \= H,  
    nao_existe_na_linha(N, T). 

%Validar se os numeros estão todos entre 1 e 9
validar_numeros([]).
validar_numeros([H|T]):-
    H>=1,
    H=<9,
    validar_numeros(T).
