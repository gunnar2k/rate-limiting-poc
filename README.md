# Rate limiting – poc

Rate-limiting outbound requests to match an external service API limits, where the rate and concurrency limits are set per organization/group.

![Overview](./docs/overview.png)


## `OrganizationSupervisor`

A `DynamicSupervisor` implementation for managing `OrganizationWorker` children.

A new organization worker can be added by:

```elixir
OrganizationSupervisor.add_organization("org-id")
```

This initiates the `OrganizationWorker` child with an empty queue.

[Go to OrganizationSupervisor code](./lib/sender/organization_supervisor.ex).


## `OrganizationWorker`

Processes the queue of requests for the given organization. The level of concurrency (number of requests to pull from queue at one time) can be predefined in the `OrganizationWorker` module attribute `@concurrency` (default is 3).

Adding new requests can be done by:

```elixir
OrganizationWorker.enqueue("org-id", fn ->
  HTTPoison.get("http://...")
end)
```

[Go to OrganizationWorker code](./lib/sender/organization_worker.ex).
