-module(part1).
-compile(export_all).

process([], Acc) -> lists:reverse(Acc);
process([H, N | T], []) when H + 32 =:= N; N + 32 =:= H ->    %% when first two polymers react (uppercase equals lowercase), remove them
    process(T, []); 
process([H, N | T], [H2 | T2]) when H + 32 =:= N; N + 32 =:= H ->
    process([H2 | T], T2);    %% when Acc has size > 0, reuse last polymer since it might react with the next polymer when reacting ones are removed
process([H | T], Acc) ->
    process(T, [H | Acc]).

solve() ->
    L = readlines("input"),
    length(process(L, [])).

%%====================================================================
%% HELPERS
%%====================================================================

readlines(Filename) ->
    {ok, Data} = file:read_file(Filename),
    binary_to_list(Data).
