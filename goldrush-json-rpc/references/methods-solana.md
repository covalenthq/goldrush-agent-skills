# GoldRush Solana JSON-RPC Methods

Endpoint: `https://rpc.goldrushdata.com/v1/solana-mainnet` (HTTP); `wss://rpc.goldrushdata.com/v1/solana-mainnet` (subscriptions).
Auth: `Authorization: Bearer <GOLDRUSH_API_KEY>` header. Commitment levels: `processed`, `confirmed`, `finalized`. Balances in lamports (1 SOL = 1e9 lamports).

## Blocks info

| Method | Transport | Credits | Summary |
|--------|-----------|--------:|---------|
| `getBlock` | HTTP | 0.05 | Returns identity and transaction information for a confirmed block. |
| `getBlocks` | HTTP | 0.05 | Returns a list of confirmed blocks between two slots. |
| `getBlocksWithLimit` | HTTP | 0.05 | Returns a list of confirmed blocks starting at a slot, up to a limit. |
| `getBlockHeight` | HTTP | 0.01 | Returns the current block height of the node. |
| `getBlockTime` | HTTP | 0.01 | Returns the estimated production time of a block. |
| `getBlockProduction` | HTTP | 0.05 | Returns recent block production information for the current or a previous epoch. |
| `getBlockCommitment` | HTTP | 0.01 | Returns the commitment (stake-weighted votes) for a block. |
| `getLatestBlockhash` | HTTP | 0.01 | Returns the latest blockhash and its last valid block height. |
| `isBlockhashValid` | HTTP | 0.01 | Returns whether a blockhash is still valid. |
| `getRecentBlockhash` (deprecated) | HTTP | 0.01 | Returns a recent blockhash and fee schedule (deprecated). |
| `getConfirmedBlock` (deprecated) | HTTP | 0.05 | Returns the contents of a confirmed block (deprecated). |
| `getConfirmedBlocks` (deprecated) | HTTP | 0.05 | Returns a list of confirmed blocks between two slots (deprecated). |

## Transactions info

| Method | Transport | Credits | Summary |
|--------|-----------|--------:|---------|
| `getTransaction` | HTTP | 0.01 | Returns details for a confirmed transaction by signature. |
| `sendTransaction` | HTTP | 0.01 | Submits a signed transaction to the cluster. |
| `simulateTransaction` | HTTP | 0.01 | Simulates sending a transaction without submitting it. |
| `getSignaturesForAddress` | HTTP | 0.05 | Returns confirmed transaction signatures involving an address. |
| `getSignatureStatuses` | HTTP | 0.01 | Returns the status of a list of transaction signatures. |
| `getTransactionCount` | HTTP | 0.01 | Returns the total number of transactions processed by the cluster. |
| `getConfirmedTransaction` (deprecated) | HTTP | 0.01 | Returns details for a confirmed transaction (deprecated). |
| `getConfirmedSignaturesForAddress2` (deprecated) | HTTP | 0.05 | Returns confirmed signatures for an address (deprecated). |

## Node info

| Method | Transport | Credits | Summary |
|--------|-----------|--------:|---------|
| `getHealth` | HTTP | 0.01 | Returns the health status of the node. |
| `getVersion` | HTTP | 0.01 | Returns the Solana software version running on the node. |
| `getIdentity` | HTTP | 0.01 | Returns the identity pubkey of the node. |
| `getClusterNodes` | HTTP | 0.01 | Returns information about all nodes participating in the cluster. |

## Account info

| Method | Transport | Credits | Summary |
|--------|-----------|--------:|---------|
| `getAccountInfo` | HTTP | 0.01 | Returns all information associated with an account. |
| `getBalance` | HTTP | 0.01 | Returns the lamport balance of an account. |
| `getMultipleAccounts` | HTTP | 0.05 | Returns account information for a list of addresses. |
| `getProgramAccounts` | HTTP | 0.05 | Returns all accounts owned by a program. |
| `getLargestAccounts` | HTTP | 0.05 | Returns the 20 largest accounts by lamport balance. |
| `getVoteAccounts` | HTTP | 0.05 | Returns the current and delinquent vote accounts. |
| `getStakeActivation` (deprecated) | HTTP | 0.01 | Returns epoch activation information for a stake account (deprecated). |

