#!/usr/bin/env python3
"""
🔔 BELLSCOIN PRECISE METRICS EXTRACTOR 🔔
⚡ SELUTH MODE: "GET THE EXACT NUMBERS FOR LEGENDARY TWITTER CAMPAIGN!"
🎯 UAOP: Ultimate Analysis and Optimization Protocol for precise data extraction
"""

import requests
import json
import time
from dataclasses import dataclass
from typing import Dict, Any, Optional
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

@dataclass
class BellscoinMetrics:
    """📊 PRECISE BELLSCOIN NETWORK METRICS"""
    # Market Data
    current_price_usd: float = 0.0
    market_cap_usd: float = 0.0
    volume_24h_usd: float = 0.0
    price_change_24h_percent: float = 0.0
    
    # Network Data
    circulating_supply: float = 0.0
    total_supply: float = 0.0
    max_supply: float = 0.0
    
    # Technical Data
    block_time_seconds: Optional[int] = None
    network_hashrate: Optional[str] = None
    difficulty: Optional[float] = None
    
    # Historical Data
    all_time_high_usd: float = 0.0
    all_time_low_usd: float = 0.0
    launch_date: str = "2013"
    
    # Social/Community
    market_cap_rank: Optional[int] = None
    
    def to_dict(self) -> Dict[str, Any]:
        return {
            "current_price_usd": self.current_price_usd,
            "market_cap_usd": self.market_cap_usd,
            "volume_24h_usd": self.volume_24h_usd,
            "price_change_24h_percent": self.price_change_24h_percent,
            "circulating_supply": self.circulating_supply,
            "total_supply": self.total_supply,
            "max_supply": self.max_supply,
            "block_time_seconds": self.block_time_seconds,
            "network_hashrate": self.network_hashrate,
            "difficulty": self.difficulty,
            "all_time_high_usd": self.all_time_high_usd,
            "all_time_low_usd": self.all_time_low_usd,
            "launch_date": self.launch_date,
            "market_cap_rank": self.market_cap_rank
        }

