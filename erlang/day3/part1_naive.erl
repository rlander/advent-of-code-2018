-module (part1_naive).
-compile(export_all).

%%
%% Naive implementation of part 1. The algorithm is correct but very inneficient (it runs for a very long time and consumes too much memory).
%%

matrix(Columns, Rows, ContentGenerator) ->
  [
    [ContentGenerator(Column, Row, Columns, Rows)
      || Column <- lists:seq(1, Columns)
    ]
    || Row <- lists:seq(1, Rows)
  ].

element_at(Column, Row, Matrix) ->
    lists:nth(Column, lists:nth(Row, Matrix)).

add(A, B) ->
  matrix(length(lists:nth(1, A)), length(A),
    fun(Column, Row, _, _) ->
      element_at(Column, Row, A) + element_at(Column, Row, B)
    end
  ).

parse_opts(Str) ->
    [list_to_integer(X) || X<- string:tokens(string:trim(Str), ",x")].

gen(Column, Row, Cols, Rows, Left, Top, Width, Height) when Row =< Top -> 0;
gen(Column, Row, Cols, Rows, Left, Top, Width, Height) when Column =< Left -> 0;
gen(Column, Row, Cols, Rows, Left, Top, Width, Height) when Column > Left + Width -> 0;
gen(Column, Row, Cols, Rows, Left, Top, Width, Height) when Row > Top + Height -> 0;
gen(_,_,_,_,_,_,_,_) -> 1.

grid(S) ->
    [Id, Padding, Dimensions] =  string:tokens(S, "@:"),
    [Left, Top] = parse_opts(Padding),
    [Width, Height] = parse_opts(Dimensions),
    grid(Left, Top, Width, Height).

grid(Left, Top, Width, Height) ->
    F = fun(C, R, Cs, Rs) -> gen(C, R, Cs, Rs, Left, Top, Width, Height) end,  
    matrix(10, 10, F).

solve() ->
    Lines = readlines("input"),
    Grids = [part1:grid(L) || L <- Lines], % Very inneficient to generate all the matrices first.
    Add = fun(A, Acc) -> add(A, Acc) end,
    lists:foldl(Add, matrix(10,10, fun(_,_,_,_) -> 0 end), Grids).


%%====================================================================
%% HELPERS
%%====================================================================

readlines(Filename) ->
    {ok, Data} = file:read_file(Filename),
    Data2 = binary:split(Data, [<<"\n">>], [global]),
    [binary_to_list(L) || L <- remove_blank(Data2)].

remove_blank(List) ->
    lists:filter(fun(El) -> El /= <<>> end, List).