## Network info

| Method | Transport | Credits | Summary |
|--------|-----------|--------:|---------|
| `getEpochInfo` | HTTP | 0.01 | Returns information about the current epoch. |
| `getEpochSchedule` | HTTP | 0.01 | Returns the epoch schedule from the cluster genesis config. |
| `getFeeForMessage` | HTTP | 0.01 | Returns the fee the cluster will charge for a message. |
| `getRecentPrioritizationFees` | HTTP | 0.01 | Returns recent per-compute-unit prioritization fees. |
| `getMinimumBalanceForRentExemption` | HTTP | 0.01 | Returns the minimum lamport balance for rent exemption. |
| `getGenesisHash` | HTTP | 0.01 | Returns the genesis hash of the cluster. |
| `getFirstAvailableBlock` | HTTP | 0.01 | Returns the slot of the lowest confirmed block still available. |
| `getHighestSnapshotSlot` | HTTP | 0.01 | Returns the highest slot for which the node has snapshots. |
| `getRecentPerformanceSamples` | HTTP | 0.05 | Returns recent network performance samples. |
| `getFees` (deprecated) | HTTP | 0.01 | Returns a recent blockhash and fee schedule (deprecated). |
| `getFeeCalculatorForBlockhash` (deprecated) | HTTP | 0.01 | Returns the fee calculator for a blockhash (deprecated). |

## Slot info

| Method | Transport | Credits | Summary |
|--------|-----------|--------:|---------|
| `getSlot` | HTTP | 0.01 | Returns the slot that has reached the given commitment level. |
| `getSlotLeader` | HTTP | 0.01 | Returns the current slot leader. |
| `getSlotLeaders` | HTTP | 0.01 | Returns the slot leaders for a slot range. |
| `getLeaderSchedule` | HTTP | 0.05 | Returns the leader schedule for an epoch. |
| `getMaxRetransmitSlot` | HTTP | 0.01 | Returns the highest slot seen by the retransmit stage. |
| `getMaxShredInsertSlot` | HTTP | 0.01 | Returns the highest slot for which shreds have been inserted. |
| `minimumLedgerSlot` | HTTP | 0.01 | Returns the lowest slot the node has information about in its ledger. |

## Token info

| Method | Transport | Credits | Summary |
|--------|-----------|--------:|---------|
| `getTokenAccountsByOwner` | HTTP | 0.05 | Returns all SPL token accounts owned by an address. |
| `getTokenAccountBalance` | HTTP | 0.01 | Returns the token balance of an SPL token account. |
| `getTokenSupply` | HTTP | 0.01 | Returns the total supply of an SPL token. |
| `getTokenLargestAccounts` | HTTP | 0.05 | Returns the 20 largest accounts for an SPL token mint. |
| `getTokenAccountsByDelegate` | HTTP | 0.05 | Returns all SPL token accounts delegated to an address. |
| `requestAirdrop` | HTTP | 0.01 | Requests an airdrop of lamports to an account (devnet/testnet). |

## Subscriptions

| Method | Transport | Credits | Summary |
|--------|-----------|--------:|---------|
| `accountSubscribe` | WebSocket | 0.01 | Subscribes to changes to an account. |
| `accountUnsubscribe` | WebSocket | 0.01 | Cancels an account subscription. |
| `logsSubscribe` | WebSocket | 0.01 | Subscribes to transaction logging. |
| `logsUnsubscribe` | WebSocket | 0.01 | Cancels a logs subscription. |
| `programSubscribe` | WebSocket | 0.01 | Subscribes to changes to all accounts owned by a program. |
| `programUnsubscribe` | WebSocket | 0.01 | Cancels a program subscription. |
| `signatureSubscribe` | WebSocket | 0.01 | Subscribes to receive a notification when a transaction is confirmed. |
| `signatureUnsubscribe` | WebSocket | 0.01 | Cancels a signature subscription. |
| `slotSubscribe` | WebSocket | 0.01 | Subscribes to receive notification when a slot is processed. |
| `slotUnsubscribe` | WebSocket | 0.01 | Cancels a slot subscription. |
| `blockSubscribe` | WebSocket | 0.01 | Subscribes to receive notification when a new block is confirmed. |
| `blockUnsubscribe` | WebSocket | 0.01 | Cancels a block subscription. |

