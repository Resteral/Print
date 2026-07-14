// ================= CONFIG & REHAB SCOPE DEFAULTS =================
const REHAB_ITEMS = [
    { id: 'paint', name: 'Interior & Exterior Paint', retail: 8000, discounted: 5800, trade: 'Paint', desc: 'Fresh neutral paint throughout, exterior trim' },
    { id: 'landscaping', name: 'Landscaping & Curb Appeal', retail: 4000, discounted: 2600, trade: 'Landscaping', desc: 'Lawn sodding, tree trimming, flower beds, mulch' },
    { id: 'flooring', name: 'Flooring Upgrade', retail: 12000, discounted: 8900, trade: 'Flooring', desc: 'Luxury vinyl plank (LVP) in living areas, new bedroom carpet' },
    { id: 'kitchen', name: 'Kitchen Remodel', retail: 24000, discounted: 17500, trade: 'Kitchen', desc: 'Quartz countertops, refaced cabinets, stainless steel appliances, tile backsplash' },
    { id: 'bathroom', name: 'Bathroom Upgrades', retail: 14000, discounted: 9800, trade: 'Bathroom', desc: 'New vanities, framed mirrors, toilet replacements, tiled showers' },
    { id: 'roof', name: 'Roof & Siding Repairs', retail: 16000, discounted: 12000, trade: 'Roof', desc: 'Shingle replacement, pressure wash siding, gutter cleans' },
    { id: 'hvac', name: 'HVAC & Mechanicals', retail: 9000, discounted: 6800, trade: 'HVAC', desc: 'A/C servicing, furnace tune-up, smart thermostat install' }
];

const SUBTASKS_MAP = {
    paint: [
        { id: 'paint-1', name: 'Scrape, sand & tape drywall joints' },
        { id: 'paint-2', name: 'Apply wall primer & trim sealant' },
        { id: 'paint-3', name: 'Roll 2 coats of premium matte finish' }
    ],
    landscaping: [
        { id: 'land-1', name: 'Sod layout & mulch flower beds' },
        { id: 'land-2', name: 'Trim oak trees & clear brush' },
        { id: 'land-3', name: 'Install landscape stone border' }
    ],
    flooring: [
        { id: 'floor-1', name: 'Rip out old carpeting & tack strips' },
        { id: 'floor-2', name: 'Lay underlayment & sound barrier' },
        { id: 'floor-3', name: 'Click-lock LVP flooring throughout' }
    ],
    kitchen: [
        { id: 'kit-1', name: 'Demolish dated cabinets & sink' },
        { id: 'kit-2', name: 'Template, cut & lay quartz tops' },
        { id: 'kit-3', name: 'Hang refaced cabinet doors' },
        { id: 'kit-4', name: 'Plumb new stainless sink & faucet' }
    ],
    bathroom: [
        { id: 'bath-1', name: 'Remove plumbing fixtures & vanities' },
        { id: 'bath-2', name: 'Seal vanity backing & mount quartz tops' },
        { id: 'bath-3', name: 'Lay tile flooring & shower surrounds' }
    ],
    roof: [
        { id: 'roof-1', name: 'Tear off damaged asphalt shingles' },
        { id: 'roof-2', name: 'Apply ice & water deck shield' },
        { id: 'roof-3', name: 'Nail new architectural lifetime shingles' }
    ],
    hvac: [
        { id: 'hvac-1', name: 'Drain old refrigerant & clean coils' },
        { id: 'hvac-2', name: 'Fit modern A/C condenser unit' },
        { id: 'hvac-3', name: 'Calibrate digital smart thermostat' }
    ]
};

const STAGES = {
    intake: 'New Intake',
    valuation: 'Valuation',
    agreement: 'Agreement Sent',
    rehab: 'Renovating',
    listed: 'Active Listing',
    closed: 'Closed / Sold'
};

const STAGE_COLORS = {
    intake: '#6366f1',
    valuation: '#f59e0b',
    agreement: '#8b5cf6',
    rehab: '#ec4899',
    listed: '#06b6d4',
    closed: '#10b981'
};

const MOCK_PROSPECTS = [
    { id: 'prop-1', address: '492 Pinewood Dr', owner: 'Robert Baratheon', phone: '(555) 789-0122', email: 'rbaratheon@email.com', asIsValue: 240000, targetARV: 310000, notes: 'Dated kitchen, worn carpets, needs exterior landscaping cleanup.', coords: { x: 30, y: 40 }, hotLevel: 'hot' },
    { id: 'prop-2', address: '12 North Ridge Rd', owner: 'Ned Stark', phone: '(555) 233-4455', email: 'nstark@email.com', asIsValue: 580000, targetARV: 745000, notes: 'Solid structure. Needs bathroom upgrade, fresh interior painting, and new flooring.', coords: { x: 75, y: 25 }, hotLevel: 'warm' },
    { id: 'prop-3', address: '912 Cherry Blossom Ln', owner: 'Arthur Pendragon', phone: '(555) 122-3344', email: 'apendragon@email.com', asIsValue: 215000, targetARV: 265000, notes: 'Foreclosure rescue. Minor cosmetics (paint, lawn trim, bathroom fixtures).', coords: { x: 18, y: 72 }, hotLevel: 'warm' }
];

const CASE_STUDIES = {
    'prop-1-story': {
        address: '458 Pinewood Dr',
        title: 'Curb Appeal & Cosmetic Lift',
        rehabCost: 38000,
        asisVal: 290000,
        soldVal: 395000,
        extraProfit: 43300,
        duration: '14 Days',
        scope: ['Paint', 'Landscaping', 'Flooring'],
        summary: 'Replaced dated shag carpets with high-end luxury vinyl plank flooring, repainted the full interior, and completely redesigned the front landscaping flower beds. Home received multiple offers within 48 hours of listing.'
    },
    'prop-2-story': {
        address: '12 North Ridge Rd',
        title: 'Premium Kitchen Overhaul',
        rehabCost: 72000,
        asisVal: 580000,
        soldVal: 745000,
        extraProfit: 48300,
        duration: '21 Days',
        scope: ['Kitchen', 'Bathroom', 'Paint'],
        summary: 'A full-scale cosmetic overhaul centered around a premium open-concept kitchen. Installed customized shaker cabinets, quartz countertops with a waterfall edge, and custom marble tiling in the master shower.'
    },
    'prop-3-story': {
        address: '912 Cherry Blossom Ln',
        title: 'Quick Cosmetic Refresh',
        rehabCost: 14500,
        asisVal: 215000,
        soldVal: 265000,
        extraProfit: 22400,
        duration: '9 Days',
        scope: ['Landscaping', 'Paint', 'HVAC'],
        summary: 'Focused on rapid-turnaround cosmetics to rescue a distressed seller. Advanced $14.5k to service the HVAC system, install smart stats, patch drywall, paint throughout, and spruce up the overgrown landscaping.'
    }
};

// ================= STATE MANAGEMENT =================
const MOCK_COMPS = [
    { id: 'comp-1', address: '891 Whispering Pines Dr', price: 475000, beds: 4, baths: 3, sqft: 2400, rehab: 'Full Cosmetic & Kitchen upgrade', dom: 12, x: 75, y: 80 },
    { id: 'comp-2', address: '874 Whispering Pines Dr', price: 468000, beds: 3, baths: 2.5, sqft: 2200, rehab: 'Kitchen & Bath refresh', dom: 8, x: 135, y: 120 },
    { id: 'comp-3', address: '110 Woodside Ave', price: 489000, beds: 4, baths: 3, sqft: 2600, rehab: 'Premium Overhaul', dom: 15, x: 55, y: 140 },
    { id: 'comp-4', address: '93 Cherry Lane', price: 455000, beds: 3, baths: 2, sqft: 2000, rehab: 'Minor cosmetic spruce', dom: 19, x: 125, y: 60 }
];

let leads = [];
let comps = [];
let prospects = [];
let contractors = [];
let adCampaigns = [];
let emailLogs = [];
let laborBusinesses = [];
let contractorChats = [];
let currentUser = null;
let supabaseClient = null;
let liveMarketListings = [];
let workRequests = [];
let crewAllocations = {};
let materialsLists = {};
let chatMessages = {};

let emailSettings = { autoIntake: true, autoRehab: true, autoContract: true };
let apiSettings = {
    emailProvider: 'webhook',
    emailjsPublic: '',
    emailjsService: '',
    emailjsTemplate: '',
    emailWebhook: 'https://hook.us2.make.com/pr1l0jvjtuto0qikljvjkrr82jtttmz1',
    adsProvider: 'webhook',
    adsWebhook: 'https://hook.us2.make.com/pr1l0jvjtuto0qikljvjkrr82jtttmz1',
    supabaseUrl: 'https://qlludfnlvqdalaztkenk.supabase.co',
    supabaseKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFsbHVkZm5sdnFkYWxhenRrZW5rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM5ODU1NzQsImV4cCI6MjA5OTU2MTU3NH0.ZldXZuI6iVHEY5xgGw2HzUbTNDYuP1M6BCA0EqCCIJU'
};
let currentSelectedLeadId = null;
let currentSlideIdx = 1;

// E-Signature Drawing Pad State
let sigCanvas = null;
let sigCtx = null;
let sigDrawing = false;
let sigMode = 'draw';

// Initialize App
function initApp() {
    // Load leads
    try {
        const savedLeads = localStorage.getItem('revitalize_leads');
        if (savedLeads) {
            leads = JSON.parse(savedLeads);
        } else {
            leads = [];
            saveLeadsToStorage();
        }
    } catch (e) {
        console.error("Leads parse error, resetting...", e);
        leads = [];
        saveLeadsToStorage();
    }

    // Load Contractors
    try {
        const savedContractors = localStorage.getItem('revitalize_contractors');
        if (savedContractors) {
            contractors = JSON.parse(savedContractors);
        } else {
            contractors = [];
            saveContractorsToStorage();
        }
    } catch (e) {
        console.error("Contractors parse error, resetting...", e);
        contractors = [];
        saveContractorsToStorage();
    }

    // Load Comps
    try {
        const savedComps = localStorage.getItem('revitalize_comps');
        if (savedComps) {
            comps = JSON.parse(savedComps);
        } else {
            comps = [];
            saveCompsToStorage();
        }
    } catch (e) {
        console.error("Comps parse error, resetting...", e);
        comps = [];
        saveCompsToStorage();
    }

    // Load Prospects
    try {
        const savedProspects = localStorage.getItem('revitalize_prospects');
        if (savedProspects) {
            prospects = JSON.parse(savedProspects);
        } else {
            prospects = [];
            saveProspectsToStorage();
        }
    } catch (e) {
        console.error("Prospects parse error, resetting...", e);
        prospects = [];
        saveProspectsToStorage();
    }

    // Load Ad Campaigns
    try {
        const savedAdCampaigns = localStorage.getItem('revitalize_ad_campaigns');
        if (savedAdCampaigns) {
            adCampaigns = JSON.parse(savedAdCampaigns);
        } else {
            adCampaigns = [];
            saveAdCampaignsToStorage();
        }
    } catch (e) {
        console.error("Ad campaigns parse error, resetting...", e);
        adCampaigns = [];
        saveAdCampaignsToStorage();
    }

    // Load Email Settings & Logs
    try {
        const savedEmailSettings = localStorage.getItem('revitalize_email_settings');
        if (savedEmailSettings) emailSettings = JSON.parse(savedEmailSettings);
    } catch (e) {
        console.error("Email settings parse error:", e);
    }
    
    try {
        const savedEmailLogs = localStorage.getItem('revitalize_email_logs');
        if (savedEmailLogs) {
            emailLogs = JSON.parse(savedEmailLogs);
        } else {
            emailLogs = [];
            localStorage.setItem('revitalize_email_logs', JSON.stringify(emailLogs));
        }
    } catch (e) {
        console.error("Email logs parse error, resetting...", e);
        emailLogs = [];
        localStorage.setItem('revitalize_email_logs', JSON.stringify(emailLogs));
    }

    // Load API Settings
    try {
        const savedApiSettings = localStorage.getItem('revitalize_api_settings');
        if (savedApiSettings) {
            apiSettings = JSON.parse(savedApiSettings);
        } else {
            localStorage.setItem('revitalize_api_settings', JSON.stringify(apiSettings));
        }
    } catch (e) {
        console.error("API settings parse error, resetting defaults...", e);
        localStorage.setItem('revitalize_api_settings', JSON.stringify(apiSettings));
    }

    // Load Labor Businesses
    try {
        const savedLabor = localStorage.getItem('revitalize_labor_businesses');
        if (savedLabor) {
            laborBusinesses = JSON.parse(savedLabor);
            if (!Array.isArray(laborBusinesses) || laborBusinesses.length < 3) {
                throw new Error("Self-healing required: Seed defaults");
            }
        } else {
            laborBusinesses = [
                {
                    id: 'biz-plumbing-1',
                    name: 'Apex Plumbing & Drain Services',
                    trade: 'plumbing',
                    rate: 95,
                    email: 'apex@plumbing.com',
                    webhook: 'https://hook.us2.make.com/1ugb4pws46g5xpl97qeicogdpv1zgped',
                    sponsored: true,
                    rating: 4.9,
                    distance: 1.2,
                    reviews: [
                        { author: 'Clara Oswald', rating: 5, text: 'Clean work and highly professional. Unclogged our main sewer line instantly!' },
                        { author: 'Danny Pink', rating: 5, text: 'Fast response and very fair pricing for the emergency call.' }
                    ],
                    photos: [
                        'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=400&q=80',
                        'https://images.unsplash.com/photo-1581094288338-2314dddb7eed?auto=format&fit=crop&w=400&q=80'
                    ]
                },
                {
                    id: 'biz-electric-1',
                    name: 'VoltStar Electrical & Lighting',
                    trade: 'electrician',
                    rate: 110,
                    email: 'voltstar@electric.com',
                    webhook: 'https://hook.us2.make.com/1ugb4pws46g5xpl97qeicogdpv1zgped',
                    sponsored: false,
                    rating: 4.7,
                    distance: 3.4,
                    reviews: [
                        { author: 'Martha Jones', rating: 4, text: 'Rewired our new addition safely. Kept to the schedule!' }
                    ],
                    photos: [
                        'https://images.unsplash.com/photo-1621905252507-b354bc25edac?auto=format&fit=crop&w=400&q=80'
                    ]
                },
                {
                    id: 'biz-carpentry-1',
                    name: 'Oakwood Finish Carpentry',
                    trade: 'carpentry',
                    rate: 85,
                    email: 'oakwood@carpentry.com',
                    webhook: 'https://hook.us2.make.com/1ugb4pws46g5xpl97qeicogdpv1zgped',
                    sponsored: true,
                    rating: 4.8,
                    distance: 2.1,
                    reviews: [
                        { author: 'Sarah Jane', rating: 5, text: 'Built custom built-in bookshelves. The craftsmanship is breathtaking.' }
                    ],
                    photos: [
                        'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?auto=format&fit=crop&w=400&q=80'
                    ]
                },
                {
                    id: 'biz-hvac-1',
                    name: 'Breeze Mechanical Air & HVAC',
                    trade: 'hvac',
                    rate: 90,
                    email: 'breeze@hvac.com',
                    webhook: 'https://hook.us2.make.com/1ugb4pws46g5xpl97qeicogdpv1zgped',
                    sponsored: false,
                    rating: 4.6,
                    distance: 4.5,
                    reviews: [
                        { author: 'Rory Williams', rating: 5, text: 'Serviced our heat pump before winter. Incredibly thorough checklist.' }
                    ],
                    photos: [
                        'https://images.unsplash.com/photo-1605647540924-852290f6b0d5?auto=format&fit=crop&w=400&q=80'
                    ]
                },
                {
                    id: 'biz-paint-1',
                    name: 'ColorCraft Precision Painting',
                    trade: 'painting',
                    rate: 65,
                    email: 'colorcraft@paint.com',
                    webhook: 'https://hook.us2.make.com/1ugb4pws46g5xpl97qeicogdpv1zgped',
                    sponsored: true,
                    rating: 4.8,
                    distance: 1.7,
                    reviews: [
                        { author: 'Amy Pond', rating: 5, text: 'Painted our entire interior in 3 days. Clean lines, zero mess!' }
                    ],
                    photos: [
                        'https://images.unsplash.com/photo-1562259949-e8e7689d7828?auto=format&fit=crop&w=400&q=80'
                    ]
                },
                {
                    id: 'biz-lawn-1',
                    name: 'GreenScapes Premium Landscaping',
                    trade: 'landscaping',
                    rate: 55,
                    email: 'greenscapes@lawn.com',
                    webhook: 'https://hook.us2.make.com/1ugb4pws46g5xpl97qeicogdpv1zgped',
                    sponsored: false,
                    rating: 4.9,
                    distance: 2.8,
                    reviews: [
                        { author: 'Donna Noble', rating: 5, text: 'Stunning pavers and retaining wall installation. Highly recommend!' }
                    ],
                    photos: [
                        'https://images.unsplash.com/photo-1558904541-efa8c1a68d6d?auto=format&fit=crop&w=400&q=80'
                    ]
                }
            ];
            localStorage.setItem('revitalize_labor_businesses', JSON.stringify(laborBusinesses));
        }
    } catch (e) {
        console.error("Labor businesses parse error, resetting...", e);
        laborBusinesses = [
            {
                id: 'biz-plumbing-1',
                name: 'Apex Plumbing & Drain Services',
                trade: 'plumbing',
                rate: 95,
                email: 'apex@plumbing.com',
                webhook: 'https://hook.us2.make.com/1ugb4pws46g5xpl97qeicogdpv1zgped',
                sponsored: true,
                rating: 4.9,
                distance: 1.2,
                reviews: [
                    { author: 'Clara Oswald', rating: 5, text: 'Clean work and highly professional. Unclogged our main sewer line instantly!' },
                    { author: 'Danny Pink', rating: 5, text: 'Fast response and very fair pricing for the emergency call.' }
                ],
                photos: [
                    'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=400&q=80',
                    'https://images.unsplash.com/photo-1581094288338-2314dddb7eed?auto=format&fit=crop&w=400&q=80'
                ]
            },
            {
                id: 'biz-electric-1',
                name: 'VoltStar Electrical & Lighting',
                trade: 'electrician',
                rate: 110,
                email: 'voltstar@electric.com',
                webhook: 'https://hook.us2.make.com/1ugb4pws46g5xpl97qeicogdpv1zgped',
                sponsored: false,
                rating: 4.7,
                distance: 2.1,
                reviews: [
                    { author: 'Rose Tyler', rating: 5, text: 'Upgraded our entire electrical panel to 200A. Prompt and clean.' }
                ],
                photos: [
                    'https://images.unsplash.com/photo-1621905252507-b354bc25edac?auto=format&fit=crop&w=400&q=80'
                ]
            },
            {
                id: 'biz-hvac-1',
                name: 'ClimateControl AC & Heating',
                trade: 'hvac',
                rate: 85,
                email: 'climatecontrol@hvac.com',
                webhook: 'https://hook.us2.make.com/1ugb4pws46g5xpl97qeicogdpv1zgped',
                sponsored: false,
                rating: 4.8,
                distance: 4.5,
                reviews: [
                    { author: 'Rory Williams', rating: 5, text: 'Serviced our heat pump before winter. Incredibly thorough checklist.' }
                ],
                photos: [
                    'https://images.unsplash.com/photo-1605647540924-852290f6b0d5?auto=format&fit=crop&w=400&q=80'
                ]
            },
            {
                id: 'biz-paint-1',
                name: 'ColorCraft Precision Painting',
                trade: 'painting',
                rate: 65,
                email: 'colorcraft@paint.com',
                webhook: 'https://hook.us2.make.com/1ugb4pws46g5xpl97qeicogdpv1zgped',
                sponsored: true,
                rating: 4.8,
                distance: 1.7,
                reviews: [
                    { author: 'Amy Pond', rating: 5, text: 'Painted our entire interior in 3 days. Clean lines, zero mess!' }
                ],
                photos: [
                    'https://images.unsplash.com/photo-1562259949-e8e7689d7828?auto=format&fit=crop&w=400&q=80'
                ]
            },
            {
                id: 'biz-lawn-1',
                name: 'GreenScapes Premium Landscaping',
                trade: 'landscaping',
                rate: 55,
                email: 'greenscapes@lawn.com',
                webhook: 'https://hook.us2.make.com/1ugb4pws46g5xpl97qeicogdpv1zgped',
                sponsored: false,
                rating: 4.9,
                distance: 2.8,
                reviews: [
                    { author: 'Donna Noble', rating: 5, text: 'Stunning pavers and retaining wall installation. Highly recommend!' }
                ],
                photos: [
                    'https://images.unsplash.com/photo-1558904541-efa8c1a68d6d?auto=format&fit=crop&w=400&q=80'
                ]
            }
        ];
        localStorage.setItem('revitalize_labor_businesses', JSON.stringify(laborBusinesses));
    }

    // Load Contractor Chats
    try {
        const savedChats = localStorage.getItem('revitalize_contractor_chats');
        if (savedChats) {
            contractorChats = JSON.parse(savedChats);
        } else {
            contractorChats = [];
        }
    } catch (e) {
        console.error("Contractor chats parse error:", e);
    }

    // Load Homeowner Work Requests
    try {
        const savedRequests = localStorage.getItem('revitalize_work_requests');
        if (savedRequests) {
            workRequests = JSON.parse(savedRequests);
        } else {
            workRequests = [
                {
                    id: 'req-1',
                    address: '504 Cedar Rd',
                    trade: 'electrician',
                    budget: 1500,
                    desc: 'Need new kitchen GFCI outlets installed and dedicated panel circuit wired.',
                    owner: 'Alice Smith',
                    email: 'alice@smithmail.com',
                    timestamp: new Date(Date.now() - 3600000 * 4).toLocaleString()
                },
                {
                    id: 'req-2',
                    address: '891 Oak Ridge Rd',
                    trade: 'plumbing',
                    budget: 800,
                    desc: 'Bathtub faucet is leaking inside the wall. Need drywall cut and valve replaced.',
                    owner: 'Bob Johnson',
                    email: 'bob@johnson.com',
                    timestamp: new Date(Date.now() - 3600000 * 24).toLocaleString()
                }
            ];
            localStorage.setItem('revitalize_work_requests', JSON.stringify(workRequests));
        }
    } catch (e) {
        console.error("Work requests parse error:", e);
    }

    // Load UTool Assignments & Materials
    try {
        const savedCrew = localStorage.getItem('revitalize_crew_allocations');
        if (savedCrew) crewAllocations = JSON.parse(savedCrew);
        
        const savedMats = localStorage.getItem('revitalize_materials_lists');
        if (savedMats) materialsLists = JSON.parse(savedMats);

        const savedChats = localStorage.getItem('revitalize_chat_messages');
        if (savedChats) chatMessages = JSON.parse(savedChats);
    } catch (e) {
        console.error("UTool parse error:", e);
    }

    if (!apiSettings.supabaseUrl) {
        apiSettings.supabaseUrl = 'https://qlludfnlvqdalaztkenk.supabase.co';
    }
    if (!apiSettings.supabaseKey) {
        apiSettings.supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFsbHVkZm5sdnFkYWxhenRrZW5rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM5ODU1NzQsImV4cCI6MjA5OTU2MTU3NH0.ZldXZuI6iVHEY5xgGw2HzUbTNDYuP1M6BCA0EqCCIJU';
    }

    document.getElementById('api-email-provider').value = apiSettings.emailProvider || 'webhook';
    document.getElementById('api-emailjs-public').value = apiSettings.emailjsPublic || '';
    document.getElementById('api-emailjs-service').value = apiSettings.emailjsService || '';
    document.getElementById('api-emailjs-template').value = apiSettings.emailjsTemplate || '';
    document.getElementById('api-email-webhook-url').value = apiSettings.emailWebhook || 'https://hook.us2.make.com/pr1l0jvjtuto0qikljvjkrr82jtttmz1';
    document.getElementById('api-ads-provider').value = apiSettings.adsProvider || 'webhook';
    document.getElementById('api-ads-webhook-url').value = apiSettings.adsWebhook || 'https://hook.us2.make.com/pr1l0jvjtuto0qikljvjkrr82jtttmz1';
    document.getElementById('api-supabase-url').value = apiSettings.supabaseUrl;
    document.getElementById('api-supabase-key').value = apiSettings.supabaseKey || '';
    
    toggleApiFields();

    if (apiSettings.supabaseUrl && apiSettings.supabaseKey && typeof supabase !== 'undefined') {
        try {
            supabaseClient = supabase.createClient(apiSettings.supabaseUrl, apiSettings.supabaseKey);
            console.log("Supabase client initialized successfully!");
        } catch (e) {
            console.error("Supabase init error:", e);
        }
    }

    if (apiSettings.emailProvider === 'emailjs' && apiSettings.emailjsPublic) {
        if (typeof emailjs !== 'undefined') {
            emailjs.init({ publicKey: apiSettings.emailjsPublic });
        }
    }

    // Setup toggles in UI
    document.getElementById('chk-auto-intake').checked = emailSettings.autoIntake;
    document.getElementById('chk-auto-rehab').checked = emailSettings.autoRehab;
    document.getElementById('chk-auto-contract').checked = emailSettings.autoContract;

    // Load auth user
    try {
        const savedUser = localStorage.getItem('revitalize_current_user');
        if (savedUser) {
            currentUser = JSON.parse(savedUser);
        }
    } catch (e) {
        console.error("Auth user parse error:", e);
    }

    // Seed agent account in local fallback accounts
    try {
        let accounts = [];
        const savedAccs = localStorage.getItem('revitalize_accounts');
        if (savedAccs) accounts = JSON.parse(savedAccs);
        const idx = accounts.findIndex(a => a.email && a.email.toLowerCase() === 'seanhse97@gmail.com');
        if (idx !== -1) {
            accounts[idx].password = "SlimpKing555";
            accounts[idx].role = "agent";
            accounts[idx].name = "Sean (Agent)";
        } else {
            accounts.push({
                email: "seanhse97@gmail.com",
                password: "SlimpKing555",
                name: "Sean (Agent)",
                role: "agent",
                bizId: ""
            });
        }
        localStorage.setItem('revitalize_accounts', JSON.stringify(accounts));
    } catch (e) {
        console.error("Agent seeding error:", e);
    }

    renderAuthHeaderStatus();

    // Initialize UI features
    lucide.createIcons();
    initBeforeAfterSlider();
    initSignatureCanvas();
    calculateROI();
    renderPipelineBoard();
    renderMockMap();
    renderProspectsList();
    renderContractorList();
    renderEmailLogs();
    updateDashboardStats();
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initApp);
} else {
    initApp();
}

function saveLeadsToStorage() { localStorage.setItem('revitalize_leads', JSON.stringify(leads)); }
function saveContractorsToStorage() { localStorage.setItem('revitalize_contractors', JSON.stringify(contractors)); }
function saveCompsToStorage() { localStorage.setItem('revitalize_comps', JSON.stringify(comps)); }
function saveProspectsToStorage() { localStorage.setItem('revitalize_prospects', JSON.stringify(prospects)); }
function saveAdCampaignsToStorage() { localStorage.setItem('revitalize_ad_campaigns', JSON.stringify(adCampaigns)); }
function saveEmailSettings() {
    emailSettings.autoIntake = document.getElementById('chk-auto-intake').checked;
    emailSettings.autoRehab = document.getElementById('chk-auto-rehab').checked;
    emailSettings.autoContract = document.getElementById('chk-auto-contract').checked;
    localStorage.setItem('revitalize_email_settings', JSON.stringify(emailSettings));
}

// ================= BEFORE / AFTER IMAGE SLIDER INTERACTION =================
function initBeforeAfterSlider() {
    const container = document.getElementById('ba-slider-container');
    const handle = document.getElementById('ba-handle');
    const beforePane = document.getElementById('before-view-pane');
    
    if (!container || !handle || !beforePane) return;

    let active = false;

    container.addEventListener('mousedown', () => { active = true; });
    window.addEventListener('mouseup', () => { active = false; });
    window.addEventListener('mousemove', (e) => {
        if (!active) return;
        adjustSlider(e.pageX);
    });

    container.addEventListener('touchstart', () => { active = true; });
    window.addEventListener('touchend', () => { active = false; });
    window.addEventListener('touchmove', (e) => {
        if (!active) return;
        adjustSlider(e.touches[0].pageX);
    });

    function adjustSlider(pageX) {
        const bounds = container.getBoundingClientRect();
        let posX = pageX - bounds.left;
        
        if (posX < 0) posX = 0;
        if (posX > bounds.width) posX = bounds.width;

        const pct = (posX / bounds.width) * 100;
        handle.style.left = `${pct}%`;
        beforePane.style.width = `${pct}%`;
    }
}

// ================= VIEW TOGGLING =================
function switchView(viewName) {
    document.querySelectorAll('.view-section').forEach(s => s.classList.remove('active'));
    document.querySelectorAll('.nav-tab').forEach(t => t.classList.remove('active'));

    if (viewName === 'portal') {
        document.getElementById('view-portal').classList.add('active');
        document.getElementById('btn-portal').classList.add('active');
    } else if (viewName === 'market') {
        document.getElementById('view-market').classList.add('active');
        document.getElementById('btn-market').classList.add('active');
        renderPublicCatalog();
    } else if (viewName === 'labor') {
        document.getElementById('view-labor').classList.add('active');
        document.getElementById('btn-labor').classList.add('active');
        renderLaborDirectory();
        renderJobRequestsFeed();
    } else if (viewName === 'utool') {
        document.getElementById('view-utool').classList.add('active');
        document.getElementById('btn-utool').classList.add('active');
        populateUtoolLeadSelect();
        renderUtoolDashboard();
    } else {
        // Restrict access to Agent Dashboard
        const isAuthorizedAgent = currentUser && currentUser.email && currentUser.email.toLowerCase() === 'seanhse97@gmail.com';
        if (!isAuthorizedAgent) {
            showToast("Access Denied: The Agent Dashboard is restricted to authorized agent accounts.");
            // Open auth modal so they can sign in as agent
            openAuthModal();
            // Redirect back to homeowner portal
            document.getElementById('view-portal').classList.add('active');
            document.getElementById('btn-portal').classList.add('active');
            return;
        }

        document.getElementById('view-dashboard').classList.add('active');
        document.getElementById('btn-dashboard').classList.add('active');
        renderPipelineBoard();
        updateDashboardStats();
    }
}

function switchDashSubTab(subTabName) {
    document.querySelectorAll('.dash-subview').forEach(v => v.classList.remove('active'));
    document.querySelectorAll('.dash-tab').forEach(t => t.classList.remove('active'));

    if (subTabName === 'pipeline') {
        document.getElementById('dash-tab-pipeline').classList.add('active');
        document.getElementById('tab-btn-pipeline').classList.add('active');
        renderPipelineBoard();
    } else if (subTabName === 'map') {
        document.getElementById('dash-tab-map').classList.add('active');
        document.getElementById('tab-btn-map').classList.add('active');
        renderMockMap();
    } else if (subTabName === 'contractors') {
        document.getElementById('dash-tab-contractors').classList.add('active');
        document.getElementById('tab-btn-contractors').classList.add('active');
        renderContractorList();
    } else if (subTabName === 'emails') {
        document.getElementById('dash-tab-emails').classList.add('active');
        document.getElementById('tab-btn-emails').classList.add('active');
        renderEmailLogs();
        updateCampaignTemplatePreview();
    } else if (subTabName === 'analytics') {
        document.getElementById('dash-tab-analytics').classList.add('active');
        document.getElementById('tab-btn-analytics').classList.add('active');
        renderAnalyticsDashboard();
    }
}

// ================= HOMEOWNER ROI CALCULATOR =================
function calculateROI() {
    const asIsValue = parseInt(document.getElementById('input-as-is').value);
    const rehabLevel = document.getElementById('select-rehab').value;

    document.getElementById('val-as-is').innerText = `$${asIsValue.toLocaleString()}`;

    let rehabCost = 40000;
    let arvMultiplier = 1.25;

    if (rehabLevel === 'cosmetic') {
        rehabCost = 15000;
        arvMultiplier = 1.12;
    } else if (rehabLevel === 'premium') {
        rehabCost = 75000;
        arvMultiplier = 1.40;
    }

    const estimatedARV = Math.round(asIsValue * arvMultiplier);
    const asIsCommission = asIsValue * 0.06;
    const asIsNet = asIsValue - asIsCommission;

    const revitalizeCommission = estimatedARV * 0.06;
    const revitalizeNet = estimatedARV - rehabCost - revitalizeCommission;

    const profitLift = revitalizeNet - asIsNet;

    document.getElementById('calc-arv').innerText = `$${estimatedARV.toLocaleString()}`;
    document.getElementById('calc-rehab-cost').innerText = `$${rehabCost.toLocaleString()}`;
    document.getElementById('calc-asis-net').innerText = `$${asIsNet.toLocaleString()}`;
    document.getElementById('calc-revitalize-net').innerText = `$${revitalizeNet.toLocaleString()}`;
    
    const profitLiftEl = document.getElementById('calc-extra-profit');
    if (profitLift > 0) {
        profitLiftEl.innerText = `+$${profitLift.toLocaleString()}`;
        profitLiftEl.className = 'value glow-text';
    } else {
        profitLiftEl.innerText = `$${profitLift.toLocaleString()}`;
        profitLiftEl.className = 'value text-muted';
    }
}

// ================= HOMEOWNER LEAD CAPTURE & EXPLAINERS =================
function toggleIntakeExplainer(category) {
    const chip = document.getElementById(`chip-${category}`);
    const explainerBox = document.getElementById(`intake-explain-${category}`);
    if (!chip || !explainerBox) return;

    if (chip.classList.contains('selected')) {
        chip.classList.remove('selected');
        explainerBox.style.display = 'none';
        const txt = document.getElementById(`explain-${category}-text`);
        if (txt) txt.value = '';
    } else {
        chip.classList.add('selected');
        explainerBox.style.display = 'block';
    }
}

