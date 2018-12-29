-module (part2).
-compile(export_all).

parse_opts(L) ->
    [list_to_integer(X) || X <- string:tokens(L, "# @,:x")].

grid([_, Left, Top, Width, Height]) ->
    [{Y, X} || Y <- lists:seq(Top + 1, Top + Height),
               X <- lists:seq(Left + 1, Left + Width)].
count(L) ->
    Count = fun(I, A) -> maps:update_with(I, fun(V) -> V + 1 end, 1, A) end,
    lists:foldl(Count, #{}, L).

find([], _,_) -> not_found;
find([H | T], Overlapping, Acc) ->
    case sets:is_disjoint(sets:from_list(H), Overlapping) of
        true -> Acc;
        false -> find(T, Overlapping, Acc + 1)
    end.

solve() ->
    Lines = readlines("input"),
    Grid = [grid(parse_opts(L)) || L <- Lines],
    FlatGrid = lists:flatten(Grid),
    CountMap = count(FlatGrid),
    Overlapping = maps:filter(fun(_, V) -> V >= 2 end, CountMap),
    OverlappingSet = sets:from_list(maps:keys(Overlapping)),
    find(Grid, OverlappingSet, 1).

%%====================================================================
%% HELPERS
%%====================================================================

readlines(Filename) ->
    {ok, Data} = file:read_file(Filename),
    Data2 = binary:split(Data, [<<"\n">>], [global]),
    [binary_to_list(L) || L <- remove_blank(Data2)].

remove_blank(List) ->
    lists:filter(fun(El) -> El /= <<>> end, List).
