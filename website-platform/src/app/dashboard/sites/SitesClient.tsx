'use client';

import { useState } from 'react';
import { Globe, Link as LinkIcon, ExternalLink, AlertCircle, ShieldCheck, UserCheck } from 'lucide-react';
import { updateCustomDomain, toggleVerificationFlags } from './actions';

interface Site {
  id: string;
  name: string;
  url: string | null;
  status: string | null;
  custom_domain: string | null;
  is_verified_secure: boolean;
  is_verified_human_review: boolean;
}

export default function SitesClient({ initialSites }: { initialSites: Site[] }) {
  const [sites, setSites] = useState<Site[]>(initialSites);
  const [editingDomainId, setEditingDomainId] = useState<string | null>(null);
  const [domainInput, setDomainInput] = useState('');
  const [error, setError] = useState('');
  const [saving, setSaving] = useState(false);

  const handleSaveDomain = async (siteId: string) => {
    if (!domainInput) return;
    setSaving(true);
    setError('');
    
    const res = await updateCustomDomain(siteId, domainInput);
    if (!res.success) {
      setError(res.error || 'Failed to update domain');
      setSaving(false);
      return;
    }
    
    setSites(prev => prev.map(s => s.id === siteId ? { ...s, custom_domain: domainInput } : s));
    setEditingDomainId(null);
    setSaving(false);
  };

  const handleToggleFlag = async (siteId: string, flag: 'secure' | 'human', currentValue: boolean) => {
    const newValue = !currentValue;
    
    // Optimistic state update
    setSites(prev => prev.map(s => {
      if (s.id === siteId) {
        return flag === 'secure' 
          ? { ...s, is_verified_secure: newValue }
          : { ...s, is_verified_human_review: newValue };
      }
      return s;
    }));

    const res = await toggleVerificationFlags(siteId, flag, newValue);
    if (!res.success) {
      // Revert state on failure
      setSites(prev => prev.map(s => {
        if (s.id === siteId) {
          return flag === 'secure' 
            ? { ...s, is_verified_secure: currentValue }
            : { ...s, is_verified_human_review: currentValue };
        }
        return s;
      }));
      alert(res.error || 'Failed to update verification setting');
    }
  };

  return (
    <div className="grid gap-6">
      {sites.map((site) => (
        <div key={site.id} className="bg-secondary/10 border border-border/50 rounded-2xl p-6 flex flex-col md:flex-row gap-6 md:items-center justify-between">
          <div className="space-y-4">
            <div>
              <div className="flex items-center gap-3 mb-2">
                <h2 className="text-xl font-bold">{site.name}</h2>
                <span className="px-3 py-1 rounded-full bg-green-500/10 text-green-500 text-xs font-semibold border border-green-500/20">
                  {site.status}
                </span>
              </div>
              
              <div className="flex flex-col gap-2 text-sm text-muted-foreground mt-4">
                <div className="flex items-center gap-2">
                  <Globe className="w-4 h-4" />
                  Resolve.bet URL: <a href={`/site/${site.url}`} target="_blank" className="text-primary hover:underline font-medium">resolve.bet/site/{site.url}</a>
                </div>
                
                <div className="flex items-center gap-2">
                  <LinkIcon className="w-4 h-4" />
                  Custom Domain: 
                  {site.custom_domain ? (
                    <span className="text-foreground font-medium flex items-center gap-2">
                      <a href={`https://${site.custom_domain}`} target="_blank" className="hover:underline">{site.custom_domain}</a>
                      <button onClick={() => { setEditingDomainId(site.id); setDomainInput(site.custom_domain); }} className="text-xs text-primary hover:underline ml-2">Edit</button>
                    </span>
                  ) : (
                    <button onClick={() => { setEditingDomainId(site.id); setDomainInput(''); }} className="text-primary hover:underline font-medium">
                      Connect Domain
                    </button>
                  )}
                </div>
              </div>
            </div>

            {/* Verification Badges Controls */}
            <div className="flex flex-wrap gap-4 pt-2 border-t border-border/30">
              <button
                onClick={() => handleToggleFlag(site.id, 'secure', site.is_verified_secure)}
                className={`px-3 py-1.5 rounded-xl border text-xs font-bold flex items-center gap-1.5 transition-all ${
                  site.is_verified_secure 
                    ? "bg-emerald-500/10 border-emerald-500/30 text-emerald-400" 
                    : "bg-secondary/40 border-border text-gray-500"
                }`}
              >
                <ShieldCheck className="w-4 h-4" />
                Verified Secure Badge: {site.is_verified_secure ? "Active" : "Off"}
              </button>

              <button
                onClick={() => handleToggleFlag(site.id, 'human', site.is_verified_human_review)}
                className={`px-3 py-1.5 rounded-xl border text-xs font-bold flex items-center gap-1.5 transition-all ${
                  site.is_verified_human_review 
                    ? "bg-blue-500/10 border-blue-500/30 text-blue-400" 
                    : "bg-secondary/40 border-border text-gray-500"
                }`}
              >
                <UserCheck className="w-4 h-4" />
                Human-Verified Copy Badge: {site.is_verified_human_review ? "Active" : "Off"}
              </button>
            </div>
          </div>
          
          <div className="flex gap-3 self-start md:self-center">
            <a href={`/site/${site.url}`} target="_blank" className="px-4 py-2 bg-secondary text-foreground rounded-xl text-sm font-medium hover:bg-secondary/80 transition-colors flex items-center gap-2">
              <ExternalLink className="w-4 h-4" />
              Visit Site
            </a>
          </div>
          
          {editingDomainId === site.id && (
            <div className="absolute inset-0 bg-background/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
              <div className="bg-background border border-border rounded-2xl shadow-2xl p-6 max-w-md w-full">
                <h3 className="text-xl font-bold mb-2">Connect Custom Domain</h3>
                <p className="text-sm text-muted-foreground mb-6">Enter the domain you want to connect to this site. Once connected, visitors to this domain will see your site.</p>
                
                {error && (
                  <div className="mb-4 bg-red-500/10 text-red-500 p-3 rounded-lg text-sm border border-red-500/20 flex items-start gap-2">
                    <AlertCircle className="w-4 h-4 mt-0.5 shrink-0" />
                    {error}
                  </div>
                )}
                
                <div className="space-y-4 mb-6">
                  <div>
                    <label className="text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-2 block">Domain Name</label>
                    <input 
                      type="text" 
                      placeholder="e.g. www.mybusiness.com"
                      value={domainInput}
                      onChange={(e) => setDomainInput(e.target.value)}
                      className="w-full bg-secondary/50 border border-border rounded-xl px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary/50"
                    />
                  </div>
                  
                  <div className="bg-blue-500/10 border border-blue-500/20 rounded-xl p-4 text-sm text-blue-500">
                    <p className="font-semibold mb-1">DNS Configuration Required</p>
                    <p className="opacity-90">After saving, you must go to your domain registrar and add an A Record pointing to <code className="bg-blue-500/20 px-1 rounded">76.76.21.21</code> (Vercel IP).</p>
                  </div>
                </div>
                
                <div className="flex gap-3 justify-end">
                  <button 
                    onClick={() => setEditingDomainId(null)}
                    className="px-4 py-2 bg-secondary text-foreground rounded-xl text-sm font-medium hover:bg-secondary/80 transition-colors"
                  >
                    Cancel
                  </button>
                  <button 
                    onClick={() => handleSaveDomain(site.id)}
                    disabled={saving}
                    className="px-4 py-2 bg-primary text-white rounded-xl text-sm font-medium hover:bg-primary/90 transition-colors"
                  >
                    {saving ? 'Saving...' : 'Save Domain'}
                  </button>
                </div>
              </div>
            </div>
          )}
        </div>
      ))}
    </div>
  );
}
