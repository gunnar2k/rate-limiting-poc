# Rate limiting – poc

Rate-limiting outbound requests to an external service. The limits are set per organization.

## Overview

![Overview](./docs/overview.png)


## `OrganizationSupervisor`

New organization workers can be added by:

```elixir
OrganizationSupervisor.add_organization("org-id")
```

This will initiate the `OrganizationWorker` child with an empty queue.


## `OrganizationWorker`

Use to enqueue new requests. Internally, the worker regularly processes the queue.

Adding new requests can be done by:

```elixir
OrganizationWorker.enqueue("org-id", fn ->
  HTTPoison.get("http://...")
end)
```

The function in the second argument will be added to the `OrganizationWorker`s internal `:queue` which the worker pulls from on a regular basis. The level of concurrency (number of requests to pull from queue) can be predefined in the `OrganizationWorker` module attribute `@concurrency` which defaults to 3.
