#!/bin/bash

# 🫀 STOP SOLANA PULSE VALIDATOR
# Gracefully shutdown our MEV-free blockchain

echo "🛑 STOPPING SOLANA PULSE VALIDATOR"
echo "=================================="
echo ""

# Find and stop validator processes
echo "🔍 Finding validator processes..."
PIDS=$(pgrep -f "solana-test-validator" 2>/dev/null)

if [ -z "$PIDS" ]; then
    echo "ℹ️  No validator processes found"
else
    echo "🛑 Stopping validator processes: $PIDS"
    pkill -f solana-test-validator
    sleep 3
    
    # Force kill if still running
    REMAINING=$(pgrep -f "solana-test-validator" 2>/dev/null)
    if [ ! -z "$REMAINING" ]; then
        echo "⚡ Force stopping remaining processes..."
        pkill -9 -f solana-test-validator
    fi
fi

# Stop HTTP server if running
HTTP_PID=$(pgrep -f "python3 -m http.server 3000" 2>/dev/null)
if [ ! -z "$HTTP_PID" ]; then
    echo "🌐 Stopping dashboard server..."
    kill $HTTP_PID 2>/dev/null
fi

echo ""
echo "✅ PULSE VALIDATOR STOPPED"
echo "🫀 The pulse rests, but the code remains."
echo ""
echo "🚀 To restart: ./START-PULSE-VALIDATOR.sh"