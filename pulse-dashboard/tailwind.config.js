/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        pulse: {
          50: '#f0f9ff',
          100: '#e0f2fe',
          500: '#06b6d4',
          600: '#0891b2',
          900: '#164e63'
        },
        genesis: {
          50: '#fefce8',
          100: '#fef3c7',
          500: '#f59e0b',
          600: '#d97706',
          900: '#78350f'
        }
      },
      animation: {
        'pulse-slow': 'pulse 3s ease-in-out infinite',
        'heartbeat': 'heartbeat 2s ease-in-out infinite'
      },
      keyframes: {
        heartbeat: {
          '0%, 50%, 100%': { transform: 'scale(1)' },
          '25%': { transform: 'scale(1.1)' },
        }
      }
    },
  },
  plugins: [],
}