## Network inflation info

| Method | Transport | Credits | Summary |
|--------|-----------|--------:|---------|
| `getInflationGovernor` | HTTP | 0.01 | Returns the current inflation governor parameters. |
| `getInflationRate` | HTTP | 0.01 | Returns the inflation rates for the current epoch. |
| `getInflationReward` | HTTP | 0.05 | Returns the inflation/staking reward for a list of addresses. |
| `getSupply` | HTTP | 0.05 | Returns information about the current supply of SOL. |

## Per-method details

### `getBlock`

**Summary:** Returns identity and transaction information for a confirmed block.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `slot` | `u64` | yes | Slot number to fetch, as a `u64` integer. |
| `config` | `object` | no | `{commitment?, encoding?, transactionDetails?, maxSupportedTransactionVersion?, rewards?}`. `encoding` is one of `json`, `jsonParsed`, `base58`, `base64`. |

**Returns:** `object | null`. Block object with `blockhash`, `previousBlockhash`, `parentSlot`, `transactions`, `rewards`, `blockTime`, `blockHeight`; `null` if the block is not confirmed.

---

### `getBlocks`

**Summary:** Returns a list of confirmed blocks between two slots.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `startSlot` | `u64` | yes | First slot to include (inclusive). |
| `endSlot` | `u64` | no | Last slot to include (inclusive). Must be no more than 500,000 slots after `startSlot`. |
| `config` | `object` | no | `{commitment?}`. `processed` is not supported. |

**Returns:** `array<u64>`. Array of confirmed block slots in ascending order.

---

### `getBlocksWithLimit`

**Summary:** Returns a list of confirmed blocks starting at a slot, up to a limit.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `startSlot` | `u64` | yes | First slot to include (inclusive). |
| `limit` | `u64` | yes | Maximum number of blocks to return (must be no greater than 500,000). |
| `config` | `object` | no | `{commitment?}`. `processed` is not supported. |

**Returns:** `array<u64>`. Array of confirmed block slots in ascending order.

---

### `getBlockHeight`

**Summary:** Returns the current block height of the node.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `config` | `object` | no | `{commitment?, minContextSlot?}`. |

**Returns:** `u64`. Current block height.

---

### `getBlockTime`

**Summary:** Returns the estimated production time of a block.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `slot` | `u64` | yes | Slot to look up. |

**Returns:** `i64 | null`. Unix timestamp in seconds, or `null` if unavailable.

---

### `getBlockProduction`

**Summary:** Returns recent block production information for the current or a previous epoch.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `config` | `object` | no | `{commitment?, identity?, range?: {firstSlot, lastSlot?}}`. `identity` filters to a single validator (base-58 pubkey). |

**Returns:** `object`. `{context, value: {byIdentity, range}}` where `byIdentity` maps validator pubkey to `[leaderSlots, blocksProduced]`.

---

### `getBlockCommitment`

**Summary:** Returns the commitment (stake-weighted votes) for a block.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `slot` | `u64` | yes | Slot to query. |

**Returns:** `object`. `{commitment: array<u64> | null, totalStake: u64}`.

---

### `getLatestBlockhash`

**Summary:** Returns the latest blockhash and its last valid block height.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `config` | `object` | no | `{commitment?, minContextSlot?}`. |

**Returns:** `object`. `{context, value: {blockhash, lastValidBlockHeight}}`.

---

### `isBlockhashValid`

**Summary:** Returns whether a blockhash is still valid.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `blockhash` | `string` | yes | Base-58 encoded blockhash to check. |
| `config` | `object` | no | `{commitment?, minContextSlot?}`. |

