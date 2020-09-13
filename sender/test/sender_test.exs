defmodule SenderTest do
  use ExUnit.Case
  alias Sender.RateLimiter

  describe "rate limiter" do
    test "adding and listing organizations" do
      assert :ok == RateLimiter.add_organization("org_id1")
      assert :ok == RateLimiter.add_organization("org_id2")
      assert :ok == RateLimiter.add_organization("org_id3")

      assert %{
               "org_id1" => %{"queue" => {[], []}},
               "org_id2" => %{"queue" => {[], []}},
               "org_id3" => %{"queue" => {[], []}}
             } == RateLimiter.list_organizations()
    end

    test "queuing function calls" do
      assert :ok == RateLimiter.add_organization("org_id1")

      :timer.sleep(2_000)

      RateLimiter.push_to_queue("org_id1", fn ->
        IO.puts("Started request")
        :timer.sleep(2000)
        IO.puts("Done request")
      end)

      :timer.sleep(10_000)
    end
  end

  # test "rate limiter" do
  #   assert :ok == RateLimiter.add_organization("org_id1")
  #   assert :ok == RateLimiter.add_organization("org_id2")
  #   assert :ok == RateLimiter.add_organization("org_id3")

  #   assert %{
  #            "org_id1" => %{"queue" => {[], []}},
  #            "org_id2" => %{"queue" => {[], []}},
  #            "org_id3" => %{"queue" => {[], []}}
  #          } == RateLimiter.list_organizations()

  #   # RateLimiter.use_slot("org_id1", fn ->
  #   #   IO.puts("Started request")
  #   #   :timer.sleep(3000)
  #   #   IO.puts("Done request")
  #   # end)
  # end
end
