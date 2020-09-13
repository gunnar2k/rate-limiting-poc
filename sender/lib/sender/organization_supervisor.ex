defmodule Sender.OrganizationSupervisor do
  use DynamicSupervisor

  # Client

  def add_organization(org_id) do
    DynamicSupervisor.start_child(__MODULE__, {Sender.OrganizationWorker, org_id})
  end

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # Server

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