**Returns:** `object`. `{context, value: boolean}`: `true` if the blockhash is still valid.

---

### `getRecentBlockhash`

**Deprecated.** Use `getLatestBlockhash` instead.

**Summary:** Returns a recent blockhash and fee schedule (deprecated).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `config` | `object` | no | `{commitment?}`. |

**Returns:** `object`. `{context, value: {blockhash, feeCalculator: {lamportsPerSignature}}}`.

---

### `getConfirmedBlock`

**Deprecated.** Use `getBlock` instead.

**Summary:** Returns the contents of a confirmed block (deprecated).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `slot` | `u64` | yes | Slot number to fetch. |
| `config` | `object` | no | `{encoding?, transactionDetails?, rewards?, commitment?}`. |

**Returns:** `object | null`. Block object, or `null` if not confirmed.

---

### `getConfirmedBlocks`

**Deprecated.** Use `getBlocks` instead.

**Summary:** Returns a list of confirmed blocks between two slots (deprecated).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `startSlot` | `u64` | yes | First slot to include. |
| `endSlot` | `u64` | no | Last slot to include. |

**Returns:** `array<u64>`. Array of confirmed block slots.

---

### `getTransaction`

**Summary:** Returns details for a confirmed transaction by signature.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `signature` | `string` | yes | Base-58 encoded transaction signature. |
| `config` | `object` | no | `{commitment?, encoding?, maxSupportedTransactionVersion?}`. `encoding` is one of `json`, `jsonParsed`, `base58`, `base64`. |

**Returns:** `object | null`. Transaction object with `slot`, `blockTime`, `transaction`, `meta`; `null` if not found.

---

### `sendTransaction`

**Summary:** Submits a signed transaction to the cluster.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `transaction` | `string` | yes | Fully-signed transaction, encoded as a `base64` (recommended) or `base58` string. |
| `config` | `object` | no | `{encoding?, skipPreflight?, preflightCommitment?, maxRetries?, minContextSlot?}`. Set `encoding: "base64"` to match the transaction encoding. |

**Returns:** `string`. Base-58 encoded transaction signature (the first signature in the transaction).

---

### `simulateTransaction`

**Summary:** Simulates sending a transaction without submitting it.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `transaction` | `string` | yes | Transaction to simulate, `base64` or `base58` encoded. May be unsigned when `sigVerify` is false. |
| `config` | `object` | no | `{encoding?, sigVerify?, replaceRecentBlockhash?, commitment?, accounts?, minContextSlot?}`. `accounts` requests post-simulation account state. |

**Returns:** `object`. `{context, value: {err, logs, accounts, unitsConsumed, returnData}}`.

---

### `getSignaturesForAddress`

**Summary:** Returns confirmed transaction signatures involving an address.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `address` | `string` | yes | Base-58 encoded account address. |
| `config` | `object` | no | `{limit?, before?, until?, commitment?, minContextSlot?}`. `limit` defaults to 1000 (max 1000). |

**Returns:** `array<object>`. Array of `{signature, slot, err, memo, blockTime, confirmationStatus}` newest first.

---

### `getSignatureStatuses`

**Summary:** Returns the status of a list of transaction signatures.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `signatures` | `array<string>` | yes | Array of base-58 encoded transaction signatures (max 256). |
| `config` | `object` | no | `{searchTransactionHistory?}`. |

**Returns:** `object`. `{context, value: array<{slot, confirmations, err, confirmationStatus} | null>}`.

---

### `getTransactionCount`

**Summary:** Returns the total number of transactions processed by the cluster.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `config` | `object` | no | `{commitment?, minContextSlot?}`. |

**Returns:** `u64`. Cumulative transaction count.

---

### `getConfirmedTransaction`

**Deprecated.** Use `getTransaction` instead.

**Summary:** Returns details for a confirmed transaction (deprecated).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `signature` | `string` | yes | Base-58 encoded transaction signature. |
| `encoding` | `string` | no | `json`, `jsonParsed`, `base58`, or `base64`. |

**Returns:** `object | null`. Transaction object, or `null` if not found.

