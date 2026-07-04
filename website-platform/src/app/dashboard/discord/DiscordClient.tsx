'use client';

import { useState } from 'react';
import { Hash, Volume2, Users, Compass, Plus, Send, Download, Bot, ChevronDown, HelpCircle, Inbox, Bell, Pin } from 'lucide-react';
import { generateDiscordServer, type DiscordServerStructure } from './actions';

export default function DiscordClient() {
  const [prompt, setPrompt] = useState('');
  const [loading, setLoading] = useState(false);
  const [server, setServer] = useState<DiscordServerStructure | null>(null);
  const [activeChannel, setActiveChannel] = useState<string>('general');
  const [messages, setMessages] = useState<{ id: string; user: string; content: string; time: string; bot?: boolean; roleColor?: string }[]>([]);
  const [chatInput, setChatInput] = useState('');

  const handleGenerate = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!prompt.trim()) return;
    setLoading(true);
    
    const res = await generateDiscordServer(prompt);
    if (res.success && res.data) {
      setServer(res.data);
      // Set active channel to first text channel
      const firstTextChannel = res.data.categories
        .flatMap(c => c.channels)
        .find(ch => ch.type === 'text');
      
      if (firstTextChannel) {
        setActiveChannel(firstTextChannel.name);
      }
      
      // Populate welcome messages
      setMessages([
        {
          id: '1',
          user: 'ResolveBot',
          content: res.data.welcomeMessage,
          time: 'Today at 6:33 AM',
          bot: true,
          roleColor: '#3b82f6'
        }
      ]);
    }
    setLoading(false);
  };

  const handleSendChat = (e: React.FormEvent) => {
    e.preventDefault();
    if (!chatInput.trim()) return;
    
    setMessages(prev => [
      ...prev,
      {
        id: Date.now().toString(),
        user: 'You (Owner)',
        content: chatInput,
        time: 'Today at ' + new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
        roleColor: '#ff0055'
      }
    ]);
    setChatInput('');
  };

  const exportJSON = () => {
    if (!server) return;
    const jsonString = `data:text/json;charset=utf-8,${encodeURIComponent(JSON.stringify(server, null, 2))}`;
    const downloadAnchorNode = document.createElement('a');
    downloadAnchorNode.setAttribute('href', jsonString);
    downloadAnchorNode.setAttribute('download', `${server.serverName.toLowerCase().replace(/\s+/g, '-')}-blueprint.json`);
    document.body.appendChild(downloadAnchorNode);
    downloadAnchorNode.click();
    downloadAnchorNode.remove();
  };

  // If server is not generated yet, show the prompt configuration landing
  if (!server) {
    return (
      <div className="h-full flex flex-col items-center justify-center p-8 bg-[#313338] text-white">
        <div className="max-w-md w-full text-center space-y-6">
          <div className="w-16 h-16 bg-[#5865F2] rounded-2xl flex items-center justify-center mx-auto shadow-lg shadow-[#5865F2]/20">
            <Compass className="w-9 h-9 text-white" />
          </div>
          
          <div>
            <h2 className="text-2xl font-bold mb-2">Create Your Discord Server</h2>
            <p className="text-sm text-gray-400">Describe the community you want to build (e.g. Esports Betting, GTA V RP, Local Coffee Shop) and let the AI draft your channels and roles.</p>
          </div>
          
          <form onSubmit={handleGenerate} className="space-y-4">
            <input 
              type="text" 
              placeholder="e.g. GTA V roleplay gang with a private lounge"
              value={prompt}
              onChange={(e) => setPrompt(e.target.value)}
              disabled={loading}
              className="w-full bg-[#1e1f22] border border-[#1e1f22] rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-[#5865F2] transition-colors placeholder:text-gray-600 text-white"
            />
            
            <button
              type="submit"
              disabled={loading || !prompt.trim()}
              className="w-full bg-[#5865F2] hover:bg-[#4752c4] text-white font-medium py-3 rounded-xl text-sm transition-colors disabled:opacity-50"
            >
              {loading ? 'Crafting Server Blueprint...' : 'Generate Discord Server'}
            </button>
          </form>
        </div>
      </div>
    );
  }

  return (
    <div className="h-full flex text-white select-none overflow-hidden bg-[#313338] font-sans">
      {/* 1. Leftmost Server list bar */}
      <div className="w-[72px] bg-[#1e1f22] flex flex-col items-center py-3 gap-2 shrink-0">
        <div className="w-12 h-12 rounded-full bg-[#5865F2] flex items-center justify-center text-white cursor-pointer hover:rounded-2xl transition-all">
          <Bot className="w-6 h-6" />
        </div>
        <div className="w-8 h-[2px] bg-[#35363c] rounded my-1" />
        <div className="w-12 h-12 rounded-2xl bg-[#313338] text-[#5865F2] border-2 border-[#5865F2] flex items-center justify-center font-bold text-sm select-none cursor-pointer">
          {server.iconText}
        </div>
        <button 
          onClick={() => setServer(null)}
          className="w-12 h-12 rounded-full bg-[#313338] hover:bg-[#23a55a] text-[#23a55a] hover:text-white flex items-center justify-center cursor-pointer hover:rounded-2xl transition-all"
        >
          <Plus className="w-6 h-6" />
        </button>
      </div>

      {/* 2. Channels Sidebar */}
      <div className="w-60 bg-[#2b2d31] flex flex-col shrink-0 overflow-hidden">
        {/* Header */}
        <div className="h-12 border-b border-[#1f2023] px-4 flex items-center justify-between font-bold text-sm shadow-sm cursor-pointer hover:bg-[#35373c] transition-colors">
          <span className="truncate">{server.serverName}</span>
          <ChevronDown className="w-4 h-4 text-gray-400" />
        </div>
        
        {/* Channel list */}
        <div className="flex-grow overflow-y-auto px-2 py-4 space-y-4">
          {server.categories.map((cat, idx) => (
            <div key={idx} className="space-y-0.5">
              <div className="text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2 py-1 flex items-center justify-between">
                <span>{cat.name}</span>
                <Plus className="w-3 h-3 hover:text-white cursor-pointer" />
              </div>
              {cat.channels.map((chan, cIdx) => (
                <button
                  key={cIdx}
                  onClick={() => chan.type === 'text' && setActiveChannel(chan.name)}
                  className={`w-full flex items-center gap-1.5 px-2 py-1.5 rounded text-sm transition-colors ${
                    activeChannel === chan.name && chan.type === 'text'
                      ? 'bg-[#35373c] text-white' 
                      : 'text-gray-400 hover:bg-[#35373c]/50 hover:text-gray-200'
                  }`}
                >
                  {chan.type === 'text' ? (
                    <Hash className="w-4 h-4 text-gray-400" />
                  ) : (
                    <Volume2 className="w-4 h-4 text-gray-400" />
                  )}
                  <span className="truncate">{chan.name.toLowerCase().replace(/\s+/g, '-')}</span>
                </button>
              ))}
            </div>
          ))}
        </div>

        {/* User bar */}
        <div className="h-14 bg-[#232428] px-2 flex items-center justify-between shrink-0">
          <div className="flex items-center gap-2">
            <div className="relative">
              <div className="w-8 h-8 rounded-full bg-[#ff0055] flex items-center justify-center font-bold text-xs text-white">
                ME
              </div>
              <div className="absolute bottom-0 right-0 w-2.5 h-2.5 bg-[#23a55a] rounded-full border-2 border-[#232428]" />
            </div>
            <div className="leading-tight">
              <div className="text-xs font-bold truncate">Server Owner</div>
              <div className="text-[10px] text-gray-400">#0001</div>
            </div>
          </div>
          <button 
            onClick={exportJSON}
            className="p-2 hover:bg-[#35373c] rounded text-gray-400 hover:text-white transition-colors flex items-center gap-1.5 text-xs font-semibold"
            title="Export Blueprint JSON"
          >
            <Download className="w-4 h-4" />
            Export
          </button>
        </div>
      </div>

      {/* 3. Main Chat view */}
      <div className="flex-grow flex flex-col bg-[#313338] min-w-0">
        {/* Header */}
        <div className="h-12 border-b border-[#1f2023] px-4 flex items-center justify-between shadow-sm shrink-0">
          <div className="flex items-center gap-2 font-bold text-sm">
            <Hash className="w-5 h-5 text-gray-400" />
            <span>{activeChannel}</span>
            <span className="text-xs font-normal text-gray-400 border-l border-gray-600 pl-3">Welcome to #{activeChannel}!</span>
          </div>
          
          <div className="flex items-center gap-4 text-gray-400">
            <Bell className="w-5 h-5 hover:text-white cursor-pointer" />
            <Pin className="w-5 h-5 hover:text-white cursor-pointer" />
            <Users className="w-5 h-5 hover:text-white cursor-pointer" />
            <Inbox className="w-5 h-5 hover:text-white cursor-pointer" />
            <HelpCircle className="w-5 h-5 hover:text-white cursor-pointer" />
          </div>
        </div>
        
        {/* Messages */}
        <div className="flex-grow overflow-y-auto p-4 space-y-6">
          <div className="mt-8 border-b border-gray-700/30 pb-6">
            <div className="w-16 h-16 rounded-full bg-[#404249] flex items-center justify-center mb-4">
              <Hash className="w-10 h-10 text-white" />
            </div>
            <h1 className="text-2xl font-bold">Welcome to #{activeChannel}!</h1>
            <p className="text-gray-400 text-sm">This is the start of the #{activeChannel} channel.</p>
          </div>

          {messages.map((msg) => (
            <div key={msg.id} className="flex gap-4 group hover:bg-[#2e3035]/30 -mx-4 px-4 py-1">
              <div className="w-10 h-10 rounded-full bg-gray-600 shrink-0 flex items-center justify-center font-bold text-sm" style={{ backgroundColor: msg.roleColor }}>
                {msg.user.substring(0, 2).toUpperCase()}
              </div>
              <div className="leading-tight">
                <div className="flex items-baseline gap-2">
                  <span className="font-semibold text-sm hover:underline cursor-pointer" style={{ color: msg.roleColor }}>{msg.user}</span>
                  {msg.bot && (
                    <span className="bg-[#5865F2] text-white text-[9px] font-bold uppercase px-1 rounded flex items-center gap-0.5">
                      BOT
                    </span>
                  )}
                  <span className="text-[10px] text-gray-400">{msg.time}</span>
                </div>
                <p className="text-gray-200 text-sm mt-1 leading-normal whitespace-pre-wrap">{msg.content}</p>
              </div>
            </div>
          ))}
        </div>

        {/* Input */}
        <form onSubmit={handleSendChat} className="p-4 shrink-0 bg-[#313338]">
          <div className="bg-[#383a40] rounded-lg px-4 py-2.5 flex items-center gap-4">
            <Plus className="w-5 h-5 text-gray-400 hover:text-white cursor-pointer" />
            <input 
              type="text" 
              placeholder={`Message #${activeChannel}`}
              value={chatInput}
              onChange={(e) => setChatInput(e.target.value)}
              className="bg-transparent flex-grow text-sm focus:outline-none placeholder:text-gray-500 text-white"
            />
            <button type="submit" className="text-gray-400 hover:text-white transition-colors">
              <Send className="w-5 h-5" />
            </button>
          </div>
        </form>
      </div>

      {/* 4. Roles / Members Sidebar */}
      <div className="w-60 bg-[#2b2d31] border-l border-[#1f2023]/20 flex flex-col shrink-0 hidden lg:flex">
        <div className="p-4 border-b border-[#1f2023] font-bold text-xs uppercase tracking-wider text-gray-400">
          Server Roles ({server.roles.length})
        </div>
        <div className="flex-grow overflow-y-auto p-2 space-y-4">
          {server.roles.map((role, idx) => (
            <div key={idx} className="space-y-1">
              <div className="text-[11px] font-bold text-gray-400 uppercase tracking-wider px-2">
                {role.name} — 1
              </div>
              <div className="flex items-center gap-2 px-2 py-1.5 rounded hover:bg-[#35373c] cursor-pointer">
                <div className="relative">
                  <div className="w-8 h-8 rounded-full bg-gray-600 flex items-center justify-center font-bold text-xs" style={{ backgroundColor: role.color }}>
                    {role.name.substring(0, 2).toUpperCase()}
                  </div>
                  <div className="absolute bottom-0 right-0 w-2.5 h-2.5 bg-[#23a55a] rounded-full border-2 border-[#2b2d31]" />
                </div>
                <div className="text-sm font-semibold truncate" style={{ color: role.color }}>
                  {role.name === 'Owner' ? 'You' : `AI ${role.name}`}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
