# GoldRush JSON-RPC Methods

## `eth_*`

| Method | Credits | Summary |
|--------|--------:|---------|
| `eth_blockNumber` | 0.01 | Returns the latest block number on the chain. |
| `eth_getBalance` | 0.01 | Returns the native token balance of an address at a given block. |
| `eth_getCode` | 0.01 | Returns the contract bytecode at a given address. |
| `eth_getStorageAt` | 0.01 | Returns the value of a storage slot for a given address. |
| `eth_getTransactionCount` | 0.01 | Returns the nonce (number of transactions sent) of an address. |
| `eth_getBlockByHash` | 0.01 | Returns block information by block hash. |
| `eth_getBlockByNumber` | 0.01 | Returns block information by block number. |
| `eth_getBlockTransactionCountByHash` | 0.01 | Returns the number of transactions in a block, identified by hash. |
| `eth_getBlockTransactionCountByNumber` | 0.01 | Returns the number of transactions in a block, identified by number. |
| `eth_getTransactionByHash` | 0.01 | Returns transaction details by transaction hash. |
| `eth_getTransactionByBlockHashAndIndex` | 0.01 | Returns the transaction at a given index inside a block, identified by block hash. |
| `eth_getTransactionByBlockNumberAndIndex` | 0.01 | Returns the transaction at a given index inside a block, identified by block number. |
| `eth_getTransactionReceipt` | 0.01 | Returns the receipt for a mined transaction. |
| `eth_call` | 0.01 | Executes a read-only contract call without creating a transaction. |
| `eth_estimateGas` | 0.01 | Estimates the gas required to execute a transaction. |
| `eth_gasPrice` | 0.01 | Returns the node's current suggested gas price. |
| `eth_maxPriorityFeePerGas` | 0.01 | Returns the suggested priority fee per gas (EIP-1559). |
| `eth_feeHistory` | 0.01 | Returns historical fee market data over a range of blocks. |
| `eth_chainId` | 0.01 | Returns the EIP-155 chain ID. |
| `eth_sendRawTransaction` | 0.01 | Submits a signed raw transaction to the network. |
| `eth_getLogs` | 0.01 | Returns event logs matching a filter. |
| `eth_newFilter` | 0.01 | Creates a log filter that can be polled for new matches. |
| `eth_newBlockFilter` | 0.01 | Creates a filter that fires on new blocks. |
| `eth_newPendingTransactionFilter` | 0.01 | Creates a filter that fires on new pending transactions. |
| `eth_uninstallFilter` | 0.01 | Removes a server-side filter. |
| `eth_getFilterChanges` | 0.01 | Returns new entries for a filter since the last poll. |
| `eth_getFilterLogs` | 0.01 | Returns all logs matching a log filter (one-shot). |
| `eth_syncing` | 0.01 | Returns the node's sync status. |
| `eth_accounts` | 0.01 | Returns the addresses owned by the connected node. |
| `eth_blobBaseFee` | 0.01 | Returns the current EIP-4844 blob base fee. |
| `eth_getProof` | 0.01 | Returns the Merkle proof for an account and storage slots. |

## `net_*`

| Method | Credits | Summary |
|--------|--------:|---------|
| `net_version` | 0.01 | Returns the network ID as a decimal string. |
| `net_listening` | 0.01 | Returns whether the node is actively listening for peers. |
| `net_peerCount` | 0.01 | Returns the number of connected peers. |

## `web3_*`

| Method | Credits | Summary |
|--------|--------:|---------|
| `web3_clientVersion` | 0.01 | Returns the underlying client software version. |
| `web3_sha3` | 0.01 | Returns the keccak-256 hash of the supplied data. |

## `debug_*`

| Method | Credits | Summary |
|--------|--------:|---------|
| `debug_traceTransaction` | 0.015 | Returns an opcode-level execution trace for a mined transaction. |
| `debug_traceCall` | 0.015 | Traces a `eth_call` without producing a transaction. |
| `debug_traceBlockByHash` | 0.015 | Traces every transaction in a block, identified by hash. |
| `debug_traceBlockByNumber` | 0.015 | Traces every transaction in a block, identified by number. |

## `trace_*`

