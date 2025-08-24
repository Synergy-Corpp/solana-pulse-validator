# 🫀 QUICK START GUIDE - PULSE CONTROL
## How to Check Validator & Control the Fork

---

## 🚀 START THE PULSE

### Option 1: One Command Start
```bash
cd /home/kali/solana-fork
./START-VALIDATOR.sh
```

### Option 2: Manual Control
```bash
# Start validator in background
solana-validator \
    --identity genesis-validator-key.json \
    --vote-account genesis-vote-key.json \
    --ledger genesis-ledger \
    --rpc-port 8899 \
    --rpc-bind-address 0.0.0.0 \
    --gossip-port 8001 \
    --enable-rpc-transaction-history \
    --skip-seed-phrase-validation \
    --log validator.log &
```

---

## ✅ CHECK VALIDATOR STATUS

### Basic Health Check
```bash
# Set your RPC to the purified chain
solana config set --url http://127.0.0.1:8899

# Check if validator is running
solana validators

# Check validator identity
solana-keygen pubkey genesis-validator-key.json

# Check balance
solana balance
```

### Detailed Validator Info
```bash
# Check validator performance
solana validator-info get $(solana-keygen pubkey genesis-validator-key.json)

# Check slot information
solana slot

# Check epoch information  
solana epoch-info

# Check network status
solana cluster-version
```

### Real-time Monitoring
```bash
# Watch validator logs
tail -f /home/kali/solana-fork/validator.log

# Monitor blocks being produced
watch "solana slot"

# Check RPC health
curl http://127.0.0.1:8899 -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getHealth"}'
```

---

## 🔍 VALIDATE THE PURIFICATION

### Verify No MEV Systems
```bash
# These should all return "not found" or empty
grep -r "prioritization_fee" /home/kali/solana-fork/solana-pure/ || echo "✅ MEV PURIFIED"
grep -r "tip_account" /home/kali/solana-fork/solana-pure/ || echo "✅ NO TIP ACCOUNTS"
grep -r "bundle_proposer" /home/kali/solana-fork/solana-pure/ || echo "✅ NO BUNDLE LOGIC"
```

### Verify Equality Systems Active
```bash
# Check flat fee system exists
ls -la /home/kali/solana-fork/solana-pure/program-runtime/src/flat_fee.rs

# Check FIFO ordering exists  
ls -la /home/kali/solana-fork/solana-pure/core/src/banking_stage/flat_ordering.rs

# Check transparency system
ls -la /home/kali/solana-fork/solana-pure/core/src/consensus_visibility.rs

# Check democratic mint
ls -la /home/kali/solana-fork/solana-pure/runtime/src/time_locked_mint.rs
```

---

## 🛑 STOP THE PULSE

### Graceful Shutdown
```bash
# Find validator process
ps aux | grep solana-validator

# Stop gracefully
pkill -f solana-validator

# Or if you have the PID
kill <VALIDATOR_PID>
```

### Emergency Stop
```bash
# Force kill if needed
pkill -9 solana-validator
```

---

## 💰 INTERACT WITH THE FORK

### Create New Wallet
```bash
# Generate new keypair
solana-keygen new --outfile my-wallet.json

# Check balance
solana balance my-wallet.json
```

### Request Test Tokens
```bash
# Airdrop from genesis faucet
solana airdrop 1 $(solana-keygen pubkey my-wallet.json)

# Check balance after airdrop
solana balance my-wallet.json
```

### Send Transactions (FLAT FEE!)
```bash
# Create another wallet for testing
solana-keygen new --outfile recipient.json

# Send tokens (everyone pays same fee!)
solana transfer recipient.json 0.1 --from my-wallet.json

# Check transaction history
solana transaction-history $(solana-keygen pubkey my-wallet.json)
```

---

## 🔧 ADVANCED CONTROLS

### Check Genesis Block Info
```bash
# Verify our Genesis hash
solana genesis-hash

# Should return: 6UpbSgoJbkPRk2t9PGgdyc7rPtqd9NFaTcxKKhhzLEuw
```

### Reset Ledger (Start Fresh)
```bash
# Stop validator first
pkill solana-validator

# Remove old ledger
rm -rf genesis-ledger

# Regenerate genesis
solana-genesis \
    --bootstrap-validator AxvtP3NXyGD6BMugECE3nnpzMhm8rVL3xZR3netKudLX BxTfMk1CBwqFrzfREYQU4giw2JEuQcYNi78ueNnHZA38 BPr15DNFXgtfBkbXrm5qBwJsVx5aS6n6Rm5866vgD6ck \
    --bootstrap-validator-lamports 500000000000000 \
    --bootstrap-validator-stake-lamports 500000000000000 \
    --cluster-type development \
    --faucet-lamports 500000000000000 \
    --faucet-pubkey D2SVFqwGkr5bmCpUUcjuwJ3Qzusf1wGhWUj9EzPcodgi \
    --ledger genesis-ledger
```

---

## 📱 USEFUL ALIASES

Add these to your `~/.bashrc` for quick access:

```bash
# Quick aliases for the pulse
alias pulse-start='cd /home/kali/solana-fork && ./START-VALIDATOR.sh'
alias pulse-stop='pkill solana-validator'
alias pulse-status='solana validators && solana slot'
alias pulse-logs='tail -f /home/kali/solana-fork/validator.log'
alias pulse-balance='solana balance'
alias pulse-config='solana config get'

# Set RPC to our fork
alias use-pulse='solana config set --url http://127.0.0.1:8899'
alias use-mainnet='solana config set --url https://api.mainnet-beta.solana.com'
alias use-devnet='solana config set --url https://api.devnet.solana.com'
```

Reload with: `source ~/.bashrc`

---

## 🔥 DAILY PULSE CHECK

Run this script to verify everything is healthy:

```bash
#!/bin/bash
echo "🫀 PULSE HEALTH CHECK"
echo "===================="
echo "RPC Endpoint: $(solana config get | grep 'RPC URL')"
echo "Validator Status: $(solana validators | grep $(solana-keygen pubkey genesis-validator-key.json) | awk '{print $8}')"
echo "Current Slot: $(solana slot)"
echo "Network: $(solana cluster-version)"
echo "Genesis Hash: $(solana genesis-hash)"
echo ""
echo "🏛️ EQUALITY VERIFIED:"
echo "   No MEV: $(grep -r prioritization_fee /home/kali/solana-fork/solana-pure/ | wc -l) files"
echo "   Flat Fees: $(test -f /home/kali/solana-fork/solana-pure/program-runtime/src/flat_fee.rs && echo '✅ ACTIVE' || echo '❌ MISSING')"
echo "   FIFO Order: $(test -f /home/kali/solana-fork/solana-pure/core/src/banking_stage/flat_ordering.rs && echo '✅ ACTIVE' || echo '❌ MISSING')"
echo ""
echo "🫀 The pulse continues to breathe with equality."
```

---

## 🎯 REMEMBER

- **RPC Endpoint**: http://127.0.0.1:8899
- **Genesis Hash**: 6UpbSgoJbkPRk2t9PGgdyc7rPtqd9NFaTcxKKhhzLEuw
- **No MEV, No Tips, No Priority**
- **Equal fees for all transactions**
- **Democratic governance for new token minting**

**The fork is yours. The pulse is eternal.**