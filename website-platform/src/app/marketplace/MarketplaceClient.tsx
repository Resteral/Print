'use client';

import { useState } from 'react';
import { Search, MapPin, ExternalLink, ShoppingBag, ArrowLeft } from 'lucide-react';
import Link from 'next/link';

interface Product {
  id: string;
  name: string;
  price: number;
  description?: string;
  image_url?: string;
  stock?: number;
  is_active?: boolean;
  site: {
    id: string;
    name: string;
    url: string | null;
    location: string;
  };
}

export default function MarketplaceClient({ 
  initialProducts,
  initialQuery,
  initialLocation
}: { 
  initialProducts: Product[],
  initialQuery: string,
  initialLocation: string
}) {
  const [query, setQuery] = useState(initialQuery);
  const [location, setLocation] = useState(initialLocation);
  const [searching, setSearching] = useState(false);

  const handleSearch = async (e: React.FormEvent) => {
    e.preventDefault();
    setSearching(true);
    
    const params = new URLSearchParams();
    if (query) params.set('q', query);
    if (location) params.set('location', location);
    
    window.location.href = `/marketplace?${params.toString()}`;
  };

  // Helper to generate mock distances for local feel deterministically
  const getMockDistance = (productId: string, storeLocation: string) => {
    const isSameCity = storeLocation.toLowerCase().includes(location.toLowerCase()) || 
                       location.toLowerCase().includes(storeLocation.toLowerCase());
                       
    if (isSameCity) {
      // Create a deterministic distance based on the product ID string
      let hash = 0;
      for (let i = 0; i < productId.length; i++) {
        hash = productId.charCodeAt(i) + ((hash << 5) - hash);
      }
      const distance = (Math.abs(hash % 20) / 10 + 0.2).toFixed(1);
      return `${distance} miles away`;
    }
    return storeLocation || 'Seattle, WA';
  };

  return (
    <div className="max-w-6xl mx-auto px-6 py-12">
      {/* Header Back button */}
      <Link href="/" className="inline-flex items-center gap-2 text-sm text-gray-400 hover:text-white mb-8 transition-colors">
        <ArrowLeft className="w-4 h-4" />
        Back to Home
      </Link>

      <div className="mb-12 flex flex-col md:flex-row justify-between md:items-end gap-4">
        <div>
          <h1 className="text-4xl font-extrabold tracking-tight mb-2 bg-gradient-to-r from-primary to-blue-400 bg-clip-text text-transparent">
            Local Product Finder
          </h1>
          <p className="text-gray-400">Find products in stock at local stores right next to you.</p>
        </div>
        <div className="flex gap-3 shrink-0">
          <Link 
            href="/marketplace/arcade" 
            className="inline-flex items-center justify-center bg-amber-500/10 text-amber-500 border border-amber-500/20 px-5 py-2.5 rounded-xl text-sm font-semibold hover:bg-amber-500 hover:text-white transition-all"
          >
            Arcade Lobbies
          </Link>
          <Link 
            href="/marketplace/debate" 
            className="inline-flex items-center justify-center bg-[#6366f1]/10 text-[#6366f1] border border-[#6366f1]/20 px-5 py-2.5 rounded-xl text-sm font-semibold hover:bg-[#6366f1] hover:text-white transition-all"
          >
            Debate Arena
          </Link>
          <Link 
            href="/drivers/signup" 
            className="inline-flex items-center justify-center bg-primary/20 text-primary border border-primary/30 px-5 py-2.5 rounded-xl text-sm font-semibold hover:bg-primary hover:text-white transition-all"
          >
            Become a Driver
          </Link>
        </div>
      </div>

      {/* Search Bar Panel */}
      <form onSubmit={handleSearch} className="bg-secondary/10 border border-border/50 rounded-2xl p-4 mb-10 flex flex-col md:flex-row gap-4 shadow-xl">
        <div className="flex-1 relative">
          <Search className="w-5 h-5 text-gray-400 absolute left-4 top-1/2 -translate-y-1/2" />
          <input 
            type="text" 
            placeholder="What are you looking for? (e.g. coffee, burgers)" 
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            className="w-full bg-[#121824] border border-border/50 rounded-xl pl-12 pr-4 py-3.5 text-sm focus:outline-none focus:border-primary transition-colors text-white placeholder:text-gray-500"
          />
        </div>
        
        <div className="w-full md:w-64 relative">
          <MapPin className="w-5 h-5 text-gray-400 absolute left-4 top-1/2 -translate-y-1/2" />
          <input 
            type="text" 
            placeholder="City or ZIP code" 
            value={location}
            onChange={(e) => setLocation(e.target.value)}
            className="w-full bg-[#121824] border border-border/50 rounded-xl pl-12 pr-4 py-3.5 text-sm focus:outline-none focus:border-primary transition-colors text-white placeholder:text-gray-500"
          />
        </div>

        <button 
          type="submit" 
          disabled={searching}
          className="bg-primary hover:bg-primary/95 text-white font-medium px-8 py-3.5 rounded-xl text-sm transition-all shadow-md shadow-primary/20 shrink-0"
        >
          {searching ? 'Searching...' : 'Find Products'}
        </button>
      </form>

      {/* Results grid */}
      <div className="grid sm:grid-cols-2 md:grid-cols-3 gap-8">
        {initialProducts.length > 0 ? initialProducts.map((product) => {
          const distanceLabel = getMockDistance(product.id, product.site.location);
          const isOutOfStock = product.stock === 0;

          return (
            <div key={product.id} className="bg-secondary/5 border border-border/30 rounded-2xl overflow-hidden flex flex-col hover:border-primary/40 transition-colors group">
              {/* Product Image */}
              <div className="h-48 w-full bg-secondary/20 relative">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img 
                  src={product.image_url} 
                  alt={product.name} 
                  className={`w-full h-full object-cover group-hover:scale-102 transition-transform duration-300 ${
                    isOutOfStock ? 'opacity-30 grayscale' : ''
                  }`}
                  onError={(e) => { (e.target as HTMLImageElement).src = 'https://via.placeholder.com/300x300?text=No+Image' }}
                />
                
                {isOutOfStock ? (
                  <div className="absolute inset-0 flex items-center justify-center">
                    <span className="bg-rose-500/90 text-white text-[10px] font-bold uppercase tracking-wider px-2.5 py-1.5 rounded-full">
                      Out of Stock
                    </span>
                  </div>
                ) : (
                  <div className="absolute top-2 left-2 bg-[#23a55a] text-white text-[9px] font-bold uppercase tracking-wider px-2 py-0.5 rounded">
                    In Stock
                  </div>
                )}
              </div>

              {/* Product Details */}
              <div className="p-5 flex-grow flex flex-col justify-between">
                <div>
                  <div className="flex justify-between items-start mb-2 gap-2">
                    <h3 className="font-bold text-lg text-white group-hover:text-primary transition-colors truncate">{product.name}</h3>
                    <span className="font-bold text-primary shrink-0">${product.price.toFixed(2)}</span>
                  </div>
                  <p className="text-xs text-gray-400 line-clamp-2 mb-4">{product.description}</p>
                </div>

                {/* Location / Site Footer */}
                <div className="pt-4 border-t border-border/20 flex flex-col gap-2.5">
                  <div className="flex items-center justify-between text-xs text-gray-300">
                    <span className="font-bold flex items-center gap-1">
                      <ShoppingBag className="w-3.5 h-3.5 text-primary" />
                      {product.site.name}
                    </span>
                    <span className="flex items-center gap-1 text-gray-400">
                      <MapPin className="w-3.5 h-3.5" />
                      {distanceLabel}
                    </span>
                  </div>

                  <a 
                    href={`/site/${product.site.url}`} 
                    target="_blank" 
                    className="w-full bg-[#121824] hover:bg-secondary/40 text-xs font-semibold py-2.5 rounded-xl border border-border/50 text-center flex items-center justify-center gap-1.5 transition-colors"
                  >
                    Visit Store
                    <ExternalLink className="w-3.5 h-3.5" />
                  </a>
                </div>
              </div>
            </div>
          );
        }) : (
          <div className="col-span-full py-16 text-center text-gray-400 bg-secondary/5 rounded-2xl border border-dashed border-border/30">
            No products found matching your search. Try searching for something else!
          </div>
        )}
      </div>
    </div>
  );
}
