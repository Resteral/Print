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
let prospects = [...MOCK_PROSPECTS];
let contractors = [];
let emailLogs = [];
let emailSettings = { autoIntake: true, autoRehab: true, autoContract: true };
let currentSelectedLeadId = null;
let currentSlideIdx = 1;

// E-Signature Drawing Pad State
let sigCanvas = null;
let sigCtx = null;
let sigDrawing = false;
let sigMode = 'draw';

// Initialize App
document.addEventListener('DOMContentLoaded', () => {
    // Load leads
    const savedLeads = localStorage.getItem('revitalize_leads');
    if (savedLeads) {
        leads = JSON.parse(savedLeads);
    } else {
        leads = [
            {
                id: 'lead-default-1',
                name: 'Eleanor Vance',
                email: 'evance@email.com',
                phone: '(555) 890-1234',
                address: '882 Whispering Pines Dr',
                asIsValue: 390000,
                targetARV: 485000,
                commissionRate: 6,
                stage: 'rehab',
                notes: 'Contract signed. Kitchen remodel and flooring upgrade are currently underway by our contractor network.',
                scope: ['kitchen', 'flooring', 'landscaping'],
                workExplanations: {
                    kitchen: 'Cabinets are yellowing honey oak and need full replacement; laminate countertops are chipped near the sink.',
                    flooring: 'Rip out stained carpets in primary bedroom and lay modern wide-plank wood flooring.',
                    landscaping: 'Mow overgrown front lawn and lay fresh dark cedar mulch in all front beds.'
                },
                dispatches: { kitchen: 'con-4', flooring: 'con-3', landscaping: 'con-2' },
                completedSubtasks: ['kit-1', 'kit-2', 'floor-1', 'land-1', 'land-2'],
                signature: {
                    date: '2026-07-11, 10:15:30 AM',
                    ip: '192.168.1.145',
                    hash: 'E8A91B012F4F7C770D6A9F7623910A92FFC1405A',
                    typedName: 'Eleanor Vance'
                }
            },
            {
                id: 'lead-default-2',
                name: 'Thomas Shelby',
                email: 'tshelby@shelbyco.com',
                phone: '(555) 901-2345',
                address: '104 Garrison Lane',
                asIsValue: 290000,
                targetARV: 370000,
                commissionRate: 5.5,
                stage: 'valuation',
                notes: 'Lead submitted via website calculator. Scheduling virtual site walkthrough to draft rehab proposal.',
                scope: ['paint', 'landscaping', 'hvac'],
                workExplanations: {
                    paint: 'Living room walls are smoke stained and need a fresh light neutral coat.',
                    landscaping: 'Spruce up front brick walkway, clear weeds, and pressure wash the rear stone patio.'
                },
                dispatches: {},
                completedSubtasks: []
            },
            {
                id: 'lead-default-3',
                name: 'Clara Oswald',
                email: 'clara.os@time.org',
                phone: '(555) 112-2334',
                address: '775 Windhill Terrace',
                asIsValue: 550000,
                targetARV: 680000,
                commissionRate: 6,
                stage: 'agreement',
                notes: 'Listing agreement sent. Premium package proposed (full kitchen, master bath, flooring). Waiting on signature.',
                scope: ['kitchen', 'bathroom', 'flooring', 'paint'],
                workExplanations: {
                    kitchen: 'Old laminate cabinets are sticky, double sink is cracked white ceramic.',
                    bathroom: 'Outdated pink floral tiling, rusty bathtub fixtures, and vanity cabinet drawer guide is broken.'
                },
                dispatches: {},
                completedSubtasks: []
            }
        ];
        saveLeadsToStorage();
    }

    // Load Contractors
    const savedContractors = localStorage.getItem('revitalize_contractors');
    if (savedContractors) {
        contractors = JSON.parse(savedContractors);
    } else {
        contractors = [
            { id: 'con-1', name: 'Apex Painting & Decor', trade: 'Paint', rating: 4.8, phone: '(555) 123-4567', status: 'active', assignments: 2 },
            { id: 'con-2', name: 'GreenScapes Landscaping', trade: 'Landscaping', rating: 4.6, phone: '(555) 234-5678', status: 'active', assignments: 1 },
            { id: 'con-3', name: 'FloorCraft Flooring Co', trade: 'Flooring', rating: 4.9, phone: '(555) 345-6789', status: 'active', assignments: 3 },
            { id: 'con-4', name: 'Elite Kitchens & Bath', trade: 'Kitchen', rating: 5.0, phone: '(555) 456-7890', status: 'busy', assignments: 1 },
            { id: 'con-5', name: 'Precision Plumbers LLC', trade: 'Bathroom', rating: 4.7, phone: '(555) 567-8901', status: 'active', assignments: 1 }
        ];
        saveContractorsToStorage();
    }

    // Load Email Settings & Logs
    const savedEmailSettings = localStorage.getItem('revitalize_email_settings');
    if (savedEmailSettings) emailSettings = JSON.parse(savedEmailSettings);
    
    const savedEmailLogs = localStorage.getItem('revitalize_email_logs');
    if (savedEmailLogs) {
        emailLogs = JSON.parse(savedEmailLogs);
    } else {
        emailLogs = [
            { id: 'log-default-1', time: '2026-07-11 11:20 AM', recipient: 'tshelby@shelbyco.com', type: 'Intake Alert', subject: 'Revitalize Value Assessment - 104 Garrison Lane', body: 'We have received your valuation inquiry for 104 Garrison Lane...' }
        ];
        localStorage.setItem('revitalize_email_logs', JSON.stringify(emailLogs));
    }

    // Setup toggles in UI
    document.getElementById('chk-auto-intake').checked = emailSettings.autoIntake;
    document.getElementById('chk-auto-rehab').checked = emailSettings.autoRehab;
    document.getElementById('chk-auto-contract').checked = emailSettings.autoContract;

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
});

