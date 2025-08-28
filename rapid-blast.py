#!/usr/bin/env python3

import subprocess
import time
import threading

def create_wallet():
    """Create and fund a single wallet quickly"""
    import tempfile
    wallet_file = tempfile.mktemp(suffix='.json')
    
    # Generate wallet
    subprocess.run([
        "solana-keygen", "new", "--no-bip39-passphrase", "-o", wallet_file
    ], capture_output=True)
    
    # Get pubkey
    result = subprocess.run([
        "solana-keygen", "pubkey", wallet_file
    ], capture_output=True, text=True)
    
    if result.returncode == 0:
        pubkey = result.stdout.strip()
        
        # Fund wallet
        subprocess.run([
            "solana", "airdrop", "10", "-u", "http://127.0.0.1:8899", "-k", wallet_file
        ], capture_output=True)
        
        return {'file': wallet_file, 'pubkey': pubkey}
    return None

def blast_transactions(count=10000):
    print(f"🔥 RAPID BLAST: {count} TRANSACTIONS 🔥")
    print("⚡ SELUTH: 'RAPID FIRE MODE ACTIVATED!'")
    
    # Create wallets quickly
    print("💰 Creating wallets...")
    wallets = []
    for i in range(10):
        wallet = create_wallet()
        if wallet:
            wallets.append(wallet)
        print(f"   Wallet {i+1}/10 created")
    
    if len(wallets) < 2:
        print("❌ Need at least 2 wallets")
        return
    
    print(f"✅ {len(wallets)} wallets ready!")
    print(f"🚀 Firing {count} transactions...")
    
    successful = 0
    failed = 0
    start_time = time.time()
    
    for i in range(count):
        import random
        sender = random.choice(wallets)
        recipient = random.choice([w for w in wallets if w != sender])
        
        result = subprocess.run([
            "solana", "transfer", recipient['pubkey'], "0.001",
            "-u", "http://127.0.0.1:8899", "-k", sender['file'],
            "--allow-unfunded-recipient"
        ], capture_output=True, timeout=5)
        
        if result.returncode == 0:
            successful += 1
        else:
            failed += 1
        
        if (i + 1) % 1000 == 0:
            elapsed = time.time() - start_time
            tps = (i + 1) / elapsed
            print(f"🔥 {i+1}/{count} | ✅{successful} ❌{failed} | TPS: {tps:.2f}")
    
    end_time = time.time()
    duration = end_time - start_time
    tps = successful / duration
    
    print(f"\n🎯 RAPID BLAST RESULTS:")
    print(f"✅ Success: {successful}/{count}")
    print(f"⚡ TPS: {tps:.2f}")
    print(f"🕒 Duration: {duration:.1f}s")

if __name__ == "__main__":
    blast_transactions(10000)