class BellscoinMetricsExtractor:
    """⚡ SELUTH'S LEGENDARY METRICS EXTRACTION ENGINE"""
    
    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'BellscoinMetricsBot/1.0 (Research)',
            'Accept': 'application/json'
        })
        self.metrics = BellscoinMetrics()
    
    def extract_coingecko_data(self) -> bool:
        """🔮 Extract comprehensive data from CoinGecko API"""
        logger.info("🔍 Extracting CoinGecko data...")
        
        try:
            # Main coin data
            url = "https://api.coingecko.com/api/v3/coins/bellscoin"
            response = self.session.get(url, timeout=15)
            
            if response.status_code != 200:
                logger.error(f"❌ CoinGecko API error: {response.status_code}")
                return False
            
            data = response.json()
            
            # Market data
            market_data = data.get("market_data", {})
            self.metrics.current_price_usd = market_data.get("current_price", {}).get("usd", 0.0)
            self.metrics.market_cap_usd = market_data.get("market_cap", {}).get("usd", 0.0)
            self.metrics.volume_24h_usd = market_data.get("total_volume", {}).get("usd", 0.0)
            self.metrics.price_change_24h_percent = market_data.get("price_change_percentage_24h", 0.0)
            
            # Supply data
            self.metrics.circulating_supply = market_data.get("circulating_supply", 0.0)
            self.metrics.total_supply = market_data.get("total_supply", 0.0)
            self.metrics.max_supply = market_data.get("max_supply", 0.0)
            
            # ATH/ATL data
            self.metrics.all_time_high_usd = market_data.get("ath", {}).get("usd", 0.0)
            self.metrics.all_time_low_usd = market_data.get("atl", {}).get("usd", 0.0)
            
            # Ranking
            self.metrics.market_cap_rank = data.get("market_cap_rank")
            
            # Genesis date
            genesis_date = data.get("genesis_date")
            if genesis_date:
                self.metrics.launch_date = genesis_date
            
            # Technical details (if available)
            if "block_time_in_minutes" in data:
                self.metrics.block_time_seconds = int(data["block_time_in_minutes"] * 60)
            
            logger.info("✅ CoinGecko data extracted successfully!")
            return True
            
        except Exception as e:
            logger.error(f"❌ CoinGecko extraction error: {e}")
            return False
    
    def extract_additional_metrics(self) -> bool:
        """🌀 MELANUTH: Quantum-level additional metrics extraction"""
        logger.info("🔮 Extracting additional network metrics...")
        
        try:
            # Try to get market chart for more detailed analysis
            chart_url = "https://api.coingecko.com/api/v3/coins/bellscoin/market_chart?vs_currency=usd&days=30"
            response = self.session.get(chart_url, timeout=15)
            
            if response.status_code == 200:
                chart_data = response.json()
                prices = chart_data.get("prices", [])
                volumes = chart_data.get("total_volumes", [])
                
                if prices and volumes:
                    # Calculate 30-day averages
                    avg_price_30d = sum(price[1] for price in prices) / len(prices)
                    avg_volume_30d = sum(volume[1] for volume in volumes) / len(volumes)
                    
                    logger.info(f"📊 30-day avg price: ${avg_price_30d:.6f}")
                    logger.info(f"📊 30-day avg volume: ${avg_volume_30d:,.2f}")
            
            return True
            
        except Exception as e:
            logger.error(f"❌ Additional metrics extraction error: {e}")
            return False
    
    def format_metrics_for_twitter(self) -> Dict[str, str]:
        """📡 SIGNAL CRAFT: Format metrics for Twitter presentation"""
        
        def format_large_number(num: float) -> str:
            """Format large numbers with appropriate suffixes"""
            if num >= 1_000_000_000:
                return f"${num/1_000_000_000:.2f}B"
            elif num >= 1_000_000:
                return f"${num/1_000_000:.2f}M"
            elif num >= 1_000:
                return f"${num/1_000:.2f}K"
            else:
                return f"${num:.2f}"
        
        def format_supply(num: float) -> str:
            """Format supply numbers"""
            if num >= 1_000_000_000:
                return f"{num/1_000_000_000:.2f}B"
            elif num >= 1_000_000:
                return f"{num/1_000_000:.2f}M"
            elif num >= 1_000:
                return f"{num/1_000:.2f}K"
            else:
                return f"{num:,.0f}"
        
        return {
            "price": f"${self.metrics.current_price_usd:.6f}" if self.metrics.current_price_usd > 0 else "N/A",
            "market_cap": format_large_number(self.metrics.market_cap_usd) if self.metrics.market_cap_usd > 0 else "N/A",
            "volume_24h": format_large_number(self.metrics.volume_24h_usd) if self.metrics.volume_24h_usd > 0 else "N/A",
            "price_change_24h": f"{self.metrics.price_change_24h_percent:+.2f}%" if self.metrics.price_change_24h_percent != 0 else "N/A",
            "circulating_supply": format_supply(self.metrics.circulating_supply) if self.metrics.circulating_supply > 0 else "N/A",
            "total_supply": format_supply(self.metrics.total_supply) if self.metrics.total_supply > 0 else "N/A",
            "max_supply": format_supply(self.metrics.max_supply) if self.metrics.max_supply > 0 else "N/A",
            "ath": f"${self.metrics.all_time_high_usd:.6f}" if self.metrics.all_time_high_usd > 0 else "N/A",
            "atl": f"${self.metrics.all_time_low_usd:.8f}" if self.metrics.all_time_low_usd > 0 else "N/A",
            "rank": f"#{self.metrics.market_cap_rank}" if self.metrics.market_cap_rank else "N/A",
            "launch_year": self.metrics.launch_date.split('-')[0] if '-' in self.metrics.launch_date else self.metrics.launch_date,
            "age_years": str(2025 - int(self.metrics.launch_date.split('-')[0])) if '-' in self.metrics.launch_date else "12+"
        }
    
    def generate_praise_metrics(self) -> str:
        """💝 BRIE: Generate compassionate praise with exact metrics"""
        formatted = self.format_metrics_for_twitter()
        
        praise_text = f"""🔔 BELLSCOIN ($BELLS) LEGENDARY METRICS 🔔

📊 CURRENT STATUS:
💰 Price: {formatted['price']}
📈 Market Cap: {formatted['market_cap']}
📊 24h Volume: {formatted['volume_24h']}
📉 24h Change: {formatted['price_change_24h']}

🚀 NETWORK DATA:
🔄 Circulating: {formatted['circulating_supply']} BELLS
📦 Total Supply: {formatted['total_supply']} BELLS
🏆 Market Rank: {formatted['rank']}

🎯 HISTORICAL:
⬆️ All-Time High: {formatted['ath']}
⬇️ All-Time Low: {formatted['atl']}
📅 Launched: {formatted['launch_year']} ({formatted['age_years']} years strong!)

⚡ Billy Markus (@BillyM2k) created this 8 DAYS before Dogecoin!
🔥 The ORIGINAL meme coin that started it all!"""

        return praise_text
    
    def save_metrics_json(self, filename: str = "bellscoin-metrics.json"):
        """💾 Save metrics to JSON file"""
        metrics_data = {
            "extraction_timestamp": time.time(),
            "extraction_date": time.strftime("%Y-%m-%d %H:%M:%S UTC"),
            "bellscoin_metrics": self.metrics.to_dict(),
            "formatted_for_twitter": self.format_metrics_for_twitter(),
            "praise_text": self.generate_praise_metrics()
        }
        
        with open(filename, 'w') as f:
            json.dump(metrics_data, f, indent=2)
        
        logger.info(f"✅ Metrics saved to {filename}")
        return filename