// Save hooks
function saveLeadsToStorage() { localStorage.setItem('revitalize_leads', JSON.stringify(leads)); }
function saveContractorsToStorage() { localStorage.setItem('revitalize_contractors', JSON.stringify(contractors)); }
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
    } else {
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
        completedSubtasks: []
    };

    leads.push(newLead);
    saveLeadsToStorage();

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
    const estPayout = lead.targetARV - totalDiscountedRehab - commVal;

    document.getElementById('client-stat-arv').innerText = `$${lead.targetARV.toLocaleString()}`;
    document.getElementById('client-stat-rehab').innerText = `$${totalDiscountedRehab.toLocaleString()}`;
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
        notes: 'Discovered through custom radius map address search.',
        coords: { x: randomX, y: randomY },
        hotLevel: 'warm'
    };

    prospects.push(newProspect);
    input.value = '';

    renderMockMap();
    renderProspectsList();
    showToast(`Custom pin dropped on Map for: ${address}`);

    setTimeout(() => {
        const pin = document.querySelector(`.map-marker[style*="left: ${randomX}%"][style*="top: ${randomY}%"]`);
        if (pin) pin.click();
    }, 400);
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
        <p>Est. ARV: $${prop.targetARV.toLocaleString()}<br>Owner: ${prop.owner}</p>
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

        item.innerHTML = `
            <div class="prospect-info">
                <h4>${prop.address}</h4>
                <p>Owner: ${prop.owner} • As-Is: $${prop.asIsValue.toLocaleString()} • Goal: $${prop.targetARV.toLocaleString()}</p>
            </div>
            ${btnHtml}
        `;
        listContainer.appendChild(item);
    });
    lucide.createIcons();
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
    const estPayout = lead.targetARV - totalRehab - commissionVal;

    if (type === 'Intake Confirmation') {
        subject = `Revitalize Project Evaluation: ${lead.address}`;
        body = `Hello ${lead.name},\n\nWe have received your request to list your property at ${lead.address} under our Fix-and-List program. Based on your inputs, we estimate an After-Repair Value (ARV) of $${lead.targetARV.toLocaleString()} following renovations. Our pre-approved discounted rehab budget is $${totalRehab.toLocaleString()}. At closing, we estimate your Net Payout will be $${Math.round(estPayout).toLocaleString()}. An agent will contact you shortly to schedule a walkthrough.`;
    } else if (type === 'Agreement Delivery') {
        subject = `Listing and Rehabilitation Proposal: ${lead.address}`;
        body = `Hello ${lead.name},\n\nWe have compiled your digital exclusive listing agreement for ${lead.address}. The renovation capital allocation has been finalized at $${totalRehab.toLocaleString()} with an estimated commission listing rate of ${lead.commissionRate || 6}%. You can review, print, or execute the agreement from your client portal.`;
    } else if (type === 'Rehab Started') {
        subject = `Renovation Commenced at ${lead.address}`;
        body = `Hello ${lead.name},\n\nGreat news! We have officially dispatched vetted contractors to begin the renovations at ${lead.address}. Subcontractors will begin working on the selected scope of work including: ${lead.scope.join(', ')}. We will email you milestones as they are completed.`;
    } else if (type === 'Flyer Delivery') {
        subject = `Equity Lift Assessment Report: ${lead.address}`;
        body = `Hello ${lead.name},\n\nAttached is your custom Equity Lift presentation flyer comparing an As-Is MLS sale vs. our interest-free Fix-and-List program. Renovation upgrades have been designed to capture an estimated $${(lead.targetARV - lead.asIsValue).toLocaleString()} in gross equity lift.`;
    } else if (type === 'Milestone Completed') {
        subject = `Rehab Progress Update: ${lead.address}`;
        body = `Hello ${lead.name},\n\nWe are pleased to report that the construction phase [${extraDetail}] has been successfully completed and inspected at your property ${lead.address}. We remain on track with schedule and budget parameters.`;
    } else if (type === 'Contract Signed Notification') {
        subject = `Agreement Executed: ${lead.address}`;
        body = `Hello ${lead.name},\n\nThank you! Your Exclusive Listing and Rehabilitation Agreement has been successfully digitally signed and locked. The security seal SHA-256 certificate has been logged, and construction scheduling is now underway.`;
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
    
    showToast(`Email alert sent to ${lead.email}`);
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
            activeRenovationCapital += leadRehabCost;
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

    const commissionVal = arv * (commPct / 100);
    const ownerFinalPayout = arv - totalDiscounted - commissionVal;

    const standardAsIsCommission = asIs * 0.06;
    const ownerAsIsPayout = asIs - standardAsIsCommission;

    const profitLift = ownerFinalPayout - ownerAsIsPayout;

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

    const contractHtml = `
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
    const selectedCompsList = (lead.selectedComps || []).map(id => MOCK_COMPS.find(c => c.id === id)).filter(Boolean);

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
                            <td>Renovation Cost</td>
                            <td>$0 (None)</td>
                            <td>-$${totalDiscountedRehab.toLocaleString()}</td>
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
                <li><strong>No Out-of-Pocket Expense:</strong> We advance 100% of the renovation capital interest-free.</li>
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
    const ownerFinalPayout = lead.targetARV - totalDiscountedRehab - commissionVal;
    const profitLift = ownerFinalPayout - ownerAsIsPayout;

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

    MOCK_COMPS.forEach(comp => {
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
    MOCK_COMPS.forEach(comp => {
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

    const commissionVal = arv * (commRate / 100);
    const escrowFees = arv * 0.015; // 1.5% Escrow
    const netProceeds = arv - rehabDiscounted - commissionVal - escrowFees;

    const standardAsIsCommission = asIs * 0.06;
    const standardAsIsEscrow = asIs * 0.015;
    const netAsIsProceeds = asIs - standardAsIsCommission - standardAsIsEscrow;

    const equityLift = netProceeds - netAsIsProceeds;

    const html = `
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
                    <td>201. Advanced Renovation Cost Reimbursement</td>
                    <td class="debit">$${rehabDiscounted.toLocaleString()}</td>
                    <td></td>
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

    const commissionVal = arv * (commRate / 100);
    const escrowFees = arv * 0.015;
    const netProceeds = arv - rehabDiscounted - commissionVal - escrowFees;

    const standardAsIsCommission = asIs * 0.06;
    const standardAsIsEscrow = asIs * 0.015;
    const netAsIsProceeds = asIs - standardAsIsCommission - standardAsIsEscrow;

    const equityLift = netProceeds - netAsIsProceeds;

    const html = `
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
                    <td>Rehab Capital Advanced</td>
                    <td style="text-align:right; color:var(--danger);">$${rehabDiscounted.toLocaleString()}</td>
                    <td></td>
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
                    <td>Your Est Net Payout</td>
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

    // Filter properties in 'listed' stage
    const listedLeads = leads.filter(l => l.stage === 'listed');

    if (listedLeads.length === 0) {
        grid.innerHTML = `
            <div style="grid-column: span 3; text-align:center; padding:3rem; color:var(--text-muted);">
                <i data-lucide="info" style="width:48px; height:48px; margin-bottom:1rem; opacity:0.5;"></i>
                <p style="font-size:1.1rem; font-weight:600; color:white;">No properties currently active on the market.</p>
                <p style="font-size:0.85rem; margin-top:0.25rem;">Move a lead to the 'Listed on MLS' stage inside the Agent Dashboard to display it here.</p>
            </div>
        `;
        lucide.createIcons();
        return;
    }

    listedLeads.forEach(lead => {
        let totalDiscountedRehab = 0;
        lead.scope.forEach(itemId => {
            const item = REHAB_ITEMS.find(i => i.id === itemId);
            if (item) totalDiscountedRehab += item.discounted;
        });

        // Highlight items
        const highlightsHtml = lead.scope.slice(0, 3).map(itemId => {
            const item = REHAB_ITEMS.find(i => i.id === itemId);
            return item ? `<span class="badge" style="background:rgba(99,102,241,0.1); color:#a5b4fc; border:1px solid rgba(99,102,241,0.2); font-size:0.7rem; padding:0.15rem 0.5rem; border-radius:10px;">${item.name}</span>` : '';
        }).join(' ');

        const card = document.createElement('div');
        card.className = 'glass-card lead-card';
        card.style.cursor = 'default';
        card.style.display = 'flex';
        card.style.flexDirection = 'column';
        card.style.justifyContent = 'space-between';
        card.style.height = '100%';
        card.style.padding = '1.5rem';

        card.innerHTML = `
            <div>
                <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:0.75rem;">
                    <div style="font-size:0.75rem; text-transform:uppercase; letter-spacing:0.05em; color:var(--primary); font-weight:700;">Active Revitalized Listing</div>
                    <div style="font-size:1.25rem; font-weight:800; color:var(--success);">$${lead.targetARV.toLocaleString()}</div>
                </div>
                <h3 style="font-size:1.1rem; font-weight:800; color:white; margin-bottom:0.25rem;">${lead.address}</h3>
                <p style="font-size:0.8rem; color:var(--text-muted); margin-bottom:1rem;">Fully renovated, turn-key residence.</p>
                
                <div style="display:flex; gap:1.25rem; font-size:0.85rem; color:white; border-top:1px solid rgba(255,255,255,0.05); border-bottom:1px solid rgba(255,255,255,0.05); padding:0.6rem 0; margin-bottom:1.25rem;">
                    <div><span style="font-weight:700;">4</span> Beds</div>
                    <div><span style="font-weight:700;">3</span> Baths</div>
                    <div><span style="font-weight:700;">2,250</span> Sq Ft</div>
                </div>

                <div style="margin-bottom:1.5rem;">
                    <div style="font-size:0.75rem; color:var(--text-muted); font-weight:700; text-transform:uppercase; margin-bottom:0.5rem;">Upgraded Scopes Included:</div>
                    <div style="display:flex; flex-wrap:wrap; gap:0.4rem;">
                        ${highlightsHtml || '<span style="font-size:0.75rem; color:var(--text-muted);">Standard full prep upgrades</span>'}
                    </div>
                </div>
            </div>

            <div style="display:flex; gap:0.75rem; border-top:1px solid rgba(255,255,255,0.05); padding-top:1.25rem;">
                <button class="btn-secondary" style="flex:1; padding:0.6rem; display:flex; justify-content:center; align-items:center; gap:4px;" onclick="openTourModal('${lead.id}', '${lead.address.replace(/'/g, "\\'")}')">
                    <i data-lucide="calendar" style="width:14px; height:14px;"></i> Tour
                </button>
                <button class="btn-primary" style="flex:1; padding:0.6rem; display:flex; justify-content:center; align-items:center; gap:4px;" onclick="openOfferModal('${lead.id}', '${lead.address.replace(/'/g, "\\'")}')">
                    <i data-lucide="banknote" style="width:14px; height:14px;"></i> Buy/Offer
                </button>
            </div>
        `;
        grid.appendChild(card);
    });

    lucide.createIcons();
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
        subject: "Is your property at {Address} still on the market? We fund repairs.",
        body: "Hi there,\n\nI noticed your listing at {Address} expired on the market. In today's market, 78% of active buyers pass on homes needing repairs or dated cosmetics (paint, floors, kitchens).\n\nRevitalize Realty advances 100% of these renovation costs upfront with zero out-of-pocket fees and zero interest, recovering the funds only when the home sells. We'll handle everything from planning to vetted contractor dispatches so you can sell for top dollar.\n\nBest regards,\nRevitalize Listing Team"
    },
    upgrade: {
        subject: "Get up to $50,000 more for your home at {Address} - zero out of pocket.",
        body: "Hi there,\n\nAre you planning to list your home but worried about the cost of making repairs? We specialize in preparing homes to capture maximum equity.\n\nWe advance all remodeling capital interest-free and manage the construction from start to finish. Let's unlock your true home valuation.\n\nBest regards,\nRevitalize Listing Team"
    },
    addition: {
        subject: "Adding square footage to {Address} to maximize your listing price.",
        body: "Hi there,\n\nDid you know adding a bathroom or extending your living area yields up to 150% ROI at closing? We provide interest-free advanced funding for additions and structural upgrades before listing your home.\n\nLet us design a custom plan to attract premium offers.\n\nBest regards,\nRevitalize Listing Team"
    }
};

function updateCampaignTemplatePreview() {
    const type = document.getElementById('campaign-template-select').value;
    const template = CAMPAIGN_TEMPLATES[type];
    
    // Choose active lead address or fallback placeholder
    const lead = leads.find(l => l.id === currentSelectedLeadId) || leads[0];
    const addr = lead ? lead.address : "123 Main St";

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
    showToast("Marketing drip campaign email dispatched successfully!");
    renderEmailLogs();
}
