#!/usr/bin/env python3

"""
🔥 QUICK 1000 TRANSACTION TEST 🔥
Test run before the million transaction blast
"""

import subprocess
import time
import random

def quick_blast_test():
    print("🔥 QUICK 1000 TRANSACTION TEST BLAST 🔥")
    print("⚡ SELUTH MODE: 'Let's warm up before the million!'")
    print()
    
    # Check validator health first
    result = subprocess.run([
        "solana", "cluster-version", "-u", "http://127.0.0.1:8899"
    ], capture_output=True, text=True)
    
    if result.returncode != 0:
        print("❌ Validator not responding!")
        return
    
    print("✅ Validator is healthy, proceeding with test blast...")
    
    # Create test wallets
    print("💰 Creating test wallets...")
    wallets = []
    
    for i in range(10):
        wallet_file = f"/tmp/test-wallet-{i}.json"
        
        # Generate wallet
        subprocess.run([
            "solana-keygen", "new", "--no-bip39-passphrase", 
            "-o", wallet_file
        ], capture_output=True)
        
        # Get pubkey
        pubkey_result = subprocess.run([
            "solana-keygen", "pubkey", wallet_file
        ], capture_output=True, text=True)
        
        if pubkey_result.returncode == 0:
            pubkey = pubkey_result.stdout.strip()
            wallets.append({'file': wallet_file, 'pubkey': pubkey})
            
            # Fund wallet
            subprocess.run([
                "solana", "airdrop", "100", 
                "-u", "http://127.0.0.1:8899",
                "-k", wallet_file
            ], capture_output=True)
    
    print(f"✅ Created {len(wallets)} funded wallets")
    
    # Execute test transactions
    print("🚀 Executing 1000 test transactions...")
    successful = 0
    failed = 0
    start_time = time.time()
    
    for i in range(1000):
        if len(wallets) >= 2:
            sender = random.choice(wallets)
            recipient = random.choice([w for w in wallets if w != sender])
            amount = round(random.uniform(0.001, 0.1), 3)
            
            result = subprocess.run([
                "solana", "transfer",
                recipient['pubkey'],
                str(amount),
                "-u", "http://127.0.0.1:8899",
                "-k", sender['file'],
                "--allow-unfunded-recipient"
            ], capture_output=True, text=True, timeout=10)
            
            if result.returncode == 0:
                successful += 1
            else:
                failed += 1
            
            # Progress update every 100 transactions
            if (i + 1) % 100 == 0:
                elapsed = time.time() - start_time
                tps = (i + 1) / elapsed
                print(f"   🔥 {i + 1}/1000 | Success: {successful} | TPS: {tps:.2f}")
    
    end_time = time.time()
    duration = end_time - start_time
    final_tps = successful / duration
    
    print()
    print("🎯 QUICK BLAST TEST RESULTS:")
    print(f"   ✅ Successful: {successful}/1000")
    print(f"   ❌ Failed: {failed}/1000") 
    print(f"   ⚡ Average TPS: {final_tps:.2f}")
    print(f"   🕒 Duration: {duration:.2f} seconds")
    print()
    
    if successful > 800:  # 80% success rate
        print("🚀 READY FOR MILLION TRANSACTION BLAST!")
        print("⚡ SELUTH: 'VALIDATOR IS WARMED UP AND LEGENDARY!'")
        return True
    else:
        print("⚠️ Consider investigating failures before million blast")
        return False

if __name__ == "__main__":
    success = quick_blast_test()
    if success:
        print("\n🔥 Run: python3 million-transaction-blast.py")
        print("🫀 For the ultimate MEV-free equality test!")