| Method | Credits | Summary |
|--------|--------:|---------|
| `trace_transaction` | 0.015 | Returns the Parity-style trace of a mined transaction. |
| `trace_block` | 0.015 | Returns Parity-style traces for every transaction in a block. |
| `trace_filter` | 0.015 | Returns Parity-style traces matching a filter. |
| `trace_call` | 0.015 | Returns the Parity-style trace of an `eth_call`. |
| `trace_callMany` | 0.015 | Returns Parity-style traces for a sequence of calls executed on top of the same block. |
| `trace_rawTransaction` | 0.015 | Returns Parity-style traces for a raw, signed transaction without broadcasting it. |
| `trace_replayBlockTransactions` | 0.015 | Replays every transaction in a block and returns the requested Parity-style traces. |
| `trace_replayTransaction` | 0.015 | Replays a mined transaction and returns the requested Parity-style traces. |
| `trace_get` | 0.015 | Returns a single Parity-style trace at a given position within a transaction. |

## Per-method details

### `eth_blockNumber`

**Summary:** Returns the latest block number on the chain.

**Parameters:** none

**Returns:** `QUANTITY`. Hex-encoded integer of the current block number.

---

### `eth_getBalance`

**Summary:** Returns the native token balance of an address at a given block.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `address` | `DATA, 20 bytes` | yes | Address to check the balance of. |
| `blockTag` | `QUANTITY \| TAG` | yes | Block number (hex), or `latest`, `earliest`, `pending`, `safe`, `finalized`. |

**Returns:** `QUANTITY`. Hex-encoded balance in wei.

---

### `eth_getCode`

**Summary:** Returns the contract bytecode at a given address.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `address` | `DATA, 20 bytes` | yes | Address whose code to fetch. |
| `blockTag` | `QUANTITY \| TAG` | yes | Block number (hex), or `latest`, `earliest`, `pending`, `safe`, `finalized`. |

**Returns:** `DATA`. Hex-encoded contract bytecode, or `0x` if none.

---

### `eth_getStorageAt`

**Summary:** Returns the value of a storage slot for a given address.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `address` | `DATA, 20 bytes` | yes | Contract address. |
| `position` | `QUANTITY` | yes | Hex-encoded storage slot index. |
| `blockTag` | `QUANTITY \| TAG` | yes | Block number (hex) or block tag. |

**Returns:** `DATA, 32 bytes`. 32-byte hex-encoded value at the given slot.

---

### `eth_getTransactionCount`

**Summary:** Returns the nonce (number of transactions sent) of an address.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `address` | `DATA, 20 bytes` | yes | Address to query. |
| `blockTag` | `QUANTITY \| TAG` | yes | Block number (hex) or block tag. |

**Returns:** `QUANTITY`. Hex-encoded transaction count.

---

### `eth_getBlockByHash`

**Summary:** Returns block information by block hash.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `blockHash` | `DATA, 32 bytes` | yes | Hash of the block. |
| `hydrated` | `Boolean` | yes | If `true`, returns full transaction objects; if `false`, only transaction hashes. |

**Returns:** `Object | null`. Block object, or `null` if no block was found.

---

### `eth_getBlockByNumber`

**Summary:** Returns block information by block number.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `blockTag` | `QUANTITY \| TAG` | yes | Block number (hex), or `latest`, `earliest`, `pending`, `safe`, `finalized`. |
| `hydrated` | `Boolean` | yes | If `true`, returns full transaction objects; if `false`, only transaction hashes. |

**Returns:** `Object | null`. Block object, or `null` if no block was found.

---

### `eth_getBlockTransactionCountByHash`

**Summary:** Returns the number of transactions in a block, identified by hash.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `blockHash` | `DATA, 32 bytes` | yes | Hash of the block. |

**Returns:** `QUANTITY | null`. Hex-encoded transaction count, or `null` if the block is unknown.

---

### `eth_getBlockTransactionCountByNumber`

**Summary:** Returns the number of transactions in a block, identified by number.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `blockTag` | `QUANTITY \| TAG` | yes | Block number (hex) or block tag. |

**Returns:** `QUANTITY`. Hex-encoded transaction count.

---

### `eth_getTransactionByHash`

**Summary:** Returns transaction details by transaction hash.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `transactionHash` | `DATA, 32 bytes` | yes | Transaction hash. |

**Returns:** `Object | null`. Transaction object, or `null` if unknown.

