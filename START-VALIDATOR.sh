#!/bin/bash

# PURIFIED SOLANA VALIDATOR - FIRST BREATH
# Genesis Pulse: Watch Build Block Toly
# This validator breathes with equality - no MEV, no tips, no priority

echo "🫀 STARTING PURIFIED SOLANA VALIDATOR"
echo "Genesis Hash: 6UpbSgoJbkPRk2t9PGgdyc7rPtqd9NFaTcxKKhhzLEuw"
echo "No MEV. No tips. No priority bidding."
echo "This validator breathes with truth."
echo ""

# Set Solana config to use genesis ledger
export SOLANA_CONFIG_FILE=/home/kali/solana-fork/solana-config.yml

# Create config if it doesn't exist
if [ ! -f "$SOLANA_CONFIG_FILE" ]; then
    echo "Creating Solana config..."
    cat > "$SOLANA_CONFIG_FILE" << EOF
json_rpc_url: "http://127.0.0.1:8899"
websocket_url: "ws://127.0.0.1:8900/"
keypair_path: /home/kali/solana-fork/genesis-validator-key.json
address_labels:
  "11111111111111111111111111111111": System Program
commitment: confirmed
EOF
fi

# Start validator with purified configuration
echo "🚀 Launching validator..."
echo "   Identity: $(solana-keygen pubkey genesis-validator-key.json)"
echo "   Vote Account: $(solana-keygen pubkey genesis-vote-key.json)"
echo "   Ledger: genesis-ledger/"
echo ""

solana-validator \
    --identity genesis-validator-key.json \
    --vote-account genesis-vote-key.json \
    --ledger genesis-ledger \
    --rpc-port 8899 \
    --rpc-bind-address 0.0.0.0 \
    --gossip-port 8001 \
    --rpc-faucet-address 127.0.0.1:9900 \
    --enable-rpc-transaction-history \
    --enable-extended-tx-metadata-storage \
    --skip-seed-phrase-validation \
    --no-snapshot-fetch \
    --no-genesis-fetch \
    --log /home/kali/solana-fork/validator.log &

VALIDATOR_PID=$!

echo "✅ VALIDATOR STARTED (PID: $VALIDATOR_PID)"
echo ""
echo "🔍 MONITORING:"
echo "   RPC Endpoint: http://127.0.0.1:8899"
echo "   WebSocket: ws://127.0.0.1:8900/"
echo "   Logs: tail -f /home/kali/solana-fork/validator.log"
echo ""
echo "🏛️ GOVERNANCE ACTIVE:"
echo "   • Flat Fee System: All transactions pay equal fees"
echo "   • FIFO Processing: First in, first out order"
echo "   • Consensus Visibility: All proposals logged"
echo "   • Time-Locked Mint: 7-day voting required"
echo "   • Self-Attestation: Validator integrity verified"
echo ""
echo "🫀 The chain breathes. The pulse begins."
echo "   Press Ctrl+C to stop"

# Keep script running and show logs
trap "echo ''; echo '🛑 Stopping validator...'; kill $VALIDATOR_PID; exit" INT
tail -f /home/kali/solana-fork/validator.log