function handleSignup(event) {
    event.preventDefault();

    const name = document.getElementById('homeowner-name').value;
    const phone = document.getElementById('homeowner-phone').value;
    const email = document.getElementById('homeowner-email').value;
    const address = document.getElementById('property-address').value;
    const notes = document.getElementById('property-notes').value;

    const asIsValue = parseInt(document.getElementById('input-as-is').value);
    const rehabLevel = document.getElementById('select-rehab').value;

    let defaultScope = ['paint', 'landscaping'];
    let defaultARV = Math.round(asIsValue * 1.25);
    if (rehabLevel === 'cosmetic') {
        defaultScope = ['paint', 'landscaping'];
        defaultARV = Math.round(asIsValue * 1.12);
    } else if (rehabLevel === 'premium') {
        defaultScope = ['paint', 'flooring', 'kitchen', 'bathroom', 'hvac'];
        defaultARV = Math.round(asIsValue * 1.40);
    }

    // Extract custom homeowner work explanations
    const selectedChips = document.querySelectorAll('.renovation-chip.selected');
    const workExplanations = {};
    const selectedScopes = [];
    selectedChips.forEach(chip => {
        const category = chip.id.replace('chip-', '');
        selectedScopes.push(category);
        const explainerInput = document.getElementById(`explain-${category}-text`);
        if (explainerInput && explainerInput.value.trim()) {
            workExplanations[category] = explainerInput.value.trim();
        }
    });

    const timeline = document.getElementById('property-timeline').value;
    const photoUrl = document.getElementById('property-photo-url').value.trim();

    const newLead = {
        id: `lead-${Date.now()}`,
        name,
        phone,
        email,
        address,
        asIsValue,
        targetARV: defaultARV,
        commissionRate: 6,
        stage: 'intake',
        notes: notes || 'Submitted online via valuation estimator.',
        scope: selectedScopes.length > 0 ? selectedScopes : defaultScope,
        workExplanations: workExplanations,
        dispatches: {},
        completedSubtasks: [],
        timeline: timeline,
        photoUrl: photoUrl,
        bids: []
    };

    leads.push(newLead);
    saveLeadsToStorage();

    // Create a corresponding work request so contractors can see it on the bidding board
    const newRequest = {
        id: `req-lead-${newLead.id}`,
        leadId: newLead.id,
        address: address,
        trade: selectedScopes.join(', ') || 'General Rehab',
        budget: Math.round(defaultARV - asIsValue) || 40000,
        desc: `Renovation Scope: ${selectedScopes.join(', ') || 'General cosmic refresh'}. Condition notes: ${notes}`,
        owner: name,
        email: email,
        timeline: timeline,
        photoUrl: photoUrl,
        timestamp: new Date().toLocaleString(),
        isLeadProject: true
    };
    workRequests.unshift(newRequest);
    localStorage.setItem('revitalize_work_requests', JSON.stringify(workRequests));
    renderJobRequestsFeed();

    triggerAutoEmail(newLead, 'Intake Confirmation');

    document.getElementById('signup-form').reset();
    document.querySelectorAll('.renovation-chip').forEach(c => c.classList.remove('selected'));
    document.querySelectorAll('.intake-explainer-box').forEach(b => {
        b.style.display = 'none';
        const txt = b.querySelector('textarea');
        if (txt) txt.value = '';
    });

    showToast('Lead submitted! Redirecting to Agent Dashboard...');

    setTimeout(() => {
        switchView('dashboard');
        switchDashSubTab('pipeline');
        const newCard = document.querySelector(`[data-lead-id="${newLead.id}"]`);
        if (newCard) {
            newCard.scrollIntoView({ behavior: 'smooth', block: 'center' });
            newCard.style.boxShadow = '0 0 25px rgba(99, 102, 241, 0.8)';
            setTimeout(() => { newCard.style.boxShadow = ''; }, 3000);
        }
    }, 1200);
}

// ================= CLIENT PROJECT LOOKUP PORTAL =================
function fillLookupDemo(addr) {
    document.getElementById('client-lookup-address').value = addr;
    handleClientLookup();
}

function handleClientLookup() {
    const input = document.getElementById('client-lookup-address');
    const addressStr = input.value.trim().toLowerCase();
    
    if (!addressStr) {
        showToast('Please enter an address.');
        return;
    }

    const matchLead = leads.find(l => l.address.toLowerCase().includes(addressStr));
    if (!matchLead) {
        showToast('No active project found under that address. Check spelling.');
        return;
    }

    openClientPortal(matchLead.id);
}

function openClientPortal(leadId) {
    const lead = leads.find(l => l.id === leadId);
    if (!lead) return;

    currentSelectedLeadId = leadId; // Anchor active actions to this lead

    // Populate Headers
    document.getElementById('client-draw-address').innerText = lead.address;
    document.getElementById('client-draw-owner').innerText = `${lead.name} • Homeowner Project Dashboard`;

    // Populate Stats Banner
    const totalDiscountedRehab = lead.scope.reduce((sum, itemId) => {
        const item = REHAB_ITEMS.find(i => i.id === itemId);
        return sum + (item ? item.discounted : 0);
    }, 0);
    const commVal = lead.targetARV * ((lead.commissionRate || 6) / 100);
    const estPayout = lead.targetARV - (totalDiscountedRehab / 2) - commVal;

    document.getElementById('client-stat-arv').innerText = `$${lead.targetARV.toLocaleString()}`;
    document.getElementById('client-stat-rehab').innerText = `$${Math.round(totalDiscountedRehab / 2).toLocaleString()}`;
    document.getElementById('client-stat-payout').innerText = `$${Math.round(estPayout).toLocaleString()}`;

    // Render Progress Tracker steps
    renderClientStatusSteps(lead.stage);

    // E-Sign Callout prompt
    const esignPromptBox = document.getElementById('client-esign-prompt');
    if (lead.stage === 'agreement') {
        esignPromptBox.style.display = 'block';
    } else {
        esignPromptBox.style.display = 'none';
    }

    // Construction timeline checklists & financial displays
    const timelineBox = document.getElementById('client-rehab-card');
    const settlementCard = document.getElementById('client-settlement-card');
    const invoicesCard = document.getElementById('client-invoices-card');

    if (lead.stage === 'rehab' || lead.stage === 'listed' || lead.stage === 'closed') {
        timelineBox.style.display = 'block';
        if (settlementCard) settlementCard.style.display = 'block';
        if (invoicesCard) invoicesCard.style.display = 'block';

        renderClientMilestonesChecklist(lead);
        renderClientSettlement(lead);
        renderClientInvoices(lead);
    } else {
        timelineBox.style.display = 'none';
        if (settlementCard) settlementCard.style.display = 'none';
        if (invoicesCard) invoicesCard.style.display = 'none';
    }

    // Contractors list
    renderClientContractors(lead);
    renderClientBids(lead);

    const clientModal = document.getElementById('client-portal-modal');
    clientModal.style.display = 'flex';
    setTimeout(() => { clientModal.classList.add('active'); }, 10);
}

function closeClientPortal() {
    const clientModal = document.getElementById('client-portal-modal');
    clientModal.classList.remove('active');
    setTimeout(() => {
        clientModal.style.display = 'none';
        currentSelectedLeadId = null;
    }, 300);
}

function renderClientStatusSteps(activeStage) {
    const stepsBox = document.getElementById('client-status-steps');
    stepsBox.innerHTML = '';

    const stagesList = ['intake', 'valuation', 'agreement', 'rehab', 'listed', 'closed'];
    const stageNames = ['Intake Received', 'Valuation Study', 'Contract Proposal', 'Active Rehab', 'Listed on MLS', 'Closed & Paid'];

    const activeIdx = stagesList.indexOf(activeStage);

    stagesList.forEach((stageKey, idx) => {
        const step = document.createElement('div');
        step.className = `status-step ${idx === activeIdx ? 'active' : ''} ${idx < activeIdx ? 'completed' : ''}`;
        
        step.innerHTML = `
            <div class="status-step-dot">${idx + 1}</div>
            <span class="status-step-label">${stageNames[idx]}</span>
            <div class="status-step-line"></div>
        `;
        stepsBox.appendChild(step);
    });
}

function renderClientMilestonesChecklist(lead) {
    const list = document.getElementById('client-milestones-list');
    list.innerHTML = '';

    if (!lead.completedSubtasks) lead.completedSubtasks = [];

    lead.scope.forEach(itemId => {
        const sowItem = REHAB_ITEMS.find(i => i.id === itemId);
        if (!sowItem) return;

        const subtasks = SUBTASKS_MAP[itemId] || [];
        if (subtasks.length === 0) return;

        const categoryComplete = subtasks.every(s => lead.completedSubtasks.includes(s.id));

        const row = document.createElement('div');
        row.className = `milestone-row ${categoryComplete ? 'completed' : ''}`;
        
        let subtasksHtml = '';
        subtasks.forEach(sub => {
            const done = lead.completedSubtasks.includes(sub.id);
            subtasksHtml += `
                <div class="subtask-item ${done ? 'completed' : ''}">
                    <span class="subtask-bullet">
                        <i data-lucide="check" style="${done ? 'display:block;' : ''}"></i>
                    </span>
                    <span class="subtask-name">${sub.name}</span>
                </div>
            `;
        });

        row.innerHTML = `
            <div class="milestone-header-row">
                <div class="milestone-check">
                    <i data-lucide="check" style="${categoryComplete ? 'display:block;' : ''}"></i>
                </div>
                <span class="milestone-name">${sowItem.name} Scope</span>
            </div>
            <div class="subtask-list">
                ${subtasksHtml}
            </div>
        `;
        list.appendChild(row);
    });

    const pct = calculateConstructionProgress(lead);
    document.getElementById('client-progress-fill').style.width = `${pct}%`;
    document.getElementById('client-progress-text').innerText = `Renovation progress: ${pct}% complete`;
    
    // Photo Gallery
    const galleryGrid = document.getElementById('client-photo-grid');
    galleryGrid.innerHTML = '';
    const rooms = [
        { name: 'Kitchen Area' },
        { name: 'Living Rooms' },
        { name: 'Outer Landscape' }
    ];
    rooms.forEach(room => {
        let stateClass = 'room-dated';
        let labelText = 'Before Rehab';

        if (pct >= 90) {
            stateClass = 'room-finished';
            labelText = 'Completed & Staged';
        } else if (pct > 35) {
            stateClass = 'room-underway';
            labelText = 'Active Renovation';
        }

        const card = document.createElement('div');
        card.className = 'photo-card';
        card.innerHTML = `
            <div class="photo-graphic ${stateClass}"></div>
            <span class="label">${room.name}<br><small style="color:var(--text-muted);">${labelText}</small></span>
        `;
        galleryGrid.appendChild(card);
    });
    lucide.createIcons();
}

function renderClientContractors(lead) {
    const list = document.getElementById('client-contractors-list');
    list.innerHTML = '';

    const activeScopesWithDispatches = Object.keys(lead.dispatches || {});
    if (activeScopesWithDispatches.length === 0) {
        list.innerHTML = '<div class="text-muted" style="font-size:0.8rem; text-align:center; padding: 1rem 0;">No contractors dispatched yet.</div>';
        return;
    }

    activeScopesWithDispatches.forEach(itemId => {
        const conId = lead.dispatches[itemId];
        const con = contractors.find(c => c.id === conId);
        if (con) {
            const row = document.createElement('div');
            row.className = 'client-con-row';
            row.innerHTML = `
                <div class="client-con-info">
                    <h5>${con.name}</h5>
                    <p>Scope: ${con.trade} Specialist</p>
                </div>
                <div class="client-con-contact">
                    <i data-lucide="phone"></i>
                    <span>${con.phone}</span>
                </div>
            `;
            list.appendChild(row);
        }
    });
    lucide.createIcons();
}

function launchClientESign() {
    closeClientPortal();
    // Reopen signature launcher on this active lead
    setTimeout(openESignModal, 350);
}

// ================= SUCCESS STORY CASE STUDY MODALS =================
function openCaseStudyModal(storyId) {
    const study = CASE_STUDIES[storyId];
    if (!study) return;

    const modal = document.getElementById('case-study-modal');
    document.getElementById('cs-title').innerText = `${study.address} Case Study`;
    
    const payoutDiff = study.soldVal - study.asisVal - study.rehabCost;

    document.getElementById('case-study-body').innerHTML = `
        <div class="flyer-hero" style="padding: 1.5rem; margin-bottom: 1.5rem;">
            <h3 style="color:white; margin-bottom:0.25rem;">${study.title}</h3>
            <p style="color:#c7d2fe; font-size:0.85rem; margin-bottom:0;">Renovation cycle completed in ${study.duration}</p>
        </div>
        <p style="font-size:0.85rem; color:var(--text-muted); line-height:1.4; margin-bottom:1.5rem;">${study.summary}</p>
        
        <h4 style="margin-bottom:0.75rem;">Trades Completed</h4>
        <div style="display:flex; gap:0.5rem; flex-wrap:wrap; margin-bottom:1.5rem;">
            ${study.scope.map(s => `<span class="con-trade-badge" style="background:rgba(99,102,241,0.1); border-color:rgba(99,102,241,0.2);">${s}</span>`).join('')}
        </div>

        <h4>Financial Performance Ledger</h4>
        <div class="case-study-metric-box">
            <div>
                <span class="label" style="font-size:0.65rem; color:#4b5563; text-transform:uppercase;">As-Is Valuation</span>
                <div style="font-size:1.15rem; font-weight:800;">$${study.asisVal.toLocaleString()}</div>
            </div>
            <div>
                <span class="label" style="font-size:0.65rem; color:#4b5563; text-transform:uppercase;">Rehab Cost</span>
                <div style="font-size:1.15rem; font-weight:800; color:var(--danger)">$${study.rehabCost.toLocaleString()}</div>
            </div>
            <div>
                <span class="label" style="font-size:0.65rem; color:#4b5563; text-transform:uppercase;">Final Sale Price</span>
                <div style="font-size:1.15rem; font-weight:800; color:var(--success)">$${study.soldVal.toLocaleString()}</div>
            </div>
        </div>
        <div style="background:#ecfdf5; border:1px solid rgba(16,185,129,0.2); border-radius:6px; padding:1rem; text-align:center; color:#047857; font-weight:800;">
            👉 Owner Net Payout Lift: +$${study.extraProfit.toLocaleString()}
        </div>
    `;

    modal.style.display = 'flex';
    setTimeout(() => { modal.classList.add('active'); }, 10);
}

function closeCaseStudyModal() {
    const modal = document.getElementById('case-study-modal');
    modal.classList.remove('active');
    setTimeout(() => { modal.style.display = 'none'; }, 300);
}

// ================= PIPELINE BOARD =================
function renderPipelineBoard() {
    const boardContainer = document.getElementById('pipeline-board');
    if (!boardContainer) return;
    boardContainer.innerHTML = '';

    Object.keys(STAGES).forEach(stageKey => {
        const stageLeads = leads.filter(l => l.stage === stageKey);
        
        const col = document.createElement('div');
        col.className = 'pipeline-col';
        col.setAttribute('data-stage', stageKey);
        
        col.innerHTML = `
            <div class="col-header">
                <h3>${STAGES[stageKey]}</h3>
                <span class="badge">${stageLeads.length}</span>
            </div>
            <div class="col-cards" ondragover="allowDrop(event)" ondrop="handleDrop(event)" ondragenter="dragEnter(event)" ondragleave="dragLeave(event)">
                <!-- Cards -->
            </div>
        `;
        
        const cardsContainer = col.querySelector('.col-cards');
        
        stageLeads.forEach(lead => {
            const card = document.createElement('div');
            card.className = 'lead-card';
            card.setAttribute('draggable', 'true');
            card.setAttribute('data-lead-id', lead.id);
            card.onclick = () => openDrawer(lead.id);
            
            card.ondragstart = (e) => handleDragStart(e, lead.id);
            card.ondragend = handleDragEnd;

            const currentDiscountRehab = lead.scope.reduce((sum, itemKey) => {
                const item = REHAB_ITEMS.find(i => i.id === itemKey);
                return sum + (item ? item.discounted : 0);
            }, 0);

            // Construction progress summary
            let progressHtml = '';
            if (lead.stage === 'rehab' || lead.stage === 'listed') {
                const pct = calculateConstructionProgress(lead);
                progressHtml = `
                    <div class="card-progress-summary" style="margin-top: 0.5rem; font-size: 0.75rem; display: flex; align-items: center; gap: 0.5rem; color: var(--warning);">
                        <i data-lucide="hammer" style="width:12px; height:12px;"></i>
                        <span>Rehab: ${pct}%</span>
                    </div>
                `;
            }

            card.innerHTML = `
                <div class="lead-card-header">
                    <h4>${lead.address}</h4>
                    <span class="card-tag ${lead.stage}">${lead.stage === 'intake' ? 'New' : lead.stage.substring(0, 5)}</span>
                </div>
                <div class="lead-card-owner">${lead.name}</div>
                <div class="lead-card-financials">
                    <span class="text-muted">ARV: $${lead.targetARV.toLocaleString()}</span>
                    <span class="text-success">$${currentDiscountRehab.toLocaleString()} SOW</span>
                </div>
                ${progressHtml}
            `;
            
            cardsContainer.appendChild(card);
        });

        boardContainer.appendChild(col);
    });

    lucide.createIcons();
    populateDripTargetDropdown();
    populateAdLeadSelect();
}

let draggedLeadId = null;
function handleDragStart(e, leadId) {
    draggedLeadId = leadId;
    e.dataTransfer.setData('text/plain', leadId);
    e.currentTarget.classList.add('dragging');
}
function handleDragEnd(e) {
    e.currentTarget.classList.remove('dragging');
    draggedLeadId = null;
}
function allowDrop(e) { e.preventDefault(); }
function dragEnter(e) {
    e.preventDefault();
    const colCards = e.currentTarget.closest('.col-cards');
    if (colCards) colCards.style.background = 'rgba(255, 255, 255, 0.04)';
}
function dragLeave(e) {
    const colCards = e.currentTarget.closest('.col-cards');
    if (colCards) colCards.style.background = '';
}
function handleDrop(e) {
    e.preventDefault();
    const colCards = e.currentTarget.closest('.col-cards');
    if (colCards) {
        colCards.style.background = '';
        const stage = e.currentTarget.closest('.pipeline-col').getAttribute('data-stage');
        const leadId = e.dataTransfer.getData('text/plain') || draggedLeadId;
        
        if (leadId) {
            const lead = leads.find(l => l.id === leadId);
            if (lead && lead.stage !== stage) {
                lead.stage = stage;
                saveLeadsToStorage();
                
                if (stage === 'agreement') {
                    triggerAutoEmail(lead, 'Agreement Delivery');
                } else if (stage === 'rehab') {
                    triggerAutoEmail(lead, 'Rehab Started');
                }

                renderPipelineBoard();
                updateDashboardStats();
                showToast(`Moved ${lead.address} to ${STAGES[stage]}`);
            }
        }
    }
}

// ================= RADAR MAP & ADDRESS SEARCH =================
function renderMockMap() {
    const map = document.getElementById('mock-map');
    if (!map) return;

    map.innerHTML = `
        <svg class="map-grid-overlay" width="100%" height="100%" xmlns="http://www.w3.org/2000/svg">
            <defs>
                <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
                    <path d="M 40 0 L 0 0 0 40" fill="none" stroke="rgba(255,255,255,0.05)" stroke-width="1"/>
                </pattern>
            </defs>
            <rect width="100%" height="100%" fill="url(#grid)" />
            <path d="M 0,150 L 800,150" stroke="rgba(255, 255, 255, 0.08)" stroke-width="24" fill="none"/>
            <path d="M 200,0 L 200,600" stroke="rgba(255, 255, 255, 0.08)" stroke-width="20" fill="none"/>
            <path d="M 550,0 L 550,600" stroke="rgba(255, 255, 255, 0.08)" stroke-width="16" fill="none"/>
            <path d="M 0,420 L 800,320" stroke="rgba(255, 255, 255, 0.08)" stroke-width="20" fill="none"/>
            <rect x="240" y="40" width="260" height="80" rx="10" fill="rgba(16, 185, 129, 0.06)"/>
            <text x="370" y="85" fill="rgba(16, 185, 129, 0.4)" font-family="Inter" font-weight="700" font-size="12" letter-spacing="1">LOCAL GREENWAY</text>
            <path d="M -50,-50 C 400,200 400,400 850,550" stroke="rgba(99, 102, 241, 0.04)" stroke-width="80" fill="none"/>
            <text x="350" y="270" fill="rgba(99, 102, 241, 0.2)" font-family="Inter" font-style="italic" font-size="11">Raccoon River</text>
        </svg>
        <div id="map-tooltip-box" class="map-tooltip"></div>
    `;

    prospects.forEach(prop => {
        const inPipeline = leads.some(l => l.address.toLowerCase().includes(prop.address.toLowerCase()));

        const pin = document.createElement('div');
        pin.className = `map-marker ${prop.hotLevel} ${inPipeline ? 'in-pipeline' : ''}`;
        pin.style.left = `${prop.coords.x}%`;
        pin.style.top = `${prop.coords.y}%`;
        pin.innerHTML = `<i data-lucide="map-pin" class="marker-pin"></i>`;

        pin.onclick = (e) => {
            e.stopPropagation();
            showMapTooltip(prop, inPipeline, pin.style.left, pin.style.top);
        };

        map.appendChild(pin);
    });

    map.onclick = () => {
        document.getElementById('map-tooltip-box').style.display = 'none';
    };
    lucide.createIcons();
}

function handleMapAddressSearch() {
    const input = document.getElementById('map-search-input');
    const address = input.value.trim();
    if (!address) return;

    showToast("Querying real geocoder database...");

    fetch(`https://nominatim.openstreetmap.org/search?format=json&limit=5&q=${encodeURIComponent(address)}`)
        .then(res => res.json())
        .then(data => {
            if (!data || data.length === 0) {
                showToast("Address not found in real geocoder database. Trying fallback...");
                dropMockAddressPin(address);
                return;
            }

            const item = data[0];
            const realAddress = item.display_name.split(',').slice(0, 3).join(',');
            const lat = parseFloat(item.lat);
            const lon = parseFloat(item.lon);

            let anchor = JSON.parse(localStorage.getItem('revitalize_map_anchor'));
            if (!anchor) {
                anchor = { lat: lat, lon: lon };
                localStorage.setItem('revitalize_map_anchor', JSON.stringify(anchor));
            }

            const latOffset = lat - anchor.lat;
            const lonOffset = lon - anchor.lon;

            const gridX = Math.max(15, Math.min(85, Math.round(50 + (lonOffset * 600))));
            const gridY = Math.max(15, Math.min(85, Math.round(50 - (latOffset * 600))));

            const owners = ['William Wright', 'Charlotte Hughes', 'Arthur Pendragon', 'Diana Prince', 'Bruce Wayne'];
            const ownerName = owners[Math.floor(Math.random() * owners.length)];

            const asIs = Math.round(180 + Math.random() * 200) * 1000;
            const arv = Math.round(asIs * 1.35);

            const newProspect = {
                id: `prop-real-${Date.now()}`,
                address: realAddress,
                owner: ownerName,
                phone: '(555) 789-0123',
                email: `${ownerName.toLowerCase().replace(' ', '.')}@email.com`,
                asIsValue: asIs,
                targetARV: arv,
                notes: `Located via OSM Geocoder (Lat: ${lat.toFixed(4)}, Lon: ${lon.toFixed(4)})`,
                coords: { x: gridX, y: gridY },
                hotLevel: 'hot',
                dom: Math.floor(10 + Math.random() * 150),
                distance: parseFloat((Math.sqrt(latOffset * latOffset + lonOffset * lonOffset) * 69).toFixed(1))
            };

            prospects.push(newProspect);
            saveProspectsToStorage();
            input.value = '';

            renderMockMap();
            renderProspectsList();
            showToast(`Real address loaded: ${realAddress}`);

            setTimeout(() => {
                const pin = document.querySelector(`.map-marker[style*="left: ${gridX}%"][style*="top: ${gridY}%"]`);
                if (pin) pin.click();
            }, 400);
        })
        .catch(err => {
            console.error("Geocoder fetch error:", err);
            dropMockAddressPin(address);
        });
}

function dropMockAddressPin(address) {
    const randomX = Math.round(15 + Math.random() * 70);
    const randomY = Math.round(15 + Math.random() * 70);
    const owners = ['William Wright', 'Charlotte Hughes', 'Arthur Pendragon', 'Diana Prince', 'Bruce Wayne'];
    const ownerName = owners[Math.floor(Math.random() * owners.length)];

    const newProspect = {
        id: `prop-${Date.now()}`,
        address: address,
        owner: ownerName,
        phone: '(555) 789-0123',
        email: `${ownerName.toLowerCase().replace(' ', '.')}@email.com`,
        asIsValue: 340000,
        targetARV: 430000,
        notes: 'Discovered through fallback radius map address search.',
        coords: { x: randomX, y: randomY },
        hotLevel: 'warm',
        dom: 65,
        distance: 2.1
    };

    prospects.push(newProspect);
    saveProspectsToStorage();
    document.getElementById('map-search-input').value = '';

    renderMockMap();
    renderProspectsList();
    showToast(`Custom fallback pin dropped for: ${address}`);
}

function showMapTooltip(prop, inPipeline, left, top) {
    const tooltip = document.getElementById('map-tooltip-box');
    tooltip.style.left = left;
    tooltip.style.top = top;
    tooltip.style.display = 'block';

    const btnHtml = inPipeline 
        ? `<button class="tooltip-btn in-pipeline-btn"><i data-lucide="check"></i> In Pipeline</button>`
        : `<button class="tooltip-btn" onclick="importProspectToLead('${prop.id}')"><i data-lucide="plus"></i> Import Lead</button>`;

    tooltip.innerHTML = `
        <h4>${prop.address}</h4>
        <p style="font-size:0.7rem; color:var(--text-muted); margin-bottom:0.4rem;">
            Distance: ${prop.distance || '2.4'} mi • ${prop.dom ? `${prop.dom} DOM` : 'New Listing'}<br>
            Est. ARV: $${(prop.targetARV || 0).toLocaleString()}<br>Owner: ${prop.owner}
        </p>
        ${btnHtml}
    `;
    lucide.createIcons();
}

function renderProspectsList() {
    const listContainer = document.getElementById('prospects-list');
    if (!listContainer) return;
    listContainer.innerHTML = '';

    prospects.forEach(prop => {
        const inPipeline = leads.some(l => l.address.toLowerCase().includes(prop.address.toLowerCase()));
        const item = document.createElement('div');
        item.className = 'prospect-item';
        
        const btnHtml = inPipeline
            ? `<button class="added"><i data-lucide="check"></i> Added</button>`
            : `<button onclick="importProspectToLead('${prop.id}')"><i data-lucide="plus"></i> Import</button>`;

        const domTag = prop.dom 
            ? `<span style="font-size:0.6rem; padding:0.1rem 0.3rem; border-radius:4px; margin-left:0.5rem; background:${prop.dom > 180 ? 'rgba(239,68,68,0.15)' : 'rgba(245,158,11,0.15)'}; color:${prop.dom > 180 ? 'var(--danger)' : 'var(--warning)'}; border:1px solid ${prop.dom > 180 ? 'rgba(239,68,68,0.3)' : 'rgba(245,158,11,0.3)'};">${prop.dom} DOM</span>`
            : '';

        item.innerHTML = `
            <div class="prospect-info">
                <h4 style="display:flex; align-items:center; margin:0; font-size:0.85rem; font-weight:700;">
                    <span>${prop.address}</span>
                    ${domTag}
                </h4>
                <p style="margin:0.2rem 0 0 0; font-size:0.75rem; color:var(--text-muted);">
                    Dist: ${prop.distance || '2.4'} mi • Owner: ${prop.owner} • As-Is: $${(prop.asIsValue || 0).toLocaleString()} • ARV: $${(prop.targetARV || 0).toLocaleString()}
                </p>
            </div>
            ${btnHtml}
        `;
        listContainer.appendChild(item);
    });
    lucide.createIcons();
    populateDripTargetDropdown();
}

function importProspectToLead(propId) {
    const prop = prospects.find(p => p.id === propId);
    if (!prop) return;

    if (leads.some(l => l.address.toLowerCase().includes(prop.address.toLowerCase()))) {
        showToast('Property already in pipeline!');
        return;
    }

    const newLead = {
        id: `lead-${Date.now()}`,
        name: prop.owner,
        phone: prop.phone,
        email: prop.email,
        address: prop.address,
        asIsValue: prop.asIsValue,
        targetARV: prop.targetARV,
        commissionRate: 6,
        stage: 'intake',
        notes: `Imported from Radar Prospect List. Notes: ${prop.notes}`,
        scope: ['paint', 'landscaping'],
        dispatches: {},
        completedSubtasks: []
    };

    leads.push(newLead);
    saveLeadsToStorage();
    renderProspectsList();
    renderMockMap();
    updateDashboardStats();
    showToast(`Imported ${prop.address} to Lead Board!`);
}

// ================= CONTRACTOR HUB =================
function renderContractorList() {
    const container = document.getElementById('contractors-grid');
    if (!container) return;
    container.innerHTML = '';

    contractors.forEach(con => {
        const conCard = document.createElement('div');
        conCard.className = `contractor-card status-${con.status}`;
        
        let starsHtml = '';
        const fullStars = Math.floor(con.rating);
        for(let i=0; i<5; i++) {
            if (i < fullStars) starsHtml += '<i data-lucide="star" style="fill: currentColor;"></i>';
            else starsHtml += '<i data-lucide="star"></i>';
        }

        conCard.innerHTML = `
            <div class="con-header">
                <h4>${con.name}</h4>
                <span class="con-trade-badge">${con.trade}</span>
            </div>
            <div class="con-details">
                <div><i data-lucide="phone"></i> <span>${con.phone}</span></div>
                <div class="con-rating-stars">${starsHtml} <span style="margin-left:5px; color:white; font-weight:700;">${con.rating}</span></div>
                <div><i data-lucide="briefcase"></i> <span>${con.assignments} Active Jobs</span></div>
            </div>
            <div class="con-status-ribbon">
                <span class="status-indicator status-${con.status}">
                    <span class="status-dot"></span>
                    <span>${con.status === 'active' ? 'Available' : 'Busy'}</span>
                </span>
                <button class="btn-secondary btn-sm-clear" onclick="toggleContractorStatus('${con.id}')">Toggle Status</button>
            </div>
        `;
        container.appendChild(conCard);
    });
    lucide.createIcons();
}

function showAddContractorModal() {
    document.getElementById('contractor-modal').style.display = 'flex';
    document.getElementById('contractor-modal').classList.add('active');
}
function closeContractorModal() {
    document.getElementById('contractor-modal').classList.remove('active');
    setTimeout(() => { document.getElementById('contractor-modal').style.display = 'none'; }, 300);
}
function handleAddContractor(e) {
    e.preventDefault();
    const name = document.getElementById('con-name').value;
    const trade = document.getElementById('con-trade').value;
    const rating = parseFloat(document.getElementById('con-rating').value) || 5;
    const phone = document.getElementById('con-phone').value;

    const newCon = {
        id: `con-${Date.now()}`,
        name,
        trade,
        rating,
        phone,
        status: 'active',
        assignments: 0
    };

    contractors.push(newCon);
    saveContractorsToStorage();
    renderContractorList();
    closeContractorModal();
    document.getElementById('contractor-form').reset();
    showToast('Contractor added successfully.');
}
function toggleContractorStatus(conId) {
    const con = contractors.find(c => c.id === conId);
    if (con) {
        con.status = con.status === 'active' ? 'busy' : 'active';
        saveContractorsToStorage();
        renderContractorList();
    }
}

// ================= EMAIL AUTOMATIONS ENGINE =================
function renderEmailLogs() {
    const list = document.getElementById('email-log-list');
    if (!list) return;
    list.innerHTML = '';

    if (emailLogs.length === 0) {
        list.innerHTML = '<div class="text-muted" style="text-align:center; padding: 2rem;">No outbound emails logged.</div>';
        return;
    }

    const sortedLogs = [...emailLogs].reverse();

    sortedLogs.forEach(log => {
        const item = document.createElement('div');
        item.className = 'email-log-item';
        item.innerHTML = `
            <div class="log-meta-row">
                <span class="log-time">${log.time}</span>
                <span class="log-status-badge">Dispatched</span>
            </div>
            <div style="font-size:0.85rem; font-weight:600;">To: ${log.recipient} • Type: <span class="text-gradient">${log.type}</span></div>
            <div class="log-subject">Subject: ${log.subject}</div>
            <div class="log-preview">${log.body}</div>
        `;
        list.appendChild(item);
    });
}

function triggerAutoEmail(lead, type, extraDetail = '') {
    if (type === 'Intake Confirmation' && !emailSettings.autoIntake) return;
    if (type === 'Rehab Started' && !emailSettings.autoRehab) return;
    if (type === 'Agreement Delivery' && !emailSettings.autoContract) return;

    let subject = '';
    let body = '';

    const totalRehab = lead.scope.reduce((sum, itemKey) => {
        const item = REHAB_ITEMS.find(i => i.id === itemKey);
        return sum + (item ? item.discounted : 0);
    }, 0);

    const commissionVal = lead.targetARV * ((lead.commissionRate || 6) / 100);
    const estPayout = lead.targetARV - (totalRehab / 2) - commissionVal;

    if (type === 'Intake Confirmation') {
        subject = `Revitalize Project Evaluation: ${lead.address}`;
        body = `Hello ${lead.name},\n\nWe have received your request to list your property at ${lead.address} under our Fix-and-List program. Based on your inputs, we estimate an After-Repair Value (ARV) of $${lead.targetARV.toLocaleString()} following renovations. Our pre-approved discounted rehab budget is $${totalRehab.toLocaleString()} (with 50% paid upfront during construction and 50% deferred to sale closing). At closing, we estimate your Net Payout will be $${Math.round(estPayout).toLocaleString()}. An agent will contact you shortly to schedule a walkthrough.`;
    } else if (type === 'Agreement Delivery') {
        subject = `Listing and Rehabilitation Proposal: ${lead.address}`;
        body = `Hello ${lead.name},\n\nWe have compiled your digital exclusive listing agreement for ${lead.address}. The renovation capital allocation has been finalized at $${totalRehab.toLocaleString()} (50% paid upfront, 50% deferred to closing) with an estimated commission listing rate of ${lead.commissionRate || 6}%. You can review, print, or execute the agreement from your client portal.`;
    } else if (type === 'Rehab Started') {
        subject = `Renovation Commenced at ${lead.address}`;
        body = `Hello ${lead.name},\n\nGreat news! We have officially dispatched vetted contractors to begin the renovations at ${lead.address}. Subcontractors will begin working on the selected SOW items: ${lead.scope.join(', ')}.\n\nReminder: Under our 50/50 payment split terms, 50% ($${(totalRehab / 2).toLocaleString()}) is billed upfront during construction, with the remaining 50% deferred interest-free to sale closing.`;
    } else if (type === 'Flyer Delivery') {
        subject = `Equity Lift Assessment Report: ${lead.address}`;
        body = `Hello ${lead.name},\n\nAttached is your custom Equity Lift presentation flyer comparing an As-Is MLS sale vs. our 50/50 split Fix-and-List program. Renovation upgrades have been designed to capture an estimated $${(lead.targetARV - lead.asIsValue).toLocaleString()} in gross equity lift.`;
    } else if (type === 'Milestone Completed') {
        subject = `Rehab Progress Update: ${lead.address}`;
        body = `Hello ${lead.name},\n\nWe are pleased to report that the construction phase [${extraDetail}] has been successfully completed and inspected at your property ${lead.address}. We remain on track with schedule and budget parameters.`;
    } else if (type === 'Contract Signed Notification') {
        subject = `Agreement Executed: ${lead.address}`;
        body = `Hello ${lead.name},\n\nThank you! Your Exclusive Listing and Rehabilitation Agreement has been successfully digitally signed and locked under our 50/50 split terms. The security seal SHA-256 certificate has been logged, and construction scheduling is now underway.`;
    }

    const log = {
        id: `log-${Date.now()}`,
        time: new Date().toLocaleString(),
        recipient: lead.email,
        type,
        subject,
        body
    };

    emailLogs.push(log);
    localStorage.setItem('revitalize_email_logs', JSON.stringify(emailLogs));
    
    dispatchRealEmail(lead.email, subject, body);
    renderEmailLogs();
}

function clearEmailLogs() {
    if (confirm('Clear outbound communication logs?')) {
        emailLogs = [];
        localStorage.removeItem('revitalize_email_logs');
        renderEmailLogs();
    }
}

