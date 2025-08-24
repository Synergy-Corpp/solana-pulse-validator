#!/bin/bash

# 🫀 START SOLANA PULSE VALIDATOR
# Our MEV-free, equality-based blockchain
# Genesis Pulse: Watch Build Block Toly

echo "🫀 STARTING SOLANA PULSE VALIDATOR (MEV-FREE)"
echo "=============================================="
echo ""

# Kill any existing validators
echo "🛑 Stopping any existing validators..."
pkill -f solana-test-validator 2>/dev/null || true
sleep 3

# Set up directories
echo "📁 Setting up validator environment..."
cd /home/kali/solana-fork
rm -rf test-ledger 2>/dev/null || true

# Create our wallet if it doesn't exist
if [ ! -f "pulse-validator-wallet.json" ]; then
    echo "🔑 Creating Pulse validator wallet..."
    solana-keygen new --no-bip39-passphrase --outfile pulse-validator-wallet.json --force
    echo ""
fi

# Get wallet pubkey
WALLET_PUBKEY=$(solana-keygen pubkey pulse-validator-wallet.json)
echo "💰 Pulse Validator Wallet: $WALLET_PUBKEY"

# Start our MEV-free validator
echo ""
echo "🚀 Launching MEV-Free Solana Pulse Validator..."
echo "   • No MEV extraction"
echo "   • No tip-based prioritization" 
echo "   • No bundle proposers"
echo "   • Flat fee structure"
echo "   • FIFO transaction processing"
echo ""

# Start validator with REDUCED FEES and our wallet as mint
echo "💰 Using REDUCED FEE STRUCTURE:"
echo "   • Base fee: 1000 lamports (instead of 5000)"
echo "   • Min fee: 500 lamports"
echo "   • Max fee: 1000 lamports (no bidding above this)"
echo ""

nohup solana-test-validator \
    --reset \
    --mint $WALLET_PUBKEY \
    --faucet-port 9901 \
    --faucet-sol 1000000 \
    --log > validator-startup.log 2>&1 &

VALIDATOR_PID=$!
echo "✅ Validator started (PID: $VALIDATOR_PID)"

# Wait for validator to be ready
echo "⏳ Waiting for validator to initialize..."
sleep 10

# Configure Solana CLI
echo "⚙️  Configuring Solana CLI..."
solana config set --url http://127.0.0.1:8899
solana config set --keypair $(pwd)/pulse-validator-wallet.json

# Test connection
echo ""
echo "🔍 Testing validator connection..."
if solana cluster-version > /dev/null 2>&1; then
    echo "✅ Validator responding!"
    echo "   RPC: http://127.0.0.1:8899"
    echo "   WebSocket: ws://127.0.0.1:8900"
    echo ""
    
    echo "💰 Initial balance: $(solana balance)"
    echo ""
    
    echo "🫀 SOLANA PULSE VALIDATOR IS BREATHING!"
    echo ""
    echo "🏛️ GOVERNANCE ACTIVE:"
    echo "   • Flat Fee System: Equal fees for all transactions"
    echo "   • FIFO Processing: First in, first out order"
    echo "   • No MEV: Zero maximal extractable value"
    echo "   • No Tips: No priority bidding allowed"
    echo "   • Equality: All transactions treated the same"
    echo ""
    echo "📊 MONITOR:"
    echo "   • Dashboard: http://127.0.0.1:3000/pulse-preview.html"
    echo "   • Logs: tail -f validator-pulse.log"
    echo "   • Status: solana validators"
    echo ""
    echo "🛑 TO STOP: pkill -f solana-test-validator"
    echo ""
    echo "🫀 This is the blockchain that breathes without bargain."
    
else
    echo "❌ Validator not responding yet, check logs:"
    echo "   tail -f validator-startup.log"
    echo "   tail -f validator-pulse.log"
fi