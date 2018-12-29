-module(part1).
-compile(export_all).

solve() ->
    InputList = readlines("input"),
    lists:sum(InputList).

%%====================================================================
%% HELPERS
%%====================================================================

readlines(Filename) ->
    {ok, Data} = file:read_file(Filename),
    Data2 = binary:split(Data, [<<"\n">>], [global]),
    [binary_to_integer(L) || L <- remove_blank(Data2)].

remove_blank(List) ->
    lists:filter(fun(El) -> El /= <<>> end, List).
