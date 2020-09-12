defmodule Receiver.Endpoint do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/", do: Receiver.Controller.get(conn)
end
