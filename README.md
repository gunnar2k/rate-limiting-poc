# Rate Limiting

Rate-limiting outbound requests to an external service where rates are set per organization, using `DynamicSupervisor`, `GenServer` and Erlang's `queue` module.
