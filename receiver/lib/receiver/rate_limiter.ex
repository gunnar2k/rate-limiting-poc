defmodule Receiver.RateLimiter do
  use GenServer

  # Client

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def hold_slot() do
    GenServer.call(__MODULE__, :hold_slot)
  end

  def release_slot() do
    GenServer.call(__MODULE__, :release_slot)
  end

  # Server

  @impl true
  def init(args) do
    {:ok, args}
  end

  @impl true
  def handle_call(:hold_slot, _from, [slots: slots] = state) do
    cond do
      slots <= 0 ->
        {:reply, {:error, :no_slots_available}, state}

      true ->
        new_slots = slots - 1

        {:reply, {:ok, new_slots}, [slots: new_slots]}
    end
  end

  @impl true
  def handle_call(:release_slot, _from, [slots: slots]) do
    new_state = [slots: slots + 1]

    {:reply, {:ok, new_state}, new_state}
  end
end