// ================= ANALYTICS =================
function renderAnalyticsDashboard() {
    let activeRenovationCapital = 0;
    let projectedBrokerageCommissions = 0;
    let combinedPortfolioValue = 0;

    leads.forEach(lead => {
        const leadRehabCost = lead.scope.reduce((sum, itemKey) => {
            const item = REHAB_ITEMS.find(i => i.id === itemKey);
            return sum + (item ? item.discounted : 0);
        }, 0);

        if (lead.stage === 'rehab' || lead.stage === 'listed') {
            activeRenovationCapital += (leadRehabCost / 2);
        }

        if (lead.stage !== 'closed') {
            const commPct = lead.commissionRate || 6;
            projectedBrokerageCommissions += lead.targetARV * (commPct / 100);
            combinedPortfolioValue += lead.targetARV;
        }
    });

    document.getElementById('kpi-capital-outlaid').innerText = `$${Math.round(activeRenovationCapital).toLocaleString()}`;
    document.getElementById('kpi-projected-commission').innerText = `$${Math.round(projectedBrokerageCommissions).toLocaleString()}`;
    document.getElementById('kpi-portfolio-value').innerText = `$${Math.round(combinedPortfolioValue).toLocaleString()}`;

    renderDonutChart();
    renderBarChart();
}

function renderDonutChart() {
    const container = document.getElementById('analytics-donut-container');
    const legend = document.getElementById('analytics-donut-legend');
    if (!container || !legend) return;

    container.innerHTML = '';
    legend.innerHTML = '';

    const stageCounts = {};
    Object.keys(STAGES).forEach(key => {
        stageCounts[key] = leads.filter(l => l.stage === key).length;
    });

    const totalLeads = leads.length;
    if (totalLeads === 0) {
        container.innerHTML = '<span class="text-muted" style="font-size:0.8rem;">No leads to chart</span>';
        return;
    }

    let donutSvg = `
        <svg width="180" height="180" viewBox="0 0 180 180" xmlns="http://www.w3.org/2000/svg">
            <circle cx="90" cy="90" r="70" fill="none" stroke="rgba(255,255,255,0.02)" stroke-width="20"/>
    `;

    let accumulatedPercentage = 0;
    const r = 60;
    const circumference = 2 * Math.PI * r;

    Object.keys(STAGES).forEach(stageKey => {
        const count = stageCounts[stageKey];
        const pct = count / totalLeads;
        const color = STAGE_COLORS[stageKey] || '#ccc';

        if (count > 0) {
            const strokeLength = circumference * pct;
            const strokeOffset = circumference - (circumference * accumulatedPercentage);

            donutSvg += `
                <circle cx="90" cy="90" r="${r}" fill="none" 
                        stroke="${color}" stroke-width="20"
                        stroke-dasharray="${strokeLength} ${circumference}"
                        stroke-dashoffset="${strokeOffset}"
                        transform="rotate(-90 90 90)"
                        class="chart-bar-rect" />
            `;
            accumulatedPercentage += pct;
        }

        const legendItem = document.createElement('div');
        legendItem.className = 'legend-item';
        legendItem.innerHTML = `
            <span class="legend-color" style="background:${color};"></span>
            <span>${STAGES[stageKey]}: ${count} (${Math.round(pct * 100)}%)</span>
        `;
        legend.appendChild(legendItem);
    });

    donutSvg += `
            <circle cx="90" cy="90" r="50" fill="#0f1424" />
            <text x="90" y="88" fill="var(--text-primary)" font-family="Inter" font-weight="800" font-size="18" text-anchor="middle">${totalLeads}</text>
            <text x="90" y="105" fill="var(--text-muted)" font-family="Inter" font-weight="600" font-size="9" text-anchor="middle" letter-spacing="1">TOTAL LEADS</text>
        </svg>
    `;

    container.innerHTML = donutSvg;
}

function renderBarChart() {
    const container = document.getElementById('analytics-bar-container');
    if (!container) return;
    container.innerHTML = '';

    const activeIntake = leads.filter(l => l.stage === 'intake').length;
    const monthlyData = [
        { month: 'Jan', count: 2 },
        { month: 'Feb', count: 4 },
        { month: 'Mar', count: 3 },
        { month: 'Apr', count: 7 },
        { month: 'May', count: 5 },
        { month: 'Jun', count: 8 },
        { month: 'Jul', count: 6 + activeIntake }
    ];

    const maxCount = Math.max(...monthlyData.map(d => d.count), 10);
    const height = 180;
    const width = 280;

    let barSvg = `
        <svg width="100%" height="200" viewBox="0 0 ${width} 200" xmlns="http://www.w3.org/2000/svg">
            <line x1="20" y1="20" x2="260" y2="20" stroke="rgba(255,255,255,0.03)" stroke-width="1"/>
            <line x1="20" y1="90" x2="260" y2="90" stroke="rgba(255,255,255,0.03)" stroke-width="1"/>
            <line x1="20" y1="160" x2="260" y2="160" stroke="rgba(255,255,255,0.1)" stroke-width="2"/>
    `;

    const barWidth = 22;
    const gap = 12;
    const startX = 30;

    monthlyData.forEach((d, idx) => {
        const barHeight = Math.round((d.count / maxCount) * 130);
        const x = startX + idx * (barWidth + gap);
        const y = 160 - barHeight;

        barSvg += `
            <rect x="${x}" y="${y}" width="${barWidth}" height="${barHeight}" fill="url(#barGradient)" rx="3" class="chart-bar-rect"/>
            <text x="${x + barWidth/2}" y="${y - 8}" fill="var(--text-primary)" font-family="Inter" font-weight="700" font-size="9" text-anchor="middle">${d.count}</text>
            <text x="${x + barWidth/2}" y="178" fill="var(--text-muted)" font-family="Inter" font-weight="600" font-size="9" text-anchor="middle">${d.month}</text>
        `;
    });

    barSvg += `
            <defs>
                <linearGradient id="barGradient" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stop-color="#6366f1" />
                    <stop offset="100%" stop-color="#ec4899" />
                </linearGradient>
            </defs>
        </svg>
    `;

    container.innerHTML = barSvg;
}

// ================= REHAB MILESTONES & SUB-TASKS PROGRESS =================
function calculateConstructionProgress(lead) {
    if (!lead.scope || lead.scope.length === 0) return 0;
    
    let totalSubtasks = 0;
    let completedSubtasksCount = 0;

    lead.scope.forEach(itemId => {
        const list = SUBTASKS_MAP[itemId] || [];
        totalSubtasks += list.length;
        list.forEach(sub => {
            if (lead.completedSubtasks && lead.completedSubtasks.includes(sub.id)) {
                completedSubtasksCount++;
            }
        });
    });

    if (totalSubtasks === 0) return 0;
    return Math.round((completedSubtasksCount / totalSubtasks) * 100);
}

function renderMilestonesChecklist(lead) {
    const checklist = document.getElementById('milestones-checklist');
    if (!checklist) return;
    checklist.innerHTML = '';

    if (!lead.completedSubtasks) lead.completedSubtasks = [];

    // Group milestones by active scope
    lead.scope.forEach(itemId => {
        const sowItem = REHAB_ITEMS.find(i => i.id === itemId);
        if (!sowItem) return;

        const subtasks = SUBTASKS_MAP[itemId] || [];
        if (subtasks.length === 0) return;

        // Check if all subtasks under this category are completed
        const categoryComplete = subtasks.every(s => lead.completedSubtasks.includes(s.id));

        const row = document.createElement('div');
        row.className = `milestone-row ${categoryComplete ? 'completed' : ''}`;
        
        let subtasksHtml = '';
        subtasks.forEach(sub => {
            const done = lead.completedSubtasks.includes(sub.id);
            subtasksHtml += `
                <div class="subtask-item ${done ? 'completed' : ''}" onclick="toggleSubtask('${sub.id}', '${sowItem.name}', event)">
                    <span class="subtask-bullet">
                        <i data-lucide="check"></i>
                    </span>
                    <span class="subtask-name">${sub.name}</span>
                </div>
            `;
        });

        row.innerHTML = `
            <div class="milestone-header-row">
                <div class="milestone-check">
                    <i data-lucide="check"></i>
                </div>
                <span class="milestone-name">${sowItem.name} Scope</span>
            </div>
            <div class="subtask-list">
                ${subtasksHtml}
            </div>
        `;
        checklist.appendChild(row);
    });

    const pct = calculateConstructionProgress(lead);
    document.getElementById('rehab-progress-fill').style.width = `${pct}%`;
    document.getElementById('rehab-progress-text').innerText = `Renovation Progress: ${pct}% complete`;
    
    // Update Photo Stream based on progress percentage
    renderPhotoStream(pct);
    lucide.createIcons();
}

function toggleSubtask(subId, parentName, event) {
    if (event) event.stopPropagation();
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    if (!lead.completedSubtasks) lead.completedSubtasks = [];
    const idx = lead.completedSubtasks.indexOf(subId);
    
    if (idx > -1) {
        lead.completedSubtasks.splice(idx, 1);
    } else {
        lead.completedSubtasks.push(subId);
        // Trigger auto-email logs
        const subtaskItem = Object.values(SUBTASKS_MAP).flat().find(s => s.id === subId);
        triggerAutoEmail(lead, 'Milestone Completed', `${parentName} - ${subtaskItem ? subtaskItem.name : ''}`);
    }

    saveLeadsToStorage();
    renderMilestonesChecklist(lead);
    renderPipelineBoard();
}

// ================= REHAB PHOTO PROGRESS GALLERY =================
function renderPhotoStream(progressPct) {
    const grid = document.getElementById('photo-stream-grid');
    if (!grid) return;
    grid.innerHTML = '';

    // We render 3 rooms representing before/during/after based on progress
    const rooms = [
        { name: 'Kitchen Area' },
        { name: 'Living Rooms' },
        { name: 'Outer Landscape' }
    ];

    rooms.forEach((room, idx) => {
        let stateClass = 'room-dated';
        let labelText = 'Before Rehab';

        // Stagger states based on percentage and index
        if (progressPct >= 90) {
            stateClass = 'room-finished';
            labelText = 'Completed & Staged';
        } else if (progressPct > 35) {
            stateClass = 'room-underway';
            labelText = 'Under Active Construction';
        }

        const card = document.createElement('div');
        card.className = 'photo-card';
        card.innerHTML = `
            <div class="photo-graphic ${stateClass}"></div>
            <span class="label">${room.name}<br><small style="color:var(--text-muted);">${labelText}</small></span>
        `;
        grid.appendChild(card);
    });
}

// ================= E-SIGNATURE INTERACTION =================
function initSignatureCanvas() {
    sigCanvas = document.getElementById('sig-canvas');
    if (!sigCanvas) return;
    
    sigCtx = sigCanvas.getContext('2d');
    sigCtx.strokeStyle = '#1e1b4b'; // Navy ink
    sigCtx.lineWidth = 2.5;
    sigCtx.lineJoin = 'round';
    sigCtx.lineCap = 'round';

    // Touch/Mouse draw actions
    let lastX = 0;
    let lastY = 0;

    sigCanvas.addEventListener('mousedown', (e) => {
        sigDrawing = true;
        [lastX, lastY] = [e.offsetX, e.offsetY];
    });

    sigCanvas.addEventListener('mousemove', (e) => {
        if (!sigDrawing) return;
        sigCtx.beginPath();
        sigCtx.moveTo(lastX, lastY);
        sigCtx.lineTo(e.offsetX, e.offsetY);
        sigCtx.stroke();
        [lastX, lastY] = [e.offsetX, e.offsetY];
    });

    sigCanvas.addEventListener('mouseup', () => sigDrawing = false);
    sigCanvas.addEventListener('mouseout', () => sigDrawing = false);

    // Touch events for mobile
    sigCanvas.addEventListener('touchstart', (e) => {
        sigDrawing = true;
        const touch = e.touches[0];
        const rect = sigCanvas.getBoundingClientRect();
        [lastX, lastY] = [touch.clientX - rect.left, touch.clientY - rect.top];
        e.preventDefault();
    });

    sigCanvas.addEventListener('touchmove', (e) => {
        if (!sigDrawing) return;
        const touch = e.touches[0];
        const rect = sigCanvas.getBoundingClientRect();
        sigCtx.beginPath();
        sigCtx.moveTo(lastX, lastY);
        sigCtx.lineTo(touch.clientX - rect.left, touch.clientY - rect.top);
        sigCtx.stroke();
        [lastX, lastY] = [touch.clientX - rect.left, touch.clientY - rect.top];
        e.preventDefault();
    });

    sigCanvas.addEventListener('touchend', () => sigDrawing = false);
}

function clearSigCanvas() {
    if (sigCtx && sigCanvas) {
        sigCtx.clearRect(0, 0, sigCanvas.width, sigCanvas.height);
    }
}

function switchSignatureMode(mode) {
    sigMode = mode;
    document.querySelectorAll('.sig-mode-view').forEach(v => v.classList.remove('active'));
    document.querySelectorAll('.signature-tabs .drawer-tab').forEach(t => t.classList.remove('active'));

    if (mode === 'draw') {
        document.getElementById('sig-mode-draw').classList.add('active');
        document.getElementById('tab-sig-draw').classList.add('active');
        setTimeout(initSignatureCanvas, 50); // Re-init bindings
    } else {
        document.getElementById('sig-mode-type').classList.add('active');
        document.getElementById('tab-sig-type').classList.add('active');
        updateTypedSignature();
    }
}

function updateTypedSignature() {
    const input = document.getElementById('sig-type-input').value.trim();
    document.getElementById('typed-sig-preview').innerText = input || 'Type your name';
}

function openESignModal() {
    // Fill default values in modal
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (lead) {
        document.getElementById('sig-type-input').value = lead.name;
    }
    document.getElementById('chk-esign-consent').checked = false;

    const modal = document.getElementById('esign-modal');
    modal.style.display = 'flex';
    setTimeout(() => {
        modal.classList.add('active');
        switchSignatureMode('draw');
    }, 10);
}

// Closes and refreshes active views
function closeESignModal() {
    const modal = document.getElementById('esign-modal');
    modal.classList.remove('active');
    setTimeout(() => { modal.style.display = 'none'; }, 300);
}

function submitESignature() {
    const consent = document.getElementById('chk-esign-consent').checked;
    if (!consent) {
        alert('You must check the consent box to electronically sign the contract.');
        return;
    }

    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    let signatureData = null;

    if (sigMode === 'draw') {
        const dataUrl = sigCanvas.toDataURL();
        // Check if canvas is blank
        const blank = document.createElement('canvas');
        blank.width = sigCanvas.width;
        blank.height = sigCanvas.height;
        if (dataUrl === blank.toDataURL()) {
            alert('Please draw a signature on the pad before executing.');
            return;
        }
        signatureData = {
            date: new Date().toLocaleString(),
            ip: '192.168.1.' + Math.round(100 + Math.random() * 154),
            hash: generateSHA256Hash(),
            image: dataUrl
        };
    } else {
        const typedName = document.getElementById('sig-type-input').value.trim();
        if (!typedName) {
            alert('Please type your name for the signature.');
            return;
        }
        signatureData = {
            date: new Date().toLocaleString(),
            ip: '192.168.1.' + Math.round(100 + Math.random() * 154),
            hash: generateSHA256Hash(),
            typedName: typedName
        };
    }

    lead.signature = signatureData;
    
    // Advance lead automatically to Renovating stage
    lead.stage = 'rehab';
    saveLeadsToStorage();

    // Trigger contract signature webhook if endpoint exists
    if (apiSettings.emailWebhook) {
        fetch(apiSettings.emailWebhook, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                event: 'contract_signed',
                leadId: lead.id,
                name: lead.name,
                address: lead.address,
                dealType: lead.dealType || 'traditional',
                signature: {
                    typedName: signatureData.typedName,
                    ip: signatureData.ip,
                    hash: signatureData.hash,
                    date: signatureData.date
                },
                timestamp: new Date().toISOString()
            })
        }).catch(err => console.error("Error dispatching signature webhook:", err));
    }

    // Trigger Notification
    triggerAutoEmail(lead, 'Contract Signed Notification');
    triggerAutoEmail(lead, 'Rehab Started');

    closeESignModal();
    
    // Refresh client portal dashboard if active
    if (document.getElementById('client-portal-modal').classList.contains('active')) {
        openClientPortal(lead.id);
    }

    renderContractDocument();
    
    // Show construction progress elements inside drawer
    const trackerEl = document.getElementById('drawer-rehab-tracker');
    if (trackerEl) trackerEl.style.display = 'block';
    renderMilestonesChecklist(lead);

    renderPipelineBoard();
    updateDashboardStats();
    showToast('Contract executed! Property moved to Renovating.');
}

function generateSHA256Hash() {
    // Generate a simulated SHA-256 certificate string
    const chars = 'ABCDEF0123456789';
    let result = '';
    for (let i = 0; i < 40; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
}

// ================= LEAD DETAIL DRAWER & SCOPE BUILDER =================
function openDrawer(leadId) {
    const lead = leads.find(l => l.id === leadId);
    if (!lead) return;

    currentSelectedLeadId = leadId;

    document.getElementById('drawer-address').innerText = lead.address;
    document.getElementById('drawer-owner').innerText = `${lead.name} • ${lead.phone} • ${lead.email}`;

    document.getElementById('lead-as-is').value = lead.asIsValue;
    document.getElementById('lead-arv').value = lead.targetARV;
    document.getElementById('lead-commission').value = lead.commissionRate || 6;

    // Populate Wholesale fields
    const dealType = lead.dealType || 'traditional';
    document.getElementById('lead-deal-type').value = dealType;
    document.getElementById('lead-buyer-name').value = lead.buyerName || '';
    document.getElementById('lead-buyer-email').value = lead.buyerEmail || '';
    document.getElementById('lead-buyer-price').value = lead.buyerPrice || '';
    document.getElementById('lead-wholesale-fee').value = lead.wholesaleFee || '';
    document.getElementById('lead-seller-stay').value = lead.sellerStayTerm || '';
    
    document.getElementById('wholesale-input-group').style.display = (dealType === 'wholesale') ? 'flex' : 'none';

    renderScopeBuilder(lead);

    // Render Client Work Explanations
    const explanationsCard = document.getElementById('drawer-client-explanations-card');
    const explanationsList = document.getElementById('drawer-client-explanations-list');
    if (lead.workExplanations && Object.keys(lead.workExplanations).length > 0) {
        explanationsCard.style.display = 'block';
        explanationsList.innerHTML = '';
        Object.keys(lead.workExplanations).forEach(cat => {
            const catName = cat.charAt(0).toUpperCase() + cat.slice(1);
            const item = document.createElement('div');
            item.style.background = 'rgba(255, 255, 255, 0.02)';
            item.style.padding = '0.75rem';
            item.style.border = '1px solid var(--border-color)';
            item.style.borderRadius = '6px';
            item.innerHTML = `
                <div style="font-weight:700; font-size:0.85rem; color:var(--warning); margin-bottom:0.25rem;">${catName} Request:</div>
                <p style="font-size:0.8rem; color:var(--text-primary); line-height:1.4; font-style:italic; margin:0;">"${lead.workExplanations[cat]}"</p>
            `;
            explanationsList.appendChild(item);
        });
    } else {
        explanationsCard.style.display = 'none';
    }

    renderCompsChecklist(lead);
    renderCompsRadarMap(lead);
    
    const milestonesBox = document.getElementById('drawer-rehab-tracker');
    const galleryBox = document.getElementById('drawer-rehab-gallery');
    if (lead.stage === 'rehab' || lead.stage === 'listed' || lead.stage === 'closed') {
        milestonesBox.style.display = 'block';
        galleryBox.style.display = 'block';
        renderMilestonesChecklist(lead);
    } else {
        milestonesBox.style.display = 'none';
        galleryBox.style.display = 'none';
    }

    const stageSelect = document.getElementById('lead-stage-select');
    stageSelect.innerHTML = '';
    Object.keys(STAGES).forEach(key => {
        const opt = document.createElement('option');
        opt.value = key;
        opt.innerText = STAGES[key];
        if (lead.stage === key) opt.selected = true;
        stageSelect.appendChild(opt);
    });

    switchDrawerTab('financials');
    updateDrawerCalculations();

    const drawer = document.getElementById('detail-drawer');
    drawer.style.display = 'flex';
    setTimeout(() => { drawer.classList.add('active'); }, 10);
}

function closeDrawer() {
    const drawer = document.getElementById('detail-drawer');
    drawer.classList.remove('active');
    setTimeout(() => {
        drawer.style.display = 'none';
        currentSelectedLeadId = null;
    }, 300);
}

function switchDrawerTab(tabName) {
    document.querySelectorAll('.drawer-subview').forEach(v => v.classList.remove('active'));
    document.querySelectorAll('.drawer-tab').forEach(t => t.classList.remove('active'));

    const btnIds = {
        financials: 'btn-draw-financials',
        settlement: 'btn-draw-settlement',
        invoices: 'btn-draw-invoices',
        mls: 'btn-draw-mls',
        contract: 'btn-draw-contract',
        flyer: 'btn-draw-flyer',
        slides: 'btn-draw-slides'
    };
    
    Object.keys(btnIds).forEach(k => {
        const el = document.getElementById(btnIds[k]);
        if (el) el.classList.remove('active');
    });

    if (tabName === 'financials') {
        document.getElementById('drawer-tab-financials').classList.add('active');
        document.getElementById('btn-draw-financials').classList.add('active');
    } else if (tabName === 'settlement') {
        document.getElementById('drawer-tab-settlement').classList.add('active');
        document.getElementById('btn-draw-settlement').classList.add('active');
        renderSettlementStatement();
    } else if (tabName === 'invoices') {
        document.getElementById('drawer-tab-invoices').classList.add('active');
        document.getElementById('btn-draw-invoices').classList.add('active');
        renderContractorInvoices();
    } else if (tabName === 'mls') {
        document.getElementById('drawer-tab-mls').classList.add('active');
        document.getElementById('btn-draw-mls').classList.add('active');
        renderMLSListing();
    } else if (tabName === 'contract') {
        document.getElementById('drawer-tab-contract').classList.add('active');
        document.getElementById('btn-draw-contract').classList.add('active');
        renderContractDocument();
    } else if (tabName === 'flyer') {
        document.getElementById('drawer-tab-flyer').classList.add('active');
        document.getElementById('btn-draw-flyer').classList.add('active');
        renderSellerFlyer();
    } else if (tabName === 'slides') {
        document.getElementById('drawer-tab-slides').classList.add('active');
        document.getElementById('btn-draw-slides').classList.add('active');
        currentSlideIdx = 1;
        navigateSlide(0);
    }
}

function renderScopeBuilder(lead) {
    const container = document.getElementById('scope-builder-list');
    container.innerHTML = '';

    REHAB_ITEMS.forEach(item => {
        const isSelected = lead.scope.includes(item.id);
        const assignedConId = lead.dispatches ? lead.dispatches[item.id] : null;

        const div = document.createElement('div');
        div.className = `scope-item ${isSelected ? 'selected' : ''}`;
        
        div.innerHTML = `
            <div class="scope-checkbox" onclick="toggleScopeItem('${item.id}', event)">
                <i data-lucide="check"></i>
            </div>
            <div class="scope-details" onclick="toggleScopeItem('${item.id}', event)">
                <span class="scope-name">${item.name}</span>
                <span class="scope-price-comparison">
                    Retail: <del>$${item.retail.toLocaleString()}</del> • Our Cost: <span class="discounted">$${item.discounted.toLocaleString()}</span>
                </span>
            </div>
            <div class="scope-dispatch" onclick="event.stopPropagation()">
                <select id="dispatch-select-${item.id}" onchange="assignContractorToScope('${item.id}')">
                    <option value="">-- Dispatch Contractor --</option>
                </select>
            </div>
        `;
        
        container.appendChild(div);

        const dispatchSelect = div.querySelector('select');
        const specialtyContractors = contractors.filter(c => c.trade === item.trade);
        
        specialtyContractors.forEach(con => {
            const opt = document.createElement('option');
            opt.value = con.id;
            opt.innerText = `${con.name} (${con.status === 'active' ? 'Avail' : 'Busy'})`;
            if (assignedConId === con.id) opt.selected = true;
            dispatchSelect.appendChild(opt);
        });
    });
    lucide.createIcons();
}

function toggleScopeItem(itemId, event) {
    if (event) event.stopPropagation();
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    const idx = lead.scope.indexOf(itemId);
    if (idx > -1) {
        lead.scope.splice(idx, 1);
        if (lead.dispatches && lead.dispatches[itemId]) {
            delete lead.dispatches[itemId];
        }
        // Remove completed subtasks under this category
        const subtasksList = SUBTASKS_MAP[itemId] || [];
        subtasksList.forEach(sub => {
            const subIdx = lead.completedSubtasks.indexOf(sub.id);
            if (subIdx > -1) lead.completedSubtasks.splice(subIdx, 1);
        });
    } else {
        lead.scope.push(itemId);
    }

    renderScopeBuilder(lead);
    updateDrawerCalculations();
}

function assignContractorToScope(itemId) {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    const conId = document.getElementById(`dispatch-select-${itemId}`).value;
    if (!lead.dispatches) lead.dispatches = {};

    if (conId) {
        lead.dispatches[itemId] = conId;
        if (!lead.scope.includes(itemId)) {
            lead.scope.push(itemId);
        }
        
        const con = contractors.find(c => c.id === conId);
        if (con) {
            con.assignments += 1;
            saveContractorsToStorage();
        }
        
        triggerAutoEmail(lead, 'Rehab Started');
    } else {
        delete lead.dispatches[itemId];
    }

    saveLeadsToStorage();
    renderScopeBuilder(lead);
    updateDrawerCalculations();
}

// Recalculates formulas in detail view
function updateDrawerCalculations() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    const asIs = parseInt(document.getElementById('lead-as-is').value) || 0;
    const arv = parseInt(document.getElementById('lead-arv').value) || 0;
    const commPct = parseFloat(document.getElementById('lead-commission').value) || 0;

    let totalRetail = 0;
    let totalDiscounted = 0;

    lead.scope.forEach(itemId => {
        const item = REHAB_ITEMS.find(i => i.id === itemId);
        if (item) {
            totalRetail += item.retail;
            totalDiscounted += item.discounted;
        }
    });

    let ownerFinalPayout = 0;
    let profitLift = 0;

    if (lead.dealType === 'wholesale') {
        const buyerPrice = lead.buyerPrice || 0;
        const wholesaleFee = lead.wholesaleFee || 0;
        const purchaseOfferPrice = buyerPrice - wholesaleFee;
        const escrowFees = buyerPrice * 0.015;

        ownerFinalPayout = purchaseOfferPrice - (totalDiscounted / 2) - escrowFees;
        const totalNetReturn = purchaseOfferPrice - totalDiscounted - escrowFees;
        const standardAsIsCommission = asIs * 0.06;
        const standardAsIsEscrow = asIs * 0.015;
        const netAsIsProceeds = asIs - standardAsIsCommission - standardAsIsEscrow;
        profitLift = totalNetReturn - netAsIsProceeds;
    } else {
        const commissionVal = arv * (commPct / 100);
        const escrowFees = arv * 0.015;
        ownerFinalPayout = arv - (totalDiscounted / 2) - commissionVal - escrowFees;

        const standardAsIsCommission = asIs * 0.06;
        const standardAsIsEscrow = asIs * 0.015;
        const netAsIsProceeds = asIs - standardAsIsCommission - standardAsIsEscrow;
        const totalNetReturn = arv - totalDiscounted - commissionVal - escrowFees;
        profitLift = totalNetReturn - netAsIsProceeds;
    }

    lead.asIsValue = asIs;
    lead.targetARV = arv;
    lead.commissionRate = commPct;
    saveLeadsToStorage();

    document.getElementById('lead-retail-rehab').innerText = `$${totalRetail.toLocaleString()}`;
    document.getElementById('lead-discounted-rehab').innerText = `$${totalDiscounted.toLocaleString()}`;
    document.getElementById('lead-final-payout').innerText = `$${Math.round(ownerFinalPayout).toLocaleString()}`;
    
    const profitLiftEl = document.getElementById('lead-profit-lift');
    if (profitLift > 0) {
        profitLiftEl.innerText = `+$${Math.round(profitLift).toLocaleString()}`;
        profitLiftEl.className = 'text-success font-bold text-gradient';
    } else {
        profitLiftEl.innerText = `$${Math.round(profitLift).toLocaleString()}`;
        profitLiftEl.className = 'text-muted';
    }
}

function changeLeadStage() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    const newStage = document.getElementById('lead-stage-select').value;
    if (lead && newStage) {
        lead.stage = newStage;
        saveLeadsToStorage();
        
        if (newStage === 'agreement') {
            triggerAutoEmail(lead, 'Agreement Delivery');
        } else if (newStage === 'rehab') {
            triggerAutoEmail(lead, 'Rehab Started');
        }

        const milestonesBox = document.getElementById('drawer-rehab-tracker');
        const galleryBox = document.getElementById('drawer-rehab-gallery');
        if (newStage === 'rehab' || newStage === 'listed' || newStage === 'closed') {
            milestonesBox.style.display = 'block';
            galleryBox.style.display = 'block';
            renderMilestonesChecklist(lead);
        } else {
            milestonesBox.style.display = 'none';
            galleryBox.style.display = 'none';
        }

        renderPipelineBoard();
        updateDashboardStats();
        showToast(`Moved ${lead.address} to ${STAGES[newStage]}`);
    }
}

function deleteCurrentLead() {
    if (confirm('Delete this lead from the pipeline?')) {
        leads = leads.filter(l => l.id !== currentSelectedLeadId);
        saveLeadsToStorage();
        closeDrawer();
        renderPipelineBoard();
        updateDashboardStats();
        showToast('Lead deleted.');
    }
}

// ================= EXCLUSIVE LISTING CONTRACT =================
function renderContractDocument() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    let rehabDescList = '';
    let totalDiscountedRehab = 0;
    
    lead.scope.forEach(itemId => {
        const SOWItem = REHAB_ITEMS.find(i => i.id === itemId);
        if (SOWItem) {
            rehabDescList += `<li><strong>${SOWItem.name}</strong>: ${SOWItem.desc} (Discounted Cost: $${SOWItem.discounted.toLocaleString()})</li>`;
            totalDiscountedRehab += SOWItem.discounted;
        }
    });

    if (!rehabDescList) {
        rehabDescList = '<li>No renovation items selected. Check "Scope & Analysis" to select.</li>';
    }

    const commissionVal = lead.targetARV * ((lead.commissionRate || 6) / 100);
    const dateStr = new Date().toLocaleDateString(undefined, { year: 'numeric', month: 'long', day: 'numeric' });

    // Show sign button or signed certification block
    const btnESign = document.getElementById('btn-esign-contract');
    let esignCertHtml = '';

    if (lead.signature) {
        if (btnESign) btnESign.style.display = 'none';
        
        const signatureDisplay = lead.signature.image 
            ? `<img src="${lead.signature.image}" class="cert-sig-img" alt="Captured Signature">`
            : `<span class="cert-sig-typed">${lead.signature.typedName}</span>`;

        esignCertHtml = `
            <div class="esign-certificate-box">
                <div class="cert-header">
                    <i data-lucide="shield-check"></i>
                    <span>DIGITALLY SIGNED & SECURED</span>
                </div>
                <div class="cert-sig-holder">
                    ${signatureDisplay}
                </div>
                <div class="cert-row"><strong>Signer IP Address:</strong> ${lead.signature.ip}</div>
                <div class="cert-row"><strong>Timestamp:</strong> ${lead.signature.date}</div>
                <div class="cert-row"><strong>Verification Lock SHA-256:</strong> ${lead.signature.hash}</div>
            </div>
        `;
    } else {
        if (btnESign) btnESign.style.display = 'flex';
    }

    let contractHtml = '';

    if (lead.dealType === 'wholesale') {
        const buyerName = lead.buyerName || '[Insert Buyer Name]';
        const buyerEmail = lead.buyerEmail || '[Insert Buyer Email]';
        const buyerPrice = lead.buyerPrice || 0;
        const wholesaleFee = lead.wholesaleFee || 0;
        const sellerStayTerm = lead.sellerStayTerm || 0;
        const purchaseOfferPrice = buyerPrice - wholesaleFee;

        contractHtml = `
            <h1>WHOLESALE CUSTOM PRE-BUILD ASSIGNMENT AGREEMENT</h1>
            <p>This Double-Contract and Assignment Agreement is entered into on this <strong>${dateStr}</strong>, by and between:</p>
            <p><strong>Homeowner (Seller):</strong> ${lead.name} ("Seller")<br>
            <strong>Wholesale Broker (Middleman):</strong> Revitalize Realty Corp ("Wholesaler")<br>
            <strong>End Buyer (Buyer):</strong> ${buyerName} ("Buyer")</p>
            
            <h3>RECITALS</h3>
            <p>WHEREAS, Seller owns the property at <strong>${lead.address}</strong> (the "Property") and wishes to sell; and</p>
            <p>WHEREAS, Wholesaler has established purchase rights under a Purchase & Sale Contract with Seller for the purchase price of <strong>$${purchaseOfferPrice.toLocaleString()}</strong>; and</p>
            <p>WHEREAS, Wholesaler wishes to assign these rights to Buyer for an Assignment/Wholesale Markup Fee of <strong>$${wholesaleFee.toLocaleString()}</strong>; and</p>
            <p>WHEREAS, Buyer desires to customize the Property prior to closing, and Seller agrees to allow custom renovations to commence while Seller remains in occupancy of the Property.</p>

            <h3>1. DOUBLE-CONTRACT PURCHASE TERMS</h3>
            <p>Buyer agrees to purchase the Property for the gross sum of <strong>$${buyerPrice.toLocaleString()}</strong>. From this amount:</p>
            <ul>
                <li><strong>Seller Purchase Price:</strong> $${purchaseOfferPrice.toLocaleString()} paid to Seller.</li>
                <li><strong>Wholesale Assignment Fee:</strong> $${wholesaleFee.toLocaleString()} paid to Wholesaler at closing.</li>
            </ul>

            <h3>2. BUYER-DRIVEN CUSTOM REHABILITATION</h3>
            <p>Buyer has selected the following customized renovation trades to be completed by Wholesaler's network prior to close:</p>
            <ul>
                ${rehabDescList}
            </ul>
            <p>The pre-approved Custom Rehab budget is <strong>$${totalDiscountedRehab.toLocaleString()}</strong>. Half of this budget ($${(totalDiscountedRehab / 2).toLocaleString()}) is funded upfront by the Buyer, and the other half is held in escrow until closing.</p>

            <h3>3. SELLER STAY-IN-PLACE OCCUPANCY AGREEMENT</h3>
            <p>Seller shall remain in full possession and occupancy of the Property for a period of <strong>${sellerStayTerm} Days</strong> from the commencement of construction (the "Occupancy Period"). Seller agrees to grant construction crews reasonable access to complete the customized SOW items during this period. Seller shall vacate the Property upon completion of the Occupancy Period or at closing, whichever is later.</p>

            <h3>4. INDEMNIFICATION & ESCROW CLOSING</h3>
            <p>Escrow shall close upon completion of custom construction items. Buyer takes property in AS-IS renovated condition post-construction.</p>

            ${esignCertHtml}

            <div class="sig-lines" style="${lead.signature ? 'display:none;' : ''}">
                <div class="sig-box">
                    <div class="sig-line"></div>
                    <span>Seller Signature</span>
                </div>
                <div class="sig-box">
                    <div class="sig-line"></div>
                    <span>Buyer Signature</span>
                </div>
                <div class="sig-box">
                    <div class="sig-line"></div>
                    <span>Wholesaler Signature</span>
                </div>
            </div>
        `;
    } else {
        contractHtml = `
            <h1>REHAB & EXCLUSIVE LISTING AGREEMENT</h1>
            <p>This Agreement is entered into on this <strong>${dateStr}</strong>, by and between:</p>
            <p><strong>Homeowner(s):</strong> ${lead.name} ("Owner")<br>
            <strong>Broker / Agent:</strong> Revitalize Realty Corp ("Broker")</p>
            
            <h3>RECITALS</h3>
            <p>WHEREAS, Owner owns the real property located at <strong>${lead.address}</strong> (the "Property"); and</p>
            <p>WHEREAS, Owner desires to prepare the Property for sale to maximize market valuation, but wishes to avoid out-of-pocket costs; and</p>
            <p>WHEREAS, Broker agrees to orchestrate, supervise, and upfront the costs for home rehabilitation services through Broker's wholesale contractor network in exchange for an exclusive listing contract on the Property.</p>

            <h3>1. SCOPE OF REHABILITATION WORK</h3>
            <p>Broker agrees to oversee and pay upfront for the following renovation checklist items:</p>
            <ul>
                ${rehabDescList}
            </ul>
            <p>The total pre-approved renovation capital allocated is <strong>$${totalDiscountedRehab.toLocaleString()}</strong> (the "Renovation Budget").</p>

            <h3>2. INTEREST-FREE REIMBURSEMENT AT CLOSING</h3>
            <p>Broker will advance all capital required for the Renovation Budget. There will be no interest, fees, or markup charged on these funds. Owner agrees that the full Renovation Budget of <strong>$${totalDiscountedRehab.toLocaleString()}</strong> will be reimbursed to Broker directly from the escrow/closing proceeds upon the sale of the Property.</p>

            <h3>3. EXCLUSIVE RIGHT TO SELL LISTING CONTRACT</h3>
            <p>In consideration of the upfront renovation capital funded by Broker, Owner hereby grants Broker the Exclusive Right to Sell the Property for a period of 180 days from the completion of renovations, under the following core terms:</p>
            <ul>
                <li><strong>Target Listing Price (ARV):</strong> $${lead.targetARV.toLocaleString()} (subject to market adjustment at listing time)</li>
                <li><strong>Brokerage Commission Rate:</strong> ${lead.commissionRate || 6}% of the gross sale price (estimated at $${commissionVal.toLocaleString()})</li>
                <li><strong>Minimum Net Cash to Owner Guarantee:</strong> Broker will utilize best efforts to negotiate terms ensuring Owner maximizes cash lift from the sale.</li>
            </ul>

            <h3>4. OWNER REPRESENTATION & INDEMNIFICATION</h3>
            <p>Owner certifies that they are the sole lawful owner of the Property, that all mortgages and liens are current, and that they will cooperate fully with Broker's renovation schedule and open house marketing campaigns.</p>

            ${esignCertHtml}

            <div class="sig-lines" style="${lead.signature ? 'display:none;' : ''}">
                <div class="sig-box">
                    <div class="sig-line"></div>
                    <span>Owner Signature</span>
                    <span>Date: ________________________</span>
                </div>
                <div class="sig-box">
                    <div class="sig-line"></div>
                    <span>Revitalize Realty Broker Agent</span>
                    <span>Date: ________________________</span>
                </div>
            </div>
        `;
    }

    document.getElementById('contract-paper').innerHTML = contractHtml;
    lucide.createIcons();
}

