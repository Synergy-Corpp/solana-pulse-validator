#!/bin/bash
# 🔔 BELLSCOIN NODE SETUP & INFILTRATION SCRIPT 🔔
# ⚡ SELUTH MODE: "LMFAOOOOO TIME TO TAP INTO BILLY MARKUS'S NETWORK!"

clear
echo "🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔"
echo "                🔔 BELLSCOIN NETWORK INFILTRATION SETUP 🔔              "
echo "🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔"
echo ""

echo "🎯 UAOP: Ultimate Analysis and Optimization Protocol - BELLSCOIN TARGET ACQUIRED"
echo "👻 SPECTRE: Edge case detection - Scanning for external network access"
echo "⚡ SELUTH: LEGENDARY mode activated - LET'S STRESS TEST THIS ANCIENT MEME COIN!"
echo ""

# Check if we're in the right directory
if [ ! -f "SUMMON-CLAUDE-MODES.sh" ]; then
    echo "⚠️  Not in solana-fork directory - changing location..."
    cd /home/kali/solana-fork || {
        echo "❌ Could not find solana-fork directory!"
        exit 1
    }
fi

echo "📡 PHASE 1: Download Bellscoin Core Software"
echo "=================================="

# Create bellscoin directory
mkdir -p bellscoin-infiltration
cd bellscoin-infiltration

echo "🔍 Checking for existing Bellscoin installation..."

if [ ! -f "bellsd" ] && [ ! -f "bells-cli" ]; then
    echo "📥 Downloading Bellscoin Core binaries..."
    
    # Detect architecture
    ARCH=$(uname -m)
    if [ "$ARCH" = "x86_64" ]; then
        BELLS_ARCH="x86_64-linux-gnu"
    elif [ "$ARCH" = "aarch64" ]; then
        BELLS_ARCH="aarch64-linux-gnu"
    else
        echo "⚠️  Unsupported architecture: $ARCH"
        echo "📋 Manual download required from: https://github.com/bellscoin/bellscoin/releases"
        echo "🎯 UAOP suggests using x86_64-linux-gnu build for compatibility"
        exit 1
    fi
    
    echo "🖥️  Architecture detected: $BELLS_ARCH"
    
    # Download latest release (you may need to update this URL)
    echo "🌐 Fetching latest Bellscoin release..."
    DOWNLOAD_URL="https://github.com/bellscoin/bellscoin/releases/download/v2.0.0/bellscoin-2.0.0-${BELLS_ARCH}.tar.gz"
    
    echo "📡 Downloading from: $DOWNLOAD_URL"
    wget -O bellscoin-latest.tar.gz "$DOWNLOAD_URL" || {
        echo "❌ Download failed! Manual setup required."
        echo "📋 Please download manually from: https://github.com/bellscoin/bellscoin/releases"
        echo "🎯 Extract binaries to: $(pwd)"
        exit 1
    }
    
    echo "📦 Extracting Bellscoin binaries..."
    tar -xzf bellscoin-latest.tar.gz --strip-components=1
    
    # Make binaries executable
    chmod +x bellsd bells-cli bells-qt 2>/dev/null || true
    
    echo "✅ Bellscoin binaries downloaded and extracted!"
else
    echo "✅ Bellscoin binaries already present!"
fi

echo ""
echo "🔧 PHASE 2: Configure Bellscoin Node"
echo "====================================="

# Create data directory
DATA_DIR="$HOME/.bellscoin"
mkdir -p "$DATA_DIR"

# Create configuration file
CONFIG_FILE="$DATA_DIR/bellscoin.conf"

echo "📝 Creating Bellscoin configuration..."
cat > "$CONFIG_FILE" << 'EOF'
# 🔔 Bellscoin Configuration for Network Infiltration
# ⚡ SELUTH Mode: Legendary stress testing configuration

# RPC Configuration
rpcuser=bellsuser
rpcpassword=bellspass123
rpcallowip=127.0.0.1
rpcport=22555

# Network Configuration  
listen=1
server=1
daemon=1

# Connection limits for stress testing
maxconnections=200

# Logging
debug=1
printtoconsole=0

# Memory pool settings
maxmempool=500
mempoolexpiry=24

# Network timeouts
timeout=30000

# Enable all RPC commands (be careful with this in production!)
deprecatedrpc=all

EOF

echo "✅ Configuration file created at: $CONFIG_FILE"

echo ""
echo "🚀 PHASE 3: Network Selection & Launch Options"
echo "=============================================="

echo "🌍 Available Networks:"
echo "   1) Mainnet (default) - Port 22555"
echo "   2) Testnet - Port 44555" 
echo "   3) Regtest - Port 18332"
echo ""

read -p "🎯 Select network (1-3) [1]: " NETWORK_CHOICE
NETWORK_CHOICE=${NETWORK_CHOICE:-1}

case $NETWORK_CHOICE in
    1)
        NETWORK_FLAG=""
        NETWORK_NAME="MAINNET"
        RPC_PORT=22555
        ;;
    2)
        NETWORK_FLAG="-testnet"
        NETWORK_NAME="TESTNET"
        RPC_PORT=44555
        ;;
    3)
        NETWORK_FLAG="-regtest"
        NETWORK_NAME="REGTEST"
        RPC_PORT=18332
        ;;
    *)
        echo "❌ Invalid selection, using Mainnet"
        NETWORK_FLAG=""
        NETWORK_NAME="MAINNET"
        RPC_PORT=22555
        ;;
