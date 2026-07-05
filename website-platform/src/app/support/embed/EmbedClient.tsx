'use client';

import { useState, useEffect, useRef } from 'react';
import { MessageCircle, X, Send, User, Mail, ShieldQuestion, HelpCircle } from 'lucide-react';
import { createSupportTicket, sendSupportMessage, fetchSupportMessages } from '../../dashboard/support/actions';

interface Message {
  id?: string;
  sender: string;
  content: string;
  created_at?: string;
}

export default function EmbedClient({ siteId }: { siteId: string }) {
  const [isOpen, setIsOpen] = useState(false);
  const [ticketId, setTicketId] = useState<string | null>(null);
  const [messages, setMessages] = useState<Message[]>([]);
  const [inputText, setInputText] = useState('');
  const [sending, setSending] = useState(false);

  // Setup Form
  const [hasDetails, setHasDetails] = useState(false);
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [loadingTicket, setLoadingTicket] = useState(false);

  const messagesEndRef = useRef<HTMLDivElement>(null);
  const pollIntervalRef = useRef<NodeJS.Timeout | null>(null);

  // Get or create Visitor Session ID
  const getSessionId = () => {
    if (typeof window === 'undefined') return '';
    let sid = localStorage.getItem('resolve_support_session_id');
    if (!sid) {
      sid = crypto.randomUUID();
      localStorage.setItem('resolve_support_session_id', sid);
    }
    return sid;
  };

  // Scroll to bottom
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  // Load existing ticket if it exists
  useEffect(() => {
    if (isOpen && siteId) {
      const checkExisting = async () => {
        const sid = getSessionId();
        const res = await createSupportTicket(siteId, sid);
        if (res.success && res.ticketId) {
          setTicketId(res.ticketId);
          setHasDetails(true);
          const msgs = await fetchSupportMessages(res.ticketId);
          setMessages(msgs);
        }
      };
      checkExisting();
    }
  }, [isOpen, siteId]);

  // Poll for replies from support
  useEffect(() => {
    if (isOpen && ticketId) {
      pollIntervalRef.current = setInterval(async () => {
        const dbMsgs = await fetchSupportMessages(ticketId);
        if (dbMsgs.length !== messages.length) {
          setMessages(dbMsgs);
        }
      }, 2000);
    } else {
      if (pollIntervalRef.current) {
        clearInterval(pollIntervalRef.current);
      }
    }

    return () => {
      if (pollIntervalRef.current) {
        clearInterval(pollIntervalRef.current);
      }
    };
  }, [isOpen, ticketId, messages.length]);

  const handleOpen = () => {
    setIsOpen(true);
    if (typeof window !== 'undefined' && window.parent) {
      window.parent.postMessage('open-support', '*');
    }
  };

  const handleClose = () => {
    setIsOpen(false);
    if (typeof window !== 'undefined' && window.parent) {
      window.parent.postMessage('close-support', '*');
    }
  };

  const handleStartTicket = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim() || !siteId) return;

    setLoadingTicket(true);
    const sid = getSessionId();
    const res = await createSupportTicket(siteId, sid, name, email);
    
    if (res.success && res.ticketId) {
      setTicketId(res.ticketId);
      setHasDetails(true);
      
      // Send initial welcome message
      await sendSupportMessage(res.ticketId, 'visitor', `Hi! I need help. (Visitor: ${name})`);
      const msgs = await fetchSupportMessages(res.ticketId);
      setMessages(msgs);
    } else {
      alert('Failed to start chat session. Please try again.');
    }
    setLoadingTicket(false);
  };

  const handleSendMessage = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!inputText.trim() || !ticketId || sending) return;

    setSending(true);
    const text = inputText;
    setInputText('');

    // Optimistically update
    const optMsg: Message = { sender: 'visitor', content: text };
    setMessages(prev => [...prev, optMsg]);

    const res = await sendSupportMessage(ticketId, 'visitor', text);
    if (!res.success) {
      alert('Failed to send message.');
    }

    setSending(false);
  };

  return (
    <div className="fixed inset-0 flex items-end justify-end pointer-events-none p-2 select-none">
      {/* Support Bubble */}
      {!isOpen && (
        <button
          onClick={handleOpen}
          className="w-14 h-14 bg-primary hover:bg-primary/95 text-white rounded-full flex items-center justify-center shadow-2xl transition-transform hover:scale-105 pointer-events-auto"
        >
          <HelpCircle className="w-7 h-7" />
        </button>
      )}

      {/* Chat Window */}
      {isOpen && (
        <div className="w-full h-full bg-[#0e1422]/95 backdrop-blur-md border border-border/50 rounded-2xl shadow-2xl flex flex-col overflow-hidden pointer-events-auto">
          {/* Header */}
          <div className="p-3 bg-primary text-white flex justify-between items-center shrink-0">
            <div className="flex items-center gap-2">
              <MessageCircle className="w-4 h-4" />
              <span className="font-bold text-xs">Live Support & Feedback</span>
            </div>
            <button onClick={handleClose} className="text-white/80 hover:text-white transition-colors">
              <X className="w-4.5 h-4.5" />
            </button>
          </div>

          {/* Body */}
          <div className="flex-grow overflow-hidden p-3 flex flex-col justify-between">
            {!hasDetails ? (
              /* Setup Form */
              <form onSubmit={handleStartTicket} className="space-y-3 my-auto w-full">
                <div className="text-center mb-1">
                  <ShieldQuestion className="w-8 h-8 text-primary mx-auto mb-1" />
                  <h4 className="font-bold text-xs text-white">How can we help?</h4>
                  <p className="text-gray-400 text-[10px] mt-0.5">Start a live support chat session.</p>
                </div>

                <div>
                  <label className="block text-[9px] uppercase font-bold text-gray-400 tracking-wider mb-0.5">Your Name</label>
                  <div className="relative">
                    <User className="w-3.5 h-3.5 text-gray-500 absolute left-2.5 top-1/2 -translate-y-1/2" />
                    <input 
                      type="text"
                      required
                      value={name}
                      onChange={(e) => setName(e.target.value)}
                      placeholder="Enter name"
                      className="w-full bg-[#121824] border border-border/50 rounded-lg pl-8 pr-2 py-1.5 text-[11px] text-white placeholder:text-gray-600 focus:outline-none focus:border-primary"
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-[9px] uppercase font-bold text-gray-400 tracking-wider mb-0.5">Email (Optional)</label>
                  <div className="relative">
                    <Mail className="w-3.5 h-3.5 text-gray-500 absolute left-2.5 top-1/2 -translate-y-1/2" />
                    <input 
                      type="email"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      placeholder="name@example.com"
                      className="w-full bg-[#121824] border border-border/50 rounded-lg pl-8 pr-2 py-1.5 text-[11px] text-white placeholder:text-gray-600 focus:outline-none focus:border-primary"
                    />
                  </div>
                </div>

                <button
                  type="submit"
                  disabled={loadingTicket}
                  className="w-full bg-primary hover:bg-primary/95 text-white font-semibold py-1.5 rounded-lg text-[10px] transition-colors disabled:opacity-50"
                >
                  {loadingTicket ? 'Starting Chat...' : 'Start Chat'}
                </button>
              </form>
            ) : (
              /* Chat Log & Message Feed */
              <div className="flex-grow flex flex-col justify-between h-full overflow-hidden">
                <div className="flex-grow overflow-y-auto space-y-2.5 pr-1 text-[11px] pb-2">
                  {messages.length === 0 && (
                    <div className="text-center text-gray-400 py-10">
                      Sending support ticket details...
                    </div>
                  )}
                  {messages.map((msg, index) => {
                    const isMe = msg.sender === 'visitor';
                    return (
                      <div key={index} className={`flex ${isMe ? 'justify-end' : 'justify-start'}`}>
                        <div className={`max-w-[85%] rounded-xl px-2.5 py-1.5 ${
                          isMe ? 'bg-primary text-white rounded-tr-none' : 'bg-[#182030] border border-border/50 text-white rounded-tl-none'
                        }`}>
                          <p className="leading-relaxed">{msg.content}</p>
                        </div>
                      </div>
                    );
                  })}
                  <div ref={messagesEndRef} />
                </div>

                {/* Input Area */}
                <form onSubmit={handleSendMessage} className="flex gap-2 border-t border-border/20 pt-2 shrink-0">
                  <input
                    type="text"
                    value={inputText}
                    onChange={(e) => setInputText(e.target.value)}
                    placeholder="Type message..."
                    className="flex-grow bg-[#121824] border border-border/50 rounded-lg px-2.5 py-1.5 text-[11px] text-white focus:outline-none focus:border-primary"
                  />
                  <button
                    type="submit"
                    disabled={!inputText.trim() || sending}
                    className="bg-primary hover:bg-primary/95 text-white w-7 h-7 rounded-lg flex items-center justify-center shrink-0 disabled:opacity-50 transition-colors"
                  >
                    <Send className="w-3 h-3" />
                  </button>
                </form>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