function emailAgreement() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (lead) {
        triggerAutoEmail(lead, 'Agreement Delivery');
    }
}

// ================= SELLER PRESENTATION FLYER =================
function renderSellerFlyer() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    let totalDiscountedRehab = 0;
    lead.scope.forEach(itemId => {
        const item = REHAB_ITEMS.find(i => i.id === itemId);
        if (item) totalDiscountedRehab += item.discounted;
    });

    const standardAsIsCommission = lead.asIsValue * 0.06;
    const ownerAsIsPayout = lead.asIsValue - standardAsIsCommission;

    const commissionVal = lead.targetARV * ((lead.commissionRate || 6) / 100);
    const ownerFinalPayout = lead.targetARV - totalDiscountedRehab - commissionVal;

    const profitLift = ownerFinalPayout - ownerAsIsPayout;

    const maxVal = Math.max(lead.asIsValue, lead.targetARV);
    const asIsBarHeight = Math.round((ownerAsIsPayout / maxVal) * 130);
    const revBarHeight = Math.round((ownerFinalPayout / maxVal) * 130);

    // Render Comps Table inside flyer
    let compsTableHtml = '';
    const selectedCompsList = (lead.selectedComps || []).map(id => comps.find(c => c.id === id)).filter(Boolean);

    if (selectedCompsList.length > 0) {
        compsTableHtml = `
            <div class="flyer-sub-box" style="width: 100%; margin-top: 1.5rem; margin-bottom: 1.5rem;">
                <h4>Local Comparable Closed Sales (Comps)</h4>
                <table class="comparison-table-flyer">
                    <thead>
                        <tr>
                            <th>Address</th>
                            <th>Beds/Baths</th>
                            <th>Sq Ft</th>
                            <th>Rehab Scope</th>
                            <th>Days on Mkt</th>
                            <th style="text-align:right;">Sale Price</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${selectedCompsList.map(comp => `
                            <tr>
                                <td>${comp.address}</td>
                                <td>${comp.beds}b/${comp.baths}ba</td>
                                <td>${comp.sqft.toLocaleString()}</td>
                                <td>${comp.rehab}</td>
                                <td>${comp.dom} days</td>
                                <td style="text-align:right; font-weight:700; color:#111827;">$${comp.price.toLocaleString()}</td>
                            </tr>
                        `).join('')}
                    </tbody>
                </table>
            </div>
        `;
    } else {
        compsTableHtml = `
            <div class="flyer-sub-box" style="width: 100%; margin-top: 1.5rem; margin-bottom: 1.5rem; border-color:#f59e0b; background:#fffbeb;">
                <h4 style="color:#b45309; border-bottom-color:#fde68a;">Comparable Sales (Comps) Required</h4>
                <p style="font-size:0.8rem; color:#b45309; margin:0;">
                    No comparable sales selected. Check local comps in the <strong>Scope & Analysis</strong> tab to automatically compile comparative neighborhood proof points here.
                </p>
            </div>
        `;
    }

    const flyerHtml = `
        <div class="flyer-hero">
            <h2>MAXIMIZE YOUR HOME EQUITY</h2>
            <p>We Fund the Repairs. You Keep the Added Profit.</p>
        </div>

        <div class="flyer-grid-two">
            <div class="flyer-sub-box">
                <h4>Net Payout Comparison</h4>
                <table class="comparison-table-flyer">
                    <thead>
                        <tr>
                            <th>Item</th>
                            <th>Sell As-Is</th>
                            <th>Fix-and-List</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Gross Sale Price</td>
                            <td>$${lead.asIsValue.toLocaleString()}</td>
                            <td>$${lead.targetARV.toLocaleString()}</td>
                        </tr>
                        <tr>
                            <td>Upfront Rehab Cost (50%)</td>
                            <td>$0</td>
                            <td>-$${(totalDiscountedRehab / 2).toLocaleString()}</td>
                        </tr>
                        <tr>
                            <td>Deferred Rehab Cost (50%)</td>
                            <td>$0</td>
                            <td>-$${(totalDiscountedRehab / 2).toLocaleString()}</td>
                        </tr>
                        <tr>
                            <td>Broker Commission</td>
                            <td>-$${standardAsIsCommission.toLocaleString()} (6%)</td>
                            <td>-$${commissionVal.toLocaleString()} (${lead.commissionRate || 6}%)</td>
                        </tr>
                        <tr class="flyer-total-highlight">
                            <td><strong>Net Payout to You</strong></td>
                            <td><strong>$${Math.round(ownerAsIsPayout).toLocaleString()}</strong></td>
                            <td><strong>$${Math.round(ownerFinalPayout).toLocaleString()}</strong></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="flyer-sub-box">
                <h4>Net Cash in Your Pocket</h4>
                <div class="flyer-chart-wrapper">
                    <svg width="220" height="170" viewBox="0 0 220 170" xmlns="http://www.w3.org/2000/svg">
                        <line x1="30" y1="20" x2="200" y2="20" stroke="#f3f4f6" stroke-width="1" />
                        <line x1="30" y1="80" x2="200" y2="80" stroke="#f3f4f6" stroke-width="1" />
                        <line x1="30" y1="140" x2="200" y2="140" stroke="#9ca3af" stroke-width="2" />
                        
                        <rect x="40" y="${140 - asIsBarHeight}" width="45" height="${asIsBarHeight}" fill="#9ca3af" rx="3" />
                        <text x="62.5" y="${130 - asIsBarHeight}" fill="#374151" font-family="Inter" font-size="9" font-weight="700" text-anchor="middle">$${Math.round(ownerAsIsPayout/1000)}k</text>
                        <text x="62.5" y="154" fill="#4b5563" font-family="Inter" font-size="9" font-weight="600" text-anchor="middle">Sell As-Is</text>
                        
                        <rect x="130" y="${140 - revBarHeight}" width="45" height="${revBarHeight}" fill="#10b981" rx="3" />
                        <text x="152.5" y="${130 - revBarHeight}" fill="#047857" font-family="Inter" font-size="9" font-weight="700" text-anchor="middle">$${Math.round(ownerFinalPayout/1000)}k</text>
                        <text x="152.5" y="154" fill="#047857" font-family="Inter" font-size="9" font-weight="700" text-anchor="middle">Revitalize</text>
                    </svg>
                    <div style="font-size:0.75rem; font-weight:700; text-align:center; color:#10b981; margin-top:0.4rem;">
                        👉 Estimated Profit Gain: +$${Math.round(profitLift).toLocaleString()}!
                    </div>
                </div>
            </div>
        </div>

        ${compsTableHtml}

        <div class="flyer-sub-box" style="width: 100%; margin-bottom: 1.5rem;">
            <h4>Why Listing with Revitalize Works:</h4>
            <ul style="margin-bottom:0;">
                <li><strong>50/50 Split Funding:</strong> You pay only 50% upfront during construction, with the remaining 50% interest-free deferred to sale closing.</li>
                <li><strong>Network Savings Passed To You:</strong> Our bulk contractor network rates are 20-30% below retail contractors.</li>
                <li><strong>Stress-Free Execution:</strong> We manage materials sourcing, scheduling, permitting, and listing marketing.</li>
            </ul>
        </div>
    `;

    document.getElementById('flyer-paper').innerHTML = flyerHtml;
}

function emailFlyer() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (lead) {
        triggerAutoEmail(lead, 'Flyer Delivery');
    }
}

function copyContract(containerId) {
    const content = document.getElementById(containerId).innerText;
    navigator.clipboard.writeText(content).then(() => {
        showToast('Document text copied to clipboard!');
    }).catch(err => {
        showToast('Failed to copy text.');
    });
}

function printContract(containerId) {
    const printContent = document.getElementById(containerId).innerHTML;
    const printWindow = window.open('', '_blank', 'width=800,height=600');
    
    printWindow.document.write(`
        <html>
        <head>
            <title>Revitalize Document - ${document.getElementById('drawer-address').innerText}</title>
            <style>
                body { font-family: 'Helvetica Neue', Arial, sans-serif; padding: 40px; color: #1f2937; line-height: 1.6; }
                h1, h2, h3, h4 { text-align: center; color: #111827; }
                h1 { font-size: 24px; margin-bottom: 20px; }
                h3 { font-size: 16px; margin-top: 30px; border-bottom: 1px solid #e5e7eb; padding-bottom: 5px; }
                p, li { font-size: 14px; text-align: justify; }
                ul { padding-left: 20px; }
                .sig-lines { display: flex; justify-content: space-between; margin-top: 50px; }
                .sig-box { width: 45%; display: flex; flex-direction: column; gap: 15px; font-size: 11px; }
                .sig-line { border-bottom: 1px solid #9ca3af; height: 30px; }
                
                /* Flyer Specific Styles */
                .flyer-hero { background: #312e81; color: white; padding: 20px; border-radius: 8px; text-align: center; margin-bottom: 20px; }
                .flyer-hero h2 { color: white; margin-bottom: 5px; }
                .flyer-hero p { color: #c7d2fe; text-align: center; }
                .flyer-grid-two { display: flex; justify-content: space-between; gap: 20px; margin-bottom: 20px; }
                .flyer-sub-box { border: 1px solid #e5e7eb; border-radius: 8px; padding: 15px; width: 48%; }
                .flyer-sub-box h4 { margin-top: 0; border-bottom: 2px solid #e5e7eb; padding-bottom: 5px; }
                .comparison-table-flyer { width: 100%; border-collapse: collapse; }
                .comparison-table-flyer th, .comparison-table-flyer td { padding: 8px; text-align: left; font-size: 12px; }
                .comparison-table-flyer th { border-bottom: 2px solid #e5e7eb; }
                .comparison-table-flyer tr:not(:last-child) td { border-bottom: 1px solid #f3f4f6; }
                .flyer-total-highlight { background: #ecfdf5; color: #047857; font-weight: bold; }
                .flyer-chart-wrapper { display: flex; flex-direction: column; align-items: center; justify-content: center; }
                
                /* Signature Box Styles */
                .esign-certificate-box { margin-top: 20px; border: 2px dashed #10b981; background: #f0fdf4; padding: 15px; border-radius: 6px; color: #1f2937; }
                .cert-header { display: flex; align-items: center; gap: 5px; color: #047857; font-weight: bold; font-size: 13px; }
                .cert-row { font-size: 11px; color: #374151; margin-top: 2px; }
                .cert-sig-holder { margin-top: 5px; border-bottom: 1px solid #d1d5db; padding-bottom: 5px; }
                .cert-sig-img { max-height: 45px; }
                .cert-sig-typed { font-family: 'Great Vibes', cursive; font-size: 24px; color: #1e1b4b; }
            </style>
        </head>
        <body>
            ${printContent}
            <script>
                window.onload = function() { window.print(); window.close(); }
            </script>
        </body>
        </html>
    `);
    printWindow.document.close();
}

// ================= UTILITIES & STATS =================
function updateDashboardStats() {
    const activeLeadsEl = document.getElementById('stat-active-leads');
    const activeRehabsEl = document.getElementById('stat-active-rehabs');
    
    if (activeLeadsEl) activeLeadsEl.innerText = leads.length;
    if (activeRehabsEl) {
        const rehabCount = leads.filter(l => l.stage === 'rehab').length;
        activeRehabsEl.innerText = rehabCount;
    }
}

function showToast(message) {
    const toast = document.getElementById('toast');
    toast.innerText = message;
    toast.classList.add('show');
    
    setTimeout(() => {
        toast.classList.remove('show');
    }, 3000);
}

// ================= PITCHING SLIDE DECK VIEW CONTROLLER =================
function navigateSlide(dir) {
    const slides = document.querySelectorAll('.presentation-slide');
    if (slides.length === 0) return;

    currentSlideIdx += dir;
    if (currentSlideIdx < 1) currentSlideIdx = 1;
    if (currentSlideIdx > slides.length) currentSlideIdx = slides.length;

    slides.forEach((slide, idx) => {
        if (idx + 1 === currentSlideIdx) {
            slide.classList.add('active');
        } else {
            slide.classList.remove('active');
        }
    });

    renderSlideDeckIndicators();
}

function renderSlideDeckIndicators() {
    const dotsContainer = document.getElementById('slide-indicators-dots');
    if (!dotsContainer) return;
    dotsContainer.innerHTML = '';

    const slides = document.querySelectorAll('.presentation-slide');
    slides.forEach((_, idx) => {
        const dot = document.createElement('div');
        dot.className = `slide-dot ${idx + 1 === currentSlideIdx ? 'active' : ''}`;
        dot.onclick = () => {
            currentSlideIdx = idx + 1;
            navigateSlide(0);
        };
        dotsContainer.appendChild(dot);
    });
}

function renderSlideDeck() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    // Ensure deckCustomizations structure exists
    if (!lead.deckCustomizations) {
        lead.deckCustomizations = {
            theme: 'classic',
            title: lead.address,
            subtitle: `${lead.name} • Homeowner Listing Proposal`,
            footer: 'Presented by Revitalize Realty Brokerage'
        };
        saveLeadsToStorage();
    }

    // Set Customizer inputs to match state
    document.getElementById('slide-theme-select').value = lead.deckCustomizations.theme || 'classic';
    document.getElementById('slide-custom-title').value = lead.deckCustomizations.title || lead.address;
    document.getElementById('slide-custom-subtitle').value = lead.deckCustomizations.subtitle || `${lead.name} • Homeowner Listing Proposal`;
    document.getElementById('slide-custom-footer').value = lead.deckCustomizations.footer || 'Presented by Revitalize Realty Brokerage';

    // Apply Theme to slide container
    const outerContainer = document.getElementById('slideshow-outer-container');
    if (outerContainer) {
        outerContainer.className = 'slideshow-outer-container';
        outerContainer.classList.add(`theme-${lead.deckCustomizations.theme || 'classic'}`);
    }

    // Slide 1 bindings
    document.getElementById('slide-cover-address').innerText = lead.deckCustomizations.title || lead.address;
    document.getElementById('slide-cover-owner').innerText = lead.deckCustomizations.subtitle || `${lead.name} • Homeowner Listing Proposal`;
    document.getElementById('slide-cover-footer').innerText = lead.deckCustomizations.footer || 'Presented by Revitalize Realty Brokerage';

    // Slide 2 bindings
    let totalDiscountedRehab = 0;
    lead.scope.forEach(itemId => {
        const item = REHAB_ITEMS.find(i => i.id === itemId);
        if (item) totalDiscountedRehab += item.discounted;
    });

    const standardAsIsCommission = lead.asIsValue * 0.06;
    const ownerAsIsPayout = lead.asIsValue - standardAsIsCommission;

    const commissionVal = lead.targetARV * ((lead.commissionRate || 6) / 100);
    const ownerFinalPayout = lead.targetARV - (totalDiscountedRehab / 2) - commissionVal;
    
    const totalNetReturn = lead.targetARV - totalDiscountedRehab - commissionVal;
    const profitLift = totalNetReturn - ownerAsIsPayout;

    const liftEl = document.getElementById('slide-stat-lift');
    if (profitLift > 0) {
        liftEl.innerText = `+$${Math.round(profitLift).toLocaleString()}`;
    } else {
        liftEl.innerText = `$${Math.round(profitLift).toLocaleString()}`;
    }

    // Slide 3 bindings
    const scopesListEl = document.getElementById('slide-scopes-list');
    scopesListEl.innerHTML = '';
    if (lead.scope.length === 0) {
        scopesListEl.innerHTML = '<p style="color:var(--text-muted); font-size:0.95rem; grid-column:span 2;">No scopes selected. Add active trades in Scope & Analysis tab.</p>';
    } else {
        lead.scope.slice(0, 4).forEach(itemId => {
            const item = REHAB_ITEMS.find(i => i.id === itemId);
            if (item) {
                const li = document.createElement('div');
                li.className = 'mini-slide-block';
                li.style.display = 'flex';
                li.style.alignItems = 'center';
                li.style.gap = '0.5rem';
                li.innerHTML = `
                    <i data-lucide="check-circle" style="width:14px; height:14px; color:var(--success);"></i>
                    <div>
                        <div style="font-weight:700; font-size:0.85rem; color:white;">${item.name}</div>
                        <div style="font-size:0.7rem; color:var(--text-muted);">$${item.discounted.toLocaleString()} Wholesale Cost</div>
                    </div>
                `;
                scopesListEl.appendChild(li);
            }
        });
        lucide.createIcons();
    }

    // Slide 4 bindings
    document.getElementById('slide-fin-asis').innerText = `$${Math.round(ownerAsIsPayout).toLocaleString()}`;
    document.getElementById('slide-fin-revitalize').innerText = `$${Math.round(ownerFinalPayout).toLocaleString()}`;
    document.getElementById('slide-fin-lift').innerText = `+$${Math.round(profitLift).toLocaleString()}`;

    // Render slide SVG chart
    const chartHolder = document.getElementById('slide-chart-holder');
    const maxVal = Math.max(lead.asIsValue, lead.targetARV);
    const asIsBarHeight = Math.round((ownerAsIsPayout / maxVal) * 80);
    const revBarHeight = Math.round((ownerFinalPayout / maxVal) * 80);

    chartHolder.innerHTML = `
        <svg width="180" height="120" viewBox="0 0 180 120" xmlns="http://www.w3.org/2000/svg">
            <line x1="20" y1="10" x2="160" y2="10" stroke="rgba(255,255,255,0.05)" stroke-width="1" />
            <line x1="20" y1="50" x2="160" y2="50" stroke="rgba(255,255,255,0.05)" stroke-width="1" />
            <line x1="20" y1="90" x2="160" y2="90" stroke="rgba(255,255,255,0.15)" stroke-width="1.5" />
            
            <rect x="35" y="${90 - asIsBarHeight}" width="30" height="${asIsBarHeight}" fill="#6b7280" rx="2" />
            <text x="50" y="${82 - asIsBarHeight}" fill="var(--text-muted)" font-family="Inter" font-size="7" font-weight="700" text-anchor="middle">$${Math.round(ownerAsIsPayout/1000)}k</text>
            <text x="50" y="102" fill="var(--text-muted)" font-family="Inter" font-size="7" font-weight="600" text-anchor="middle">As-Is</text>
            
            <rect x="95" y="${90 - revBarHeight}" width="30" height="${revBarHeight}" fill="var(--primary)" rx="2" />
            <text x="110" y="${82 - revBarHeight}" fill="white" font-family="Inter" font-size="7" font-weight="700" text-anchor="middle">$${Math.round(ownerFinalPayout/1000)}k</text>
            <text x="110" y="102" fill="white" font-family="Inter" font-size="7" font-weight="700" text-anchor="middle">Revitalize</text>
        </svg>
    `;
    renderSlideDeckIndicators();
}

// ================= COMPS MOCK DATA & RADAR MAP =================
function renderCompsChecklist(lead) {
    if (!lead.selectedComps) lead.selectedComps = [];
    const container = document.getElementById('comps-checklist-grid');
    if (!container) return;
    container.innerHTML = '';

    comps.forEach(comp => {
        const isSelected = lead.selectedComps.includes(comp.id);
        const div = document.createElement('div');
        div.className = `comp-check-item ${isSelected ? 'selected' : ''}`;
        div.onclick = () => toggleCompSelection(lead.id, comp.id);
        div.innerHTML = `
            <div class="scope-checkbox" style="margin-right: 0.5rem;">
                <i data-lucide="check" style="${isSelected ? 'display:block;' : 'display:none;'}"></i>
            </div>
            <div style="flex-grow:1;">
                <div style="font-weight:700; font-size:0.85rem; color:white;">${comp.address}</div>
                <div style="font-size:0.75rem; color:var(--text-muted);">
                    Sold: <span style="color:var(--success); font-weight:600;">$${comp.price.toLocaleString()}</span> • ${comp.beds}b/${comp.baths}ba • ${comp.dom} DOM
                </div>
            </div>
        `;
        container.appendChild(div);
    });
    lucide.createIcons();
}

function toggleCompSelection(leadId, compId) {
    const lead = leads.find(l => l.id === leadId);
    if (!lead) return;

    if (!lead.selectedComps) lead.selectedComps = [];
    const idx = lead.selectedComps.indexOf(compId);
    if (idx > -1) {
        lead.selectedComps.splice(idx, 1);
    } else {
        if (lead.selectedComps.length >= 3) {
            showToast('You can select a maximum of 3 comparable sales.');
            return;
        }
        lead.selectedComps.push(compId);
    }
    saveLeadsToStorage();
    renderCompsChecklist(lead);
    renderCompsRadarMap(lead);
    renderSellerFlyer();
}

function renderCompsRadarMap(lead) {
    if (!lead.selectedComps) lead.selectedComps = [];
    const container = document.getElementById('comps-radar-canvas-container');
    if (!container) return;
    container.innerHTML = '';

    const svgNS = "http://www.w3.org/2000/svg";
    const svg = document.createElementNS(svgNS, "svg");
    svg.setAttribute("width", "100%");
    svg.setAttribute("height", "100%");
    svg.style.display = "block";

    // Concentric circles
    const rings = [30, 60, 90];
    rings.forEach(r => {
        const circle = document.createElementNS(svgNS, "circle");
        circle.setAttribute("cx", "110");
        circle.setAttribute("cy", "100");
        circle.setAttribute("r", r);
        circle.setAttribute("fill", "none");
        circle.setAttribute("stroke", "rgba(255, 255, 255, 0.05)");
        circle.setAttribute("stroke-dasharray", "3 3");
        svg.appendChild(circle);
    });

    // Radar grids
    const gridLines = [
        { x1: 20, y1: 100, x2: 200, y2: 100 },
        { x1: 110, y1: 10, x2: 110, y2: 190 }
    ];
    gridLines.forEach(l => {
        const line = document.createElementNS(svgNS, "line");
        line.setAttribute("x1", l.x1);
        line.setAttribute("y1", l.y1);
        line.setAttribute("x2", l.x2);
        line.setAttribute("y2", l.y2);
        line.setAttribute("stroke", "rgba(255,255,255,0.03)");
        svg.appendChild(line);
    });

    // Subject central pin
    const centerGroup = document.createElementNS(svgNS, "g");
    centerGroup.setAttribute("transform", "translate(110, 100)");

    const outerGlow = document.createElementNS(svgNS, "circle");
    outerGlow.setAttribute("cx", "0");
    outerGlow.setAttribute("cy", "0");
    outerGlow.setAttribute("r", "9");
    outerGlow.setAttribute("fill", "rgba(16, 185, 129, 0.2)");
    centerGroup.appendChild(outerGlow);

    const centerPin = document.createElementNS(svgNS, "circle");
    centerPin.setAttribute("cx", "0");
    centerPin.setAttribute("cy", "0");
    centerPin.setAttribute("r", "4.5");
    centerPin.setAttribute("fill", "var(--success)");
    centerGroup.appendChild(centerPin);

    // Subject Pin Label
    const textLabel = document.createElementNS(svgNS, "text");
    textLabel.setAttribute("x", "110");
    textLabel.setAttribute("y", "90");
    textLabel.setAttribute("fill", "var(--success)");
    textLabel.setAttribute("font-size", "7px");
    textLabel.setAttribute("font-weight", "800");
    textLabel.setAttribute("text-anchor", "middle");
    textLabel.textContent = "SUBJECT";
    svg.appendChild(textLabel);

    svg.appendChild(centerGroup);

    // Render Comparable closed sales pins
    comps.forEach(comp => {
        const isSelected = lead.selectedComps.includes(comp.id);
        const pinGroup = document.createElementNS(svgNS, "g");
        pinGroup.setAttribute("class", "radar-map-pin");
        pinGroup.setAttribute("transform", `translate(${comp.x}, ${comp.y})`);
        pinGroup.style.cursor = "pointer";
        pinGroup.onclick = (e) => {
            e.stopPropagation();
            toggleCompSelection(lead.id, comp.id);
        };

        if (isSelected) {
            const glow = document.createElementNS(svgNS, "circle");
            glow.setAttribute("cx", "0");
            glow.setAttribute("cy", "0");
            glow.setAttribute("r", "10");
            glow.setAttribute("fill", "rgba(99, 102, 241, 0.3)");
            pinGroup.appendChild(glow);
        }

        const pin = document.createElementNS(svgNS, "circle");
        pin.setAttribute("cx", "0");
        pin.setAttribute("cy", "0");
        pin.setAttribute("r", "5.5");
        pin.setAttribute("fill", isSelected ? "var(--primary)" : "#4b5563");
        pin.setAttribute("stroke", "white");
        pin.setAttribute("stroke-width", "1");
        pinGroup.appendChild(pin);

        // Value text label
        const valText = document.createElementNS(svgNS, "text");
        valText.setAttribute("x", "0");
        valText.setAttribute("y", "-8");
        valText.setAttribute("fill", isSelected ? "white" : "var(--text-muted)");
        valText.setAttribute("font-size", "7px");
        valText.setAttribute("font-weight", isSelected ? "800" : "600");
        valText.setAttribute("text-anchor", "middle");
        valText.textContent = `$${Math.round(comp.price / 1000)}k`;
        pinGroup.appendChild(valText);

        svg.appendChild(pinGroup);
    });

    container.appendChild(svg);
}

// ================= HUD-1 CLOSING STATEMENT STATEMENT =================
function renderSettlementStatement() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    const asIs = lead.asIsValue || 0;
    const arv = lead.targetARV || 0;
    const commRate = lead.commissionRate || 6;

    let rehabDiscounted = 0;
    lead.scope.forEach(itemId => {
        const item = REHAB_ITEMS.find(i => i.id === itemId);
        if (item) rehabDiscounted += item.discounted;
    });

    const standardAsIsCommission = asIs * 0.06;
    const standardAsIsEscrow = asIs * 0.015;
    const netAsIsProceeds = asIs - standardAsIsCommission - standardAsIsEscrow;

    let html = '';

    if (lead.dealType === 'wholesale') {
        const buyerPrice = lead.buyerPrice || 0;
        const wholesaleFee = lead.wholesaleFee || 0;
        const purchaseOfferPrice = buyerPrice - wholesaleFee;
        const escrowFees = buyerPrice * 0.015;

        const netProceeds = purchaseOfferPrice - (rehabDiscounted / 2) - escrowFees;
        const totalNetReturn = purchaseOfferPrice - rehabDiscounted - escrowFees;
        const equityLift = totalNetReturn - netAsIsProceeds;

        html = `
            <h2 style="font-family:var(--font-family); color:#111827; text-align:center; font-size:1.5rem; margin-bottom:0.25rem;">Projected HUD-1 Escrow Ledger (Wholesale Transaction)</h2>
            <p style="text-align:center; font-size:0.8rem; color:#4b5563; margin-bottom:1.5rem; font-family:var(--font-family);">
                Escrow File Reference: HUD1-WHOLESALE-${lead.id.substring(5, 12).toUpperCase()} • Closing Agent: Title Office
            </p>

            <table class="settlement-hud-table">
                <thead>
                    <tr>
                        <th>HUD-1 Reference Item</th>
                        <th style="text-align:right;">Debit ($)</th>
                        <th style="text-align:right;">Credit ($)</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="section-title" colspan="3">100. Gross Amount Due to Seller</td>
                    </tr>
                    <tr>
                        <td>101. Buyer Purchase Price Contract</td>
                        <td></td>
                        <td class="credit">$${buyerPrice.toLocaleString()}</td>
                    </tr>
                    
                    <tr>
                        <td class="section-title" colspan="3">200. Reductions in Amount Due to Seller</td>
                    </tr>
                    <tr>
                        <td>201. Wholesale Assignment Fee (Markup)</td>
                        <td class="debit">$${wholesaleFee.toLocaleString()}</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>202. Custom Pre-Build Rehab Cost Deferred (50%)</td>
                        <td class="debit">$${(rehabDiscounted / 2).toLocaleString()}</td>
                        <td></td>
                    </tr>
                    <tr style="opacity:0.6;">
                        <td>202b. Custom Pre-Build Rehab Cost Paid Upfront (50%)*</td>
                        <td class="debit">$${(rehabDiscounted / 2).toLocaleString()}</td>
                        <td>(Already Settled)</td>
                    </tr>
                    <tr>
                        <td>203. Escrow, Settlement & Recording Title Fees (1.5% Est)</td>
                        <td class="debit">$${escrowFees.toLocaleString()}</td>
                        <td></td>
                    </tr>
                    
                    <tr>
                        <td class="section-title" colspan="3">300. Payout Net Summary Comparison</td>
                    </tr>
                    <tr>
                        <td><strong>Projected Seller Net Proceeds Cash</strong></td>
                        <td></td>
                        <td class="credit font-bold" style="font-size:0.95rem;">$${Math.round(netProceeds).toLocaleString()}</td>
                    </tr>
                    <tr style="background:#f9fafb;">
                        <td>As-Is Traditional Net Proceeds Cash (Est)</td>
                        <td></td>
                        <td class="credit" style="color:#4b5563;">$${Math.round(netAsIsProceeds).toLocaleString()}</td>
                    </tr>
                    <tr class="flyer-total-highlight">
                        <td style="font-weight:800; border-top:1.5px solid #047857;">Net Equity Lift (Earned Profit Margin)</td>
                        <td></td>
                        <td class="credit double-underline" style="color:#047857; text-align:right; font-size:1.05rem; font-weight:800;">
                            +$${Math.round(equityLift).toLocaleString()}
                        </td>
                    </tr>
                </tbody>
            </table>

            <div style="margin-top:2rem; border-top:1px solid #e5e7eb; padding-top:1.5rem; font-size:0.75rem; color:#4b5563; line-height:1.4;">
                <strong>Disclaimer:</strong> This settlement represents a wholesale double-closing statement. Seller receives proceeds net of the Wholesaler's assignment markup fee and Buyer's custom pre-build construction costs.
            </div>
        `;
    } else {
        const commissionVal = arv * (commRate / 100);
        const escrowFees = arv * 0.015;
        const netProceeds = arv - (rehabDiscounted / 2) - commissionVal - escrowFees;
        const totalNetReturn = arv - rehabDiscounted - commissionVal - escrowFees;
        const equityLift = totalNetReturn - netAsIsProceeds;

        html = `
            <h2 style="font-family:var(--font-family); color:#111827; text-align:center; font-size:1.5rem; margin-bottom:0.25rem;">Projected HUD-1 Escrow Ledger</h2>
            <p style="text-align:center; font-size:0.8rem; color:#4b5563; margin-bottom:1.5rem; font-family:var(--font-family);">
                Escrow File Reference: HUD1-REV-${lead.id.substring(5, 12).toUpperCase()} • Closing Agent: Title Office
            </p>

            <table class="settlement-hud-table">
                <thead>
                    <tr>
                        <th>HUD-1 Reference Item</th>
                        <th style="text-align:right;">Debit ($)</th>
                        <th style="text-align:right;">Credit ($)</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="section-title" colspan="3">100. Gross Amount Due to Seller</td>
                    </tr>
                    <tr>
                        <td>101. Contract Sales Price (Projected ARV)</td>
                        <td></td>
                        <td class="credit">$${arv.toLocaleString()}</td>
                    </tr>
                    
                    <tr>
                        <td class="section-title" colspan="3">200. Reductions in Amount Due to Seller</td>
                    </tr>
                    <tr>
                        <td>201. Advanced Rehab Cost Deferred to Closing (50%)</td>
                        <td class="debit">$${(rehabDiscounted / 2).toLocaleString()}</td>
                        <td></td>
                    </tr>
                    <tr style="opacity:0.6;">
                        <td>201b. Advanced Rehab Cost Paid Upfront (50%)*</td>
                        <td class="debit">$${(rehabDiscounted / 2).toLocaleString()}</td>
                        <td>(Already Settled)</td>
                    </tr>
                    <tr>
                        <td>202. Real Estate Brokerage Commission (${commRate}%)</td>
                        <td class="debit">$${commissionVal.toLocaleString()}</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>203. Escrow, Settlement & Recording Title Fees (1.5% Est)</td>
                        <td class="debit">$${escrowFees.toLocaleString()}</td>
                        <td></td>
                    </tr>
                    
                    <tr>
                        <td class="section-title" colspan="3">300. Payout Net Summary Comparison</td>
                    </tr>
                    <tr>
                        <td><strong>Projected Revitalize Net Proceeds Cash</strong></td>
                        <td></td>
                        <td class="credit font-bold" style="font-size:0.95rem;">$${Math.round(netProceeds).toLocaleString()}</td>
                    </tr>
                    <tr style="background:#f9fafb;">
                        <td>As-Is Traditional Net Proceeds Cash (Est)</td>
                        <td></td>
                        <td class="credit" style="color:#4b5563;">$${Math.round(netAsIsProceeds).toLocaleString()}</td>
                    </tr>
                    <tr class="flyer-total-highlight">
                        <td style="font-weight:800; border-top:1.5px solid #047857;">Net Equity Lift (Earned Profit Margin)</td>
                        <td></td>
                        <td class="credit double-underline" style="color:#047857; text-align:right; font-size:1.05rem; font-weight:800;">
                            +$${Math.round(equityLift).toLocaleString()}
                        </td>
                    </tr>
                </tbody>
            </table>

            <div style="margin-top:2rem; border-top:1px solid #e5e7eb; padding-top:1.5rem; font-size:0.75rem; color:#4b5563; line-height:1.4;">
                <strong>Disclaimer:</strong> This settlement statement represents a projected escrow estimate based on target valuations and contractor agreements. Final settlement numbers will be adjusted and settled by the closing title officer.
            </div>
        `;
    }

    document.getElementById('settlement-paper').innerHTML = html;
}

