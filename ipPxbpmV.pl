%sudoku(Sudoku,Solution).
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
 %   validar_linhas(Sudoku),


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
%Validar se os numeros nao se repetem na linha
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

%Validar os numeros das linhas
validar_linhas([]).
validar_linhas([L|R]):- %valida linha a linha
    validar_numeros(L),
    validar_linhas(R).