---

### `getConfirmedSignaturesForAddress2`

**Deprecated.** Use `getSignaturesForAddress` instead.

**Summary:** Returns confirmed signatures for an address (deprecated).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `address` | `string` | yes | Base-58 encoded account address. |
| `config` | `object` | no | `{limit?, before?, until?, commitment?}`. |

**Returns:** `array<object>`. Array of `{signature, slot, err, memo, blockTime}`.

---

### `getHealth`

**Summary:** Returns the health status of the node.

**Parameters:** none

**Returns:** `string`. `"ok"` when healthy.

---

### `getVersion`

**Summary:** Returns the Solana software version running on the node.

**Parameters:** none

**Returns:** `object`. `{"solana-core": string, "feature-set": u32}`.

---

### `getIdentity`

**Summary:** Returns the identity pubkey of the node.

**Parameters:** none

**Returns:** `object`. `{identity: string}`: base-58 encoded validator identity pubkey.

---

### `getClusterNodes`

**Summary:** Returns information about all nodes participating in the cluster.

**Parameters:** none

**Returns:** `array<object>`. Array of `{pubkey, gossip, tpu, rpc, version, featureSet, shredVersion}`.

---

### `getAccountInfo`

**Summary:** Returns all information associated with an account.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `address` | `string` | yes | Base-58 encoded account address (pubkey). |
| `config` | `object` | no | `{commitment?, encoding?, dataSlice?: {offset, length}, minContextSlot?}`. `encoding` is one of `base58`, `base64`, `base64+zstd`, `jsonParsed`. |

**Returns:** `object | null`. `{context, value: {lamports, owner, data, executable, rentEpoch, space} | null}`. `value` is `null` if the account does not exist.

---

### `getBalance`

**Summary:** Returns the lamport balance of an account.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `address` | `string` | yes | Base-58 encoded account address. |
| `config` | `object` | no | `{commitment?, minContextSlot?}`. |

**Returns:** `object`. `{context, value: u64}`: balance in lamports.

---

### `getMultipleAccounts`

**Summary:** Returns account information for a list of addresses.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `addresses` | `array<string>` | yes | Array of base-58 encoded account addresses (max 100). |
| `config` | `object` | no | `{commitment?, encoding?, dataSlice?, minContextSlot?}`. |

**Returns:** `object`. `{context, value: array<accountInfo | null>}`.

---

### `getProgramAccounts`

**Summary:** Returns all accounts owned by a program.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `programId` | `string` | yes | Base-58 encoded program pubkey. |
| `config` | `object` | no | `{commitment?, encoding?, dataSlice?, filters?: array, withContext?, minContextSlot?}`. `filters` accepts `{dataSize}` and `{memcmp: {offset, bytes}}`. |

**Returns:** `array<object> | object`. Array of `{pubkey, account}` objects (or a `{context, value}` envelope when `withContext` is set).

---

### `getLargestAccounts`

**Summary:** Returns the 20 largest accounts by lamport balance.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `config` | `object` | no | `{commitment?, filter?: "circulating" \| "nonCirculating"}`. |

**Returns:** `object`. `{context, value: array<{address, lamports}>}`.

---

### `getVoteAccounts`

**Summary:** Returns the current and delinquent vote accounts.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `config` | `object` | no | `{commitment?, votePubkey?, keepUnstakedDelinquents?, delinquentSlotDistance?}`. `votePubkey` filters to a single validator. |

**Returns:** `object`. `{current: array<voteAccount>, delinquent: array<voteAccount>}` with `votePubkey`, `nodePubkey`, `activatedStake`, `commission`, `epochCredits`, `lastVote`.

---

### `getStakeActivation`

**Deprecated.** Use `getAccountInfo` instead.

**Summary:** Returns epoch activation information for a stake account (deprecated).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `address` | `string` | yes | Base-58 encoded stake account address. |
| `config` | `object` | no | `{commitment?, epoch?, minContextSlot?}`. |

**Returns:** `object`. `{state, active, inactive}`.

---

### `getEpochInfo`

