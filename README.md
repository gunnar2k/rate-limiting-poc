# Rate limiting – poc

Rate-limiting outbound requests to an external service. The limits are set per organization.

## `OrganizationSupervisor`

Uses `DynamicSupervisor` to manage `OrganizationWorker` children. New workers can be added by

```elixir
OrganizationSupervisor.add_organization("org-id")
```

## `OrganizationWorker`

Enqueue new requests. The worker processes the `:queue` of functions to be called. The level of concurrency, ie. how many requests to make at the same time, can be predefined.

New requests can be added by

```elixir
OrganizationWorker.enqueue("org-id", fn ->
  HTTPoison.get("http://...")
end)
```

## Overview

![Overview](./docs/overview.png)
