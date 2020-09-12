defmodule Receiver.Application do
  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Use Plug.Cowboy.child_spec/3 to register our endpoint as a plug
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Receiver.Endpoint,
        options: [port: 4000]
      ),
      {Receiver.RateLimiter, [slots: 3]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Receiver.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
