-module(part1).
-compile(export_all).

count(Str) ->
    Count = fun(I, A) -> maps:update_with(I, fun(V) -> V + 1 end, 1, A) end,
    lists:foldl(Count, #{}, Str).

invert(Map) ->
    Invert = fun(K, V, Acc) -> maps:put(V, K, Acc) end,
    maps:fold(Invert, #{}, Map).

filter_dups(CountMap) ->
    sets:to_list(sets:from_list(maps:keys(CountMap))).

solve() ->
    List = readlines("input"),
    Counts = [filter_dups(invert(count(Elem))) || Elem <- List],
    #{2 := Twos, 3 := Threes} = count(lists:flatten(Counts)),
    Twos * Threes.

%%====================================================================
%% HELPERS
%%====================================================================

readlines(Filename) ->
    {ok, Data} = file:read_file(Filename),
    Data2 = binary:split(Data, [<<"\n">>], [global]),
    [binary_to_list(L) || L <- remove_blank(Data2)].

remove_blank(List) ->
    lists:filter(fun(El) -> El /= <<>> end, List).