**Summary:** Returns information about the current epoch.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `config` | `object` | no | `{commitment?, minContextSlot?}`. |

**Returns:** `object`. `{epoch, absoluteSlot, slotIndex, slotsInEpoch, blockHeight, transactionCount}`.

---

### `getEpochSchedule`

**Summary:** Returns the epoch schedule from the cluster genesis config.

**Parameters:** none

**Returns:** `object`. `{slotsPerEpoch, leaderScheduleSlotOffset, warmup, firstNormalEpoch, firstNormalSlot}`.

---

### `getFeeForMessage`

**Summary:** Returns the fee the cluster will charge for a message.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `message` | `string` | yes | Base-64 encoded serialized transaction message. |
| `config` | `object` | no | `{commitment?, minContextSlot?}`. |

**Returns:** `object`. `{context, value: u64 | null}`: fee in lamports, or `null` if the blockhash has expired.

---

### `getRecentPrioritizationFees`

**Summary:** Returns recent per-compute-unit prioritization fees.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `addresses` | `array<string>` | no | Up to 128 base-58 account addresses; fees are scoped to slots where these accounts were written. |

**Returns:** `array<object>`. Array of `{slot, prioritizationFee}` for recent slots.

---

### `getMinimumBalanceForRentExemption`

**Summary:** Returns the minimum lamport balance for rent exemption.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `dataLength` | `usize` | yes | Account data length in bytes. |
| `config` | `object` | no | `{commitment?}`. |

**Returns:** `u64`. Minimum rent-exempt balance in lamports.

---

### `getGenesisHash`

**Summary:** Returns the genesis hash of the cluster.

**Parameters:** none

**Returns:** `string`. Base-58 encoded genesis hash.

---

### `getFirstAvailableBlock`

**Summary:** Returns the slot of the lowest confirmed block still available.

**Parameters:** none

**Returns:** `u64`. Slot of the first available block.

---

### `getHighestSnapshotSlot`

**Summary:** Returns the highest slot for which the node has snapshots.

**Parameters:** none

**Returns:** `object`. `{full: u64, incremental: u64 | null}`.

---

### `getRecentPerformanceSamples`

**Summary:** Returns recent network performance samples.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `limit` | `usize` | no | Number of samples to return (max 720). |

**Returns:** `array<object>`. Array of `{slot, numTransactions, numSlots, samplePeriodSecs, numNonVoteTransactions}`.

---

### `getFees`

**Deprecated.** Use `getFeeForMessage` instead.

**Summary:** Returns a recent blockhash and fee schedule (deprecated).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `config` | `object` | no | `{commitment?}`. |

**Returns:** `object`. `{context, value: {blockhash, feeCalculator, lastValidSlot, lastValidBlockHeight}}`.

---

### `getFeeCalculatorForBlockhash`

**Deprecated.** Use `getFeeForMessage` instead.

**Summary:** Returns the fee calculator for a blockhash (deprecated).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `blockhash` | `string` | yes | Base-58 encoded blockhash. |
| `config` | `object` | no | `{commitment?}`. |

**Returns:** `object`. `{context, value: {feeCalculator: {lamportsPerSignature}} | null}`.

---

### `getSlot`

**Summary:** Returns the slot that has reached the given commitment level.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `config` | `object` | no | `{commitment?, minContextSlot?}`. |

**Returns:** `u64`. Current slot.

---

### `getSlotLeader`

**Summary:** Returns the current slot leader.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `config` | `object` | no | `{commitment?, minContextSlot?}`. |

**Returns:** `string`. Base-58 encoded slot leader identity pubkey.

---

### `getSlotLeaders`

**Summary:** Returns the slot leaders for a slot range.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `startSlot` | `u64` | yes | First slot of the range. |
| `limit` | `u64` | yes | Number of leaders to return (1–5000). |

**Returns:** `array<string>`. Array of base-58 leader identity pubkeys, one per slot.

---

### `getLeaderSchedule`

