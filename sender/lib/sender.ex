defmodule Sender do
  def start do
    IO.puts("Starting…")

    Enum.each(1..10, fn i ->
      Task.async(fn ->
        case HTTPoison.get("http://localhost:4000", [], recv_timeout: 30_000, timeout: 30_000) do
          {:ok, %HTTPoison.Response{status_code: 200}} ->
            IO.puts("Request #{i} succeeded")

          {:ok, %HTTPoison.Response{status_code: 429}} ->
            IO.puts("Request #{i} failed")
        end
      end)
    end)
  end
end
