defmodule Sender.OrganizationWorker do
  use GenServer

  @concurrency 3

  # Client

  def start_link(org_id) do
    state = %{
      org_id: org_id,
      queue: :queue.new()
    }

    GenServer.start_link(__MODULE__, state, name: via_tuple(org_id))
  end

  def enqueue(org_id, f) do
    GenServer.cast(via_tuple(org_id), {:enqueue, f})
  end

  # Server

  @impl true
  def init(stack) do
    schedule_work()

    {:ok, stack}
  end

  @impl true
  def handle_cast({:enqueue, f}, %{queue: queue} = state) do
    new_queue = :queue.in(f, queue)
    new_state = Map.put(state, :queue, new_queue)
    {:noreply, new_state}
  end

  @impl true
  def handle_info(:process_queue, %{queue: queue} = state) do
    new_queue =
      Enum.reduce(1..@concurrency, queue, fn _, new_queue ->
        {value, new_queue} = :queue.out(new_queue)

        case value do
          {:value, f} -> f.()
          :empty -> nil
        end

        new_queue
      end)

    schedule_work()
    new_state = Map.put(state, :queue, new_queue)
    {:noreply, new_state}
  end

  # Private

  defp via_tuple(org_id) do
    {:via, Registry, {Registry.Organizations, org_id}}
  end

  defp schedule_work() do
    Process.send_after(self(), :process_queue, 5_000)
  end
end