**Summary:** Returns the leader schedule for an epoch.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `slot` | `u64` | no | Slot whose epoch's schedule to fetch; defaults to the current epoch. |
| `config` | `object` | no | `{commitment?, identity?}`. `identity` filters to a single validator. |

**Returns:** `object | null`. Map of leader pubkey → array of slot indices, or `null` if the epoch has no schedule.

---

### `getMaxRetransmitSlot`

**Summary:** Returns the highest slot seen by the retransmit stage.

**Parameters:** none

**Returns:** `u64`. Highest retransmit slot.

---

### `getMaxShredInsertSlot`

**Summary:** Returns the highest slot for which shreds have been inserted.

**Parameters:** none

**Returns:** `u64`. Highest shred-insert slot.

---

### `minimumLedgerSlot`

**Summary:** Returns the lowest slot the node has information about in its ledger.

**Parameters:** none

**Returns:** `u64`. Lowest retained ledger slot.

---

### `getTokenAccountsByOwner`

**Summary:** Returns all SPL token accounts owned by an address.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `owner` | `string` | yes | Base-58 encoded owner wallet address. |
| `filter` | `object` | yes | Either `{mint}` (base-58 token mint) or `{programId}` (base-58 token program). Exactly one is required. |
| `config` | `object` | no | `{commitment?, encoding?, dataSlice?, minContextSlot?}`. |

**Returns:** `object`. `{context, value: array<{pubkey, account}>}`: token accounts with parsed `tokenAmount` when `jsonParsed`.

---

### `getTokenAccountBalance`

**Summary:** Returns the token balance of an SPL token account.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `account` | `string` | yes | Base-58 encoded SPL token account address. |
| `config` | `object` | no | `{commitment?}`. |

**Returns:** `object`. `{context, value: {amount, decimals, uiAmount, uiAmountString}}`.

---

### `getTokenSupply`

**Summary:** Returns the total supply of an SPL token.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `mint` | `string` | yes | Base-58 encoded SPL token mint address. |
| `config` | `object` | no | `{commitment?}`. |

**Returns:** `object`. `{context, value: {amount, decimals, uiAmount, uiAmountString}}`.

---

### `getTokenLargestAccounts`

**Summary:** Returns the 20 largest accounts for an SPL token mint.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `mint` | `string` | yes | Base-58 encoded SPL token mint address. |
| `config` | `object` | no | `{commitment?}`. |

**Returns:** `object`. `{context, value: array<{address, amount, decimals, uiAmount, uiAmountString}>}`.

---

### `getTokenAccountsByDelegate`

**Summary:** Returns all SPL token accounts delegated to an address.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `delegate` | `string` | yes | Base-58 encoded delegate address. |
| `filter` | `object` | yes | Either `{mint}` or `{programId}`. Exactly one is required. |
| `config` | `object` | no | `{commitment?, encoding?, dataSlice?, minContextSlot?}`. |

**Returns:** `object`. `{context, value: array<{pubkey, account}>}`.

---

### `requestAirdrop`

**Summary:** Requests an airdrop of lamports to an account (devnet/testnet).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `address` | `string` | yes | Base-58 encoded recipient address. |
| `lamports` | `u64` | yes | Number of lamports to airdrop. |
| `config` | `object` | no | `{commitment?}`. |

**Returns:** `string`. Base-58 encoded airdrop transaction signature.

---

### `getInflationGovernor`

**Summary:** Returns the current inflation governor parameters.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `config` | `object` | no | `{commitment?}`. |

**Returns:** `object`. `{initial, terminal, taper, foundation, foundationTerm}`.

---

### `getInflationRate`

**Summary:** Returns the inflation rates for the current epoch.

**Parameters:** none

**Returns:** `object`. `{total, validator, foundation, epoch}`.

---

### `getInflationReward`

**Summary:** Returns the inflation/staking reward for a list of addresses.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `addresses` | `array<string>` | yes | Array of base-58 account addresses to query. |
| `config` | `object` | no | `{commitment?, epoch?, minContextSlot?}`. |

**Returns:** `array<object>`. Array of `{epoch, effectiveSlot, amount, postBalance, commission} | null`, one per address.

---

