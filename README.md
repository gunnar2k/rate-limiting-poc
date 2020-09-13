# Rate limiting

Rate-limiting outbound requests to an external service where rates are set per organization, using `DynamicSupervisor`, `GenServer` and Erlang's `queue` module.

## `OrganizationSupervisor`

Uses `DynamicSupervisor` to manage organizations outbound requests.

## `OrganizationWorker`

Uses `GenServer` to process queue of functions to be called, where the concurrency of each queue can be predefined.