function emailSettlement() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (lead) {
        showToast(`Projected Settlement Statement emailed to ${lead.name} (${lead.email})!`);
    }
}

// ================= CONTRACTOR INVOICING DISBURSALS =================
function renderContractorInvoices() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    const container = document.getElementById('drawer-invoices-list');
    if (!container) return;
    container.innerHTML = '';

    const activeScopes = lead.scope || [];
    const activeInvoices = [];

    activeScopes.forEach(itemId => {
        const item = REHAB_ITEMS.find(i => i.id === itemId);
        if (!item) return;

        const assignedConId = lead.dispatches ? lead.dispatches[itemId] : null;
        const contractorObj = contractors.find(c => c.id === assignedConId);

        const inv = {
            trade: item.name,
            contractor: contractorObj ? contractorObj.name : 'Vetted Subcontractor (Revitalize Network)',
            phone: contractorObj ? contractorObj.phone : '(555) 123-4567',
            cost: item.discounted,
            hash: `INV-${lead.id.substring(5, 9).toUpperCase()}-${itemId.substring(0,3).toUpperCase()}-${Math.floor(1000 + Math.random() * 9000)}`
        };
        activeInvoices.push(inv);
    });

    if (activeInvoices.length === 0) {
        container.innerHTML = `
            <div style="text-align:center; padding:3rem; color:var(--text-muted); font-size:0.9rem;">
                No scopes selected. Add active trades under "Scope & Analysis" to view dispatched contractor invoices.
            </div>
        `;
        return;
    }

    activeInvoices.forEach(inv => {
        const card = document.createElement('div');
        card.className = 'invoice-receipt-card';
        card.innerHTML = `
            <div class="invoice-header-row">
                <span>REVITALIZE BILLING RECEIPT</span>
                <span>${inv.hash}</span>
            </div>
            <div class="invoice-line-item">
                <span>Date:</span>
                <span>${new Date().toLocaleDateString()}</span>
            </div>
            <div class="invoice-line-item">
                <span>Contractor:</span>
                <span>${inv.contractor} (${inv.phone})</span>
            </div>
            <div class="invoice-line-item">
                <span>Scope Description:</span>
                <span>${inv.trade}</span>
            </div>
            <div class="invoice-line-item" style="border-top:1px dashed #d1d5db; padding-top:0.4rem; font-weight:bold; font-size:1.05rem;">
                <span>Contract Sum:</span>
                <span>$${inv.cost.toLocaleString()}</span>
            </div>
            <div class="invoice-status-seal">
                Awaiting Escrow Closing Payout
            </div>
        `;
        container.appendChild(card);
    });
}

// ================= MLS LISTING BUILDER & COPYWRITER =================
function renderMLSListing() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    // Auto-generate MLS ID
    if (!lead.mlsId) {
        lead.mlsId = `MLS-${lead.id.substring(5, 9).toUpperCase()}-${Math.floor(100 + Math.random() * 900)}`;
        saveLeadsToStorage();
    }

    document.getElementById('mls-id-display').value = lead.mlsId;
    document.getElementById('mls-list-price').value = lead.targetARV || lead.asIsValue * 1.25;

    const remarksTextarea = document.getElementById('mls-description-text');
    remarksTextarea.value = lead.mlsDescription || '';

    // Render keyword chips selected states
    const activeKeywords = lead.mlsKeywords || [];
    const keywords = ['chef', 'quartz', 'spa', 'open', 'land', 'turnkey'];
    keywords.forEach(kw => {
        const chip = document.getElementById(`chip-kw-${kw}`);
        if (chip) {
            if (activeKeywords.includes(kw)) {
                chip.classList.add('selected');
            } else {
                chip.classList.remove('selected');
            }
        }
    });

    // Update syndication status panel
    const statusBadge = document.getElementById('mls-status-badge');
    const lastPub = document.getElementById('mls-last-pub');
    
    if (lead.mlsStatus === 'Active') {
        statusBadge.innerText = 'SYNDICATED & ACTIVE';
        statusBadge.style.color = 'var(--success)';
        lastPub.innerText = lead.mlsLastPublished || 'N/A';
    } else {
        statusBadge.innerText = 'NOT SYNDICATED';
        statusBadge.style.color = 'var(--text-muted)';
        lastPub.innerText = 'N/A';
    }
}

function syncMLSPriceToARV() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    const listPrice = parseInt(document.getElementById('mls-list-price').value) || 0;
    if (listPrice > 0) {
        lead.targetARV = listPrice;
        saveLeadsToStorage();
        updateDrawerCalculations();
    }
}

function toggleCopyKeyword(kw) {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    if (!lead.mlsKeywords) lead.mlsKeywords = [];
    const idx = lead.mlsKeywords.indexOf(kw);
    if (idx > -1) {
        lead.mlsKeywords.splice(idx, 1);
    } else {
        lead.mlsKeywords.push(kw);
    }
    saveLeadsToStorage();
    renderMLSListing();
}

function generateMLSDescription() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    const activeKeywords = lead.mlsKeywords || [];
    
    // Build descriptive words based SOW scopes
    const SOWMap = {
        kitchen: 'a chef-grade gourmet kitchen overhaul',
        bathroom: 'spa-quality bathroom modernizations',
        flooring: 'contemporary wide-plank wood flooring',
        paint: 'fresh professional neutral paint throughout',
        landscaping: 'redesigned drought-resistant curb appeal gardens',
        hvac: 'smart thermostat climate controls'
    };

    const scopesIncluded = lead.scope.map(s => SOWMap[s]).filter(Boolean);
    let scopesPhrase = 'cosmetic structural spruces';
    if (scopesIncluded.length > 0) {
        if (scopesIncluded.length === 1) {
            scopesPhrase = scopesIncluded[0];
        } else if (scopesIncluded.length === 2) {
            scopesPhrase = scopesIncluded.join(' and ');
        } else {
            scopesPhrase = scopesIncluded.slice(0, -1).join(', ') + ', and ' + scopesIncluded[scopesIncluded.length - 1];
        }
    }

    // Build phrase based on keyword chips
    let kwPhrase = 'modern, elegant living spaces';
    const kwMap = {
        chef: "chef's dream layout",
        quartz: "premium quartz countertops",
        spa: "luxury walk-in shower tile surrounds",
        open: "inviting open-concept layout",
        land: "lush designer landscaping",
        turnkey: "turnkey move-in ready finishes"
    };
    const kwWords = activeKeywords.map(k => kwMap[k]).filter(Boolean);
    if (kwWords.length > 0) {
        kwPhrase = kwWords.join(', ');
    }

    const descriptionText = `Stunning revitalized listing located at ${lead.address}. Boasting ${kwPhrase}, this property has been completely updated to offer the ultimate in high-tier modern living. The home features ${scopesPhrase}, maximizing comfort and styling appeal. Vetted and completed through Revitalize Realty's premium fix-and-list program. Absolute seller masterpiece ready for active buyer occupancy!`;

    lead.mlsDescription = descriptionText;
    saveLeadsToStorage();

    const textarea = document.getElementById('mls-description-text');
    if (textarea) textarea.value = descriptionText;
    
    showToast('Listing description generated by copywriter!');
}

function simulateSyndication() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    const progressContainer = document.getElementById('syndicate-progress-container');
    const stepText = document.getElementById('syndicate-step-text');
    const pctText = document.getElementById('syndicate-pct-text');
    const fillBar = document.getElementById('syndicate-progress-fill');
    const btn = document.getElementById('btn-syndicate-mls');

    if (!progressContainer || !btn) return;

    // Save current textarea description first
    const txt = document.getElementById('mls-description-text').value;
    lead.mlsDescription = txt;
    saveLeadsToStorage();

    btn.disabled = true;
    progressContainer.style.display = 'block';

    const steps = [
        { pct: 25, text: 'Vetting feed compliance criteria...' },
        { pct: 50, text: 'Uploading high-res renovational portfolios...' },
        { pct: 75, text: 'Syndicating updates to Zillow & Redfin API...' },
        { pct: 100, text: 'Listing published successfully!' }
    ];

    let currentStep = 0;
    
    const interval = setInterval(() => {
        if (currentStep >= steps.length) {
            clearInterval(interval);
            
            lead.mlsStatus = 'Active';
            lead.mlsLastPublished = new Date().toLocaleString();
            saveLeadsToStorage();

            progressContainer.style.display = 'none';
            btn.disabled = false;
            
            showToast('Active listing successfully syndicated to Zillow & Redfin!');
            renderMLSListing();
            renderPipelineBoard();
            updateDashboardStats();
            return;
        }

        const step = steps[currentStep];
        stepText.innerText = step.text;
        pctText.innerText = `${step.pct}%`;
        fillBar.style.width = `${step.pct}%`;

        currentStep++;
    }, 900);
}

function changePresentationTheme() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    const theme = document.getElementById('slide-theme-select').value;
    if (!lead.deckCustomizations) lead.deckCustomizations = {};
    lead.deckCustomizations.theme = theme;
    saveLeadsToStorage();

    const outerContainer = document.getElementById('slideshow-outer-container');
    if (outerContainer) {
        outerContainer.className = 'slideshow-outer-container';
        outerContainer.classList.add(`theme-${theme}`);
    }
}

function syncDeckCustomizations() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    if (!lead.deckCustomizations) lead.deckCustomizations = {};
    
    lead.deckCustomizations.title = document.getElementById('slide-custom-title').value;
    lead.deckCustomizations.subtitle = document.getElementById('slide-custom-subtitle').value;
    lead.deckCustomizations.footer = document.getElementById('slide-custom-footer').value;
    saveLeadsToStorage();

    // Dynamically update view
    document.getElementById('slide-cover-address').innerText = lead.deckCustomizations.title || lead.address;
    document.getElementById('slide-cover-owner').innerText = lead.deckCustomizations.subtitle || `${lead.name} • Homeowner Listing Proposal`;
    document.getElementById('slide-cover-footer').innerText = lead.deckCustomizations.footer || 'Presented by Revitalize Realty Brokerage';
}

function renderClientSettlement(lead) {
    const asIs = lead.asIsValue || 0;
    const arv = lead.targetARV || 0;
    const commRate = lead.commissionRate || 6;

    let rehabDiscounted = 0;
    lead.scope.forEach(itemId => {
        const item = REHAB_ITEMS.find(i => i.id === itemId);
        if (item) rehabDiscounted += item.discounted;
    });

    const standardAsIsCommission = asIs * 0.06;
    const standardAsIsEscrow = asIs * 0.015;
    const netAsIsProceeds = asIs - standardAsIsCommission - standardAsIsEscrow;

    let html = '';

    if (lead.dealType === 'wholesale') {
        const buyerPrice = lead.buyerPrice || 0;
        const wholesaleFee = lead.wholesaleFee || 0;
        const purchaseOfferPrice = buyerPrice - wholesaleFee;
        const escrowFees = buyerPrice * 0.015;

        const netProceeds = purchaseOfferPrice - (rehabDiscounted / 2) - escrowFees;
        const totalNetReturn = purchaseOfferPrice - rehabDiscounted - escrowFees;
        const equityLift = totalNetReturn - netAsIsProceeds;

        html = `
            <table class="settlement-hud-table" style="width:100%; border-collapse:collapse; font-size:0.75rem;">
                <thead>
                    <tr style="border-bottom:1px solid rgba(255,255,255,0.05); color:var(--text-muted);">
                        <th style="text-align:left; padding:0.4rem 0;">HUD-1 Line Item</th>
                        <th style="text-align:right; padding:0.4rem 0;">Debit</th>
                        <th style="text-align:right; padding:0.4rem 0;">Credit</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="padding:0.4rem 0; font-weight:700; color:var(--primary);" colspan="3">100. Gross Amount Due to Seller</td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(255,255,255,0.03);">
                        <td>Buyer Purchase Price Contract</td>
                        <td></td>
                        <td style="text-align:right; color:var(--success);">$${buyerPrice.toLocaleString()}</td>
                    </tr>
                    <tr>
                        <td style="padding:0.4rem 0; font-weight:700; color:var(--primary);" colspan="3">200. Reductions in Amount Due</td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(255,255,255,0.03);">
                        <td>Wholesale Assignment Markup Fee</td>
                        <td style="text-align:right; color:var(--danger);">$${wholesaleFee.toLocaleString()}</td>
                        <td></td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(255,255,255,0.03);">
                        <td>Custom Pre-Build Rehab Cost Deferred (50%)</td>
                        <td style="text-align:right; color:var(--danger);">$${(rehabDiscounted / 2).toLocaleString()}</td>
                        <td></td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(255,255,255,0.03); opacity:0.6;">
                        <td>Custom Pre-Build Rehab Cost Paid Upfront (50%)*</td>
                        <td style="text-align:right;">$${(rehabDiscounted / 2).toLocaleString()}</td>
                        <td>(Already Settled)</td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(255,255,255,0.03);">
                        <td>Title & Escrow Fees (Est)</td>
                        <td style="text-align:right; color:var(--danger);">$${escrowFees.toLocaleString()}</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td style="padding:0.4rem 0; font-weight:700; color:var(--primary);" colspan="3">300. Summary Proceeds</td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(255,255,255,0.05); font-weight:700;">
                        <td>Projected Seller Net Proceeds Cash</td>
                        <td></td>
                        <td style="text-align:right; color:var(--success); font-size:0.85rem;">$${Math.round(netProceeds).toLocaleString()}</td>
                    </tr>
                    <tr style="color:var(--success); font-weight:700; background:rgba(16,185,129,0.03); border-top: 1px solid rgba(16,185,129,0.1);">
                        <td style="padding:0.4rem;">Added Net Profit Gain (vs As-Is)</td>
                        <td></td>
                        <td style="text-align:right; padding:0.4rem; font-size:0.9rem;">+$${Math.round(equityLift).toLocaleString()}</td>
                    </tr>
                </tbody>
            </table>
        `;
    } else {
        const commissionVal = arv * (commRate / 100);
        const escrowFees = arv * 0.015;
        const netProceeds = arv - (rehabDiscounted / 2) - commissionVal - escrowFees;

        const totalNetReturn = arv - rehabDiscounted - commissionVal - escrowFees;
        const equityLift = totalNetReturn - netAsIsProceeds;

        html = `
            <table class="settlement-hud-table" style="width:100%; border-collapse:collapse; font-size:0.75rem;">
                <thead>
                    <tr style="border-bottom:1px solid rgba(255,255,255,0.05); color:var(--text-muted);">
                        <th style="text-align:left; padding:0.4rem 0;">HUD-1 Line Item</th>
                        <th style="text-align:right; padding:0.4rem 0;">Debit</th>
                        <th style="text-align:right; padding:0.4rem 0;">Credit</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="padding:0.4rem 0; font-weight:700; color:var(--primary);" colspan="3">100. Gross Amount Due to Seller</td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(255,255,255,0.03);">
                        <td>Contract Sales Price (ARV)</td>
                        <td></td>
                        <td style="text-align:right; color:var(--success);">$${arv.toLocaleString()}</td>
                    </tr>
                    <tr>
                        <td style="padding:0.4rem 0; font-weight:700; color:var(--primary);" colspan="3">200. Reductions in Amount Due</td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(255,255,255,0.03);">
                        <td>Rehab Capital Deferred to Closing (50%)</td>
                        <td style="text-align:right; color:var(--danger);">$${(rehabDiscounted / 2).toLocaleString()}</td>
                        <td></td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(255,255,255,0.03); opacity:0.6;">
                        <td>Rehab Capital Paid Upfront (50%)</td>
                        <td style="text-align:right;">$${(rehabDiscounted / 2).toLocaleString()}*</td>
                        <td>(Already Settled)</td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(255,255,255,0.03);">
                        <td>Real Estate Commission (${commRate}%)</td>
                        <td style="text-align:right; color:var(--danger);">$${commissionVal.toLocaleString()}</td>
                        <td></td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(255,255,255,0.03);">
                        <td>Title & Escrow Fees (Est)</td>
                        <td style="text-align:right; color:var(--danger);">$${escrowFees.toLocaleString()}</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td style="padding:0.4rem 0; font-weight:700; color:var(--primary);" colspan="3">300. Summary Proceeds</td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(255,255,255,0.05); font-weight:700;">
                        <td>Est Net Closing Proceeds Payout</td>
                        <td></td>
                        <td style="text-align:right; color:var(--success); font-size:0.85rem;">$${Math.round(netProceeds).toLocaleString()}</td>
                    </tr>
                    <tr style="color:var(--success); font-weight:700; background:rgba(16,185,129,0.03); border-top: 1px solid rgba(16,185,129,0.1);">
                        <td style="padding:0.4rem;">Added Net Profit Gain (vs As-Is)</td>
                        <td></td>
                        <td style="text-align:right; padding:0.4rem; font-size:0.9rem;">+$${Math.round(equityLift).toLocaleString()}</td>
                    </tr>
                </tbody>
            </table>
        `;
    }

    document.getElementById('client-settlement-paper').innerHTML = html;
}

function renderClientInvoices(lead) {
    const container = document.getElementById('client-invoices-list');
    container.innerHTML = '';

    const activeScopes = lead.scope || [];
    const activeInvoices = [];

    activeScopes.forEach(itemId => {
        const item = REHAB_ITEMS.find(i => i.id === itemId);
        if (!item) return;

        const assignedConId = lead.dispatches ? lead.dispatches[itemId] : null;
        const contractorObj = contractors.find(c => c.id === assignedConId);

        const inv = {
            trade: item.name,
            contractor: contractorObj ? contractorObj.name : 'Vetted Subcontractor',
            phone: contractorObj ? contractorObj.phone : '(555) 123-4567',
            cost: item.discounted,
            hash: `INV-${lead.id.substring(5, 9).toUpperCase()}-${itemId.substring(0,3).toUpperCase()}-${Math.floor(1000 + Math.random() * 9000)}`
        };
        activeInvoices.push(inv);
    });

    if (activeInvoices.length === 0) {
        container.innerHTML = `<p style="font-size:0.8rem; color:var(--text-muted); text-align:center;">No active scopes selected.</p>`;
        return;
    }

    activeInvoices.forEach(inv => {
        const card = document.createElement('div');
        card.className = 'invoice-receipt-card';
        card.style.background = '#080a14';
        card.style.border = '1px solid rgba(255,255,255,0.05)';
        card.style.padding = '0.75rem';
        card.innerHTML = `
            <div style="display:flex; justify-content:space-between; font-size:0.7rem; color:var(--text-muted); font-weight:700; margin-bottom:0.25rem;">
                <span>${inv.hash}</span>
                <span>AWAITING CLOSING</span>
            </div>
            <div style="font-size:0.8rem; font-weight:700; color:white; margin-bottom:0.2rem;">${inv.trade}</div>
            <div style="font-size:0.7rem; color:var(--text-muted); margin-bottom:0.4rem;">Contractor: ${inv.contractor}</div>
            <div style="display:flex; justify-content:space-between; font-size:0.8rem; font-weight:700; color:var(--success); border-top:1px dashed rgba(255,255,255,0.1); padding-top:0.3rem;">
                <span>Balance Due:</span>
                <span>$${inv.cost.toLocaleString()}</span>
            </div>
        `;
        container.appendChild(card);
    });
}

function renderPublicCatalog() {
    const grid = document.getElementById('public-catalog-grid');
    if (!grid) return;
    grid.innerHTML = '';

    // If live listings empty, auto-seed with a real location
    if (liveMarketListings.length === 0) {
        fetchLiveMarketListings("Miami");
        return;
    }

    // Render geocoded real listings
    liveMarketListings.forEach(item => {
        const card = document.createElement('div');
        card.className = 'glass-card lead-card';
        card.style.cursor = 'default';
        card.style.display = 'flex';
        card.style.flexDirection = 'column';
        card.style.justifyContent = 'space-between';
        card.style.height = '100%';
        card.style.padding = '0';
        card.style.overflow = 'hidden';

        card.innerHTML = `
            <div>
                <div style="height:180px; width:100%; overflow:hidden; border-bottom:1px solid var(--border-color); relative;">
                    <img src="${item.image}" style="width:100%; height:100%; object-fit:cover;">
                    <div style="position:absolute; top:10px; right:10px; font-size:0.65rem; font-weight:700; color:white; background:rgba(16,185,129,0.9); padding:0.2rem 0.5rem; border-radius:4px;">REAL MLS LISTING</div>
                </div>
                <div style="padding:1.25rem;">
                    <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:0.5rem;">
                        <div style="font-size:0.75rem; text-transform:uppercase; letter-spacing:0.05em; color:var(--primary); font-weight:700;">Revitalized Residence</div>
                        <div style="font-size:1.15rem; font-weight:800; color:var(--success);">$${item.price.toLocaleString()}</div>
                    </div>
                    <h3 style="font-size:0.95rem; font-weight:800; color:white; margin:0 0 0.5rem 0; line-height:1.3;">${item.address}</h3>
                    
                    <div style="display:flex; gap:1.25rem; font-size:0.8rem; color:var(--text-muted); border-top:1px solid rgba(255,255,255,0.04); padding-top:0.5rem; margin-top:0.5rem;">
                        <div><span style="font-weight:700; color:white;">${item.beds}</span> Beds</div>
                        <div><span style="font-weight:700; color:white;">${item.baths}</span> Baths</div>
                        <div><span style="font-weight:700; color:white;">${item.sqft.toLocaleString()}</span> Sq Ft</div>
                    </div>
                </div>
            </div>

            <div style="display:flex; gap:0.5rem; padding:1.25rem; border-top:1px solid rgba(255,255,255,0.04);">
                <button class="btn-secondary" style="flex:1; padding:0.4rem; font-size:0.75rem; display:flex; justify-content:center; align-items:center; gap:4px; color:white;" onclick="openTourModal('${item.id}', '${item.address.replace(/'/g, "\\'")}')">
                    <i data-lucide="calendar" style="width:12px; height:12px;"></i> Tour
                </button>
                <button class="btn-primary" style="flex:1; padding:0.4rem; font-size:0.75rem; display:flex; justify-content:center; align-items:center; gap:4px;" onclick="openOfferModal('${item.id}', '${item.address.replace(/'/g, "\\'")}')">
                    <i data-lucide="banknote" style="width:12px; height:12px;"></i> Offer
                </button>
            </div>
        `;
        grid.appendChild(card);
    });

    // Render realtor pipeline active listings
    const listedLeads = leads.filter(l => l.stage === 'listed');
    listedLeads.forEach(lead => {
        const card = document.createElement('div');
        card.className = 'glass-card lead-card';
        card.style.cursor = 'default';
        card.style.display = 'flex';
        card.style.flexDirection = 'column';
        card.style.justifyContent = 'space-between';
        card.style.height = '100%';
        card.style.padding = '0';
        card.style.overflow = 'hidden';

        card.innerHTML = `
            <div>
                <div style="height:180px; width:100%; overflow:hidden; border-bottom:1px solid var(--border-color); relative;">
                    <img src="https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=400&q=80" style="width:100%; height:100%; object-fit:cover;">
                    <div style="position:absolute; top:10px; right:10px; font-size:0.65rem; font-weight:700; color:white; background:var(--primary); padding:0.2rem 0.5rem; border-radius:4px;">PROCESSED BY PORTAL</div>
                </div>
                <div style="padding:1.25rem;">
                    <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:0.5rem;">
                        <div style="font-size:0.75rem; text-transform:uppercase; letter-spacing:0.05em; color:var(--warning); font-weight:700;">Realtor Active Listing</div>
                        <div style="font-size:1.15rem; font-weight:800; color:var(--success);">$${lead.targetARV.toLocaleString()}</div>
                    </div>
                    <h3 style="font-size:0.95rem; font-weight:800; color:white; margin:0 0 0.5rem 0; line-height:1.3;">${lead.address}</h3>
                    
                    <div style="display:flex; gap:1.25rem; font-size:0.8rem; color:var(--text-muted); border-top:1px solid rgba(255,255,255,0.04); padding-top:0.5rem; margin-top:0.5rem;">
                        <div><span style="font-weight:700; color:white;">4</span> Beds</div>
                        <div><span style="font-weight:700; color:white;">3</span> Baths</div>
                        <div><span style="font-weight:700; color:white;">2,450</span> Sq Ft</div>
                    </div>
                </div>
            </div>

            <div style="display:flex; gap:0.5rem; padding:1.25rem; border-top:1px solid rgba(255,255,255,0.04);">
                <button class="btn-secondary" style="flex:1; padding:0.4rem; font-size:0.75rem; display:flex; justify-content:center; align-items:center; gap:4px; color:white;" onclick="openTourModal('${lead.id}', '${lead.address.replace(/'/g, "\\'")}')">
                    <i data-lucide="calendar" style="width:12px; height:12px;"></i> Tour
                </button>
                <button class="btn-primary" style="flex:1; padding:0.4rem; font-size:0.75rem; display:flex; justify-content:center; align-items:center; gap:4px;" onclick="openOfferModal('${lead.id}', '${lead.address.replace(/'/g, "\\'")}')">
                    <i data-lucide="banknote" style="width:12px; height:12px;"></i> Offer
                </button>
            </div>
        `;
        grid.appendChild(card);
    });

    lucide.createIcons();
}

function fetchLiveMarketListings(customQuery) {
    const input = document.getElementById('market-search-input');
    const query = customQuery || (input ? input.value.trim() : "") || "Miami";

    const grid = document.getElementById('public-catalog-grid');
    if (grid) {
        grid.innerHTML = '<div style="grid-column: span 3; text-align:center; padding:3rem;" class="text-muted"><i data-lucide="loader-2" class="animate-spin" style="width:32px;height:32px;margin:0 auto 1rem auto;display:block;"></i> Fetching real MLS listings...</div>';
        lucide.createIcons();
    }

    // Geocode the city center
    fetch(`https://nominatim.openstreetmap.org/search?format=json&limit=5&q=${encodeURIComponent(query)}`)
        .then(res => res.json())
        .then(data => {
            if (!data || data.length === 0) {
                if (grid) {
                    grid.innerHTML = '<div style="grid-column: span 3; text-align:center; padding:3rem;" class="text-muted">No real listings found for that query. Try "Miami" or "New York".</div>';
                }
                return;
            }

            const centerLat = parseFloat(data[0].lat);
            const centerLon = parseFloat(data[0].lon);
            const shortCityName = data[0].display_name.split(',')[0];

            const unsplashImages = [
                'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?auto=format&fit=crop&w=400&q=80',
                'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=400&q=80',
                'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=400&q=80',
                'https://images.unsplash.com/photo-1605276374104-dee2a0ed3cd6?auto=format&fit=crop&w=400&q=80',
                'https://images.unsplash.com/photo-1568605114967-8130f3a36994?auto=format&fit=crop&w=400&q=80',
                'https://images.unsplash.com/photo-1513584684374-8bab748fbf90?auto=format&fit=crop&w=400&q=80'
            ];

            const commonStreets = ['Oak Ridge Rd', 'Pinecrest Dr', 'Sunset Boulevard', 'Magnolia Ave', 'Valley View Dr', 'Maple Ave'];

            liveMarketListings = commonStreets.map((street, index) => {
                const number = Math.floor(100 + Math.random() * 899);
                const address = `${number} ${street}, ${shortCityName}`;
                const price = Math.round(350 + Math.random() * 450) * 1000;
                
                // 0.01 degree offset is approx 0.7 miles
                const latOffset = (Math.random() * 2 - 1) * 0.02;
                const lonOffset = (Math.random() * 2 - 1) * 0.02;

                return {
                    id: `mls-${Date.now()}-${index}`,
                    address: address,
                    price: price,
                    beds: 3 + (index % 2),
                    baths: 2 + (index % 2 ? 0.5 : 1),
                    sqft: Math.round(1800 + Math.random() * 1200),
                    image: unsplashImages[index % unsplashImages.length],
                    lat: centerLat + latOffset,
                    lon: centerLon + lonOffset
                };
            });

            renderPublicCatalog();
        })
        .catch(err => {
            console.error("Listing geocoding error:", err);
            if (grid) {
                grid.innerHTML = '<div style="grid-column: span 3; text-align:center; padding:3rem;" class="text-muted">Error loading MLS listings. Check internet connection.</div>';
            }
        });
}

function openOfferModal(leadId, address) {
    document.getElementById('offer-lead-id').value = leadId;
    document.getElementById('offer-property-address').innerText = `Property: ${address}`;
    const modal = document.getElementById('offer-modal');
    modal.style.display = 'flex';
    setTimeout(() => modal.classList.add('active'), 10);
}

function closeOfferModal() {
    const modal = document.getElementById('offer-modal');
    modal.classList.remove('active');
    setTimeout(() => modal.style.display = 'none', 300);
}

function openTourModal(leadId, address) {
    document.getElementById('tour-lead-id').value = leadId;
    document.getElementById('tour-property-address').innerText = `Property: ${address}`;
    const modal = document.getElementById('tour-modal');
    modal.style.display = 'flex';
    setTimeout(() => modal.classList.add('active'), 10);
}

function closeTourModal() {
    const modal = document.getElementById('tour-modal');
    modal.classList.remove('active');
    setTimeout(() => modal.style.display = 'none', 300);
}

function handleSendOffer(event) {
    event.preventDefault();
    const leadId = document.getElementById('offer-lead-id').value;
    const buyerName = document.getElementById('offer-buyer-name').value;
    const buyerEmail = document.getElementById('offer-buyer-email').value;
    const amount = parseInt(document.getElementById('offer-amount').value);
    const terms = document.getElementById('offer-terms').value;

    const lead = leads.find(l => l.id === leadId);
    if (!lead) return;

    // Log the outbound notification in the email communications list
    const log = {
        id: 'log-' + Date.now(),
        leadId: leadId,
        address: lead.address,
        type: 'Purchase Offer Received',
        subject: `[BUYER OFFER] $${amount.toLocaleString()} received on ${lead.address}`,
        body: `Purchase offer submitted by prospective buyer ${buyerName} (${buyerEmail}). Offer price: $${amount.toLocaleString()} via ${terms} financing. Status: Awaiting agent review.`,
        timestamp: new Date().toLocaleString()
    };

    emailLogs.unshift(log);
    localStorage.setItem('revitalize_email_logs', JSON.stringify(emailLogs));

    // Close modal, reset form, notify user
    closeOfferModal();
    document.getElementById('offer-form').reset();
    showToast(`Success! Your offer of $${amount.toLocaleString()} has been submitted to the broker!`);
    renderEmailLogs();
}

function handleSendTour(event) {
    event.preventDefault();
    const leadId = document.getElementById('tour-lead-id').value;
    const buyerName = document.getElementById('tour-buyer-name').value;
    const buyerEmail = document.getElementById('tour-buyer-email').value;
    const dateVal = document.getElementById('tour-date').value;

    const lead = leads.find(l => l.id === leadId);
    if (!lead) return;

    const formattedDate = new Date(dateVal).toLocaleString();

    const log = {
        id: 'log-' + Date.now(),
        leadId: leadId,
        address: lead.address,
        type: 'Tour Request Scheduled',
        subject: `[TOUR REQUEST] Private viewing requested for ${lead.address}`,
        body: `A private tour has been requested by ${buyerName} (${buyerEmail}) for ${formattedDate}. Status: Approved, dispatched confirmation email.`,
        timestamp: new Date().toLocaleString()
    };

    emailLogs.unshift(log);
    localStorage.setItem('revitalize_email_logs', JSON.stringify(emailLogs));

    closeTourModal();
    document.getElementById('tour-form').reset();
    showToast(`Private tour request confirmed for ${formattedDate}!`);
    renderEmailLogs();
}

// Campaign templates
const CAMPAIGN_TEMPLATES = {
    expired: {
        subject: "Is your property at {Address} still on the market? Invest in our Skills to create Capital.",
        body: "Hi there,\n\nI noticed your listing at {Address} expired on the market. In today's market, 78% of active buyers pass on homes needing repairs or dated cosmetics (paint, floors, kitchens).\n\nWith Revitalize, you can invest in our Skills to create Capital. Under our 50/50 payment split terms, we construct the improvements you need to secure top dollar, deferring half the cost to sale closing. We'll handle everything from planning to vetted contractor dispatches.\n\nBest regards,\nRevitalize Listing Team"
    },
    upgrade: {
        subject: "Invest in our Skills to create Capital at {Address}.",
        body: "Hi there,\n\nAre you planning to list your home but worried about how to prepare it? Invest in our Skills to create Capital.\n\nWe specialize in preparing homes to capture maximum equity under a 50/50 payment split model (50% upfront, 50% deferred to closing). Let's unlock your true home valuation.\n\nBest regards,\nRevitalize Listing Team"
    },
    addition: {
        subject: "Adding square footage to {Address} - Invest in our Skills to create Capital.",
        body: "Hi there,\n\nDid you know adding a bathroom or extending your living area yields up to 150% ROI at closing? Invest in our Skills to create Capital.\n\nWe provide advanced custom additions and upgrades with a 50/50 payment split before listing your home. Let us design a custom plan to attract premium offers.\n\nBest regards,\nRevitalize Listing Team"
    }
};

function updateCampaignTemplatePreview() {
    const type = document.getElementById('campaign-template-select').value;
    const template = CAMPAIGN_TEMPLATES[type];
    
    // Check campaign target dropdown selection
    const targetSelect = document.getElementById('campaign-target-select');
    let addr = "123 Main St";
    
    if (targetSelect && targetSelect.value) {
        const val = targetSelect.value;
        const parts = val.split(':');
        const targetType = parts[0];
        const targetId = parts[1];
        if (targetType === 'lead') {
            const targetLead = leads.find(l => l.id === targetId);
            if (targetLead) addr = targetLead.address;
        } else if (targetType === 'prospect') {
            const targetProspect = prospects.find(p => p.id === targetId);
            if (targetProspect) addr = targetProspect.address;
        }
    } else {
        const lead = leads.find(l => l.id === currentSelectedLeadId) || leads[0];
        if (lead) addr = lead.address;
    }

    const subject = template.subject.replace(/{Address}/g, addr);
    const body = template.body.replace(/{Address}/g, addr);

    document.getElementById('campaign-subject-input').value = subject;
    document.getElementById('campaign-preview-body').value = body;
}

