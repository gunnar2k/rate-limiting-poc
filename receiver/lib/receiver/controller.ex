defmodule Receiver.Controller do
  import Plug.Conn
  alias Receiver.RateLimiter

  def get(conn) do
    case RateLimiter.hold_slot() do
      {:ok, slots} ->
        IO.inspect("Holding slot. Slots left: #{slots}")

        :timer.sleep(5000)

        {:ok, [slots: slots]} = RateLimiter.release_slot()

        IO.inspect("Released slot. Slots left: #{slots}")

        send_resp(conn, 200, "Success")

      {:error, :no_slots_available} ->
        IO.inspect("Error: No slots left!")

        send_resp(conn, 429, "Too many requests")
    end
  end
end
