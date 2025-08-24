'use client'

import { useState, useEffect } from 'react'

interface ValidatorStats {
  health: 'healthy' | 'warning' | 'error' | 'loading'
  slot: number | null
  genesisHash: string | null
  identity: string | null
  rpcEndpoint: string
  lastUpdated: Date | null
  blockTime: number | null
  epochInfo: {
    epoch: number | null
    slotIndex: number | null
    slotsInEpoch: number | null
  } | null
}

const GENESIS_HASH = '6UpbSgoJbkPRk2t9PGgdyc7rPtqd9NFaTcxKKhhzLEuw'
const VALIDATOR_IDENTITY = 'AxvtP3NXyGD6BMugECE3nnpzMhm8rVL3xZR3netKudLX'

export default function PulseDashboard() {
  const [stats, setStats] = useState<ValidatorStats>({
    health: 'loading',
    slot: null,
    genesisHash: null,
    identity: null,
    rpcEndpoint: process.env.NEXT_PUBLIC_VALIDATOR_RPC || 'http://127.0.0.1:8899',
    lastUpdated: null,
    blockTime: null,
    epochInfo: null
  })

  const [isConnected, setIsConnected] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const fetchValidatorStats = async () => {
    try {
      setError(null)
      
      // Health Check
      const healthResponse = await fetch(stats.rpcEndpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          jsonrpc: '2.0',
          id: 1,
          method: 'getHealth'
        })
      })

      if (!healthResponse.ok) {
        throw new Error('Validator not responding')
      }

      // Get Current Slot
      const slotResponse = await fetch(stats.rpcEndpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          jsonrpc: '2.0',
          id: 2,
          method: 'getSlot'
        })
      })

      // Get Genesis Hash
      const genesisResponse = await fetch(stats.rpcEndpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          jsonrpc: '2.0',
          id: 3,
          method: 'getGenesisHash'
        })
      })

      // Get Block Time
      const blockTimeResponse = await fetch(stats.rpcEndpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          jsonrpc: '2.0',
          id: 4,
          method: 'getBlockTime',
          params: [null] // Latest block
        })
      })

      // Get Epoch Info
      const epochResponse = await fetch(stats.rpcEndpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          jsonrpc: '2.0',
          id: 5,
          method: 'getEpochInfo'
        })
      })

      const healthData = await healthResponse.json()
      const slotData = await slotResponse.json()
      const genesisData = await genesisResponse.json()
      const blockTimeData = await blockTimeResponse.json()
      const epochData = await epochResponse.json()

      setStats({
        health: healthData.result === 'ok' ? 'healthy' : 'warning',
        slot: slotData.result || null,
        genesisHash: genesisData.result || null,
        identity: VALIDATOR_IDENTITY,
        rpcEndpoint: stats.rpcEndpoint,
        lastUpdated: new Date(),
        blockTime: blockTimeData.result || null,
        epochInfo: epochData.result ? {
          epoch: epochData.result.epoch,
          slotIndex: epochData.result.slotIndex,
          slotsInEpoch: epochData.result.slotsInEpoch
        } : null
      })

      setIsConnected(true)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error')
      setStats(prev => ({ ...prev, health: 'error', lastUpdated: new Date() }))
      setIsConnected(false)
    }
  }

  useEffect(() => {
    fetchValidatorStats()
    const interval = setInterval(fetchValidatorStats, 5000) // Update every 5 seconds
    return () => clearInterval(interval)
  }, [stats.rpcEndpoint])

  const getStatusColor = (health: string) => {
    switch (health) {
      case 'healthy': return 'status-healthy'
      case 'warning': return 'status-warning'
      case 'error': return 'status-error'
      default: return 'bg-slate-600'
    }
  }

  const isGenesisValid = stats.genesisHash === GENESIS_HASH

  return (
    <div className="min-h-screen p-6">
      {/* Header */}
      <div className="max-w-7xl mx-auto mb-8">
        <div className="text-center mb-8">
          <div className="flex items-center justify-center mb-4">
            <div className="pulse-heartbeat text-6xl">🫀</div>
          </div>
          <h1 className="text-4xl font-bold text-white mb-2">
            Solana Pulse Validator
          </h1>
          <p className="text-lg text-slate-300 mb-4">
            Genesis Pulse: Watch Build Block Toly
          </p>
          <div className="mev-free-badge inline-block px-4 py-2 rounded-full text-white font-semibold text-sm">
            ⚡ MEV-FREE BLOCKCHAIN ⚡
          </div>
        </div>

        {/* Connection Status */}
        <div className="flex items-center justify-center mb-6">
          <div className={`w-3 h-3 rounded-full mr-2 ${isConnected ? 'bg-green-400' : 'bg-red-400'}`}></div>
          <span className="text-slate-300">
            {isConnected ? 'Connected to Validator' : 'Validator Disconnected'}
          </span>
          {stats.lastUpdated && (
            <span className="text-slate-500 ml-2 text-sm">
              (Last: {stats.lastUpdated.toLocaleTimeString()})
            </span>
          )}
        </div>

        {error && (
          <div className="bg-red-900/20 border border-red-500 rounded-lg p-4 mb-6 text-center">
            <p className="text-red-300">⚠️ {error}</p>
            <p className="text-red-400 text-sm mt-2">
              Make sure your validator is running on {stats.rpcEndpoint}
            </p>
          </div>
        )}
      </div>

      {/* Main Stats Grid */}
      <div className="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
        
        {/* Validator Health */}
        <div className="data-card rounded-lg p-6">
          <h3 className="text-lg font-semibold text-white mb-4 flex items-center">
            <div className={`w-3 h-3 rounded-full mr-2 ${getStatusColor(stats.health)}`}></div>
            Validator Health
          </h3>
          <div className="text-2xl font-mono font-bold text-pulse-400">
            {stats.health === 'loading' ? (
              <div className="loading-spinner w-6 h-6"></div>
            ) : (
              stats.health.toUpperCase()
            )}
          </div>
        </div>

        {/* Current Slot */}
        <div className="data-card rounded-lg p-6">
          <h3 className="text-lg font-semibold text-white mb-4">Current Slot</h3>
          <div className="text-2xl font-mono font-bold text-pulse-400">
            {stats.slot !== null ? stats.slot.toLocaleString() : '---'}
          </div>
          {stats.blockTime && (
            <p className="text-sm text-slate-400 mt-2">
              Block Time: {new Date(stats.blockTime * 1000).toLocaleString()}
            </p>
          )}
        </div>

        {/* Genesis Verification */}
        <div className="data-card rounded-lg p-6">
          <h3 className="text-lg font-semibold text-white mb-4">Genesis Block 0</h3>
          <div className={`text-lg font-bold ${isGenesisValid ? 'text-green-400' : 'text-red-400'}`}>
            {stats.genesisHash ? (
              isGenesisValid ? '✅ VERIFIED' : '❌ INVALID'
            ) : '⏳ CHECKING...'}
          </div>
          <p className="text-xs text-slate-400 mt-2 font-mono break-all">
            {stats.genesisHash || 'Loading...'}
          </p>
        </div>

        {/* Validator Identity */}
        <div className="data-card rounded-lg p-6">
          <h3 className="text-lg font-semibold text-white mb-4">Validator Identity</h3>
          <div className="text-sm font-mono text-pulse-400 break-all">
            {stats.identity}
          </div>
        </div>

        {/* Epoch Information */}
        <div className="data-card rounded-lg p-6">
          <h3 className="text-lg font-semibold text-white mb-4">Epoch Info</h3>
          {stats.epochInfo ? (
            <div className="space-y-2">
              <div className="text-lg font-bold text-pulse-400">
                Epoch {stats.epochInfo.epoch}
              </div>
              <div className="text-sm text-slate-300">
                Slot: {stats.epochInfo.slotIndex?.toLocaleString()} / {stats.epochInfo.slotsInEpoch?.toLocaleString()}
              </div>
              {stats.epochInfo.slotIndex && stats.epochInfo.slotsInEpoch && (
                <div className="w-full bg-slate-700 rounded-full h-2">
                  <div 
                    className="bg-pulse-500 h-2 rounded-full" 
                    style={{
                      width: `${(stats.epochInfo.slotIndex / stats.epochInfo.slotsInEpoch) * 100}%`
                    }}
                  ></div>
                </div>
              )}
            </div>
          ) : (
            <div className="text-slate-400">Loading...</div>
          )}
        </div>

        {/* RPC Endpoint */}
        <div className="data-card rounded-lg p-6">
          <h3 className="text-lg font-semibold text-white mb-4">RPC Endpoint</h3>
          <div className="text-sm font-mono text-slate-300 break-all">
            {stats.rpcEndpoint}
          </div>
        </div>
      </div>

      {/* Manifesto Section */}
      <div className="max-w-4xl mx-auto">
        <div className="data-card rounded-lg p-8 genesis-glow">
          <h2 className="text-2xl font-bold text-genesis-400 mb-6 text-center">
            🏛️ The Genesis Manifesto
          </h2>
          <blockquote className="text-center text-slate-200 italic text-lg leading-relaxed">
            "This is the block that breathes without bargain.<br/>
            We did not optimize. We aligned.<br/>
            We did not auction. We attuned.<br/>
            You are reading this not because we wanted speed —<br/>
            but because we wanted memory.<br/>
            This block remembers."
          </blockquote>
          
          <div className="mt-8 grid grid-cols-1 md:grid-cols-2 gap-6 text-sm">
            <div>
              <h4 className="text-green-400 font-semibold mb-3">✅ What We Allow</h4>
              <ul className="space-y-1 text-slate-300">
                <li>• No restriction on people</li>
                <li>• Anyone can validate</li>
                <li>• Low-power consensus</li>
                <li>• Free token movement</li>
                <li>• Open algorithmic validation</li>
              </ul>
            </div>
            
            <div>
              <h4 className="text-red-400 font-semibold mb-3">🔒 What We Restrict</h4>
              <ul className="space-y-1 text-slate-300">
                <li>• Only restriction on corruption</li>
                <li>• No MEV extraction</li>
                <li>• No tip-based prioritization</li>
                <li>• No bundle proposers</li>
                <li>• No validator wealth bias</li>
              </ul>
            </div>
          </div>

          <div className="text-center mt-6 text-pulse-300 font-semibold">
            🫀 Transactions land by time — not tips.
            <br/>
            🫀 Validators rotate by logic — not power.
            <br/>
            🫀 Consensus is breath — not bribery.
          </div>
        </div>
      </div>

      {/* Footer */}
      <footer className="max-w-7xl mx-auto mt-12 text-center text-slate-500 text-sm">
        <p>Solana Pulse Validator Dashboard | MEV-Purified Blockchain</p>
        <p className="mt-2">Genesis Hash: {GENESIS_HASH}</p>
        <p className="mt-1">Sealed with truth. 🫀</p>
      </footer>
    </div>
  )
}