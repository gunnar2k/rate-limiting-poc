defmodule Sender.RateLimiter do
  use GenServer

  # Client

  def start_link(_default) do
    initial_state = %{
      "orgs" => %{}
    }

    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def add_organization(org_id) do
    GenServer.cast(__MODULE__, {:add_organization, org_id})
  end

  def list_organizations do
    GenServer.call(__MODULE__, :list_organizations)
  end

  def push_to_queue(org_id, f) do
    GenServer.cast(__MODULE__, {:push_to_queue, org_id, f})
  end

  # Server

  @impl true
  def init(args) do
    {:ok, args}
  end

  @impl true
  def handle_cast({:add_organization, org_id}, %{"orgs" => orgs} = state) do
    new_orgs = Map.put(orgs, org_id, %{"queue" => :queue.new()})
    new_state = Map.put(state, "orgs", new_orgs)

    schedule_work(org_id)

    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:push_to_queue, org_id, f}, %{"orgs" => orgs} = state) do
    %{"queue" => queue} = orgs[org_id]
    IO.inspect(queue)
    new_queue = :queue.in(f, queue)
    new_orgs = Map.put(orgs, org_id, %{"queue" => new_queue})
    new_state = Map.put(state, "orgs", new_orgs)
    {:noreply, new_state}
  end

  @impl true
  def handle_call(:list_organizations, _from, %{"orgs" => orgs} = state) do
    {:reply, orgs, state}
  end

  @impl true
  def handle_info({:process_queue, org_id}, %{"orgs" => orgs} = state) do
    %{"queue" => queue} = orgs[org_id]

    {value, new_queue} = :queue.out(queue)

    case value do
      {:value, f} ->
        IO.inspect(f)

      :empty ->
        IO.puts("Empty queue")
    end

    schedule_work(org_id)

    new_orgs = Map.put(orgs, org_id, %{"queue" => new_queue})
    new_state = Map.put(state, "orgs", new_orgs)

    {:noreply, new_state}
  end

  defp schedule_work(org_id) do
    Process.send_after(self(), {:process_queue, org_id}, 1000)
  end
end
