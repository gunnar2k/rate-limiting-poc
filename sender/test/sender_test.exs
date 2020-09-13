defmodule SenderTest do
  use ExUnit.Case
  alias Sender.{OrganizationSupervisor, OrganizationWorker}

  test "sender" do
    assert {:ok, _pid} = OrganizationSupervisor.add_organization(("org1"))
    assert {:ok, _pid} = OrganizationSupervisor.add_organization(("org2"))
    assert {:ok, _pid} = OrganizationSupervisor.add_organization(("org3"))

    assert :ok == OrganizationWorker.enqueue("org1", fn -> nil end)
    assert :ok == OrganizationWorker.enqueue("org1", fn -> nil end)
    assert :ok == OrganizationWorker.enqueue("org1", fn -> nil end)

    assert :ok == OrganizationWorker.enqueue("org2", fn -> nil end)
    assert :ok == OrganizationWorker.enqueue("org2", fn -> nil end)
    assert :ok == OrganizationWorker.enqueue("org2", fn -> nil end)

    assert :ok == OrganizationWorker.enqueue("org3", fn -> nil end)
    assert :ok == OrganizationWorker.enqueue("org3", fn -> nil end)
    assert :ok == OrganizationWorker.enqueue("org3", fn -> nil end)
  end
end