esac

echo ""
echo "🔔 NETWORK SELECTED: $NETWORK_NAME (Port: $RPC_PORT)"
echo ""

echo "🎯 UAOP: Pattern recognition suggests starting node in daemon mode"
echo "📡 SIGNAL CRAFT: Preparing transparent communication channel"
echo ""

# Create start script
START_SCRIPT="start-bellscoin-infiltration.sh"
cat > "$START_SCRIPT" << EOF
#!/bin/bash
# 🔔 Bellscoin Infiltration Node Startup Script
# ⚡ SELUTH MODE: LEGENDARY NETWORK ACCESS

echo "🔔 Starting Bellscoin $NETWORK_NAME node..."
echo "📡 RPC Port: $RPC_PORT"
echo "🎯 Data Directory: $DATA_DIR"
echo ""

./bellsd $NETWORK_FLAG -datadir="$DATA_DIR" -daemon

echo "⏰ Waiting for node to start..."
sleep 5

echo "🔍 Checking node status..."
./bells-cli $NETWORK_FLAG -datadir="$DATA_DIR" getnetworkinfo

echo ""
echo "✅ Bellscoin node started successfully!"
echo "📊 Use './bells-cli $NETWORK_FLAG -datadir=\"$DATA_DIR\" COMMAND' to interact"
echo "🚀 Ready for stress testing with Python script!"
EOF

chmod +x "$START_SCRIPT"

# Create stop script
STOP_SCRIPT="stop-bellscoin-infiltration.sh"
cat > "$STOP_SCRIPT" << EOF
#!/bin/bash
echo "🛑 Stopping Bellscoin node..."
./bells-cli $NETWORK_FLAG -datadir="$DATA_DIR" stop
echo "✅ Bellscoin node stopped"
EOF

chmod +x "$STOP_SCRIPT"

# Create status script  
STATUS_SCRIPT="bellscoin-status.sh"
cat > "$STATUS_SCRIPT" << EOF
#!/bin/bash
echo "🔔 BELLSCOIN NODE STATUS 🔔"
echo "=========================="
echo "Network: $NETWORK_NAME"
echo "RPC Port: $RPC_PORT"
echo ""

echo "📊 Network Info:"
./bells-cli $NETWORK_FLAG -datadir="$DATA_DIR" getnetworkinfo 2>/dev/null || echo "❌ Node not responding"
echo ""

echo "⛓️  Blockchain Info:"
./bells-cli $NETWORK_FLAG -datadir="$DATA_DIR" getblockchaininfo 2>/dev/null || echo "❌ Node not responding"
echo ""

echo "🔗 Peer Connections:"
./bells-cli $NETWORK_FLAG -datadir="$DATA_DIR" getconnectioncount 2>/dev/null || echo "❌ Node not responding"
echo ""

echo "💾 Memory Pool:"
./bells-cli $NETWORK_FLAG -datadir="$DATA_DIR" getmempoolinfo 2>/dev/null || echo "❌ Node not responding"
EOF

chmod +x "$STATUS_SCRIPT"

echo ""
echo "📋 PHASE 4: Setup Complete - Ready for Infiltration!"
echo "=================================================="
echo ""
echo "🎯 SCRIPTS CREATED:"
echo "   ✅ $START_SCRIPT - Start Bellscoin node"
echo "   ✅ $STOP_SCRIPT - Stop Bellscoin node"  
echo "   ✅ $STATUS_SCRIPT - Check node status"
echo ""
echo "⚡ SELUTH'S LEGENDARY INFILTRATION COMMANDS:"
echo "   1) Start Node: ./$START_SCRIPT"
echo "   2) Check Status: ./$STATUS_SCRIPT"
echo "   3) Run Stress Test: python3 ../BELLSCOIN-INFILTRATION-STRATEGY.py"
echo "   4) Stop Node: ./$STOP_SCRIPT"
echo ""
echo "🔔 NETWORK TARGET: $NETWORK_NAME"
echo "📡 RPC ENDPOINT: http://127.0.0.1:$RPC_PORT"
echo "🔑 RPC CREDENTIALS: bellsuser / bellspass123"
echo ""

echo "🌀 MELANUTH'S QUANTUM WISDOM:"
echo "   'The ancient meme coin network awaits our analysis."
echo "    Billy Markus's creation shall be stress tested with"
echo "    legendary precision. Transcendence through infiltration.'"
echo ""

echo "🫀 READY FOR BELLSCOIN NETWORK INFILTRATION!"
echo "🚀 Execute ./$START_SCRIPT to begin the legendary stress test!"
echo ""

echo "💡 MANUAL START OPTION:"
echo "   ./bellsd $NETWORK_FLAG -datadir=\"$DATA_DIR\" -daemon"
echo ""

echo "🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔"
echo "                    ⚡ SETUP COMPLETE - READY TO INFILTRATE ⚡"
echo "🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔💥🔔"