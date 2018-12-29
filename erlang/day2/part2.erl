-module(part2).
-compile(export_all).

matching_letters(Id1, Id2) -> [W || {W, W} <- lists:zip(Id1, Id2)].

find_common_ids([]) -> not_found;
find_common_ids([Id | Rest]) ->
	case find_common_ids(Id, Rest) of
		not_found -> find_common_ids(Rest);
		Res -> Res
	end.

find_common_ids(_, []) -> not_found;
find_common_ids(Id, [NextId | Rest]) ->
	LenDiff = string:len(Id) - 1,
	MatchingLetters = matching_letters(Id, NextId),
	case string:len(MatchingLetters) =:= LenDiff of
		true -> MatchingLetters;
		false -> find_common_ids(Id, Rest)
	end.
	
solve() ->
	Ids = readlines("input"),
	find_common_ids(Ids).

%%====================================================================
%% HELPERS
%%====================================================================

readlines(Filename) ->
    {ok, Data} = file:read_file(Filename),
    Data2 = binary:split(Data, [<<"\n">>], [global]),
    [binary_to_list(L) || L <- remove_blank(Data2)].

remove_blank(List) ->
    lists:filter(fun(El) -> El /= <<>> end, List).