### `getSupply`

**Summary:** Returns information about the current supply of SOL.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `config` | `object` | no | `{commitment?, excludeNonCirculatingAccountsList?}`. |

**Returns:** `object`. `{context, value: {total, circulating, nonCirculating, nonCirculatingAccounts}}`: values in lamports.

---

### `accountSubscribe`

**Summary:** Subscribes to changes to an account.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `address` | `string` | yes | Base-58 encoded account address to watch. |
| `config` | `object` | no | `{commitment?, encoding?}`. |

**Returns:** `number`. Subscription id (used with `accountUnsubscribe`). Notifications arrive as `accountNotification` messages.

---

### `accountUnsubscribe`

**Summary:** Cancels an account subscription.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `subscriptionId` | `number` | yes | Subscription id returned by `accountSubscribe`. |

**Returns:** `boolean`. `true` if the subscription was successfully cancelled.

---

### `logsSubscribe`

**Summary:** Subscribes to transaction logging.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `filter` | `string \| object` | yes | `"all"`, `"allWithVotes"`, or `{mentions: [<base-58 address>]}`. |
| `config` | `object` | no | `{commitment?}`. |

**Returns:** `number`. Subscription id (used with `logsUnsubscribe`). Notifications arrive as `logsNotification` messages.

---

### `logsUnsubscribe`

**Summary:** Cancels a logs subscription.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `subscriptionId` | `number` | yes | Subscription id returned by `logsSubscribe`. |

**Returns:** `boolean`. `true` if the subscription was successfully cancelled.

---

### `programSubscribe`

**Summary:** Subscribes to changes to all accounts owned by a program.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `programId` | `string` | yes | Base-58 encoded program pubkey to watch. |
| `config` | `object` | no | `{commitment?, encoding?, filters?}`. |

**Returns:** `number`. Subscription id (used with `programUnsubscribe`). Notifications arrive as `programNotification` messages.

---

### `programUnsubscribe`

**Summary:** Cancels a program subscription.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `subscriptionId` | `number` | yes | Subscription id returned by `programSubscribe`. |

**Returns:** `boolean`. `true` if the subscription was successfully cancelled.

---

### `signatureSubscribe`

**Summary:** Subscribes to receive a notification when a transaction is confirmed.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `signature` | `string` | yes | Base-58 encoded transaction signature to watch. |
| `config` | `object` | no | `{commitment?, enableReceivedNotification?}`. |

**Returns:** `number`. Subscription id (used with `signatureUnsubscribe`). Notifications arrive as `signatureNotification` messages.

---

### `signatureUnsubscribe`

**Summary:** Cancels a signature subscription.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `subscriptionId` | `number` | yes | Subscription id returned by `signatureSubscribe`. |

**Returns:** `boolean`. `true` if the subscription was successfully cancelled.

---

### `slotSubscribe`

**Summary:** Subscribes to receive notification when a slot is processed.

**Parameters:** none

**Returns:** `number`. Subscription id (used with `slotUnsubscribe`). Notifications arrive as `slotNotification` messages with `{parent, root, slot}`.

---

### `slotUnsubscribe`

**Summary:** Cancels a slot subscription.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `subscriptionId` | `number` | yes | Subscription id returned by `slotSubscribe`. |

**Returns:** `boolean`. `true` if the subscription was successfully cancelled.

---

### `blockSubscribe`

**Summary:** Subscribes to receive notification when a new block is confirmed.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `filter` | `string \| object` | yes | `"all"` or `{mentionsAccountOrProgram: <base-58 address>}`. |
| `config` | `object` | no | `{commitment?, encoding?, transactionDetails?, showRewards?, maxSupportedTransactionVersion?}`. |

**Returns:** `number`. Subscription id (used with `blockUnsubscribe`). Notifications arrive as `blockNotification` messages.

---

### `blockUnsubscribe`

**Summary:** Cancels a block subscription.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `subscriptionId` | `number` | yes | Subscription id returned by `blockSubscribe`. |

**Returns:** `boolean`. `true` if the subscription was successfully cancelled.

---