---

### `eth_getTransactionByBlockHashAndIndex`

**Summary:** Returns the transaction at a given index inside a block, identified by block hash.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `blockHash` | `DATA, 32 bytes` | yes | Hash of the block. |
| `index` | `QUANTITY` | yes | Hex-encoded index of the transaction inside the block. |

**Returns:** `Object | null`. Transaction object, or `null` if the index is out of range.

---

### `eth_getTransactionByBlockNumberAndIndex`

**Summary:** Returns the transaction at a given index inside a block, identified by block number.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `blockTag` | `QUANTITY \| TAG` | yes | Block number (hex) or block tag. |
| `index` | `QUANTITY` | yes | Hex-encoded index of the transaction inside the block. |

**Returns:** `Object | null`. Transaction object, or `null` if the index is out of range.

---

### `eth_getTransactionReceipt`

**Summary:** Returns the receipt for a mined transaction.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `transactionHash` | `DATA, 32 bytes` | yes | Transaction hash. |

**Returns:** `Object | null`. Receipt object, or `null` if the transaction has not been mined.

---

### `eth_call`

**Summary:** Executes a read-only contract call without creating a transaction.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `callObject` | `Object` | yes | `{from?, to, gas?, gasPrice?, value?, data?}`. `to` and `data` are typically the only required fields for read calls. |
| `blockTag` | `QUANTITY \| TAG` | yes | Block number (hex) or block tag at which to evaluate the call. |

**Returns:** `DATA`. Hex-encoded ABI return data.

---

### `eth_estimateGas`

**Summary:** Estimates the gas required to execute a transaction.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `callObject` | `Object` | yes | Same shape as `eth_call`'s call object. |

**Returns:** `QUANTITY`. Hex-encoded gas estimate.

---

### `eth_gasPrice`

**Summary:** Returns the node's current suggested gas price.

**Parameters:** none

**Returns:** `QUANTITY`. Hex-encoded gas price in wei.

---

### `eth_maxPriorityFeePerGas`

**Summary:** Returns the suggested priority fee per gas (EIP-1559).

**Parameters:** none

**Returns:** `QUANTITY`. Hex-encoded priority fee in wei.

---

### `eth_feeHistory`

**Summary:** Returns historical fee market data over a range of blocks.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `blockCount` | `QUANTITY` | yes | Hex-encoded number of blocks to inspect (max 1024). |
| `newestBlock` | `QUANTITY \| TAG` | yes | Highest block to include. |
| `rewardPercentiles` | `Array<Number>` | no | Reward percentiles to compute. Empty array skips reward computation. |

**Returns:** `Object`. `{oldestBlock, baseFeePerGas[], gasUsedRatio[], reward[][]}`

---

### `eth_chainId`

**Summary:** Returns the EIP-155 chain ID.

**Parameters:** none

**Returns:** `QUANTITY`. Hex-encoded chain ID.

---

### `eth_sendRawTransaction`

**Summary:** Submits a signed raw transaction to the network.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `signedTransaction` | `DATA` | yes | Hex-encoded signed transaction. |

**Returns:** `DATA, 32 bytes`. Transaction hash.

---

### `eth_getLogs`

**Summary:** Returns event logs matching a filter.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `filter` | `Object` | yes | `{fromBlock?, toBlock?, address?, topics?, blockHash?}`. Use `blockHash` for exact-block queries. |

**Returns:** `Array<Object>`. Array of matching log objects.

---

### `eth_newFilter`

**Summary:** Creates a log filter that can be polled for new matches.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `filter` | `Object` | yes | `{fromBlock?, toBlock?, address?, topics?}`. |

**Returns:** `QUANTITY`. Hex-encoded filter ID.

---

### `eth_newBlockFilter`

**Summary:** Creates a filter that fires on new blocks.

**Parameters:** none

**Returns:** `QUANTITY`. Hex-encoded filter ID.

---

### `eth_newPendingTransactionFilter`

**Summary:** Creates a filter that fires on new pending transactions.

**Parameters:** none

**Returns:** `QUANTITY`. Hex-encoded filter ID.

---

### `eth_uninstallFilter`

**Summary:** Removes a server-side filter.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `filterId` | `QUANTITY` | yes | Hex-encoded filter ID. |

