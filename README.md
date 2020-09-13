# Rate limiting – poc

Rate-limiting outbound requests to an external service where rates are set per organization, using `DynamicSupervisor`, `GenServer` and Erlang's `queue` module.

![Overview](./docs/overview.png)

## `OrganizationSupervisor`

Uses `DynamicSupervisor` to manage an organizations outbound requests.

## `OrganizationWorker`

Enqueue new requests. The worker processes the `:queue` of functions to be called. The level of concurrency, ie. how many requests to make at the same time, can be predefined.
