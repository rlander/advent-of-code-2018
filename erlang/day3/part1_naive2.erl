-module (part1).
-compile(export_all).

%
% A few optimizations: the matrices are flattened and only generated on demand.
%

parse_opts(Str) ->
    [list_to_integer(X) || X<- string:tokens(string:trim(Str), ",x")].

matrix(Columns, Rows, ContentGenerator) ->
  [
    [ContentGenerator(Column, Row, Columns, Rows)
      || Column <- lists:seq(1, Columns)
    ]
    || Row <- lists:seq(1, Rows)
  ].

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
    matrix(1000, 1000, F).

add(M1, M2) ->
    Grid = grid(M1),
    FlatGrid = lists:flatten(Grid),                      % after generating the matrix we flatten it (more efficient).
    lists:zipwith(fun(X, Y) -> X + Y end, FlatGrid, M2).

solve() ->
    Lines = readlines("input"),
    FlatEmptyMatrix = lists:flatten(matrix(1000, 1000, fun(_,_,_,_) -> 0 end)),
    Res = lists:foldl(fun add/2, FlatEmptyMatrix, Lines),
    lists:sum([1 || N <- Res, N >= 2]).


%%====================================================================
%% HELPERS
%%====================================================================

readlines(Filename) ->
    {ok, Data} = file:read_file(Filename),
    Data2 = binary:split(Data, [<<"\n">>], [global]),
    [binary_to_list(L) || L <- remove_blank(Data2)].

remove_blank(List) ->
    lists:filter(fun(El) -> El /= <<>> end, List).
