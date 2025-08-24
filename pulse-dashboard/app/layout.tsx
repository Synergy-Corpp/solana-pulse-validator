import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Solana Pulse Dashboard - MEV-Free Validator Monitor',
  description: 'Live monitoring dashboard for Solana Pulse Validator - Genesis Block 0 verification, MEV-free transaction flow, and real-time consensus tracking.',
  keywords: ['solana', 'blockchain', 'mev-free', 'validator', 'dashboard', 'pulse', 'genesis'],
  authors: [{ name: 'Genesis Pulse Protocol' }],
  openGraph: {
    title: 'Solana Pulse Dashboard',
    description: 'Monitor the MEV-free blockchain that breathes with equality',
    type: 'website',
    siteName: 'Solana Pulse Validator',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Solana Pulse Dashboard',
    description: 'Live monitoring of the MEV-purified blockchain',
  },
  robots: {
    index: true,
    follow: true,
  },
  viewport: 'width=device-width, initial-scale=1',
  themeColor: '#06b6d4',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <head>
        <link rel="icon" type="image/svg+xml" href="/pulse-icon.svg" />
        <meta name="theme-color" content="#06b6d4" />
      </head>
      <body className="min-h-screen bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900">
        <div className="relative">
          {/* Background Pattern */}
          <div className="absolute inset-0 bg-gradient-to-r from-pulse-500/5 to-genesis-500/5 opacity-50"></div>
          <div className="absolute inset-0" style={{
            backgroundImage: `radial-gradient(circle at 25px 25px, rgba(255,255,255,0.1) 2px, transparent 0), 
                             radial-gradient(circle at 75px 75px, rgba(6,182,212,0.1) 2px, transparent 0)`,
            backgroundSize: '100px 100px'
          }}></div>
          
          {/* Main Content */}
          <div className="relative z-10">
            {children}
          </div>
        </div>
      </body>
    </html>
  )
}