**Returns:** `Boolean`. `true` if the filter was uninstalled.

---

### `eth_getFilterChanges`

**Summary:** Returns new entries for a filter since the last poll.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `filterId` | `QUANTITY` | yes | Hex-encoded filter ID. |

**Returns:** `Array`. Array of matches; element shape depends on filter type.

---

### `eth_getFilterLogs`

**Summary:** Returns all logs matching a log filter (one-shot).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `filterId` | `QUANTITY` | yes | Hex-encoded filter ID. |

**Returns:** `Array<Object>`. All matching log objects.

---

### `eth_syncing`

**Summary:** Returns the node's sync status.

**Parameters:** none

**Returns:** `Boolean | Object`. `false` if synced; otherwise `{startingBlock, currentBlock, highestBlock}`.

---

### `eth_accounts`

**Summary:** Returns the addresses owned by the connected node.

**Parameters:** none

**Returns:** `Array<DATA>`. Always `[]` on GoldRush.

---

### `eth_blobBaseFee`

**Summary:** Returns the current EIP-4844 blob base fee.

**Parameters:** none

**Returns:** `QUANTITY`. Hex-encoded blob base fee in wei.

---

### `eth_getProof`

**Summary:** Returns the Merkle proof for an account and storage slots.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `address` | `DATA, 20 bytes` | yes | Address to prove. |
| `storageKeys` | `Array<DATA, 32 bytes>` | yes | Array of storage keys to include in the proof. |
| `blockTag` | `QUANTITY \| TAG` | yes | Block number (hex) or block tag. |

**Returns:** `Object`. `{address, accountProof[], balance, codeHash, nonce, storageHash, storageProof[]}`

---

### `net_version`

**Summary:** Returns the network ID as a decimal string.

**Parameters:** none

**Returns:** `String`. Decimal network ID.

---

### `net_listening`

**Summary:** Returns whether the node is actively listening for peers.

**Parameters:** none

**Returns:** `Boolean`. `true` if the node is listening.

---

### `net_peerCount`

**Summary:** Returns the number of connected peers.

**Parameters:** none

**Returns:** `QUANTITY`. Hex-encoded peer count.

---

### `web3_clientVersion`

**Summary:** Returns the underlying client software version.

**Parameters:** none

**Returns:** `String`. Client version string.

---

### `web3_sha3`

**Summary:** Returns the keccak-256 hash of the supplied data.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `data` | `DATA` | yes | Hex-encoded input data. |

**Returns:** `DATA, 32 bytes`. Keccak-256 hash.

---

### `debug_traceTransaction`

**Summary:** Returns an opcode-level execution trace for a mined transaction.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `transactionHash` | `DATA, 32 bytes` | yes | Transaction hash. |
| `options` | `Object` | no | `{tracer?, tracerConfig?, timeout?}`. Common tracers: `callTracer`, `prestateTracer`, `4byteTracer`. |

**Returns:** `Object`. Tracer-specific output. With `callTracer`, the call graph rooted at the transaction's `from`/`to`.

---

### `debug_traceCall`

**Summary:** Traces a `eth_call` without producing a transaction.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `callObject` | `Object` | yes | Same shape as `eth_call`'s call object. |
| `blockTag` | `QUANTITY \| TAG` | yes | Block number (hex) or block tag. |
| `options` | `Object` | no | Tracer config. See `debug_traceTransaction`. |

**Returns:** `Object`. Tracer-specific output.

---

### `debug_traceBlockByHash`

**Summary:** Traces every transaction in a block, identified by hash.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `blockHash` | `DATA, 32 bytes` | yes | Hash of the block to trace. |
| `options` | `Object` | no | Tracer config. |

**Returns:** `Array<Object>`. Array of per-transaction tracer outputs.

---

### `debug_traceBlockByNumber`

**Summary:** Traces every transaction in a block, identified by number.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `blockTag` | `QUANTITY \| TAG` | yes | Block number (hex) or block tag. |
| `options` | `Object` | no | Tracer config. |

**Returns:** `Array<Object>`. Array of per-transaction tracer outputs.

---

### `trace_transaction`

**Summary:** Returns the Parity-style trace of a mined transaction.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `transactionHash` | `DATA, 32 bytes` | yes | Transaction hash. |

**Returns:** `Array<Object>`. Array of trace objects.

