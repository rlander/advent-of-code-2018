-module(part1).
-compile(export_all).

tokenize(L) ->
    string:tokens(L, " []-:").

parse_record([Y, M, D, Hour, Min, "falls" | _]) ->
    {asleep, list_to_integer(Min)};
parse_record([Y, M, D, Hour, Min, "wakes" | _]) ->
    {wakes, list_to_integer(Min)};
parse_record([Y, M, D, Hour, Min, "Guard", "#" ++ Id | _]) ->
    {guard, list_to_integer(Id)}. 

parse_records([], Guard, StartSleep, Acc) -> Acc; 
parse_records([H | T], Guard, StartSleep, Acc) ->
    case parse_record(H) of
        {guard, Id} ->
            parse_records(T, Id, StartSleep, Acc);
        {asleep, Min} ->
            parse_records(T, Guard, Min, Acc);
        {wakes, StopSleep} ->
            SleepingTime = [{Guard, N} || N <- lists:seq(StartSleep, StopSleep - 1)],
            parse_records(T, Guard, StartSleep, [SleepingTime | Acc])
    end.

count(L) ->
    Count = fun(I, A) -> maps:update_with(I, fun(V) -> V + 1 end, 1, A) end,
    lists:foldl(Count, #{}, L).       

max(Map) ->
    lists:last(lists:keysort(2, maps:to_list(Map))).

solve() ->
    Lines = [tokenize(L) || L <- lists:sort(readlines("input"))],
    MinsAsleep = lists:flatten(parse_records(Lines, 0,0,[])),
    MinsAsleepIds = [Id || {Id, _} <- MinsAsleep],

    {Id, _} = max(count(MinsAsleepIds)),

    OtherGuardsRemoved = lists:filter(fun({K, _}) -> K =:= Id end, MinsAsleep),
    {{Id, Min}, _} = max(count(OtherGuardsRemoved)),

    Id * Min.


%%====================================================================
%% HELPERS
%%====================================================================

readlines(Filename) ->
    {ok, Data} = file:read_file(Filename),
    Data2 = binary:split(Data, [<<"\n">>], [global]),
    [binary_to_list(L) || L <- Data2].