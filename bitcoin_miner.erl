-module(bitcoin_miner).
-export([master/1, mining/3, start_worker/1]).

start_worker(ServerName_IPAddress) ->
    net_kernel:connect_node(ServerName_IPAddress).
    %%'youms@10.136.214.191'

generate_msg(Input) ->
    "shromana.kumar;" ++ base64:encode(crypto:strong_rand_bytes(Input)).

mining(Zeroes, Input, Master_PID)  ->
    Msg = generate_msg(Input),
    Hexcode = string:lowercase(binary:encode_hex(crypto:hash(sha256, Msg))),
    HexStart = binary_to_list(string:slice(Hexcode, 0, Zeroes)),
    Zerocopies = string:copies("0", Zeroes),
    Bool = HexStart == Zerocopies,
    compare(Zeroes, Msg, Hexcode, Bool, Input, Master_PID).

compare(_, Msg, Hexcode, true, _, Master_PID) ->
    %%Node_Name = node(),
    %%io:format("~w ~n~s ~n~s ~nxxxxx The bitcoin was found by the node named ~w ~n~n", [Zeroes, Msg, Hexcode, node()]),
    Master_PID ! [finish, Msg, Hexcode],
    
    receive
        falsefinish ->
            io:format("Just stalling", [])
    end;

compare(Zeroes, _, _, false, Input, Master_PID) ->
    %%io:format("~w ~n~s ~n~s ~n~n False", [Zeroes, Msg, Hexcode]),
    mining(Zeroes, Input, Master_PID).

master(Noofzeroes) ->

    {StartingWCTime, _} = statistics(wall_clock),
    {StartingCPUTime, _} = statistics(runtime),

    Mining5 = spawn(bitcoin_miner, mining, [Noofzeroes, 5, self()]),
    Mining6 = spawn(bitcoin_miner, mining, [Noofzeroes, 6, self()]),

    Node1 = nodes(),

    if Node1 /= [] ->
        Worker1 = lists:nth(1, nodes()),
        Mining7 = spawn(Worker1, bitcoin_miner, mining, [Noofzeroes, 7, self()]),
        Mining8 = spawn(Worker1, bitcoin_miner, mining, [Noofzeroes, 8, self()]);
    Node1 == [] ->
        Mining7 = undefined,
        Mining8 = undefined
    end,

    receive
        [finish, Msg, Hexcode] -> 
            io:format("~w ~n~s ~n~s ~n~n", [Noofzeroes, Msg, Hexcode]),
            case Node1 == [] of
                false ->
                    exit(Mining7, kill),
                    exit(Mining8, kill);
                true ->
                    ok
            end,
            exit(Mining5, kill),
            exit(Mining6, kill)
    end,
    {EndingCPUTime, _} = statistics(runtime),
    {EndingWCTime, _} = statistics(wall_clock),

    io:format("Ending Statistics .....~nCPU Time is ~w seconds ~nReal Time is ~w seconds ~n", [ (EndingCPUTime - StartingCPUTime)/1000, (EndingWCTime - StartingWCTime)/1000]).
    
