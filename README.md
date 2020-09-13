# Rate limiting – poc

Rate-limiting outbound requests to an external service. The limits are set per organization.

## `OrganizationSupervisor`

Uses `DynamicSupervisor` to manage `OrganizationWorker` children.

## `OrganizationWorker`

Enqueue new requests. The worker processes the `:queue` of functions to be called. The level of concurrency, ie. how many requests to make at the same time, can be predefined.

## Overview

![Overview](./docs/overview.png)