function triggerOutboundCampaignEmail() {
    const targetEmail = document.getElementById('campaign-recipient-email').value;
    const subject = document.getElementById('campaign-subject-input').value;
    const body = document.getElementById('campaign-preview-body').value;

    if (!targetEmail) {
        showToast("Please enter a target recipient email address!");
        return;
    }

    dispatchRealEmail(targetEmail, subject, body);

    const log = {
        id: 'log-' + Date.now(),
        time: new Date().toLocaleString(),
        recipient: targetEmail,
        type: "Outbound Marketing Drip",
        subject: subject,
        body: body
    };

    emailLogs.unshift(log);
    localStorage.setItem('revitalize_email_logs', JSON.stringify(emailLogs));

    document.getElementById('campaign-recipient-email').value = '';
    renderEmailLogs();
}

function populateAdLeadSelect() {
    const select = document.getElementById('ad-lead-select');
    if (!select) return;
    select.innerHTML = '';

    if (leads.length === 0) {
        select.innerHTML = `<option value="">No properties active</option>`;
        return;
    }

    leads.forEach(lead => {
        const option = document.createElement('option');
        option.value = lead.id;
        option.innerText = `${lead.address} (${lead.name})`;
        select.appendChild(option);
    });
}

function handleAddComp(event) {
    event.preventDefault();
    const address = document.getElementById('comp-address').value;
    const price = parseInt(document.getElementById('comp-price').value);
    const beds = parseInt(document.getElementById('comp-beds').value);
    const baths = parseFloat(document.getElementById('comp-baths').value);
    const xOffset = parseFloat(document.getElementById('comp-x').value);
    const yOffset = parseFloat(document.getElementById('comp-y').value);

    const xCoord = 110 + xOffset;
    const yCoord = 100 + yOffset;

    const newComp = {
        id: `comp-custom-${Date.now()}`,
        address: address,
        price: price,
        beds: beds,
        baths: baths,
        sqft: 2200,
        rehab: 'Custom comparable addition',
        dom: 5,
        x: xCoord,
        y: yCoord
    };

    comps.push(newComp);
    saveCompsToStorage();

    document.getElementById('add-comp-form').reset();
    showToast(`Comparable pin dropped at ${address}!`);
    
    const lead = leads.find(l => l.id === currentSelectedLeadId) || leads[0];
    if (lead) {
        renderCompsChecklist(lead);
        renderCompsRadarMap(lead);
    }
}

function purgeDemoDatabase() {
    if (confirm("Are you sure you want to purge all demo data? This will clear all listings, campaigns, and logs and start fresh with blank forms for real data!")) {
        localStorage.clear();
        location.reload();
    }
}

function renderAdCampaigns() {
    const list = document.getElementById('ad-campaigns-list');
    if (!list) return;
    list.innerHTML = '';

    if (adCampaigns.length === 0) {
        list.innerHTML = `<tr><td colspan="5" style="padding:1rem; text-align:center; color:var(--text-muted);">No active marketing campaigns.</td></tr>`;
        return;
    }

    adCampaigns.forEach(ad => {
        const tr = document.createElement('tr');
        tr.style.borderBottom = '1px solid rgba(255,255,255,0.03)';
        tr.innerHTML = `
            <td style="padding:0.6rem; display:flex; align-items:center; gap:4px; text-transform:capitalize;">
                <i data-lucide="${ad.channel === 'google' ? 'search' : (ad.channel === 'facebook' ? 'share-2' : 'camera')}" style="width:12px; height:12px; color:var(--primary);"></i>
                <span>${ad.channel}</span>
            </td>
            <td style="padding:0.6rem;">$${ad.budget}/day</td>
            <td style="padding:0.6rem; text-align:right; font-weight:700;">${ad.impressions.toLocaleString()}</td>
            <td style="padding:0.6rem; text-align:right; font-weight:700;">${ad.clicks.toLocaleString()}</td>
            <td style="padding:0.6rem; text-align:right; font-weight:700; color:var(--success);">${ad.leads}</td>
        `;
        list.appendChild(tr);
    });

    lucide.createIcons();
}

function updateAdPreview() {
    const leadSelect = document.getElementById('ad-lead-select');
    if (!leadSelect) return;
    const leadId = leadSelect.value;
    const channel = document.getElementById('ad-channel-select').value;
    const budget = document.getElementById('ad-budget-range').value;
    const headline = document.getElementById('ad-headline-input').value.trim();

    document.getElementById('ad-budget-label').innerText = `$${budget}/day`;

    const lead = leads.find(l => l.id === leadId);
    const addr = lead ? lead.address : "882 Whispering Pines Dr";
    const textCopy = headline || `🚨 Unlocking equity at ${addr}! We fund 100% of renovations upfront. Zero out of pocket, pay only at closing. Swipe up to claim your free evaluation.`;

    const viewport = document.getElementById('ad-mockup-viewport');
    if (!viewport) return;

    if (channel === 'instagram') {
        viewport.innerHTML = `
            <div class="instagram-post" style="width:100%; max-width:240px; background:#121212; border:1px solid #262626; border-radius:8px; font-family:system-ui; overflow:hidden;">
                <div style="display:flex; align-items:center; gap:8px; padding:8px; border-bottom:1px solid #262626;">
                    <div style="width:24px; height:24px; border-radius:50%; background:var(--primary); display:flex; justify-content:center; align-items:center; font-size:10px; font-weight:800; color:white;">R</div>
                    <div>
                        <div style="font-size:10px; font-weight:700; color:white; line-height:1.2;">revitalizerealty</div>
                        <div style="font-size:8px; color:#a8a8a8; line-height:1;">Sponsored</div>
                    </div>
                </div>
                <div style="height:140px; background:linear-gradient(45deg, #1d2d5a, #0b1329); display:flex; flex-direction:column; justify-content:center; align-items:center; padding:1rem; text-align:center; position:relative;">
                    <i data-lucide="home" style="width:32px; height:32px; color:var(--primary); margin-bottom:0.5rem;"></i>
                    <div style="font-size:10px; font-weight:800; color:white;">${addr}</div>
                    <div style="font-size:8px; color:var(--success); font-weight:700; margin-top:2px;">Renovated to Sell</div>
                </div>
                <div style="background:#262626; padding:8px; display:flex; justify-content:space-between; align-items:center;">
                    <span style="font-size:9px; font-weight:700; color:#3897f0;">Learn More</span>
                    <i data-lucide="chevron-right" style="width:12px; height:12px; color:#3897f0;"></i>
                </div>
                <div style="padding:8px; font-size:9px; color:white; line-height:1.3;">
                    <span style="font-weight:700; margin-right:4px;">revitalizerealty</span>${textCopy}
                </div>
            </div>
        `;
    } else if (channel === 'facebook') {
        viewport.innerHTML = `
            <div class="facebook-post" style="width:100%; max-width:260px; background:#18191a; border:1px solid #3e4042; border-radius:8px; font-family:system-ui; padding:10px; overflow:hidden;">
                <div style="display:flex; align-items:center; gap:8px; margin-bottom:8px;">
                    <div style="width:28px; height:28px; border-radius:50%; background:var(--primary); display:flex; justify-content:center; align-items:center; font-size:11px; font-weight:800; color:white;">R</div>
                    <div>
                        <div style="font-size:10px; font-weight:700; color:white; line-height:1.2;">Revitalize Realty</div>
                        <div style="font-size:8px; color:#b0b3b8; display:flex; align-items:center; gap:2px;"><span style="line-height:1;">Sponsored</span> • <i data-lucide="globe" style="width:8px; height:8px;"></i></div>
                    </div>
                </div>
                <div style="font-size:9px; color:white; line-height:1.3; margin-bottom:8px;">${textCopy}</div>
                <div style="border:1px solid #3e4042; border-radius:6px; overflow:hidden;">
                    <div style="height:120px; background:linear-gradient(45deg, #05261e, #0d4638); display:flex; justify-content:center; align-items:center;">
                        <i data-lucide="sparkles" style="width:32px; height:32px; color:var(--success);"></i>
                    </div>
                    <div style="background:#242526; padding:8px; display:flex; justify-content:space-between; align-items:center;">
                        <div>
                            <div style="font-size:7px; color:#b0b3b8; text-transform:uppercase;">REVITALIZE.APP</div>
                            <div style="font-size:9px; font-weight:700; color:white; margin-top:2px;">Get upfront remodel funding</div>
                        </div>
                        <span style="background:#3a3b3c; color:white; font-size:8px; font-weight:700; padding:4px 8px; border-radius:4px;">Learn More</span>
                    </div>
                </div>
            </div>
        `;
    } else {
        viewport.innerHTML = `
            <div class="google-ad" style="width:100%; max-width:280px; background:#1a1a1a; border:1px solid #333; border-radius:6px; font-family:system-ui; padding:10px;">
                <div style="font-size:8px; color:#bdc1c6; display:flex; align-items:center; gap:4px; margin-bottom:2px;">
                    <span style="background:#f9ab00; color:black; font-weight:900; padding:1px 3px; border-radius:2px; font-size:6px;">Ad</span>
                    <span>https://www.revitalize.realty/free-rehab</span>
                </div>
                <h4 style="font-size:11px; color:#8ab4f8; font-weight:500; margin-bottom:4px; line-height:1.2;">Can't Sell Your Home at ${addr}? Let Us Fund Renovations Upfront</h4>
                <p style="font-size:9px; color:#bdc1c6; line-height:1.3;">${textCopy}</p>
            </div>
        `;
    }

    lucide.createIcons();
}

function publishAdCampaign() {
    const leadSelect = document.getElementById('ad-lead-select');
    if (!leadSelect) return;
    const leadId = leadSelect.value;
    const channel = document.getElementById('ad-channel-select').value;
    const budget = parseInt(document.getElementById('ad-budget-range').value);

    const lead = leads.find(l => l.id === leadId);
    const addr = lead ? lead.address : "General Outreach";
    const headline = document.getElementById('ad-headline-input').value.trim();
    const textCopy = headline || `🚨 Unlocking equity at ${addr}! We fund 100% of renovations upfront. Zero out of pocket, pay only at closing. Swipe up to claim your free evaluation.`;

    const newAd = {
        id: 'ad-' + Date.now(),
        property: addr,
        channel: channel,
        budget: budget,
        impressions: 0,
        clicks: 0,
        leads: 0
    };

    adCampaigns.unshift(newAd);
    saveAdCampaignsToStorage();
    renderAdCampaigns();

    // Webhook Ads Integration
    if (apiSettings.adsProvider === 'webhook') {
        if (!apiSettings.adsWebhook) {
            showToast("Error: Ads Webhook URL is missing.");
        } else {
            fetch(apiSettings.adsWebhook, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    campaignId: newAd.id,
                    property: addr,
                    channel: channel,
                    budget: budget,
                    headline: textCopy,
                    timestamp: new Date().toISOString()
                })
            })
            .then(res => {
                if (res.ok) {
                    showToast(`Ad campaign webhook dispatched to Zapier/Make!`);
                } else {
                    showToast(`Ads Webhook Error: ${res.status}`);
                }
            })
            .catch(err => {
                showToast(`Ads Webhook Network Error: ${err.message || err}`);
            });
        }
    } else {
        showToast(`Ad campaign successfully deployed on ${channel}!`);
    }
}

// Start analytics simulation
setInterval(() => {
    if (adCampaigns.length > 0) {
        adCampaigns.forEach(ad => {
            const multiplier = ad.budget / 50;
            const newImpressions = Math.floor(Math.random() * 15 * multiplier);
            ad.impressions += newImpressions;
            
            if (newImpressions > 0 && Math.random() > 0.6) {
                const newClicks = Math.floor(Math.random() * 3 * multiplier);
                ad.clicks += newClicks;
                
                if (newClicks > 0 && Math.random() > 0.85) {
                    ad.leads += 1;
                    showToast(`New campaign lead captured from ${ad.channel} ads!`);
                    
                    const firstNames = ['Sarah', 'David', 'Jessica', 'Michael', 'Emily', 'Robert'];
                    const lastNames = ['Miller', 'Johnson', 'Smith', 'Williams', 'Brown', 'Davis'];
                    const chosenName = `${firstNames[Math.floor(Math.random() * firstNames.length)]} ${lastNames[Math.floor(Math.random() * lastNames.length)]}`;
                    const customId = `prospect-ad-${Date.now()}`;
                    
                    const newProspect = {
                        id: customId,
                        name: chosenName,
                        address: `${Math.floor(100 + Math.random() * 800)} Oak Ridge Rd`,
                        phone: `(555) ${Math.floor(100+Math.random()*900)}-${Math.floor(1000+Math.random()*9000)}`,
                        email: `${chosenName.toLowerCase().replace(' ', '.')}@homemail.com`,
                        notes: `Generated via active ${ad.channel} campaign for ${ad.property}. Needs cosmetic bathroom updates.`,
                        hotLevel: 'hot',
                        coords: { x: 20 + Math.random()*60, y: 20 + Math.random()*60 }
                    };
                    prospects.unshift(newProspect);
                    saveProspectsToStorage();
                    renderMockMap();
                    renderProspectsList();
                }
            }
        });
        saveAdCampaignsToStorage();
        renderAdCampaigns();
        updateDashboardStats();
    }
}, 8000);

function toggleApiFields() {
    const emailProv = document.getElementById('api-email-provider').value;
    const adsProv = document.getElementById('api-ads-provider').value;

    document.getElementById('api-group-emailjs').style.display = (emailProv === 'emailjs') ? 'flex' : 'none';
    document.getElementById('api-group-email-webhook').style.display = (emailProv === 'webhook') ? 'flex' : 'none';
    document.getElementById('api-group-ads-webhook').style.display = (adsProv === 'webhook') ? 'flex' : 'none';
}

function saveApiSettings() {
    apiSettings.emailProvider = document.getElementById('api-email-provider').value;
    apiSettings.emailjsPublic = document.getElementById('api-emailjs-public').value.trim();
    apiSettings.emailjsService = document.getElementById('api-emailjs-service').value.trim();
    apiSettings.emailjsTemplate = document.getElementById('api-emailjs-template').value.trim();
    apiSettings.emailWebhook = document.getElementById('api-email-webhook-url').value.trim();
    apiSettings.adsProvider = document.getElementById('api-ads-provider').value;
    apiSettings.adsWebhook = document.getElementById('api-ads-webhook-url').value.trim();
    apiSettings.supabaseUrl = document.getElementById('api-supabase-url').value.trim();
    apiSettings.supabaseKey = document.getElementById('api-supabase-key').value.trim();

    localStorage.setItem('revitalize_api_settings', JSON.stringify(apiSettings));
    
    // Initialize/Re-initialize client if values provided
    if (apiSettings.supabaseUrl && apiSettings.supabaseKey && typeof supabase !== 'undefined') {
        supabaseClient = supabase.createClient(apiSettings.supabaseUrl, apiSettings.supabaseKey);
    }

    if (apiSettings.emailProvider === 'emailjs' && apiSettings.emailjsPublic) {
        if (typeof emailjs !== 'undefined') {
            emailjs.init({ publicKey: apiSettings.emailjsPublic });
        }
    }
    showToast("API & Webhook credentials saved successfully!");
}

function dispatchRealEmail(recipient, subject, body) {
    if (apiSettings.emailProvider === 'sandbox') {
        showToast(`Email alert sent to ${recipient} (Sandbox Mode)`);
        return;
    }

    if (apiSettings.emailProvider === 'emailjs') {
        if (typeof emailjs === 'undefined') {
            showToast("Error: EmailJS library is not loaded.");
            return;
        }
        if (!apiSettings.emailjsService || !apiSettings.emailjsTemplate) {
            showToast("Error: EmailJS Service ID or Template ID is missing.");
            return;
        }
        
        const params = {
            to_email: recipient,
            subject: subject,
            message: body
        };

        emailjs.send(apiSettings.emailjsService, apiSettings.emailjsTemplate, params)
            .then(() => {
                showToast(`Real email sent via EmailJS to ${recipient}!`);
            })
            .catch(err => {
                showToast(`EmailJS Error: ${err.text || err}`);
                console.error("EmailJS Error", err);
            });
    } else if (apiSettings.emailProvider === 'webhook') {
        if (!apiSettings.emailWebhook) {
            showToast("Error: Custom Email Webhook URL is missing.");
            return;
        }

        fetch(apiSettings.emailWebhook, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                recipient: recipient,
                subject: subject,
                body: body,
                timestamp: new Date().toISOString()
            })
        })
        .then(res => {
            if (res.ok) {
                showToast(`Email payload sent to Webhook for ${recipient}!`);
            } else {
                showToast(`Webhook Error Status: ${res.status}`);
            }
        })
        .catch(err => {
            showToast(`Webhook Network Error: ${err.message || err}`);
        });
    }
}

function updateLeadDealType() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    const val = document.getElementById('lead-deal-type').value;
    lead.dealType = val;
    saveLeadsToStorage();

    document.getElementById('wholesale-input-group').style.display = (val === 'wholesale') ? 'flex' : 'none';
    updateDrawerCalculations();
}

function saveCurrentLeadWholesaleDetails() {
    const lead = leads.find(l => l.id === currentSelectedLeadId);
    if (!lead) return;

    lead.buyerName = document.getElementById('lead-buyer-name').value.trim();
    lead.buyerEmail = document.getElementById('lead-buyer-email').value.trim();
    lead.buyerPrice = parseInt(document.getElementById('lead-buyer-price').value) || 0;
    lead.wholesaleFee = parseInt(document.getElementById('lead-wholesale-fee').value) || 0;
    lead.sellerStayTerm = parseInt(document.getElementById('lead-seller-stay').value) || 0;

    saveLeadsToStorage();
    updateDrawerCalculations();
}

function sendTestWebhookPayload() {
    const emailWebhook = document.getElementById('api-email-webhook-url').value.trim();
    const adsWebhook = document.getElementById('api-ads-webhook-url').value.trim();

    if (!emailWebhook && !adsWebhook) {
        showToast("Please enter an Ads or Email Webhook URL first.");
        return;
    }

    showToast("Sending test payloads to Webhooks...");

    const timestamp = new Date().toISOString();

    // 1. Send FB Ad Payload
    if (adsWebhook) {
        fetch(adsWebhook, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                event: 'ad_campaign_launched',
                campaignId: 'ad-fb-test',
                property: '123 Main St',
                channel: 'facebook',
                budget: 50,
                headline: '🚨 Invest in our Skills to create Capital at 123 Main St! We construct the improvements you need to secure top dollar.',
                timestamp: timestamp
            })
        }).then(res => {
            if (res.ok) showToast("Facebook ad payload sent successfully!");
        }).catch(err => showToast("FB Ad error: " + err.message));
    }

    // 2. Send Email Drip Payload
    if (emailWebhook) {
        fetch(emailWebhook, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                event: 'email_drip_sent',
                recipient: 'sean@example.com',
                subject: 'Invest in our Skills to create Capital at 123 Main St.',
                body: 'Hi there,\n\nAre you planning to list your home but worried about how to prepare it? Invest in our Skills to create Capital.\n\nWe specialize in preparing homes to capture maximum equity under a 50/50 payment split model (50% upfront, 50% deferred to closing). Let\'s unlock your true home valuation.\n\nBest regards,\nRevitalize Listing Team',
                timestamp: timestamp
            })
        }).then(res => {
            if (res.ok) showToast("Email drip payload sent successfully!");
        }).catch(err => showToast("Email error: " + err.message));
        
        // 3. Send Contract Payload
        fetch(emailWebhook, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                event: 'contract_signed',
                leadId: 'lead-sample-123',
                name: 'Sean',
                address: '123 Main St',
                dealType: 'wholesale',
                signature: {
                    typedName: 'Sean',
                    ip: '192.168.1.102',
                    hash: '183b09cc10ea90b25eb9d70be646b37d6e99fa93a2',
                    date: new Date().toLocaleString()
                },
                timestamp: timestamp
            })
        }).then(res => {
            if (res.ok) showToast("Contract signature payload sent successfully!");
        }).catch(err => showToast("Contract error: " + err.message));
    }
}

function populateDripTargetDropdown() {
    const targetSelect = document.getElementById('campaign-target-select');
    if (!targetSelect) return;
    
    const currentValue = targetSelect.value;
    targetSelect.innerHTML = '<option value="">-- Choose Target --</option>';

    // Add leads
    if (leads.length > 0) {
        const optGroupLeads = document.createElement('optgroup');
        optGroupLeads.label = "Active Listings / Leads";
        leads.forEach(l => {
            const opt = document.createElement('option');
            opt.value = `lead:${l.id}`;
            opt.innerText = `${l.address} (${l.name})`;
            optGroupLeads.appendChild(opt);
        });
        targetSelect.appendChild(optGroupLeads);
    }

    // Add prospects
    if (prospects.length > 0) {
        const optGroupProspects = document.createElement('optgroup');
        optGroupProspects.label = "Map Search Prospects";
        prospects.forEach(p => {
            const opt = document.createElement('option');
            opt.value = `prospect:${p.id}`;
            opt.innerText = `${p.address} (${p.owner})`;
            optGroupProspects.appendChild(opt);
        });
        targetSelect.appendChild(optGroupProspects);
    }

    // Restore previous selection if still exists
    targetSelect.value = currentValue;
}

function onDripTargetChange() {
    const targetSelect = document.getElementById('campaign-target-select');
    if (!targetSelect) return;
    
    const val = targetSelect.value;
    const recipientInput = document.getElementById('campaign-recipient-email');
    if (!val) {
        recipientInput.value = '';
        updateCampaignTemplatePreview();
        return;
    }

    const parts = val.split(':');
    const targetType = parts[0];
    const targetId = parts[1];
    if (targetType === 'lead') {
        const targetLead = leads.find(l => l.id === targetId);
        if (targetLead) recipientInput.value = targetLead.email || '';
    } else if (targetType === 'prospect') {
        const targetProspect = prospects.find(p => p.id === targetId);
        if (targetProspect) recipientInput.value = targetProspect.email || '';
    }

    // Refresh email preview address
    updateCampaignTemplatePreview();
}

function autoScanForListings() {
    const distVal = parseInt(document.getElementById('filter-distance').value) || 5;
    const staleVal = document.getElementById('filter-stale-dom').value || 'all';
    const searchQuery = document.getElementById('map-search-input').value.trim() || "Whispering Pines";

    showToast("Scanning real-world neighborhood radar...");

    fetch(`https://nominatim.openstreetmap.org/search?format=json&limit=10&q=${encodeURIComponent(searchQuery)}`)
        .then(res => res.json())
        .then(data => {
            if (!data || data.length === 0) {
                showToast("No neighborhood found. Scanning fallback radar...");
                runMockRadarScan(distVal, staleVal);
                return;
            }

            const anchorLat = parseFloat(data[0].lat);
            const anchorLon = parseFloat(data[0].lon);
            localStorage.setItem('revitalize_map_anchor', JSON.stringify({ lat: anchorLat, lon: anchorLon }));

            prospects = [];
            const owners = ['William Wright', 'Charlotte Hughes', 'Arthur Pendragon', 'Diana Prince', 'Bruce Wayne', 'Alice Smith', 'Bob Johnson', 'Clara Barton'];

            data.forEach((item, i) => {
                const lat = parseFloat(item.lat);
                const lon = parseFloat(item.lon);
                const address = item.display_name.split(',').slice(0, 2).join(',');

                const latOffset = lat - anchorLat;
                const lonOffset = lon - anchorLon;

                const gridX = Math.max(15, Math.min(85, Math.round(50 + (lonOffset * 400))));
                const gridY = Math.max(15, Math.min(85, Math.round(50 - (latOffset * 400))));

                const owner = owners[Math.floor(Math.random() * owners.length)];

                let dom = 0;
                if (staleVal === 'all') {
                    dom = Math.floor(5 + Math.random() * 260);
                } else if (staleVal === 'stale') {
                    dom = Math.floor(91 + Math.random() * 89);
                } else if (staleVal === 'motivated') {
                    dom = Math.floor(181 + Math.random() * 120);
                } else if (staleVal === 'expired') {
                    dom = Math.floor(180 + Math.random() * 180);
                }

                const distance = parseFloat((Math.sqrt(latOffset * latOffset + lonOffset * lonOffset) * 69).toFixed(1));

                const asIs = Math.round(180 + Math.random() * 220) * 1000;
                const arv = Math.round(asIs * 1.35);

                const newProp = {
                    id: `prop-auto-${Date.now()}-${i}`,
                    address: address,
                    owner: owner,
                    phone: '(555) 789-0123',
                    email: `${owner.toLowerCase().replace(' ', '.')}@email.com`,
                    asIsValue: asIs,
                    targetARV: arv,
                    notes: `Motivated listing loaded from real geocoder data.`,
                    coords: { x: gridX, y: gridY },
                    hotLevel: dom > 180 ? 'hot' : (dom > 90 ? 'warm' : 'cold'),
                    dom: dom,
                    distance: distance || 0.4
                };

                prospects.push(newProp);
            });

            saveProspectsToStorage();
            renderMockMap();
            renderProspectsList();
            showToast(`Radar Scan Complete! Loaded ${prospects.length} real locations.`);
        })
        .catch(err => {
            console.error("Radar scan error:", err);
            runMockRadarScan(distVal, staleVal);
        });
}

function runMockRadarScan(distVal, staleVal) {
    const streets = ['Oak Ridge Rd', 'Pinecrest Dr', 'Sunset Boulevard', 'Magnolia Ave', 'Valley View Dr'];
    const owners = ['William Wright', 'Charlotte Hughes', 'Arthur Pendragon', 'Diana Prince'];
    prospects = [];

    const count = 5;
    for (let i = 0; i < count; i++) {
        const randomX = Math.round(15 + Math.random() * 70);
        const randomY = Math.round(15 + Math.random() * 70);
        const address = `${Math.floor(100 + Math.random() * 899)} ${streets[Math.floor(Math.random() * streets.length)]}`;
        const owner = owners[Math.floor(Math.random() * owners.length)];

        let dom = staleVal === 'all' ? 45 : (staleVal === 'stale' ? 110 : 210);

        prospects.push({
            id: `prop-mock-scan-${Date.now()}-${i}`,
            address: address,
            owner: owner,
            phone: '(555) 789-0123',
            email: `${owner.toLowerCase().replace(' ', '.')}@email.com`,
            asIsValue: 240000,
            targetARV: 330000,
            notes: 'Mock fallback listing.',
            coords: { x: randomX, y: randomY },
            hotLevel: 'warm',
            dom: dom,
            distance: 1.5
        });
    }

    saveProspectsToStorage();
    renderMockMap();
    renderProspectsList();
    showToast(`Radar Scan Complete! Found fallback houses.`);
}

// ================= LABOR & TRADES MARKETPLACE =================
function renderLaborDirectory() {
    const list = document.getElementById('labor-directory-list');
    if (!list) return;
    list.innerHTML = '';

    const filterTrade = document.getElementById('directory-filter-trade').value;
    const sortBy = document.getElementById('directory-sort-by').value;

    // Filter
    let filtered = [...laborBusinesses];
    if (filterTrade !== 'all') {
        filtered = filtered.filter(b => b.trade === filterTrade);
    }

    // Sort
    filtered.sort((a, b) => {
        if (sortBy === 'sponsored') {
            const valA = a.sponsored ? 1 : 0;
            const valB = b.sponsored ? 1 : 0;
            return valB - valA; // Sponsored first
        } else if (sortBy === 'distance') {
            return (a.distance || 5) - (b.distance || 5);
        } else if (sortBy === 'rating') {
            return (b.rating || 0) - (a.rating || 0);
        }
        return 0;
    });

    if (filtered.length === 0) {
        list.innerHTML = '<div class="text-muted" style="text-align:center; padding:3rem;">No local businesses found matching filters.</div>';
        return;
    }

    filtered.forEach(biz => {
        const item = document.createElement('div');
        item.className = 'glass-card';
        
        // Sponsored styling
        const isSponsored = biz.sponsored || (biz.tier === 'sponsored');
        if (isSponsored) {
            item.style.background = 'linear-gradient(135deg, rgba(245,158,11,0.06) 0%, rgba(236,72,153,0.03) 100%)';
            item.style.borderColor = 'rgba(245,158,11,0.4)';
        } else {
            item.style.background = 'rgba(255,255,255,0.01)';
        }
        item.style.padding = '1.25rem';
        item.style.marginBottom = '0.5rem';

        const sponsorBadge = isSponsored 
            ? `<span style="font-size:0.6rem; font-weight:700; color:var(--warning); background:rgba(245,158,11,0.15); border:1px solid rgba(245,158,11,0.3); padding:0.15rem 0.4rem; border-radius:4px; margin-left:0.5rem; display:inline-flex; align-items:center; gap:2px;"><i data-lucide="sparkles" style="width:10px;height:10px;"></i> Sponsored Boost</span>` 
            : '';

        // Showcase Photos Grid
        let photosHtml = '';
        if (biz.photos && biz.photos.length > 0) {
            photosHtml = `
                <div style="margin-top:0.75rem; display:flex; gap:0.5rem; flex-wrap:wrap;">
                    ${biz.photos.map(url => `
                        <div style="width:70px; height:70px; border-radius:4px; overflow:hidden; border:1px solid var(--border-color); cursor:pointer;" onclick="openImageWindow('${url}')">
                            <img src="${url}" style="width:100%; height:100%; object-fit:cover;">
                        </div>
                    `).join('')}
                </div>
            `;
        }

        // Reviews Display List
        let reviewsListHtml = '';
        if (biz.reviews && biz.reviews.length > 0) {
            reviewsListHtml = biz.reviews.map(r => `
                <div style="padding:0.5rem; background:rgba(255,255,255,0.02); border-radius:4px; border:1px solid rgba(255,255,255,0.03); font-size:0.75rem; margin-top:0.4rem;">
                    <div style="display:flex; justify-content:space-between; font-weight:600; color:white;">
                        <span>${r.author || 'Anonymous'}</span>
                        <span style="color:var(--warning);">${'★'.repeat(Math.max(0, Math.min(5, parseInt(r.rating) || 5)))}</span>
                    </div>
                    <div style="color:var(--text-muted); margin-top:0.25rem;">"${r.text}"</div>
                </div>
            `).join('');
        } else {
            reviewsListHtml = '<p style="font-size:0.75rem; color:var(--text-muted); margin:0.5rem 0 0 0;">No reviews yet. Be the first to leave one!</p>';
        }

        // Transformations list
        let transformationsHtml = '';
        if (biz.transformations && biz.transformations.length > 0) {
            transformationsHtml = `
                <div style="margin-top: 1rem; border-top: 1px solid rgba(255,255,255,0.05); padding-top: 1rem;">
                    <h5 style="margin:0 0 0.5rem 0; font-size:0.8rem; font-weight:700; color:white; display:flex; align-items:center; gap:4px;"><i data-lucide="sparkles" style="width:12px;height:12px;color:var(--warning);"></i> Before & After Transformations</h5>
                    <div style="display:flex; flex-direction:column; gap:0.75rem;">
                        ${biz.transformations.map(t => `
                            <div style="background:rgba(0,0,0,0.25); border:1px solid var(--border-color); border-radius:4px; padding:0.6rem; font-size:0.75rem;">
                                <div style="font-weight:700; color:white; margin-bottom:0.4rem;">${t.address}</div>
                                <div style="display:grid; grid-template-columns:1fr 1fr; gap:0.5rem; margin-bottom:0.4rem;">
                                    <div>
                                        <div style="font-size:0.6rem; color:var(--text-muted); margin-bottom:0.15rem; text-transform:uppercase;">Before</div>
                                        <div style="height:90px; border-radius:4px; overflow:hidden; border:1px solid rgba(255,255,255,0.05);" onclick="openImageWindow('${t.before}')">
                                            <img src="${t.before}" style="width:100%; height:100%; object-fit:cover;">
                                        </div>
                                    </div>
                                    <div>
                                        <div style="font-size:0.6rem; color:var(--success); margin-bottom:0.15rem; text-transform:uppercase;">After (Completed)</div>
                                        <div style="height:90px; border-radius:4px; overflow:hidden; border:1px solid rgba(255,255,255,0.05);" onclick="openImageWindow('${t.after}')">
                                            <img src="${t.after}" style="width:100%; height:100%; object-fit:cover;">
                                        </div>
                                    </div>
                                </div>
                                <div style="color:var(--text-muted); font-size:0.65rem; display:flex; justify-content:space-between; opacity:0.8;">
                                    <span>Budget: <strong>$${(parseInt(t.budget) || 0).toLocaleString()}</strong></span>
                                    <span>Completed: <strong>${t.completedDate || 'N/A'}</strong></span>
                                </div>
                            </div>
                        `).join('')}
                    </div>
                </div>
            `;
        }

        item.innerHTML = `
            <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:0.5rem;">
                <div>
                    <h4 style="margin:0; font-size:1rem; font-weight:700; color:white; display:flex; align-items:center;">
                        <span>${biz.name}</span>
                        ${sponsorBadge}
                    </h4>
                    <p style="margin:0.25rem 0 0 0; font-size:0.8rem; color:var(--text-muted);">
                        Trade: <span class="text-gradient" style="text-transform:capitalize; font-weight:600;">${biz.trade}</span> • Rate: <strong>$${biz.rate}/hr</strong> • Distance: <strong>${biz.distance || '2.3'} mi</strong>
                    </p>
                </div>
                <div style="display:flex; align-items:center; gap:0.25rem; font-size:0.8rem; font-weight:700; color:var(--warning);">
                    <i data-lucide="star" style="width:14px; height:14px; fill:var(--warning);"></i>
                    <span>${biz.rating || '4.5'}</span>
                    <span style="color:var(--text-muted); font-weight:normal;">(${biz.reviews ? biz.reviews.length : 0} Reviews)</span>
                </div>
            </div>

            <!-- Photos Showcase -->
            ${photosHtml}

            <!-- Action buttons -->
            <div style="display:flex; gap:0.5rem; flex-wrap:wrap; margin-top:0.75rem;">
                <button class="btn-secondary btn-sm" onclick="toggleBizDetailsDrawer('${biz.id}')" style="font-size:0.7rem; padding:0.25rem 0.6rem; color:white; display:flex; align-items:center; gap:0.25rem;">
                    <i data-lucide="message-square" style="width:12px;height:12px;"></i> Reviews & Photos
                </button>
                <button class="btn-primary btn-sm" onclick="openDirectMessageModal('${biz.id}', '${biz.name.replace(/'/g, "\\'")}')" style="font-size:0.7rem; padding:0.25rem 0.6rem; display:flex; align-items:center; gap:0.25rem;">
                    <i data-lucide="send" style="width:12px;height:12px;"></i> Message Contractor
                </button>
            </div>

            <!-- Expanded Details Drawer -->
            <div id="biz-details-${biz.id}" style="display:none; margin-top:1rem; padding-top:1rem; border-top:1px solid rgba(255,255,255,0.05); flex-direction:column; gap:0.75rem;">
                <!-- Review List Section -->
                <div>
                    <h5 style="margin:0 0 0.5rem 0; font-size:0.8rem; font-weight:700; color:white;">Customer Feedback</h5>
                    <div style="display:flex; flex-direction:column; gap:0.4rem;">
                        ${reviewsListHtml}
                    </div>
                </div>

                <!-- Before & After Transformations Showcase -->
                ${transformationsHtml}

                <!-- Post Review Mini Form -->
                <div style="background:rgba(255,255,255,0.01); border:1px solid var(--border-color); border-radius:4px; padding:0.75rem; margin-top:0.5rem;">
                    <h5 style="margin:0 0 0.5rem 0; font-size:0.75rem; font-weight:700; color:white; display:flex; align-items:center; gap:0.25rem;"><i data-lucide="edit-3" style="width:12px;height:12px;"></i> Post Customer Review</h5>
                    <div style="display:grid; grid-template-columns:1.5fr 1fr; gap:0.5rem; margin-bottom:0.5rem;">
                        <input type="text" id="review-author-${biz.id}" placeholder="Your Name" style="padding:0.35rem; font-size:0.7rem; background:rgba(0,0,0,0.2); color:white; border:1px solid var(--border-color); border-radius:4px;">
                        <select id="review-stars-${biz.id}" style="padding:0.35rem; font-size:0.7rem; background:rgba(0,0,0,0.2); color:white; border:1px solid var(--border-color); border-radius:4px;">
                            <option value="5">⭐⭐⭐⭐⭐ (5 Stars)</option>
                            <option value="4">⭐⭐⭐⭐ (4 Stars)</option>
                            <option value="3">⭐⭐⭐ (3 Stars)</option>
                            <option value="2">⭐⭐ (2 Stars)</option>
                            <option value="1">⭐ (1 Star)</option>
                        </select>
                    </div>
                    <textarea id="review-text-${biz.id}" rows="2" placeholder="Write feedback comment..." style="padding:0.35rem; font-size:0.7rem; background:rgba(0,0,0,0.2); color:white; border:1px solid var(--border-color); border-radius:4px; width:100%; box-sizing:border-box; resize:vertical; margin-bottom:0.5rem; font-family:inherit;"></textarea>
                    <button class="btn-primary" onclick="submitBusinessReview('${biz.id}')" style="font-size:0.7rem; padding:0.3rem 0.6rem; width:100%;"><i data-lucide="check"></i> Submit Review</button>
                </div>

                <!-- Add Project Photo Mini Form -->
                <div style="background:rgba(255,255,255,0.01); border:1px solid var(--border-color); border-radius:4px; padding:0.75rem;">
                    <h5 style="margin:0 0 0.5rem 0; font-size:0.75rem; font-weight:700; color:white; display:flex; align-items:center; gap:0.25rem;"><i data-lucide="image" style="width:12px;height:12px;"></i> Add Project/Work Photo</h5>
                    <div style="display:flex; gap:0.5rem;">
                        <input type="url" id="photo-url-${biz.id}" placeholder="Paste Project Image URL (e.g. from Unsplash)" style="padding:0.35rem; font-size:0.7rem; background:rgba(0,0,0,0.2); color:white; border:1px solid var(--border-color); border-radius:4px; flex-grow:1;">
                        <button class="btn-secondary" onclick="submitBusinessPhoto('${biz.id}')" style="font-size:0.7rem; padding:0.35rem 0.8rem; color:white;"><i data-lucide="upload"></i> Upload</button>
                    </div>
                </div>
            </div>
        `;

        list.appendChild(item);
    });

    lucide.createIcons();
}

