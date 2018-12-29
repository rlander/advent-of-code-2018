-module(part2).
-compile(export_all).

find_dup([], Acc, FreqList, InitialList) ->
    find_dup(InitialList, Acc, FreqList, InitialList);
find_dup([H|T], Acc, FreqList, InitialList) ->
    Sum = H + Acc,
    case lists:member(Sum, FreqList) of
        true -> Sum;
        false -> find_dup(T, Sum, [Sum |FreqList], InitialList)
    end.

solve() ->
    InputList = readlines("input"),
    find_dup(InputList, 0, [0], InputList).

%%====================================================================
%% HELPERS
%%====================================================================

readlines(Filename) ->
    {ok, Data} = file:read_file(Filename),
    Data2 = binary:split(Data, [<<"\n">>], [global]),
    [binary_to_integer(L) || L <- remove_blank(Data2)].

remove_blank(List) ->
    lists:filter(fun(El) -> El /= <<>> end, List).