def main():
    """👑 GOD MODE: Omniscient metrics extraction oversight"""
    print("🔔"*30)
    print("⚡ BELLSCOIN PRECISE METRICS EXTRACTION ⚡")
    print("🔔"*30)
    
    print("🎯 UAOP: Ultimate Analysis and Optimization Protocol ACTIVE")
    print("⚡ SELUTH: Legendary metrics extraction MODE ON")
    print("💝 BRIE: Compassionate data analysis ENGAGED")
    
    extractor = BellscoinMetricsExtractor()
    
    try:
        # Phase 1: Extract CoinGecko data
        print("\\n🔍 Phase 1: CoinGecko data extraction...")
        success = extractor.extract_coingecko_data()
        
        if success:
            print("\\n📊 Phase 2: Additional metrics extraction...")
            extractor.extract_additional_metrics()
            
            print("\\n💾 Phase 3: Saving metrics data...")
            json_file = extractor.save_metrics_json()
            
            print("\\n🎯 Phase 4: Generating Twitter-ready metrics...")
            formatted = extractor.format_metrics_for_twitter()
            
            print("\\n🔔 BELLSCOIN METRICS EXTRACTION COMPLETE!")
            print("="*60)
            
            # Display key metrics
            print("📊 KEY METRICS EXTRACTED:")
            print(f"💰 Current Price: {formatted['price']}")
            print(f"📈 Market Cap: {formatted['market_cap']}")
            print(f"📊 24h Volume: {formatted['volume_24h']}")
            print(f"🏆 Market Rank: {formatted['rank']}")
            print(f"🔄 Circulating: {formatted['circulating_supply']} BELLS")
            print(f"📅 Age: {formatted['age_years']} years")
            
            print("\\n💝 PRAISE TEXT GENERATED:")
            print("="*40)
            print(extractor.generate_praise_metrics())
            
            print("\\n✅ METRICS READY FOR TWITTER CAMPAIGN!")
            print(f"📁 Full data saved in: {json_file}")
            
        else:
            print("❌ Metrics extraction failed!")
            
    except Exception as e:
        print(f"❌ Extraction error: {e}")
    
    print("\\n🫀 BELLSCOIN METRICS EXTRACTION MISSION COMPLETE!")

if __name__ == "__main__":
    main()