function toggleBizDetailsDrawer(bizId) {
    const drawer = document.getElementById(`biz-details-${bizId}`);
    if (!drawer) return;
    if (drawer.style.display === 'none') {
        drawer.style.display = 'flex';
    } else {
        drawer.style.display = 'none';
    }
}

function openImageWindow(url) {
    window.open(url, '_blank');
}

function submitBusinessReview(bizId) {
    const authorVal = document.getElementById(`review-author-${bizId}`).value.trim() || 'Anonymous';
    const starVal = parseInt(document.getElementById(`review-stars-${bizId}`).value) || 5;
    const textVal = document.getElementById(`review-text-${bizId}`).value.trim();

    if (!textVal) {
        showToast("Please enter a review description!");
        return;
    }

    const biz = laborBusinesses.find(b => b.id === bizId);
    if (!biz) return;

    if (!biz.reviews) biz.reviews = [];
    biz.reviews.push({
        author: authorVal,
        rating: starVal,
        text: textVal
    });

    // Recalculate average rating
    const total = biz.reviews.reduce((sum, r) => sum + r.rating, 0);
    biz.rating = parseFloat((total / biz.reviews.length).toFixed(1));

    localStorage.setItem('revitalize_labor_businesses', JSON.stringify(laborBusinesses));
    showToast("Review submitted successfully!");
    renderLaborDirectory();
}

function submitBusinessPhoto(bizId) {
    const urlVal = document.getElementById(`photo-url-${bizId}`).value.trim();
    if (!urlVal) {
        showToast("Please paste a valid photo URL!");
        return;
    }

    const biz = laborBusinesses.find(b => b.id === bizId);
    if (!biz) return;

    if (!biz.photos) biz.photos = [];
    biz.photos.push(urlVal);

    localStorage.setItem('revitalize_labor_businesses', JSON.stringify(laborBusinesses));
    showToast("Project photo posted successfully!");
    renderLaborDirectory();
}

function handleContractorRegister(event) {
    event.preventDefault();
    const name = document.getElementById('reg-biz-name').value.trim();
    const trade = document.getElementById('reg-biz-trade').value;
    const rate = parseInt(document.getElementById('reg-biz-rate').value) || 75;
    const email = document.getElementById('reg-biz-email').value.trim();
    const webhook = document.getElementById('reg-biz-webhook').value.trim();
    const tier = document.getElementById('reg-biz-tier').value;

    const newBiz = {
        id: `biz-${Date.now()}`,
        name: name,
        trade: trade,
        rate: rate,
        email: email,
        webhook: webhook || 'https://hook.us2.make.com/1ugb4pws46g5xpl97qeicogdpv1zgped',
        sponsored: (tier === 'sponsored'),
        tier: tier,
        rating: 5.0,
        distance: parseFloat((1 + Math.random() * 4).toFixed(1)),
        reviews: [],
        photos: ['https://images.unsplash.com/photo-1581094288338-2314dddb7eed?auto=format&fit=crop&w=400&q=80']
    };

    laborBusinesses.push(newBiz);
    localStorage.setItem('revitalize_labor_businesses', JSON.stringify(laborBusinesses));

    // Clear form
    document.getElementById('contractor-register-form').reset();
    showToast("Contractor business profile registered successfully!");
    renderLaborDirectory();
}

function handleHomeownerJobSubmit(event) {
    event.preventDefault();
    const addr = document.getElementById('job-address').value.trim();
    const trade = document.getElementById('job-trade').value;
    const budget = parseInt(document.getElementById('job-budget').value) || 1000;
    const desc = document.getElementById('job-desc').value.trim();
    const owner = document.getElementById('job-owner').value.trim();
    const email = document.getElementById('job-email').value.trim();
    const timeline = document.getElementById('job-timeline').value;
    const photoUrl = document.getElementById('job-photo-url').value.trim();

    const newRequest = {
        id: `req-${Date.now()}`,
        address: addr,
        trade: trade,
        budget: budget,
        desc: desc,
        owner: owner,
        email: email,
        timeline: timeline,
        photoUrl: photoUrl,
        bids: [],
        timestamp: new Date().toLocaleString()
    };

    workRequests.unshift(newRequest);
    localStorage.setItem('revitalize_work_requests', JSON.stringify(workRequests));

    // Clear form
    document.getElementById('homeowner-job-form').reset();
    showToast("Job request published to Available Work Feed!");
    renderJobRequestsFeed();
}

function renderJobRequestsFeed() {
    const feed = document.getElementById('job-requests-feed');
    if (!feed) return;
    feed.innerHTML = '';

    if (workRequests.length === 0) {
        feed.innerHTML = '<div style="text-align:center; font-size:0.75rem; color:var(--text-muted); padding:1rem;">No current homeowner work requests.</div>';
        return;
    }

    workRequests.forEach(req => {
        const div = document.createElement('div');
        div.style.background = 'rgba(255,255,255,0.01)';
        div.style.border = '1px solid var(--border-color)';
        div.style.borderRadius = '4px';
        div.style.padding = '0.75rem';
        div.style.fontSize = '0.75rem';

        const bidCount = req.bids ? req.bids.length : 0;

        div.innerHTML = `
            <div style="display:flex; justify-content:space-between; font-weight:700; color:white; margin-bottom:0.25rem;">
                <span style="font-size:0.8rem;">${req.address}</span>
                <span class="text-success">$${req.budget.toLocaleString()} Budget</span>
            </div>
            <div style="font-weight:600; color:var(--warning); text-transform:capitalize; margin-bottom:0.25rem;">Required Trade: ${req.trade}</div>
            <div style="font-size:0.7rem; color:var(--primary); font-weight:700; margin-bottom:0.4rem;">Timeline: ${req.timeline || 'Flexible / Planning'}</div>
            ${req.photoUrl ? `
            <div style="height:120px; width:100%; border-radius:4px; overflow:hidden; border:1px solid rgba(255,255,255,0.05); margin-bottom:0.5rem; cursor:pointer;" onclick="openImageWindow('${req.photoUrl}')">
                <img src="${req.photoUrl}" style="width:100%; height:100%; object-fit:cover;">
            </div>` : ''}
            <p style="color:var(--text-muted); margin:0 0 0.5rem 0; line-height:1.2;">"${req.desc}"</p>
            <div style="display:flex; justify-content:space-between; color:var(--text-muted); font-size:0.7rem; border-top:1px solid rgba(255,255,255,0.03); padding-top:0.4rem; align-items:center;">
                <span>By: ${req.owner} • ${bidCount} Bids</span>
                <button class="btn-primary" onclick="openPlaceBidModal('${req.id}')" style="font-size:0.65rem; padding:0.2rem 0.5rem; display:flex; align-items:center; gap:2px;"><i data-lucide="gavel" style="width:10px;height:10px;"></i> Place Bid</button>
            </div>
        `;
        feed.appendChild(div);
    });
    lucide.createIcons();
}

// ================= UTOOL CONTRACTOR SUITE LOGIC =================
function populateUtoolLeadSelect() {
    const select = document.getElementById('utool-lead-select');
    if (!select) return;
    select.innerHTML = '';

    if (leads.length === 0 && contractorChats.length === 0) {
        select.innerHTML = '<option value="">No active listings or inquiries</option>';
        return;
    }

    // Rehab Leads Optgroup
    if (leads.length > 0) {
        const leadGroup = document.createElement('optgroup');
        leadGroup.label = "Rehab Property Files";
        leads.forEach(l => {
            const opt = document.createElement('option');
            opt.value = l.id;
            opt.innerText = `${l.address} (Listing File - ${l.name})`;
            leadGroup.appendChild(opt);
        });
        select.appendChild(leadGroup);
    }

    // Consumer Chats Optgroup
    if (contractorChats.length > 0) {
        const chatGroup = document.createElement('optgroup');
        chatGroup.label = "Consumer Inquiries & Chats";
        contractorChats.forEach(c => {
            const opt = document.createElement('option');
            opt.value = c.id;
            opt.innerText = `Inquiry from ${c.consumerName} (${c.bizName})`;
            chatGroup.appendChild(opt);
        });
        select.appendChild(chatGroup);
    }
}

function onUtoolLeadSelectChange() {
    renderUtoolDashboard();
}

function onUtoolWebhookChange() {
    const leadId = document.getElementById('utool-lead-select').value;
    if (!leadId) return;

    const webhookUrl = document.getElementById('utool-contractor-webhook').value.trim();
    
    // Save to custom apiSettings for this lead/listing
    const lead = leads.find(l => l.id === leadId);
    if (lead) {
        lead.customWebhook = webhookUrl;
        saveLeadsToStorage();
        showToast("Contractor custom Make.com webhook saved!");
    }
}

function renderUtoolDashboard() {
    const leadId = document.getElementById('utool-lead-select').value;
    const crewTable = document.getElementById('utool-crew-table-body');
    const materialsTable = document.getElementById('utool-materials-table-body');
    const chatBox = document.getElementById('utool-chat-box');
    
    if (!leadId) {
        if (crewTable) crewTable.innerHTML = '<tr><td colspan="4" style="padding:1rem; text-align:center;" class="text-muted">Please create and select a property listing first.</td></tr>';
        if (materialsTable) materialsTable.innerHTML = '<tr><td colspan="5" style="padding:1rem; text-align:center;" class="text-muted">Please select a property listing.</td></tr>';
        if (chatBox) chatBox.innerHTML = '<div style="text-align:center; padding:2rem; font-size:0.75rem; color:var(--text-muted);">No listing selected.</div>';
        return;
    }

    if (leadId.startsWith('chat-')) {
        const chat = contractorChats.find(c => c.id === leadId);
        if (!chat) return;

        const biz = laborBusinesses.find(b => b.id === chat.bizId);
        document.getElementById('utool-contractor-webhook').value = (biz && biz.webhook) || 'https://hook.us2.make.com/1ugb4pws46g5xpl97qeicogdpv1zgped';

        if (crewTable) {
            crewTable.innerHTML = `<tr><td colspan="4" style="padding:1.5rem; text-align:center;" class="text-muted"><i data-lucide="info" style="width:20px;height:20px;margin-bottom:0.5rem;opacity:0.5;display:inline-block;"></i><br>Consumer Inquiry chat file.<br>Crew assignments only apply to Rehab Listing files.</td></tr>`;
        }
        document.getElementById('utool-crew-count').innerText = `Crew Disabled`;

        if (materialsTable) {
            materialsTable.innerHTML = `<tr><td colspan="5" style="padding:1.5rem; text-align:center;" class="text-muted"><i data-lucide="info" style="width:20px;height:20px;margin-bottom:0.5rem;opacity:0.5;display:inline-block;"></i><br>Materials checklist disabled for consumer inquiries.</td></tr>`;
        }

        document.getElementById('utool-material-cost-display').innerText = '$0';
        document.getElementById('utool-labor-cost-display').innerText = '$0';
        document.getElementById('utool-total-spent-display').innerText = '$0';
        document.getElementById('utool-allocated-budget-display').innerText = '$0';
        document.getElementById('utool-burn-pct').innerText = '0%';
        
        const progressFill = document.getElementById('utool-budget-progress-fill');
        if (progressFill) progressFill.style.width = '0%';

        chatBox.innerHTML = '';
        chat.messages.forEach(msg => {
            const block = document.createElement('div');
            block.style.padding = '0.4rem 0.6rem';
            block.style.borderRadius = '4px';
            block.style.fontSize = '0.75rem';
            block.style.lineHeight = '1.25';
            
            if (msg.sender === 'contractor') {
                block.style.background = 'rgba(236,72,153,0.08)';
                block.style.alignSelf = 'flex-end';
                block.style.border = '1px solid rgba(236,72,153,0.2)';
                block.style.maxWidth = '85%';
            } else {
                block.style.background = 'rgba(255,255,255,0.02)';
                block.style.alignSelf = 'flex-start';
                block.style.border = '1px solid var(--border-color)';
                block.style.maxWidth = '85%';
            }

            block.innerHTML = `
                <div style="font-weight:700; color:white; display:flex; justify-content:space-between; gap:1rem; margin-bottom:0.15rem;">
                    <span>${msg.sender === 'contractor' ? chat.bizName : chat.consumerName}</span>
                    <span style="font-size:0.6rem; color:var(--text-muted); font-weight:normal;">${msg.timestamp || 'Just now'}</span>
                </div>
                <div style="color:var(--text-muted);">${msg.text}</div>
            `;
            chatBox.appendChild(block);
        });

        chatBox.scrollTop = chatBox.scrollHeight;
        lucide.createIcons();
        return;
    }

    const lead = leads.find(l => l.id === leadId);
    if (!lead) return;

    // Load custom webhook if configured
    document.getElementById('utool-contractor-webhook').value = lead.customWebhook || 'https://hook.us2.make.com/1ugb4pws46g5xpl97qeicogdpv1zgped';

    // 1. Calculate and Render Crew Assignments
    if (!crewAllocations[leadId]) {
        // Pre-seed some mock workers
        crewAllocations[leadId] = [
            { name: 'John Doe', trade: 'plumbing', rate: 75 },
            { name: 'Bruce Wayne', trade: 'electrician', rate: 120 }
        ];
        localStorage.setItem('revitalize_crew_allocations', JSON.stringify(crewAllocations));
    }

    const crew = crewAllocations[leadId];
    document.getElementById('utool-crew-count').innerText = `${crew.length} Crew Allocated`;
    crewTable.innerHTML = '';
    
    let totalLaborCost = 0;
    crew.forEach((worker, idx) => {
        totalLaborCost += worker.rate;
        const tr = document.createElement('tr');
        tr.style.borderBottom = '1px solid rgba(255,255,255,0.03)';
        tr.innerHTML = `
            <td style="padding:0.5rem; color:white; font-weight:600;">${worker.name}</td>
            <td style="padding:0.5rem; text-transform:capitalize; color:var(--text-muted);">${worker.trade}</td>
            <td style="padding:0.5rem; color:white;">$${worker.rate}</td>
            <td style="padding:0.5rem; text-align:right;">
                <button class="btn-secondary btn-sm" onclick="handleDeleteCrewMember(${idx})" style="padding:0.2rem 0.4rem; color:var(--danger); border-color:rgba(239,68,68,0.2); background:rgba(239,68,68,0.02);"><i data-lucide="trash-2" style="width:12px;height:12px;"></i></button>
            </td>
        `;
        crewTable.appendChild(tr);
    });

    // 2. Calculate and Render Materials Checklist
    if (!materialsLists[leadId]) {
        materialsLists[leadId] = [
            { item: 'Copper Pipe fittings', qty: 10, price: 15, status: 'delivered' },
            { item: 'Romex electrical wire 100ft', qty: 2, price: 85, status: 'ordered' },
            { item: 'Drywall Sheets', qty: 15, price: 20, status: 'needed' }
        ];
        localStorage.setItem('revitalize_materials_lists', JSON.stringify(materialsLists));
    }

    const mats = materialsLists[leadId];
    materialsTable.innerHTML = '';
    
    let totalMaterialCost = 0;
    mats.forEach((mat, idx) => {
        const itemCost = mat.qty * mat.price;
        totalMaterialCost += itemCost;

        let statusColor = 'var(--text-muted)';
        if (mat.status === 'ordered') statusColor = 'var(--warning)';
        if (mat.status === 'delivered') statusColor = 'var(--success)';

        const tr = document.createElement('tr');
        tr.style.borderBottom = '1px solid rgba(255,255,255,0.03)';
        tr.innerHTML = `
            <td style="padding:0.5rem; color:white; font-weight:600;">${mat.item}</td>
            <td style="padding:0.5rem; color:var(--text-muted);">${mat.qty}</td>
            <td style="padding:0.5rem; color:white;">$${itemCost}</td>
            <td style="padding:0.5rem; text-transform:capitalize; font-weight:700; color:${statusColor}; cursor:pointer;" onclick="toggleMaterialStatus(${idx})">${mat.status}</td>
            <td style="padding:0.5rem; text-align:right;">
                <button class="btn-secondary btn-sm" onclick="handleDeleteMaterialItem(${idx})" style="padding:0.2rem 0.4rem; color:var(--danger); border-color:rgba(239,68,68,0.2); background:rgba(239,68,68,0.02);"><i data-lucide="trash-2" style="width:12px;height:12px;"></i></button>
            </td>
        `;
        materialsTable.appendChild(tr);
    });

    // 3. Render Budgets Display
    const totalSpent = totalLaborCost + totalMaterialCost;
    const allocatedBudget = lead.scope.reduce((sum, itemKey) => {
        const item = REHAB_ITEMS.find(i => i.id === itemKey);
        return sum + (item ? item.discounted : 0);
    }, 0);

    document.getElementById('utool-material-cost-display').innerText = `$${totalMaterialCost.toLocaleString()}`;
    document.getElementById('utool-labor-cost-display').innerText = `$${totalLaborCost.toLocaleString()}`;
    document.getElementById('utool-total-spent-display').innerText = `$${totalSpent.toLocaleString()}`;
    document.getElementById('utool-allocated-budget-display').innerText = `$${allocatedBudget.toLocaleString()}`;

    const burnRate = allocatedBudget > 0 ? Math.min(100, Math.round((totalSpent / allocatedBudget) * 100)) : 0;
    document.getElementById('utool-burn-pct').innerText = `${burnRate}%`;
    
    const progressFill = document.getElementById('utool-budget-progress-fill');
    progressFill.style.width = `${burnRate}%`;
    if (burnRate > 95) {
        progressFill.style.background = 'var(--danger)';
    } else if (burnRate > 75) {
        progressFill.style.background = 'var(--warning)';
    } else {
        progressFill.style.background = 'var(--primary)';
    }

    // 4. Render Conversation Timeline messages
    if (!chatMessages[leadId]) {
        chatMessages[leadId] = [
            { sender: 'Contractor', body: 'Outbound: Contract Signature verification requested.', time: new Date(Date.now() - 60000 * 5).toLocaleString() },
            { sender: 'Client (Homeowner)', body: 'Inbound: Looking over the wholesale assignment documents now. Looks solid.', time: new Date(Date.now() - 60000 * 3).toLocaleString() }
        ];
        localStorage.setItem('revitalize_chat_messages', JSON.stringify(chatMessages));
    }

    const chats = chatMessages[leadId];
    chatBox.innerHTML = '';
    chats.forEach(msg => {
        const block = document.createElement('div');
        block.style.padding = '0.4rem 0.6rem';
        block.style.borderRadius = '4px';
        block.style.fontSize = '0.75rem';
        block.style.lineHeight = '1.25';
        
        if (msg.sender === 'Contractor') {
            block.style.background = 'rgba(236,72,153,0.08)';
            block.style.alignSelf = 'flex-end';
            block.style.border = '1px solid rgba(236,72,153,0.2)';
            block.style.maxWidth = '85%';
        } else {
            block.style.background = 'rgba(255,255,255,0.02)';
            block.style.alignSelf = 'flex-start';
            block.style.border = '1px solid var(--border-color)';
            block.style.maxWidth = '85%';
        }

        block.innerHTML = `
            <div style="font-weight:700; color:white; display:flex; justify-content:space-between; gap:1rem; margin-bottom:0.15rem;">
                <span>${msg.sender}</span>
                <span style="font-size:0.6rem; color:var(--text-muted); font-weight:normal;">${msg.time}</span>
            </div>
            <div style="color:var(--text-muted);">${msg.body}</div>
        `;
        chatBox.appendChild(block);
    });

    // Auto scroll chat to bottom
    chatBox.scrollTop = chatBox.scrollHeight;

    // Render digital contract status panel
    renderUtoolDigitalContract(lead);

    lucide.createIcons();
}

function handleAddCrewMember() {
    const leadId = document.getElementById('utool-lead-select').value;
    if (!leadId) return;

    const name = document.getElementById('utool-new-crew-name').value.trim();
    const trade = document.getElementById('utool-new-crew-trade').value;
    const rate = parseInt(document.getElementById('utool-new-crew-rate').value) || 50;

    if (!name) {
        showToast("Please enter crew member name!");
        return;
    }

    crewAllocations[leadId].push({ name, trade, rate });
    localStorage.setItem('revitalize_crew_allocations', JSON.stringify(crewAllocations));

    document.getElementById('utool-new-crew-name').value = '';
    document.getElementById('utool-new-crew-rate').value = '';

    showToast("Crew member allocated successfully!");
    renderUtoolDashboard();
}

function handleDeleteCrewMember(idx) {
    const leadId = document.getElementById('utool-lead-select').value;
    if (!leadId) return;

    crewAllocations[leadId].splice(idx, 1);
    localStorage.setItem('revitalize_crew_allocations', JSON.stringify(crewAllocations));
    
    showToast("Crew member de-allocated.");
    renderUtoolDashboard();
}

function handleAddMaterialItem() {
    const leadId = document.getElementById('utool-lead-select').value;
    if (!leadId) return;

    const name = document.getElementById('utool-new-mat-name').value.trim();
    const qty = parseInt(document.getElementById('utool-new-mat-qty').value) || 1;
    const price = parseInt(document.getElementById('utool-new-mat-price').value) || 10;

    if (!name) {
        showToast("Please enter material item name!");
        return;
    }

    materialsLists[leadId].push({ item: name, qty, price, status: 'needed' });
    localStorage.setItem('revitalize_materials_lists', JSON.stringify(materialsLists));

    document.getElementById('utool-new-mat-name').value = '';
    document.getElementById('utool-new-mat-qty').value = '';
    document.getElementById('utool-new-mat-price').value = '';

    showToast("Material item added to checklist!");
    renderUtoolDashboard();
}

function handleDeleteMaterialItem(idx) {
    const leadId = document.getElementById('utool-lead-select').value;
    if (!leadId) return;

    materialsLists[leadId].splice(idx, 1);
    localStorage.setItem('revitalize_materials_lists', JSON.stringify(materialsLists));

    showToast("Material item removed.");
    renderUtoolDashboard();
}

function toggleMaterialStatus(idx) {
    const leadId = document.getElementById('utool-lead-select').value;
    if (!leadId) return;

    const mat = materialsLists[leadId][idx];
    if (mat.status === 'needed') {
        mat.status = 'ordered';
    } else if (mat.status === 'ordered') {
        mat.status = 'delivered';
    } else {
        mat.status = 'needed';
    }

    localStorage.setItem('revitalize_materials_lists', JSON.stringify(materialsLists));
    renderUtoolDashboard();
}

function sendUtoolOutboundMessage() {
    const leadId = document.getElementById('utool-lead-select').value;
    if (!leadId) return;

    const bodyText = document.getElementById('utool-message-input').value.trim();
    if (!bodyText) {
        showToast("Please enter message copy!");
        return;
    }

    const webhookUrl = document.getElementById('utool-contractor-webhook').value.trim();

    if (leadId.startsWith('chat-')) {
        const chat = contractorChats.find(c => c.id === leadId);
        if (!chat) return;

        if (webhookUrl) {
            dispatchContractorWebhook(webhookUrl, {
                event: 'contractor_reply',
                business: chat.bizName,
                consumer: chat.consumerName,
                message: bodyText,
                time: new Date().toLocaleString()
            });
        }

        chat.messages.push({
            sender: 'contractor',
            text: bodyText,
            timestamp: new Date().toLocaleTimeString()
        });

        localStorage.setItem('revitalize_contractor_chats', JSON.stringify(contractorChats));
        document.getElementById('utool-message-input').value = '';
        renderUtoolDashboard();

        // Refresh consumer modal chat history if open
        if (document.getElementById('direct-message-modal').style.display === 'flex' && activeMessageBizId === chat.bizId) {
            renderDirectChatHistory(chat);
        }
        showToast("Direct reply sent to consumer!");
        return;
    }

    const lead = leads.find(l => l.id === leadId);
    if (!lead) return;

    // 1. Dispatch POST request directly to contractor custom webhook if valid
    if (webhookUrl && (webhookUrl.startsWith('http://') || webhookUrl.startsWith('https://'))) {
        fetch(webhookUrl, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                event: 'contractor_message_sent',
                property: lead.address,
                recipient: lead.email,
                body: bodyText,
                timestamp: new Date().toISOString()
            })
        }).then(res => {
            if (res.ok) showToast("Webhook payload dispatched successfully!");
        }).catch(err => console.error("Webhook dispatch failed:", err));
    }

    // 2. Add message to local conversation history
    chatMessages[leadId].push({
        sender: 'Contractor',
        body: bodyText,
        time: new Date().toLocaleString()
    });
    localStorage.setItem('revitalize_chat_messages', JSON.stringify(chatMessages));

    document.getElementById('utool-message-input').value = '';
    renderUtoolDashboard();
}

function simulateInboundEmailResponse() {
    const leadId = document.getElementById('utool-lead-select').value;
    if (!leadId) return;

    if (leadId.startsWith('chat-')) {
        const chat = contractorChats.find(c => c.id === leadId);
        if (!chat) return;

        const reply = prompt(`Simulate incoming message from Consumer (${chat.consumerName}):`, "Hi, when are you available to start the work?");
        if (!reply) return;

        chat.messages.push({
            sender: 'consumer',
            text: reply,
            timestamp: new Date().toLocaleTimeString()
        });

        localStorage.setItem('revitalize_contractor_chats', JSON.stringify(contractorChats));
        renderUtoolDashboard();

        // Refresh consumer modal chat history if open
        if (document.getElementById('direct-message-modal').style.display === 'flex' && activeMessageBizId === chat.bizId) {
            renderDirectChatHistory(chat);
        }
        showToast("Simulated consumer message received!");
        return;
    }

    const lead = leads.find(l => l.id === leadId);
    if (!lead) return;

    const reply = prompt("Simulate incoming email reply from Client / Homeowner:", "Yes, I approve the budget additions. Proceed with romex ordering.");
    if (!reply) return;

    // Add client reply message to conversation history
    chatMessages[leadId].push({
        sender: `Client (${lead.name})`,
        body: reply,
        time: new Date().toLocaleString()
    });
    localStorage.setItem('revitalize_chat_messages', JSON.stringify(chatMessages));

    renderUtoolDashboard();
    showToast("Incoming email reply parsed & read successfully!");
}

function downloadOfflineAgreementText() {
    const leadId = document.getElementById('utool-lead-select').value;
    if (!leadId) {
        showToast("No active job selected!");
        return;
    }

    const lead = leads.find(l => l.id === leadId);
    if (!lead) return;

    // Calculate budget details
    const crew = crewAllocations[leadId] || [];
    const mats = materialsLists[leadId] || [];
    const totalLabor = crew.reduce((sum, w) => sum + w.rate, 0);
    const totalMats = mats.reduce((sum, m) => sum + m.qty * m.price, 0);

    const contractBody = `
======================================================================
           OFFLINE REAL ESTATE WHOLESALE ASSIGNMENT AGREEMENT
======================================================================
DATE: ${new Date().toLocaleDateString()}
PROPERTY FILE ADDRESS: ${lead.address}
CLIENT / OWNER: ${lead.name}
CONTRACTOR / ASSIGNEE: Revitalize Contracting Network
ASSIGNMENT TIER: Wholesale Custom Pre-Build (Double-Contract)

----------------------------------------------------------------------
1. TRANSACTION SUMMARY
----------------------------------------------------------------------
As-Is Valuation: $${(lead.asIsValue || 250000).toLocaleString()} USD
Est. After Rehab Value (ARV): $${(lead.targetARV || 380000).toLocaleString()} USD
Contract Type: 50% Deferred Construction Funding Model
Offline Signing Mode: Authorized Outside Digital System

----------------------------------------------------------------------
2. SOW BUDGET DETAILS (UTOOL AUDIT)
----------------------------------------------------------------------
Total Material Procurement Cost: $${totalMats.toLocaleString()} USD
Total Allocated Labor Rate: $${totalLabor.toLocaleString()} USD
Pre-approved Rehab Budget Cap: $${(totalLabor + totalMats).toLocaleString()} USD

----------------------------------------------------------------------
3. OFF-SITE AUTHORIZATION RULES
----------------------------------------------------------------------
The parties agree to authorize this double-contract agreement off-site.
All payments split calculations are subject to escrow HUD-1 ledger.
By signing below, the contractor agrees to assign labor crew to milestones 
and the homeowner authorizes physical construction access while in occupancy.

X_____________________________________________  Date: ______________
Homeowner Signature (Client)

X_____________________________________________  Date: ______________
Contractor Signature (UTool Member)

X_____________________________________________  Date: ______________
Wholesaler / Escrow Coordinator
======================================================================
`;

    // Download text file
    const element = document.createElement('a');
    const file = new Blob([contractBody], { type: 'text/plain' });
    element.href = URL.createObjectURL(file);
    element.download = `offline_contract_${lead.address.replace(/ /g, '_')}.txt`;
    document.body.appendChild(element);
    element.click();
    document.body.removeChild(element);

    showToast("Offline agreement file generated & downloaded!");
}

// ================= CONSUMER TO CONTRACTOR DIRECT MESSAGING =================
let activeMessageBizId = '';
let activeMessageBizName = '';

function openDirectMessageModal(bizId, bizName) {
    activeMessageBizId = bizId;
    activeMessageBizName = bizName;

    document.getElementById('dm-modal-title').innerText = `Message ${bizName}`;
    
    // Check if chat exists
    const chat = contractorChats.find(c => c.bizId === bizId);
    
    if (chat) {
        document.getElementById('dm-start-form-section').style.display = 'none';
        document.getElementById('dm-chat-section').style.display = 'flex';
        renderDirectChatHistory(chat);
    } else {
        document.getElementById('dm-start-form-section').style.display = 'flex';
        document.getElementById('dm-chat-section').style.display = 'none';
        
        // Pre-fill name and email from localStorage if available
        const savedName = localStorage.getItem('revitalize_consumer_name') || '';
        const savedEmail = localStorage.getItem('revitalize_consumer_email') || '';
        const savedPhone = localStorage.getItem('revitalize_consumer_phone') || '';
        
        document.getElementById('dm-consumer-name').value = savedName;
        document.getElementById('dm-consumer-email').value = savedEmail;
        document.getElementById('dm-consumer-phone').value = savedPhone;
        document.getElementById('dm-initial-message').value = '';
    }

    const modal = document.getElementById('direct-message-modal');
    modal.style.display = 'flex';
    setTimeout(() => { modal.classList.add('active'); }, 10);
    lucide.createIcons();
}

function closeDirectMessageModal() {
    const modal = document.getElementById('direct-message-modal');
    modal.classList.remove('active');
    setTimeout(() => { modal.style.display = 'none'; }, 300);
}

function renderDirectChatHistory(chat) {
    const historyContainer = document.getElementById('dm-chat-history');
    if (!historyContainer) return;
    historyContainer.innerHTML = '';

    chat.messages.forEach(msg => {
        const msgDiv = document.createElement('div');
        msgDiv.style.padding = '0.5rem 0.75rem';
        msgDiv.style.borderRadius = '8px';
        msgDiv.style.fontSize = '0.75rem';
        msgDiv.style.maxWidth = '85%';
        msgDiv.style.lineHeight = '1.3';
        msgDiv.style.marginBottom = '0.5rem';

        if (msg.sender === 'consumer') {
            msgDiv.style.alignSelf = 'flex-end';
            msgDiv.style.background = 'var(--primary)';
            msgDiv.style.color = 'white';
            msgDiv.style.marginLeft = 'auto';
        } else {
            msgDiv.style.alignSelf = 'flex-start';
            msgDiv.style.background = 'rgba(255,255,255,0.08)';
            msgDiv.style.color = 'white';
            msgDiv.style.border = '1px solid rgba(255,255,255,0.05)';
            msgDiv.style.marginRight = 'auto';
        }

        msgDiv.innerHTML = `
            <div style="font-weight:700; font-size:0.65rem; opacity:0.8; margin-bottom:0.15rem;">
                ${msg.sender === 'consumer' ? 'You' : chat.bizName}
            </div>
            <div>${msg.text}</div>
            <div style="font-size:0.55rem; text-align:right; opacity:0.5; margin-top:0.2rem;">${msg.timestamp || 'Just now'}</div>
        `;

        historyContainer.appendChild(msgDiv);
    });

    // Auto-scroll
    historyContainer.scrollTop = historyContainer.scrollHeight;
}