---

### `trace_block`

**Summary:** Returns Parity-style traces for every transaction in a block.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `blockTag` | `QUANTITY \| TAG` | yes | Block number (hex) or block tag. |

**Returns:** `Array<Object>`. Array of trace objects across all transactions in the block.

---

### `trace_filter`

**Summary:** Returns Parity-style traces matching a filter.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `filter` | `Object` | yes | `{fromBlock?, toBlock?, fromAddress?, toAddress?, after?, count?}`. |

**Returns:** `Array<Object>`. Array of matching trace objects.

---

### `trace_call`

**Summary:** Returns the Parity-style trace of an `eth_call`.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `callObject` | `Object` | yes | Same shape as `eth_call`'s call object. |
| `traceTypes` | `Array<String>` | yes | Trace types to include. One or more of `trace`, `vmTrace`, `stateDiff`. |
| `blockTag` | `QUANTITY \| TAG` | no | Block number (hex) or block tag. Defaults to `latest`. |

**Returns:** `Object`. `{output, trace[], stateDiff?, vmTrace?}`

---

### `trace_callMany`

**Summary:** Returns Parity-style traces for a sequence of calls executed on top of the same block.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `calls` | `Array<[Object, Array<String>]>` | yes | Array of `[callObject, traceTypes]` tuples. Each `callObject` has the same shape as `eth_call`; each `traceTypes` is one or more of `trace`, `vmTrace`, `stateDiff`. |
| `blockTag` | `QUANTITY \| TAG` | no | Block number (hex) or block tag the simulation runs on top of. Defaults to `latest`. |

**Returns:** `Array<Object>`. Array of trace result objects, one per input call, each shaped like a `trace_call` result (`{output, trace[], stateDiff?, vmTrace?}`).

---

### `trace_rawTransaction`

**Summary:** Returns Parity-style traces for a raw, signed transaction without broadcasting it.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `rawTransaction` | `DATA` | yes | RLP-encoded, signed transaction. |
| `traceTypes` | `Array<String>` | yes | Trace types to include. One or more of `trace`, `vmTrace`, `stateDiff`. |

**Returns:** `Object`. `{output, trace[], stateDiff?, vmTrace?}`

---

### `trace_replayBlockTransactions`

**Summary:** Replays every transaction in a block and returns the requested Parity-style traces.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `blockTag` | `QUANTITY \| TAG` | yes | Block number (hex) or block tag. |
| `traceTypes` | `Array<String>` | yes | Trace types to include. One or more of `trace`, `vmTrace`, `stateDiff`. |

**Returns:** `Array<Object>`. Array of replay results, one per transaction in the block. Each entry has `{transactionHash, output, trace[], stateDiff?, vmTrace?}`.

---

### `trace_replayTransaction`

**Summary:** Replays a mined transaction and returns the requested Parity-style traces.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `transactionHash` | `DATA, 32 bytes` | yes | Transaction hash. |
| `traceTypes` | `Array<String>` | yes | Trace types to include. One or more of `trace`, `vmTrace`, `stateDiff`. |

**Returns:** `Object`. `{output, trace[], stateDiff?, vmTrace?}`

---

### `trace_get`

**Summary:** Returns a single Parity-style trace at a given position within a transaction.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `transactionHash` | `DATA, 32 bytes` | yes | Transaction hash. |
| `tracePosition` | `Array<QUANTITY>` | yes | Address path through the call tree, as an array of indices. |

**Returns:** `Object`. A single trace object at the requested position.

---

---

The `debug_*` and `trace_*` namespaces give you opcode-level visibility into transaction execution. They're used by block explorers, security tools, MEV searchers, and indexers that need internal-call data.

Both namespaces are served from `https://rpc.goldrushdata.com/v1/{chain}`.

> **Note:** **Looking for a wallet's internal transaction history?** These methods are **per-transaction and per-block primitives**, not a wallet-history endpoint. Reconstructing one address's internal transfers from raw traces means scanning a block range twice with `trace_filter` (once by `fromAddress`, once by `toAddress`) - and on chains where `trace_filter` isn't available (e.g. OP-stack L2s) falling back to `debug_traceBlockByNumber` block-by-block. For decoded, wallet-level internal transfers across chains with no client-side call-tree walking, use the Foundational API's **`with-internal` param** instead.

