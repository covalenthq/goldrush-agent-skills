---
name: goldrush-solana
description: "GoldRush API for Solana. Use this skill whenever the user wants SPL token balances for a Solana wallet (REST). REST is at `https://api.covalenthq.com/v1/solana-mainnet/...` (kebab-case chain name). SPL transfer history, Solana transactions, NFTs (Metaplex + Bubblegum cNFTs), and token pricing REST endpoints are NOT supported on Solana today. For non-Solana chain data, use goldrush-foundational-api. For Hyperliquid specifically, use goldrush-hyperliquid."
---

# GoldRush API for Solana

GoldRush's Solana coverage today:

- **SPL token balances** for any wallet - Foundational REST.

## Not supported on Solana today

- SPL token transfer history.
- Solana transactions (signature lookup, paginated history, summary).
- NFTs (Metaplex Token Metadata, Bubblegum compressed NFTs).
- Token pricing REST endpoints (historical or pool spot).
- Solana-native primitives (stake, validators, IDL, Token-2022 extensions, SPL delegations).
- PumpFun-specific lifecycle tables.

## Quick examples

### Token balances (REST)

```bash
curl https://api.covalenthq.com/v1/solana-mainnet/address/4ZJhPQAgUseCsWhKvJLTmmRRUV74fdoTpQLNfKoekbPY/balances_v2/ \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY"
```

## Critical rules

1. **Chain name (REST)** - `solana-mainnet` (kebab-case). Used in Foundational API paths: `/v1/solana-mainnet/...`.
2. **Wallet address format** - base58, 32-44 chars, **case-preserved** (unlike EVM 0x-hex which is lowercased).
3. **Token mint** - base58 mint pubkey. USDC = `EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v`. Wrapped SOL = `So11111111111111111111111111111111111111112`.
4. **Native unit** - lamports. 1 SOL = 10⁹ lamports.

## Decision matrix

| Need | Use |
|---|---|
| SPL token balances for a wallet | Foundational `get-token-balances-for-address` |
| SPL transfer history / Solana transactions / NFTs / pricing REST | Not supported on Solana today |

## Agent routing

- For Solana-specific REST questions → this skill.
- For the same products on a different chain → [goldrush-foundational-api](../goldrush-foundational-api/SKILL.md) or the broader docs.
- For Hyperliquid (HyperCore + HyperEVM) → [goldrush-hyperliquid](../goldrush-hyperliquid/SKILL.md).
- For x402 (pay-per-request) → [goldrush-x402](../goldrush-x402/SKILL.md).
- For the CLI / MCP wrappers → [goldrush-cli](../goldrush-cli/SKILL.md).

## Reference Files

| File | When to read |
|------|--------------|
| [overview.md](references/overview.md) | Product overview for Solana |
| [foundational.md](references/foundational.md) | REST reference for SPL balances on Solana |
