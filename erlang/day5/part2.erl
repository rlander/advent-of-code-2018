-module(part2).
-compile(export_all).

process([], Acc) -> length(Acc);
process([H, N | T], []) when H + 32 =:= N; N + 32 =:= H ->
    process(T, []); 
process([H, N | T], [H2 | T2]) when H + 32 =:= N; N + 32 =:= H ->
    process([H2 | T], T2);
process([H | T], Acc) ->
    process(T, [H | Acc]).

remove(L, Chars) ->
	lists:flatten(string:tokens(L, Chars)).	

solve() ->
	L = readlines("input"),
	Chars = [[C, C + 32] || C <- lists:seq($A, $Z)], %% make a list like ["Aa", "bB" ...]
	Res = [process(remove(L, C), []) || C <- Chars],
	hd(lists:sort(Res)).

%%====================================================================
%% HELPERS
%%====================================================================

readlines(Filename) ->
    {ok, Data} = file:read_file(Filename),
    binary_to_list(Data).
