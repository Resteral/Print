'use client';

import { useState, useEffect, useRef } from 'react';
import { Users, ArrowLeft, Trophy, Swords, Zap } from 'lucide-react';
import { getTugLobby, pullRope } from './actions';
import Link from 'next/link';

interface LobbyState {
  id: string;
  name: string;
  position: number;
  team_left_score: number;
  team_right_score: number;
  status: string;
}

export default function TugLobbyClient() {
  const [lobby, setLobby] = useState<LobbyState | null>(null);
  const [team, setTeam] = useState<'left' | 'right' | null>(null);
  const [loading, setLoading] = useState(true);
  const [pulling, setPulling] = useState(false);
  const [particles, setParticles] = useState<{ id: number; x: number; y: number }[]>([]);
  
  const pollIntervalRef = useRef<NodeJS.Timeout | null>(null);
  const particleIdRef = useRef(0);

  // Poll for lobby state
  useEffect(() => {
    const fetchLobby = async () => {
      const data = await getTugLobby();
      if (data) {
        setLobby(data);
      }
      setLoading(false);
    };

    fetchLobby();
    pollIntervalRef.current = setInterval(fetchLobby, 500); // Poll every 500ms

    return () => {
      if (pollIntervalRef.current) {
        clearInterval(pollIntervalRef.current);
      }
    };
  }, []);

  const handlePull = async (e: React.MouseEvent<HTMLButtonElement>) => {
    if (!team || !lobby || lobby.status !== 'active' || pulling) return;

    setPulling(true);

    // Create particle explosion effect at cursor
    const rect = e.currentTarget.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    const newParticle = { id: particleIdRef.current++, x, y };
    setParticles(prev => [...prev, newParticle]);

    // Clean up particles
    setTimeout(() => {
      setParticles(prev => prev.filter(p => p.id !== newParticle.id));
    }, 800);

    // Optimistic local update
    const diff = team === 'left' ? -1 : 1;
    const nextPos = Math.max(-25, Math.min(25, lobby.position + diff));
    setLobby(prev => prev ? { ...prev, position: nextPos } : null);

    const res = await pullRope(team);
    if (res.success && res.lobby) {
      setLobby(res.lobby as LobbyState);
    }
    
    setPulling(false);
  };

  if (loading || !lobby) {
    return (
      <div className="bg-secondary/10 border border-border/50 rounded-3xl p-16 text-center space-y-6 shadow-2xl max-w-md mx-auto">
        <div className="w-12 h-12 border-4 border-primary border-t-transparent rounded-full animate-spin mx-auto" />
        <p className="text-gray-400 text-sm">Connecting to Tug Arena...</p>
      </div>
    );
  }

  // Position represented as a percentage offset from center (-25 to +25)
  // Left limit = 0%, Center = 50%, Right limit = 100%
  const WIN_LIMIT = 25;
  const flagPercentage = 50 + (lobby.position / WIN_LIMIT) * 50;

  return (
    <div className="space-y-6">
      <Link href="/marketplace" className="inline-flex items-center gap-2 text-sm text-gray-400 hover:text-white transition-colors mb-2">
        <ArrowLeft className="w-4 h-4" />
        Back to Local Finder
      </Link>

      <div className="bg-[#0e1422]/60 border border-border/50 rounded-3xl p-8 shadow-2xl relative overflow-hidden">
        {/* Synthwave grid background */}
        <div className="absolute inset-0 bg-[linear-gradient(to_bottom,rgba(99,102,241,0.05)_1px,transparent_1px),linear-gradient(to_right,rgba(99,102,241,0.05)_1px,transparent_1px)] bg-[size:24px_24px] pointer-events-none -z-10" />
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-96 h-96 bg-primary/10 rounded-full blur-3xl -z-10" />

        {/* Header */}
        <div className="text-center space-y-2 mb-10">
          <div className="inline-flex items-center gap-2 px-3 py-1 bg-primary/10 border border-primary/20 rounded-full text-xs font-semibold text-primary">
            <Zap className="w-3.5 h-3.5 animate-pulse text-amber-400" />
            Live Multiplayer Clicker
          </div>
          <h1 className="text-4xl font-extrabold tracking-tight bg-gradient-to-r from-rose-500 via-purple-400 to-blue-500 bg-clip-text text-transparent flex items-center justify-center gap-3">
            <Swords className="w-8 h-8 text-rose-500" />
            TUG-OF-WAR ARENA
          </h1>
          <p className="text-gray-400 text-sm max-w-sm mx-auto">
            Choose a team, spam click to pull the rope, and drag the flag to your side to win!
          </p>
        </div>

        {/* Global Scores */}
        <div className="grid grid-cols-2 gap-4 max-w-sm mx-auto mb-8 text-center bg-black/25 border border-border/30 rounded-2xl p-4">
          <div>
            <span className="text-[10px] uppercase font-bold text-rose-500 tracking-wider">Red Team Wins</span>
            <div className="text-3xl font-extrabold text-rose-500 mt-1 flex justify-center items-center gap-1.5">
              <Trophy className="w-5 h-5 text-amber-500 shrink-0" />
              {lobby.team_left_score}
            </div>
          </div>
          <div className="border-l border-border/30">
            <span className="text-[10px] uppercase font-bold text-blue-500 tracking-wider">Blue Team Wins</span>
            <div className="text-3xl font-extrabold text-blue-500 mt-1 flex justify-center items-center gap-1.5">
              <Trophy className="w-5 h-5 text-amber-500 shrink-0" />
              {lobby.team_right_score}
            </div>
          </div>
        </div>

        {/* Visual Tug-of-War Rope */}
        <div className="my-14 space-y-4">
          <div className="flex justify-between text-xs font-bold px-2 text-muted-foreground">
            <span className="text-rose-500">RED WIN ZONE</span>
            <span className="text-blue-500">BLUE WIN ZONE</span>
          </div>

          <div className="relative h-6 bg-[#161c2a] border border-border/50 rounded-full flex items-center p-1 shadow-inner overflow-hidden">
            {/* The Rope */}
            <div className="absolute inset-x-4 h-2 bg-gradient-to-r from-rose-500/20 via-yellow-600/30 to-blue-500/20 rounded-full" />
            
            {/* Center Line Marker */}
            <div className="absolute left-1/2 -translate-x-1/2 w-1.5 h-full bg-border" />

            {/* Left/Right Win thresholds indicators */}
            <div className="absolute left-[5%] w-1 h-full bg-rose-500/35" />
            <div className="absolute right-[5%] w-1 h-full bg-blue-500/35" />

            {/* Flag / Anchor */}
            <div 
              style={{ left: `${flagPercentage}%` }} 
              className="absolute -translate-x-1/2 w-8 h-10 bg-gradient-to-b from-amber-400 to-amber-500 border-2 border-white rounded-lg shadow-2xl flex items-center justify-center transition-all duration-150 ease-out z-10"
            >
              <Zap className="w-4 h-4 text-black animate-pulse" />
            </div>
          </div>
        </div>

        {/* Game State Overlay */}
        {lobby.status !== 'active' && (
          <div className="text-center p-6 bg-secondary/15 border border-border/50 rounded-2xl mb-8 animate-bounce">
            <h3 className="text-2xl font-bold text-amber-400">
              {lobby.status === 'left_won' ? '🔴 RED TEAM WINS MATCH!' : '🔵 BLUE TEAM WINS MATCH!'}
            </h3>
            <p className="text-xs text-gray-400 mt-1">Starting next round on the next pull...</p>
          </div>
        )}

        {/* Team Selection or Game Controls */}
        {!team ? (
          /* Selection Screen */
          <div className="space-y-4 max-w-md mx-auto">
            <h3 className="text-center text-xs font-bold uppercase tracking-wider text-gray-400">Select Your Stance</h3>
            <div className="grid grid-cols-2 gap-4">
              <button
                onClick={() => setTeam('left')}
                className="bg-rose-500/10 hover:bg-rose-500/20 border border-rose-500/30 rounded-2xl p-6 text-center space-y-2 hover:scale-105 transition-all text-rose-500"
              >
                <div className="font-extrabold text-lg">RED TEAM</div>
                <div className="text-[10px] opacity-80 uppercase font-bold tracking-wider">Pull Left</div>
              </button>
              
              <button
                onClick={() => setTeam('right')}
                className="bg-blue-500/10 hover:bg-blue-500/20 border border-blue-500/30 rounded-2xl p-6 text-center space-y-2 hover:scale-105 transition-all text-blue-500"
              >
                <div className="font-extrabold text-lg">BLUE TEAM</div>
                <div className="text-[10px] opacity-80 uppercase font-bold tracking-wider">Pull Right</div>
              </button>
            </div>
          </div>
        ) : (
          /* Action Screen */
          <div className="space-y-6 text-center max-w-sm mx-auto">
            <div className="flex justify-between items-center bg-black/20 px-4 py-2.5 rounded-xl border border-border/30 text-xs">
              <span className="flex items-center gap-1.5 text-gray-400">
                <Users className="w-4 h-4 text-primary" />
                Stance: <strong className={team === 'left' ? 'text-rose-500' : 'text-blue-500'}>{team === 'left' ? 'RED TEAM' : 'BLUE TEAM'}</strong>
              </span>
              <button 
                onClick={() => setTeam(null)}
                className="text-primary hover:underline hover:text-primary/95 text-[10px] font-bold uppercase tracking-wider"
              >
                Switch Team
              </button>
            </div>

            {/* Giant Pull Button */}
            <button
              onClick={handlePull}
              disabled={lobby.status !== 'active'}
              className={`w-full py-8 text-2xl font-extrabold rounded-3xl transition-all transform active:scale-95 disabled:opacity-50 select-none shadow-2xl relative overflow-hidden ${
                team === 'left' 
                  ? 'bg-rose-500 hover:bg-rose-600 text-white shadow-rose-500/20' 
                  : 'bg-blue-500 hover:bg-blue-600 text-white shadow-blue-500/20'
              }`}
            >
              {pulling ? 'PULLING!' : 'PULL!'}
              
              {/* Click explosion particles */}
              {particles.map(p => (
                <span 
                  key={p.id}
                  style={{ left: p.x, top: p.y }}
                  className="absolute w-2 h-2 bg-white rounded-full animate-ping pointer-events-none scale-150"
                />
              ))}
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
