"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { LayoutDashboard, Globe, MessageSquare, Megaphone, Settings, Link as LinkIcon, ShoppingCart, Bot, Inbox, Compass, Truck, LifeBuoy } from "lucide-react";
import { motion } from "framer-motion";

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex h-screen bg-background text-foreground overflow-hidden">
      {/* Sidebar */}
      <aside className="w-64 bg-secondary/30 border-r border-border flex flex-col hidden md:flex">
        <div className="p-6 border-b border-border/50">
          <Link href="/" className="font-bold text-xl tracking-tight flex items-center gap-2 text-primary hover:opacity-80 transition-opacity">
            <Bot className="w-6 h-6" />
            Resolve.bet
          </Link>
        </div>
        <nav className="flex-grow p-4 flex flex-col gap-2">
          <NavLink href="/dashboard" icon={<LayoutDashboard size={18} />} label="Overview" />
          <NavLink href="/dashboard/generate" icon={<Globe size={18} />} label="Generate Site" />
          <NavLink href="/dashboard/sites" icon={<Globe size={18} />} label="My Sites" />
          <NavLink href="/dashboard/store" icon={<ShoppingCart size={18} />} label="E-Commerce" />
          <NavLink href="/dashboard/inbox" icon={<Inbox size={18} />} label="CRM Inbox" />
          <NavLink href="/dashboard/drivers" icon={<Truck size={18} />} label="Delivery Drivers" />
          <NavLink href="/dashboard/support" icon={<LifeBuoy size={18} />} label="Support Inbox" />
          <NavLink href="/dashboard/chatbot" icon={<MessageSquare size={18} />} label="AI Chatbot" />
          <NavLink href="/dashboard/discord" icon={<Compass size={18} />} label="Discord Gen" />
          <NavLink href="/dashboard/integrations" icon={<LinkIcon size={18} />} label="Integrations" />
          <NavLink href="/devspace" icon={<Megaphone size={18} />} label="Marketing & Ads" />
          
          <div className="mt-auto">
            <NavLink href="/dashboard/settings" icon={<Settings size={18} />} label="Settings" />
          </div>
        </nav>
      </aside>

      {/* Main Content Area */}
      <main className="flex-1 overflow-y-auto relative">
        {/* Top Gradient Blur */}
        <div className="absolute top-0 inset-x-0 h-32 bg-gradient-to-b from-primary/5 to-transparent pointer-events-none" />
        
        <div className="relative z-10">
          {children}
        </div>
      </main>
    </div>
  );
}

function NavLink({ href, icon, label }: { href: string, icon: React.ReactNode, label: string }) {
  const pathname = usePathname();
  const isActive = pathname === href;

  return (
    <Link 
      href={href}
      className={`flex items-center gap-3 px-4 py-3 rounded-xl transition-all font-medium ${
        isActive 
          ? "bg-primary text-white shadow-md shadow-primary/20" 
          : "text-muted-foreground hover:bg-secondary/50 hover:text-foreground"
      }`}
    >
      {icon}
      {label}
      {isActive && (
        <motion.div 
          layoutId="active-nav-indicator"
          className="absolute left-0 w-1 h-8 bg-primary rounded-r-full"
          initial={false}
          transition={{ type: "spring", stiffness: 300, damping: 30 }}
        />
      )}
    </Link>
  );
}