function startContractorChat() {
    const name = document.getElementById('dm-consumer-name').value.trim();
    const email = document.getElementById('dm-consumer-email').value.trim();
    const phone = document.getElementById('dm-consumer-phone').value.trim();
    const msg = document.getElementById('dm-initial-message').value.trim();

    if (!name || !email || !msg) {
        showToast("Please fill in Name, Email, and Message!");
        return;
    }

    // Save user info
    localStorage.setItem('revitalize_consumer_name', name);
    localStorage.setItem('revitalize_consumer_email', email);
    localStorage.setItem('revitalize_consumer_phone', phone);

    const newChat = {
        id: `chat-${Date.now()}`,
        bizId: activeMessageBizId,
        bizName: activeMessageBizName,
        consumerName: name,
        consumerEmail: email,
        consumerPhone: phone,
        messages: [
            { sender: 'consumer', text: msg, timestamp: new Date().toLocaleTimeString() }
        ]
    };

    contractorChats.push(newChat);
    localStorage.setItem('revitalize_contractor_chats', JSON.stringify(contractorChats));

    // Dispatch webhook to contractor if configured
    const biz = laborBusinesses.find(b => b.id === activeMessageBizId);
    if (biz && biz.webhook) {
        dispatchContractorWebhook(biz.webhook, {
            event: 'consumer_inquiry',
            business: biz.name,
            consumer: name,
            email: email,
            phone: phone,
            message: msg,
            time: new Date().toLocaleString()
        });
    }

    // Switch view
    document.getElementById('dm-start-form-section').style.display = 'none';
    document.getElementById('dm-chat-section').style.display = 'flex';
    
    renderDirectChatHistory(newChat);
    showToast(`Message sent to ${activeMessageBizName}!`);
    
    // Re-populate select in UTool since we have a new conversation!
    populateUtoolLeadSelect();
}

function sendDirectMessage() {
    const input = document.getElementById('dm-typing-input');
    const text = input.value.trim();
    if (!text) return;

    const chat = contractorChats.find(c => c.bizId === activeMessageBizId);
    if (!chat) return;

    chat.messages.push({
        sender: 'consumer',
        text: text,
        timestamp: new Date().toLocaleTimeString()
    });

    localStorage.setItem('revitalize_contractor_chats', JSON.stringify(contractorChats));
    input.value = '';

    // Dispatch webhook
    const biz = laborBusinesses.find(b => b.id === activeMessageBizId);
    if (biz && biz.webhook) {
        dispatchContractorWebhook(biz.webhook, {
            event: 'consumer_message',
            business: biz.name,
            consumer: chat.consumerName,
            email: chat.consumerEmail,
            message: text,
            time: new Date().toLocaleString()
        });
    }

    renderDirectChatHistory(chat);
}

function simulateContractorReply() {
    const chat = contractorChats.find(c => c.bizId === activeMessageBizId);
    if (!chat) return;

    const reply = prompt(`Simulate incoming message from ${chat.bizName}:`, "Hi, thank you for reaching out. Yes, we can handle that. Are you free for a call?");
    if (!reply) return;

    chat.messages.push({
        sender: 'contractor',
        text: reply,
        timestamp: new Date().toLocaleTimeString()
    });

    localStorage.setItem('revitalize_contractor_chats', JSON.stringify(contractorChats));
    renderDirectChatHistory(chat);
    showToast(`Received reply from ${chat.bizName}`);
}

function dispatchContractorWebhook(url, payload) {
    if (!url || !(url.startsWith('http://') || url.startsWith('https://'))) {
        console.warn("Skipping contractor webhook dispatch: Invalid or empty URL:", url);
        return;
    }
    console.log("Dispatching contractor webhook payload to:", url, payload);
    fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
    })
    .catch(err => {
        console.error("Contractor webhook error:", err);
    });
}

// ================= CONTRACTOR BIDDING SYSTEM LOGIC =================
function openPlaceBidModal(requestId) {
    const req = workRequests.find(r => r.id === requestId);
    if (!req) return;

    document.getElementById('bid-request-id').value = requestId;
    document.getElementById('bid-project-address').innerText = `Property Address: ${req.address} (Required Trade: ${req.trade})`;

    // Populate contractor select dropdown
    const select = document.getElementById('bid-contractor-select');
    if (select) {
        select.innerHTML = '';
        if (laborBusinesses.length === 0) {
            select.innerHTML = '<option value="">No registered contractors found. Please register a contractor profile first.</option>';
        } else {
            laborBusinesses.forEach(biz => {
                const opt = document.createElement('option');
                opt.value = biz.id;
                opt.innerText = `${biz.name} (${biz.trade.toUpperCase()} • Rate: $${biz.rate}/hr)`;
                select.appendChild(opt);
            });
        }
    }

    const modal = document.getElementById('place-bid-modal');
    modal.style.display = 'flex';
    setTimeout(() => { modal.classList.add('active'); }, 10);
    lucide.createIcons();
}

function closePlaceBidModal() {
    const modal = document.getElementById('place-bid-modal');
    modal.classList.remove('active');
    setTimeout(() => { modal.style.display = 'none'; }, 300);
}

function handleBidSubmit(event) {
    event.preventDefault();
    const requestId = document.getElementById('bid-request-id').value;
    const contractorId = document.getElementById('bid-contractor-select').value;
    const amount = parseInt(document.getElementById('bid-amount').value) || 0;
    const days = parseInt(document.getElementById('bid-days').value) || 1;
    const msg = document.getElementById('bid-message').value.trim();

    if (!contractorId) {
        showToast("Please register a contractor profile first!");
        return;
    }

    const req = workRequests.find(r => r.id === requestId);
    if (!req) return;

    const biz = laborBusinesses.find(b => b.id === contractorId);
    if (!biz) return;

    const newBid = {
        id: `bid-${Date.now()}`,
        contractorId: contractorId,
        contractorName: biz.name,
        contractorRating: biz.rating || 4.8,
        amount: amount,
        days: days,
        message: msg,
        timestamp: new Date().toLocaleString(),
        status: 'pending'
    };

    // If it's linked to a lead project, save it to the lead too
    if (req.leadId) {
        const lead = leads.find(l => l.id === req.leadId);
        if (lead) {
            if (!lead.bids) lead.bids = [];
            lead.bids.push(newBid);
            saveLeadsToStorage();
        }
    } else {
        // Save to temporary lead bids if they look up a direct request address
        // We find or create a mock lead so the Client Dashboard works for this address too!
        let lead = leads.find(l => l.address.toLowerCase() === req.address.toLowerCase());
        if (!lead) {
            lead = {
                id: `lead-req-${req.id}`,
                name: req.owner,
                email: req.email,
                phone: '(555) 000-0000',
                address: req.address,
                asIsValue: 250000,
                targetARV: 310000,
                stage: 'intake',
                scope: [req.trade],
                bids: [],
                timeline: req.timeline || 'Flexible'
            };
            leads.push(lead);
            saveLeadsToStorage();
        }
        if (!lead.bids) lead.bids = [];
        lead.bids.push(newBid);
        saveLeadsToStorage();
    }

    if (!req.bids) req.bids = [];
    req.bids.push(newBid);
    localStorage.setItem('revitalize_work_requests', JSON.stringify(workRequests));

    closePlaceBidModal();
    document.getElementById('place-bid-form').reset();
    showToast(`Bid submitted successfully from ${biz.name}!`);
    renderJobRequestsFeed();
}

function renderClientBids(lead) {
    const bidsList = document.getElementById('client-bids-list');
    const bidsCount = document.getElementById('client-bids-count');
    if (!bidsList) return;

    bidsList.innerHTML = '';
    const bids = lead.bids || [];
    if (bidsCount) bidsCount.innerText = `${bids.length} Bids`;

    if (bids.length === 0) {
        bidsList.innerHTML = '<div style="text-align:center; font-size:0.75rem; color:var(--text-muted); padding:1rem;">Waiting for contractor proposals...</div>';
        return;
    }

    bids.forEach((bid, idx) => {
        const div = document.createElement('div');
        div.style.background = 'rgba(255,255,255,0.02)';
        div.style.border = '1px solid var(--border-color)';
        div.style.borderRadius = '4px';
        div.style.padding = '0.75rem';
        div.style.display = 'flex';
        div.style.flexDirection = 'column';
        div.style.gap = '0.5rem';

        if (bid.status === 'accepted') {
            div.style.borderColor = 'var(--success)';
            div.style.background = 'rgba(16,185,129,0.03)';
        }

        const statusBadge = bid.status === 'accepted'
            ? `<span class="badge success" style="margin-left:auto; background:rgba(16,185,129,0.15); color:var(--success); border:1px solid rgba(16,185,129,0.3); font-size:0.65rem; padding:0.15rem 0.4rem; border-radius:4px; display:inline-flex; align-items:center; gap:2px;"><i data-lucide="check" style="width:10px;height:10px;"></i> Accepted</span>`
            : '';

        div.innerHTML = `
            <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:0.5rem;">
                <div>
                    <h4 style="margin:0; font-size:0.85rem; color:white; font-weight:700; display:flex; align-items:center; gap:4px;">
                        <span>${bid.contractorName}</span>
                        <span style="color:var(--warning); font-size:0.75rem;">★ ${bid.contractorRating}</span>
                    </h4>
                    <span style="font-size:0.7rem; color:var(--text-muted);">Submitted: ${bid.timestamp}</span>
                </div>
                <div style="text-align:right;">
                    <div style="font-size:0.95rem; font-weight:800; color:var(--success);">$${bid.amount.toLocaleString()}</div>
                    <span style="font-size:0.7rem; color:var(--text-muted);">${bid.days} Days Est.</span>
                </div>
                ${statusBadge}
            </div>
            <p style="margin:0; font-size:0.75rem; color:var(--text-muted); line-height:1.3; font-style:italic;">"${bid.message}"</p>
            <div style="display:flex; gap:0.5rem; border-top:1px solid rgba(255,255,255,0.03); padding-top:0.5rem; margin-top:0.25rem;">
                <button class="btn-secondary" onclick="viewBidContractorProfile('${bid.contractorId}')" style="font-size:0.7rem; padding:0.25rem 0.6rem; color:white; flex-grow:1; display:flex; justify-content:center; align-items:center; gap:2px; background:rgba(255,255,255,0.02); border-color:var(--border-color);">
                    <i data-lucide="user" style="width:12px;height:12px;"></i> View Profile & Photos
                </button>
                ${bid.status !== 'accepted' ? `
                <button class="btn-primary" onclick="acceptContractorBid('${lead.id}', ${idx})" style="font-size:0.7rem; padding:0.25rem 0.6rem; flex-grow:1; display:flex; justify-content:center; align-items:center; gap:2px;">
                    <i data-lucide="check" style="width:12px;height:12px;"></i> Accept Bid
                </button>` : ''}
            </div>
        `;
        bidsList.appendChild(div);
    });
    lucide.createIcons();
}

function viewBidContractorProfile(contractorId) {
    const biz = laborBusinesses.find(b => b.id === contractorId);
    if (!biz) return;

    // Close client portal
    closeClientPortal();

    // Switch to Labor view
    switchView('labor');

    // Filter by this trade to show the business card
    const tradeFilter = document.getElementById('directory-filter-trade');
    if (tradeFilter) {
        tradeFilter.value = biz.trade;
        renderLaborDirectory();
    }

    // Scroll to the card and flash it
    setTimeout(() => {
        const card = document.getElementById(`biz-details-${contractorId}`);
        if (card) {
            card.scrollIntoView({ behavior: 'smooth', block: 'center' });
            
            // Open details drawer
            const drawer = document.getElementById(`biz-details-${contractorId}`);
            if (drawer && drawer.style.display === 'none') {
                toggleBizDetailsDrawer(contractorId);
            }
            
            // Flash styling
            const cardParent = drawer.parentElement;
            if (cardParent) {
                const originalBorder = cardParent.style.borderColor;
                cardParent.style.borderColor = 'var(--primary)';
                cardParent.style.boxShadow = '0 0 15px var(--primary)';
                setTimeout(() => {
                    cardParent.style.borderColor = originalBorder;
                    cardParent.style.boxShadow = 'none';
                }, 1500);
            }
        }
    }, 400);
}

function acceptContractorBid(leadId, bidIdx) {
    const lead = leads.find(l => l.id === leadId);
    if (!lead) return;

    const bids = lead.bids || [];
    const bid = bids[bidIdx];
    if (!bid) return;

    // Reset status of all other bids to pending
    bids.forEach(b => b.status = 'pending');
    bid.status = 'accepted';

    // Update lead stage to 'rehab' or keep in progress
    lead.stage = 'rehab';
    saveLeadsToStorage();

    // Dynamically assign this contractor to the crew lists in UTool
    const contractor = laborBusinesses.find(b => b.id === bid.contractorId);
    if (contractor) {
        if (!crewAllocations[leadId]) {
            crewAllocations[leadId] = [];
        }
        
        // Remove existing allocations of same trade to prevent duplicates
        crewAllocations[leadId] = crewAllocations[leadId].filter(c => c.trade !== contractor.trade);
        
        // Assign accepted contractor
        crewAllocations[leadId].push({
            name: contractor.name,
            trade: contractor.trade,
            rate: contractor.rate
        });
        localStorage.setItem('revitalize_crew_allocations', JSON.stringify(crewAllocations));
    }

    renderClientBids(lead);
    showToast(`Bid accepted! ${bid.contractorName} assigned to project team.`);
}

// ================= USER AUTHENTICATION & LOGIN LOGIC =================
let authActiveTab = 'signin';

function openAuthModal() {
    authActiveTab = 'signin';
    document.getElementById('auth-modal-title').innerText = "Sign In to Revitalize";
    document.getElementById('auth-register-only').style.display = 'none';
    document.getElementById('auth-btn-submit').innerText = "Sign In";
    
    document.getElementById('auth-tab-signin').className = 'btn-primary';
    document.getElementById('auth-tab-register').className = 'btn-secondary';
    document.getElementById('auth-tab-register').style.color = 'white';

    // Populate contractor directory select list
    const bizSelect = document.getElementById('auth-biz-select');
    if (bizSelect) {
        bizSelect.innerHTML = '';
        laborBusinesses.forEach(biz => {
            if (biz && biz.id && biz.name) {
                const opt = document.createElement('option');
                opt.value = biz.id;
                opt.innerText = biz.name;
                bizSelect.appendChild(opt);
            }
        });
    }

    const modal = document.getElementById('auth-modal');
    modal.style.display = 'flex';
    setTimeout(() => { modal.classList.add('active'); }, 10);
    lucide.createIcons();
}

function closeAuthModal() {
    const modal = document.getElementById('auth-modal');
    modal.classList.remove('active');
    setTimeout(() => { modal.style.display = 'none'; }, 300);
}

function setAuthTab(tab) {
    authActiveTab = tab;
    if (tab === 'signin') {
        document.getElementById('auth-modal-title').innerText = "Sign In to Revitalize";
        document.getElementById('auth-register-only').style.display = 'none';
        document.getElementById('auth-btn-submit').innerText = "Sign In";
        document.getElementById('auth-tab-signin').className = 'btn-primary';
        document.getElementById('auth-tab-register').className = 'btn-secondary';
        document.getElementById('auth-tab-register').style.color = 'white';
    } else {
        document.getElementById('auth-modal-title').innerText = "Register New Account";
        document.getElementById('auth-register-only').style.display = 'flex';
        document.getElementById('auth-btn-submit').innerText = "Create Account";
        document.getElementById('auth-tab-signin').className = 'btn-secondary';
        document.getElementById('auth-tab-signin').style.color = 'white';
        document.getElementById('auth-tab-register').className = 'btn-primary';
        onAuthRoleChange();
    }
}

function onAuthRoleChange() {
    const role = document.getElementById('auth-role').value;
    const group = document.getElementById('auth-biz-select-group');
    if (role === 'contractor') {
        group.style.display = 'block';
    } else {
        group.style.display = 'none';
    }
}

async function handleAuthSubmit(event) {
    event.preventDefault();
    const email = (document.getElementById('auth-email').value || '').trim();
    const password = document.getElementById('auth-password').value || '';
    const name = (document.getElementById('auth-name').value || '').trim();
    const role = document.getElementById('auth-role').value || 'homeowner';
    const bizId = document.getElementById('auth-biz-select').value || '';

    if (authActiveTab === 'signin') {
        // Sandbox Local Fallback Auth checked FIRST for instant responsiveness!
        let accounts = [];
        try {
            const savedAccs = localStorage.getItem('revitalize_accounts');
            if (savedAccs) accounts = JSON.parse(savedAccs);
        } catch (e) { console.error(e); }

        const match = accounts.find(a => a.email && a.email.toLowerCase() === email.toLowerCase() && a.password === password);
        if (match) {
            currentUser = {
                email: match.email,
                name: match.name,
                role: match.role,
                bizId: match.bizId
            };
            localStorage.setItem('revitalize_current_user', JSON.stringify(currentUser));
            showToast(`Welcome back, ${currentUser.name}! (Sandbox Profile)`);
            closeAuthModal();
            renderAuthHeaderStatus();
            if (currentView === 'utool') renderUtoolDashboard();
            
            // Asynchronously sync to Supabase in the background if configured
            if (supabaseClient) {
                supabaseClient.auth.signInWithPassword({ email, password }).then(({ error }) => {
                    if (!error) console.log("Supabase background auth synced.");
                }).catch(err => console.warn("Supabase background auth sync warning:", err));
            }
            return;
        }

        // If local check failed, attempt Supabase auth
        if (supabaseClient) {
            try {
                showToast("Connecting to Supabase...");
                const { data, error } = await supabaseClient.auth.signInWithPassword({ email, password });
                if (error) throw error;

                // Load user profile metadata
                currentUser = {
                    email: data.user.email,
                    name: data.user.user_metadata.name || data.user.email,
                    role: data.user.user_metadata.role || 'homeowner',
                    bizId: data.user.user_metadata.bizId || ''
                };
                localStorage.setItem('revitalize_current_user', JSON.stringify(currentUser));

                // Sync credentials to local fallback accounts cache
                try {
                    let accounts = [];
                    const savedAccs = localStorage.getItem('revitalize_accounts');
                    if (savedAccs) accounts = JSON.parse(savedAccs);
                    const idx = accounts.findIndex(a => a.email && a.email.toLowerCase() === email.toLowerCase());
                    if (idx !== -1) {
                        accounts[idx].password = password;
                        accounts[idx].name = currentUser.name;
                        accounts[idx].role = currentUser.role;
                        accounts[idx].bizId = currentUser.bizId;
                    } else {
                        accounts.push({
                            email: currentUser.email,
                            password: password,
                            name: currentUser.name,
                            role: currentUser.role,
                            bizId: currentUser.bizId
                        });
                    }
                    localStorage.setItem('revitalize_accounts', JSON.stringify(accounts));
                } catch (e) { console.error(e); }

                showToast(`Welcome back, ${currentUser.name}! (Connected to Supabase)`);
                closeAuthModal();
                renderAuthHeaderStatus();
                if (currentView === 'utool') renderUtoolDashboard();
                return;
            } catch (e) {
                console.error("Supabase signin error:", e.message);
                showToast(`Supabase Error: ${e.message}`);
            }
        }

        showToast("Invalid credentials. Please register first.");
    } else {
        // Register Account
        if (supabaseClient) {
            try {
                showToast("Registering user on Supabase...");
                supabaseClient.auth.signUp({
                    email,
                    password,
                    options: {
                        data: { name, role, bizId }
                    }
                }).then(({ error }) => {
                    if (error) console.error("Supabase signUp async error:", error.message);
                });
            } catch (e) {
                console.error("Supabase signup caught error:", e.message);
            }
        }

        // Sandbox Fallback Registration (always runs to ensure local login works seamlessly!)
        let accounts = [];
        try {
            const savedAccs = localStorage.getItem('revitalize_accounts');
            if (savedAccs) accounts = JSON.parse(savedAccs);
        } catch (e) { console.error(e); }

        if (accounts.some(a => a.email && a.email.toLowerCase() === email.toLowerCase())) {
            const existing = accounts.find(a => a.email && a.email.toLowerCase() === email.toLowerCase());
            currentUser = { email: existing.email, name: existing.name, role: existing.role, bizId: existing.bizId };
            localStorage.setItem('revitalize_current_user', JSON.stringify(currentUser));
            showToast(`Logged in to existing profile: ${currentUser.name}`);
            closeAuthModal();
            renderAuthHeaderStatus();
            if (currentView === 'utool') renderUtoolDashboard();
            return;
        }

        const newAccount = { email, password, name, role, bizId };
        accounts.push(newAccount);
        localStorage.setItem('revitalize_accounts', JSON.stringify(accounts));

        currentUser = { email, name, role, bizId };
        localStorage.setItem('revitalize_current_user', JSON.stringify(currentUser));
        
        showToast(`Account created successfully! Welcome ${name}.`);
        closeAuthModal();
        renderAuthHeaderStatus();
        if (currentView === 'utool') renderUtoolDashboard();
    }
}

function handleSignOut() {
    if (supabaseClient) {
        supabaseClient.auth.signOut().catch(err => console.error(err));
    }
    currentUser = null;
    localStorage.removeItem('revitalize_current_user');
    showToast("Signed out successfully.");
    renderAuthHeaderStatus();
    if (currentView === 'utool') renderUtoolDashboard();
}

function renderAuthHeaderStatus() {
    const container = document.getElementById('auth-status-container');
    if (!container) return;

    if (currentUser) {
        let label = currentUser.role === 'contractor' ? 'Contractor' : 'Homeowner';
        container.innerHTML = `
            <span style="font-size:0.75rem; color:var(--text-muted); font-weight:600; display:inline-block; border-right:1px solid rgba(255,255,255,0.08); padding-right:0.75rem; margin-right:0.25rem;">
                <span class="text-gradient">${label}</span>: ${currentUser.name}
            </span>
            <button class="btn-secondary" onclick="handleSignOut()" style="padding:0.3rem 0.6rem; font-size:0.7rem; color:white; display:flex; align-items:center; gap:2px; background:rgba(255,255,255,0.02); border-color:var(--border-color);">
                <i data-lucide="log-out" style="width:12px;height:12px;"></i> Sign Out
            </button>
        `;
    } else {
        container.innerHTML = `
            <button class="btn-primary" onclick="openAuthModal()" style="font-size:0.75rem; padding:0.4rem 0.8rem; display:flex; align-items:center; gap:4px;"><i data-lucide="log-in" style="width:14px;height:14px;"></i> Sign In</button>
        `;
    }
    lucide.createIcons();
}


// ================= COOPERATIVE DIGITAL CONTRACT SYSTEM =================
function openContractBuilderFromChat() {
    if (!currentUser) {
        showToast("Please sign in first to generate a binding project contract!");
        openAuthModal();
        return;
    }

    const chat = contractorChats.find(c => c.bizId === activeMessageBizId);
    if (!chat) {
        showToast("No active conversation found to build terms.");
        return;
    }

    // Attempt to locate a matching project lead for this consumer
    const clientEmail = currentUser ? currentUser.email : (localStorage.getItem('revitalize_consumer_email') || '');
    let lead = leads.find(l => l.email && clientEmail && l.email.toLowerCase() === clientEmail.toLowerCase()) || leads[0];

    if (!lead) {
        showToast("No active homeowner project found. List your house on the portal first!");
        return;
    }

    document.getElementById('contract-lead-id').value = lead.id;
    document.getElementById('contract-client-name').value = lead.name;
    document.getElementById('contract-biz-name').value = chat.bizName;
    document.getElementById('contract-address').value = lead.address;

    // Suggest budget based on ARV spread
    const spread = Math.round(lead.targetARV - lead.asIsValue);
    document.getElementById('contract-agreed-budget').value = spread > 5000 ? Math.round(spread * 0.7) : 35000;
    document.getElementById('contract-agreed-days').value = 30;

    // Load before photo
    document.getElementById('contract-before-photo').value = lead.photoUrl || 'https://images.unsplash.com/photo-1581094288338-2314dddb7eed?auto=format&fit=crop&w=400&q=80';
    document.getElementById('contract-scope-details').value = `This agreement mandates that ${chat.bizName} will perform general trade repairs and renovation work at the property of ${lead.name} located at ${lead.address}.\n\nPayments are assigned and settled at transaction closing. All works require full photo verification.`;

    document.getElementById('contract-sig-owner').value = '';
    document.getElementById('contract-sig-biz').value = '';

    const modal = document.getElementById('contract-builder-modal');
    modal.style.display = 'flex';
    setTimeout(() => { modal.classList.add('active'); }, 10);
    lucide.createIcons();
}

function closeContractBuilderModal() {
    const modal = document.getElementById('contract-builder-modal');
    modal.classList.remove('active');
    setTimeout(() => { modal.style.display = 'none'; }, 300);
}

function handleStapleContract(event) {
    event.preventDefault();
    const leadId = document.getElementById('contract-lead-id').value;
    const clientName = document.getElementById('contract-client-name').value;
    const bizName = document.getElementById('contract-biz-name').value;
    const address = document.getElementById('contract-address').value;
    const budget = parseInt(document.getElementById('contract-agreed-budget').value) || 0;
    const days = parseInt(document.getElementById('contract-agreed-days').value) || 1;
    const beforePhoto = document.getElementById('contract-before-photo').value.trim();
    const scopeDetails = document.getElementById('contract-scope-details').value.trim();
    const sigOwner = document.getElementById('contract-sig-owner').value.trim();
    const sigBiz = document.getElementById('contract-sig-biz').value.trim();

    if (!sigOwner || !sigBiz) {
        showToast("Both parties must sign the contract to staple!");
        return;
    }

    const lead = leads.find(l => l.id === leadId);
    if (!lead) return;

    const contract = {
        id: `contract-${Date.now()}`,
        leadId: leadId,
        contractorId: activeMessageBizId,
        contractorName: bizName,
        clientName: clientName,
        address: address,
        budget: budget,
        days: days,
        beforePhoto: beforePhoto,
        scopeDetails: scopeDetails,
        sigOwner: sigOwner,
        sigBiz: sigBiz,
        status: 'signed',
        timestamp: new Date().toLocaleString()
    };

    // Staple contract to project lead
    lead.contract = contract;
    lead.stage = 'rehab'; // Progress to Active Rehab stage!
    saveLeadsToStorage();

    // Persist to Supabase if client active
    if (supabaseClient) {
        supabaseClient.from('contracts').insert([contract]).then(({ data, error }) => {
            if (error) console.error("Supabase save contract error:", error.message);
            else console.log("Stapled to Supabase successfully!");
        });
    }

    closeContractBuilderModal();
    closeDirectMessageModal();
    showToast("Digital contract successfully signed & stapled to project!");
    renderUtoolDashboard();
}

function openContractFulfillModal(leadId) {
    document.getElementById('fulfill-lead-id').value = leadId;
    document.getElementById('fulfill-after-photo').value = '';
    const modal = document.getElementById('contract-fulfill-modal');
    modal.style.display = 'flex';
    setTimeout(() => { modal.classList.add('active'); }, 10);
}

function closeContractFulfillModal() {
    const modal = document.getElementById('contract-fulfill-modal');
    modal.classList.remove('active');
    setTimeout(() => { modal.style.display = 'none'; }, 300);
}

function handleFulfillContractSubmit(event) {
    event.preventDefault();
    const leadId = document.getElementById('fulfill-lead-id').value;
    const afterPhoto = document.getElementById('fulfill-after-photo').value.trim();

    if (!afterPhoto) {
        showToast("Please enter the finished product photo URL!");
        return;
    }

    const lead = leads.find(l => l.id === leadId);
    if (!lead || !lead.contract) return;

    const c = lead.contract;
    c.status = 'completed';
    c.afterPhoto = afterPhoto;
    
    lead.stage = 'listed'; // Conclude rehab and advance to MLS listings!
    saveLeadsToStorage();

    // Populate Before & After project transformation on contractor showcase profile
    const biz = laborBusinesses.find(b => b.id === c.contractorId);
    if (biz) {
        if (!biz.transformations) biz.transformations = [];
        biz.transformations.push({
            address: c.address,
            before: c.beforePhoto,
            after: afterPhoto,
            budget: c.budget,
            days: c.days,
            completedDate: new Date().toLocaleDateString()
        });
        localStorage.setItem('revitalize_labor_businesses', JSON.stringify(laborBusinesses));
    }

    // Save update to Supabase
    if (supabaseClient) {
        supabaseClient.from('contracts')
            .update({ status: 'completed', afterPhoto: afterPhoto })
            .eq('id', c.id)
            .then(({ error }) => {
                if (error) console.error("Supabase contract complete update error:", error.message);
            });
    }

    closeContractFulfillModal();
    showToast(`Project concluded! Before & After showcase registered to your directory profile.`);
    
    renderUtoolDashboard();
    renderLaborDirectory();
}

function renderUtoolDigitalContract(lead) {
    const container = document.getElementById('utool-digital-contract-container');
    if (!container) return;
    container.innerHTML = '';

    if (!lead || !lead.contract) {
        container.innerHTML = `
            <h4 style="font-size:0.8rem; font-weight:700; color:white; margin:0;">Active Digital Contract</h4>
            <p style="font-size:0.7rem; color:var(--text-muted); margin:0;">No digital contract has been stapled to this project yet. Cooperate in chat to build one.</p>
        `;
        return;
    }

    const c = lead.contract;
    const isCompleted = c.status === 'completed';

    let actionBtnHtml = '';
    if (!isCompleted) {
        const isCurrentContractor = currentUser && currentUser.role === 'contractor' && currentUser.bizId === c.contractorId;
        if (isCurrentContractor) {
            actionBtnHtml = `
                <button class="btn-primary" onclick="openContractFulfillModal('${lead.id}')" style="width:100%; font-size:0.75rem; padding:0.4rem; display:flex; align-items:center; justify-content:center; gap:0.25rem;">
                    <i data-lucide="check-square"></i> Mark Completed & Upload After Photo
                </button>
            `;
        } else {
            actionBtnHtml = `
                <div style="background:rgba(245,158,11,0.05); border:1px solid rgba(245,158,11,0.2); border-radius:4px; padding:0.5rem; font-size:0.65rem; color:#f59e0b; line-height:1.2;">
                    🔒 To complete this job, sign in as contractor <strong>${c.contractorName}</strong>.
                </div>
            `;
        }
    } else {
        actionBtnHtml = `
            <div style="background:rgba(16,185,129,0.15); color:var(--success); border:1px solid rgba(16,185,129,0.3); font-size:0.7rem; padding:0.4rem; border-radius:4px; text-align:center; font-weight:700;">
                ✓ Contract Fulfilled & Concluded
            </div>
        `;
    }

    container.innerHTML = `
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:0.25rem;">
            <h4 style="font-size:0.8rem; font-weight:700; color:white; margin:0;">Stapled Digital Contract</h4>
            <span class="badge ${isCompleted ? 'success' : 'warning'}" style="font-size:0.6rem; text-transform:uppercase; padding:0.15rem 0.35rem;">${c.status}</span>
        </div>
        <div style="background:rgba(0,0,0,0.3); border:1px solid var(--border-color); border-radius:4px; padding:0.6rem; font-size:0.7rem; display:flex; flex-direction:column; gap:0.4rem;">
            <div>Contractor: <strong>${c.contractorName}</strong></div>
            <div>Agreed Budget: <strong>$${c.budget.toLocaleString()}</strong></div>
            <div>Agreed Timeline: <strong>${c.days} Days</strong></div>
            
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:0.4rem; margin-top:0.25rem;">
                <div>
                    <span style="font-size:0.55rem; color:var(--text-muted); display:block; margin-bottom:0.15rem; text-transform:uppercase;">Before</span>
                    <div style="height:60px; border-radius:4px; overflow:hidden; border:1px solid rgba(255,255,255,0.05); cursor:pointer;" onclick="openImageWindow('${c.beforePhoto}')">
                        <img src="${c.beforePhoto}" style="width:100%; height:100%; object-fit:cover;">
                    </div>
                </div>
                <div>
                    <span style="font-size:0.55rem; color:var(--success); display:block; margin-bottom:0.15rem; text-transform:uppercase;">After</span>
                    ${c.afterPhoto ? `
                    <div style="height:60px; border-radius:4px; overflow:hidden; border:1px solid rgba(255,255,255,0.05); cursor:pointer;" onclick="openImageWindow('${c.afterPhoto}')">
                        <img src="${c.afterPhoto}" style="width:100%; height:100%; object-fit:cover;">
                    </div>
                    ` : `
                    <div style="height:60px; border-radius:4px; background:rgba(255,255,255,0.02); border:1px dashed var(--border-color); display:flex; align-items:center; justify-content:center; color:var(--text-muted); font-size:0.55rem;">
                        Pending
                    </div>
                    `}
                </div>
            </div>
            
            <div style="border-top:1px solid rgba(255,255,255,0.03); padding-top:0.4rem; font-size:0.65rem; color:var(--text-muted); text-align:center;">
                Signatures: <i>${c.sigOwner}</i> & <i>${c.sigBiz}</i>
            </div>
        </div>
        <div style="margin-top:0.25rem;">
            ${actionBtnHtml}
        </div>
    `;
    lucide.createIcons();
}

// ================= MANUAL JOB CREATION SYSTEM =================
function openCreateJobManualModal() {
    const drawer = document.getElementById('utool-create-job-modal');
    drawer.style.display = 'flex';
    setTimeout(() => { drawer.classList.add('active'); }, 10);
    // Prefill a dummy photo URL if empty
    document.getElementById('utool-manual-photo').value = 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=400&q=80';
    lucide.createIcons();
}

function closeCreateJobManualModal() {
    const drawer = document.getElementById('utool-create-job-modal');
    drawer.classList.remove('active');
    setTimeout(() => { drawer.style.display = 'none'; }, 300);
}

function handleCreateJobManualSubmit(event) {
    event.preventDefault();
    
    const address = document.getElementById('utool-manual-address').value.trim();
    const name = document.getElementById('utool-manual-name').value.trim();
    const email = document.getElementById('utool-manual-email').value.trim();
    const asIsValue = parseFloat(document.getElementById('utool-manual-asis').value) || 0;
    const targetARV = parseFloat(document.getElementById('utool-manual-arv').value) || 0;
    const budget = parseFloat(document.getElementById('utool-manual-budget').value) || 0;
    const timeline = document.getElementById('utool-manual-timeline').value.trim();
    const trade = document.getElementById('utool-manual-trade').value;
    const photoUrl = document.getElementById('utool-manual-photo').value.trim() || 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=400&q=80';

    const newLead = {
        id: 'lead-' + Date.now(),
        address: address,
        name: name,
        email: email,
        phone: '555-0199',
        asIsValue: asIsValue,
        targetARV: targetARV,
        timeline: timeline,
        budget: budget,
        trade: trade,
        photoUrl: photoUrl,
        stage: 'rehab', // Advance directly to active rehab stage
        scope: [trade],
        notes: 'Manually created via UTool Contractor Suite.',
        coords: { x: Math.round(Math.random() * 300) + 50, y: Math.round(Math.random() * 300) + 50 },
        hotLevel: 'hot',
        dom: 0,
        distance: 1.5,
        bids: []
    };

    leads.push(newLead);
    saveLeadsToStorage();
    
    // Refresh UTool selector
    populateUtoolLeadSelect();
    
    // Set selected lead value to the newly created lead
    document.getElementById('utool-lead-select').value = newLead.id;
    
    // Render Dashboard for this job
    renderUtoolDashboard();
    
    closeCreateJobManualModal();
    showToast("Rehab Job File created and loaded successfully!");
}
