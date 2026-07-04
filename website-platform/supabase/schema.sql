-- Create a table for users' generated websites
CREATE TABLE public.sites (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  url TEXT UNIQUE,
  industry TEXT,
  status TEXT DEFAULT 'Draft',
  prompt TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create a table for chatbot configurations
CREATE TABLE public.chatbot_configs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  site_id UUID REFERENCES public.sites(id) ON DELETE CASCADE UNIQUE,
  theme_color TEXT DEFAULT '#3b82f6',
  welcome_message TEXT DEFAULT 'Hi there! How can I help you today?',
  system_prompt TEXT,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security (RLS)
ALTER TABLE public.sites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chatbot_configs ENABLE ROW LEVEL SECURITY;

-- Policies for 'sites' table
CREATE POLICY "Users can view their own sites"
ON public.sites FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own sites"
ON public.sites FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own sites"
ON public.sites FOR UPDATE
TO authenticated
USING (auth.uid() = user_id);

-- Policies for 'chatbot_configs' table
CREATE POLICY "Users can view chatbot configs for their sites"
ON public.chatbot_configs FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.sites
    WHERE sites.id = chatbot_configs.site_id
    AND sites.user_id = auth.uid()
  )
);

CREATE POLICY "Users can insert chatbot configs for their sites"
ON public.chatbot_configs FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.sites
    WHERE sites.id = chatbot_configs.site_id
    AND sites.user_id = auth.uid()
  )
);

-- PHASE 3 UPDATES

-- Add social tracking to sites
ALTER TABLE public.sites ADD COLUMN IF NOT EXISTS likes_count INTEGER DEFAULT 0;
ALTER TABLE public.sites ADD COLUMN IF NOT EXISTS shares_count INTEGER DEFAULT 0;

-- Add CRM config to chatbots
ALTER TABLE public.chatbot_configs ADD COLUMN IF NOT EXISTS crm_webhook_url TEXT;
ALTER TABLE public.chatbot_configs ADD COLUMN IF NOT EXISTS crm_provider TEXT DEFAULT 'custom';

-- Create table for likes (many-to-many relationship)
CREATE TABLE IF NOT EXISTS public.site_likes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  site_id UUID REFERENCES public.sites(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  UNIQUE(user_id, site_id) -- A user can only like a site once
);

-- Enable RLS for likes
ALTER TABLE public.site_likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view likes"
ON public.site_likes FOR SELECT
USING (true);

CREATE POLICY "Users can insert their own likes"
ON public.site_likes FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own likes"
ON public.site_likes FOR DELETE
TO authenticated
USING (auth.uid() = user_id);

CREATE POLICY "Users can update chatbot configs for their sites"
ON public.chatbot_configs FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.sites
    WHERE sites.id = chatbot_configs.site_id
    AND sites.user_id = auth.uid()
  )
);

-- PHASE 4: E-COMMERCE

-- Create products table for local businesses
CREATE TABLE IF NOT EXISTS public.products (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  site_id UUID REFERENCES public.sites(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  image_url TEXT,
  stock INTEGER DEFAULT -1, -- -1 means infinite stock
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS for products
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view products"
ON public.products FOR SELECT
USING (true);

CREATE POLICY "Users can insert products for their sites"
ON public.products FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.sites
    WHERE sites.id = products.site_id
    AND sites.user_id = auth.uid()
  )
);

CREATE POLICY "Users can update products for their sites"
ON public.products FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.sites
    WHERE sites.id = products.site_id
    AND sites.user_id = auth.uid()
  )
);

CREATE POLICY "Users can delete products for their sites"
ON public.products FOR DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.sites
    WHERE sites.id = products.site_id
    AND sites.user_id = auth.uid()
  )
);

-- PHASE 5: LIVE AI GENERATION
ALTER TABLE public.sites ADD COLUMN IF NOT EXISTS html_content TEXT;

-- PHASE 6: CRM & ANALYTICS
CREATE TABLE IF NOT EXISTS public.crm_leads (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    site_id UUID REFERENCES public.sites(id) ON DELETE CASCADE,
    name TEXT,
    email TEXT,
    transcript TEXT,
    status TEXT DEFAULT 'New',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.crm_leads ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view leads for their sites" ON public.crm_leads FOR SELECT TO authenticated USING (
    EXISTS (SELECT 1 FROM public.sites WHERE sites.id = crm_leads.site_id AND sites.user_id = auth.uid())
);

CREATE POLICY "Users can update leads for their sites" ON public.crm_leads FOR UPDATE TO authenticated USING (
    EXISTS (SELECT 1 FROM public.sites WHERE sites.id = crm_leads.site_id AND sites.user_id = auth.uid())
);

CREATE POLICY "Anyone can insert leads" ON public.crm_leads FOR INSERT WITH CHECK (true);

CREATE TABLE IF NOT EXISTS public.site_analytics (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    site_id UUID REFERENCES public.sites(id) ON DELETE CASCADE,
    date DATE DEFAULT CURRENT_DATE,
    page_views INTEGER DEFAULT 0,
    unique_visitors INTEGER DEFAULT 0,
    UNIQUE(site_id, date)
);

ALTER TABLE public.site_analytics ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view analytics for their sites" ON public.site_analytics FOR SELECT TO authenticated USING (
    EXISTS (SELECT 1 FROM public.sites WHERE sites.id = site_analytics.site_id AND sites.user_id = auth.uid())
);

