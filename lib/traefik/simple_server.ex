# server() ->
#     {ok, LSock} = gen_tcp:listen(5678, [binary, {packet, 0},
#                                         {active, false}]),
#     {ok, Sock} = gen_tcp:accept(LSock),
#     {ok, Bin} = do_recv(Sock, []),
#     ok = gen_tcp:close(Sock),
#     ok = gen_tcp:close(LSock),
#     Bin.
#
# do_recv(Sock, Bs) ->
#     case gen_tcp:recv(Sock, 0) of
#         {ok, B} ->
#             do_recv(Sock, [Bs, B]);
#         {error, closed} ->
#             {ok, list_to_binary(Bs)}
#     end.

defmodule Traefik.SimpleServer do
  def server() do
    {:ok, lsock} = :gen_tcp.listen(5678, [:binary, {:packet, 0}, {:active, false}])
    {:ok, sock} = :gen_tcp.accept(lsock)
    {:ok, bin} = :gen_tcp.recv(sock, 0)
    # Handles
    :ok = :gen_tcp.close(sock)
    :ok = :gen_tcp.close(lsock)
    bin
  end
end