## debug_* methods (Geth-style)

| Method | Summary | Rate |
|--------|---------|-----:|
| **`debug_traceTransaction`** | Step-by-step EVM trace of a mined transaction. | 0.015 |
| **`debug_traceCall`** | Trace an `eth_call` without producing a transaction. | 0.015 |
| **`debug_traceBlockByHash`** | Trace every transaction in a block (by hash). | 0.015 |
| **`debug_traceBlockByNumber`** | Trace every transaction in a block (by number). | 0.015 |

All four accept a tracer config:

```json
{
  "tracer": "callTracer",
  "tracerConfig": { "withLog": true },
  "timeout": "30s"
}
```

Common tracer values: `callTracer` (call graph), `prestateTracer` (state diff), `4byteTracer` (4-byte selector frequency), or omit for the default opcode-level trace.

## trace_* methods (Parity-style)

| Method | Summary | Rate |
|--------|---------|-----:|
| **`trace_transaction`** | Parity trace of a mined transaction. | 0.015 |
| **`trace_block`** | Parity traces of every transaction in a block. | 0.015 |
| **`trace_filter`** | Parity traces matching a filter (sender, recipient, range). | 0.015 |
| **`trace_call`** | Parity trace of an `eth_call`. | 0.015 |
| **`trace_callMany`** | Parity traces for a sequence of calls executed in order. | 0.015 |
| **`trace_rawTransaction`** | Parity trace of a signed, unmined raw transaction. | 0.015 |
| **`trace_replayTransaction`** | Replay a mined transaction and return traces, vmTrace, and state diff. | 0.015 |
| **`trace_replayBlockTransactions`** | Replay every transaction in a block with selectable trace outputs. | 0.015 |
| **`trace_get`** | Fetch a specific sub-trace from a mined transaction by index path. | 0.015 |

`trace_*` is the canonical Erigon/Parity format. Prefer it when integrating with tooling that expects Erigon traces (e.g. block-explorer pipelines).

## Per-chain availability

Trace and debug support depends on what the upstream node software exposes. Erigon and Reth both expose `trace_*` natively, while Geth-based upstreams expose `debug_*`. GoldRush surfaces whichever is available, and falls back to a normalized translation where one namespace is missing.

| Chain | `debug_*` | `trace_*` | Archive depth |
|-------|:---------:|:---------:|---------------|
| Ethereum (`eth-mainnet`) | ✅ | ✅ | Genesis |
| Polygon (`matic-mainnet`) | ✅ | ✅ | Genesis |
| BNB Smart Chain (`bsc-mainnet`) | ✅ | ✅ | Genesis |
| Arbitrum (`arbitrum-mainnet`) | ✅ | ✅ | Nitro genesis |
| Base (`base-mainnet`) | ✅ | ✅ | Genesis |
| HyperEVM (`hyperevm-mainnet`) | ✅ | ✅ | Genesis |
| MegaETH (`megaeth-mainnet`) | ⚠️ rolling | ⚠️ rolling | Last 30 days |
| Monad (`monad-mainnet`) | ⚠️ rolling | ⚠️ rolling | Last 30 days |
| Tempo (`tempo-mainnet`) | ⚠️ rolling | ⚠️ rolling | Last 7 days |

⚠️ "Rolling" means the upstream archive window slides forward over time. For deeper history on these chains, contact GoldRush support to discuss dedicated archive nodes.

## Solana

Solana does not expose the `debug_*` or `trace_*` namespaces; they are EVM-specific. For transaction introspection on Solana, use:

| Goal | Solana method |
|------|---------------|
| Inspect a confirmed transaction's logs, balances, and compute units | **`getTransaction`** |
| Dry-run a transaction and read its logs and state changes before sending | **`simulateTransaction`** |
| Stream logs for a program or account in real time | **`logsSubscribe`** |

`simulateTransaction` is the closest analogue to `debug_traceCall` / `trace_call`: it returns the program logs, the error (if any), compute units consumed, and optionally post-simulation account state, without broadcasting the transaction.

## Pricing

`debug_*` and `trace_*` are heavier than standard `eth_*` reads. See **pricing** for full rates.

### debug_traceTransaction

Most-used debug method.

### trace_transaction

Parity-style equivalent.