CREATE POLICY "Anyone can insert analytics" ON public.site_analytics FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update analytics" ON public.site_analytics FOR UPDATE USING (true);

-- PHASE 7: CUSTOM DOMAINS
ALTER TABLE public.sites ADD COLUMN IF NOT EXISTS custom_domain TEXT UNIQUE;

-- PHASE 9: INVENTORY MANAGEMENT
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;
ALTER TABLE public.sites ADD COLUMN IF NOT EXISTS location TEXT DEFAULT 'Seattle, WA';

-- PHASE 10: DELIVERY DRIVER NETWORK
CREATE TABLE IF NOT EXISTS public.driver_applications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    vehicle_type TEXT NOT NULL,
    location TEXT NOT NULL,
    preferred_site_id UUID REFERENCES public.sites(id) ON DELETE SET NULL,
    status TEXT DEFAULT 'Pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.driver_applications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view driver applications for their sites" ON public.driver_applications FOR SELECT TO authenticated USING (
    preferred_site_id IS NULL OR EXISTS (SELECT 1 FROM public.sites WHERE sites.id = driver_applications.preferred_site_id AND sites.user_id = auth.uid())
);

CREATE POLICY "Users can update driver applications for their sites" ON public.driver_applications FOR UPDATE TO authenticated USING (
    preferred_site_id IS NULL OR EXISTS (SELECT 1 FROM public.sites WHERE sites.id = driver_applications.preferred_site_id AND sites.user_id = auth.uid())
);

CREATE POLICY "Anyone can insert driver applications" ON public.driver_applications FOR INSERT WITH CHECK (true);

-- PHASE 11: DEBATE ARENA (OMEGLE-STYLE)
CREATE TABLE IF NOT EXISTS public.debate_rooms (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  topic TEXT NOT NULL,
  category TEXT DEFAULT 'gaming', -- politics, gaming
  status TEXT DEFAULT 'active', -- active, finished
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.debate_messages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  room_id UUID REFERENCES public.debate_rooms(id) ON DELETE CASCADE,
  sender TEXT NOT NULL, -- 'User1', 'User2', or 'System'
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.debate_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.debate_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can access debate rooms" ON public.debate_rooms FOR SELECT USING (true);
CREATE POLICY "Anyone can insert debate rooms" ON public.debate_rooms FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can access debate messages" ON public.debate_messages FOR SELECT USING (true);
CREATE POLICY "Anyone can insert debate messages" ON public.debate_messages FOR INSERT WITH CHECK (true);

-- PHASE 12: LIVE CHAT SUPPORT
CREATE TABLE IF NOT EXISTS public.support_tickets (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  site_id UUID REFERENCES public.sites(id) ON DELETE CASCADE,
  visitor_session_id TEXT NOT NULL,
  visitor_name TEXT,
  visitor_email TEXT,
  status TEXT DEFAULT 'open',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.support_messages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  ticket_id UUID REFERENCES public.support_tickets(id) ON DELETE CASCADE,
  sender TEXT NOT NULL, -- 'visitor' or 'agent'
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.support_tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.support_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view support tickets for their sites" ON public.support_tickets FOR SELECT TO authenticated USING (
  EXISTS (SELECT 1 FROM public.sites WHERE sites.id = support_tickets.site_id AND sites.user_id = auth.uid())
);

CREATE POLICY "Users can update support tickets for their sites" ON public.support_tickets FOR UPDATE TO authenticated USING (
  EXISTS (SELECT 1 FROM public.sites WHERE sites.id = support_tickets.site_id AND sites.user_id = auth.uid())
);

CREATE POLICY "Anyone can insert support tickets" ON public.support_tickets FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can select support tickets" ON public.support_tickets FOR SELECT USING (true);

CREATE POLICY "Users can view support messages for their tickets" ON public.support_messages FOR SELECT TO authenticated USING (
  EXISTS (
    SELECT 1 FROM public.support_tickets
    JOIN public.sites ON sites.id = support_tickets.site_id
    WHERE support_tickets.id = support_messages.ticket_id
    AND sites.user_id = auth.uid()
  )
);

CREATE POLICY "Users can insert support messages for their tickets" ON public.support_messages FOR INSERT TO authenticated WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.support_tickets
    JOIN public.sites ON sites.id = support_tickets.site_id
    WHERE support_tickets.id = support_messages.ticket_id
    AND sites.user_id = auth.uid()
  )
);

CREATE POLICY "Anyone can insert support messages" ON public.support_messages FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can select support messages" ON public.support_messages FOR SELECT USING (true);

-- PHASE 13: ARCADE & TUG LOBBIES
CREATE TABLE IF NOT EXISTS public.tug_lobbies (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  position INTEGER DEFAULT 0, -- -50 to +50
  team_left_score INTEGER DEFAULT 0,
  team_right_score INTEGER DEFAULT 0,
  status TEXT DEFAULT 'active',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.tug_lobbies ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can select tug lobbies" ON public.tug_lobbies FOR SELECT USING (true);
CREATE POLICY "Anyone can update tug lobbies" ON public.tug_lobbies FOR UPDATE USING (true);
CREATE POLICY "Anyone can insert tug lobbies" ON public.tug_lobbies FOR INSERT WITH CHECK (true);

-- Insert a default lobby if not exists
INSERT INTO public.tug_lobbies (id, name, position) VALUES ('00000000-0000-0000-0000-000000000000', 'Tug Arena', 0) ON CONFLICT (id) DO NOTHING;
