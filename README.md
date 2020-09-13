# Rate limiting

Rate-limiting outbound requests to an external service where rates are set per organization, using `DynamicSupervisor`, `GenServer` and Erlang's `queue` module.

## `OrganizationSupervisor`

Uses `DynamicSupervisor` to manage an organizations outbound requests.

## `OrganizationWorker`

Uses `GenServer` to enqueue new requests. Behind the scenes the worker processes the queue of functions to be called. The level of concurrency, ie. how many requests to make at the same time, can be predefined.
