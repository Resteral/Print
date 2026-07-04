// App Logic - The Capital Loop & Public Square & Developer Hub

document.addEventListener('DOMContentLoaded', () => {
  initTabs();
  initSVGInteractivity();
  initReflectionCalculator();
  
  // Phase 2: Public Square Initializers
  initSubTabs();
  initDebateArena();
  initDebateFeed();
  initLeaderboard();
  initNewsHub();

  // Phase 3: Developer Hub & Local Board Initializers
  initDeveloperHub();
  initLocalBoard();

  // Phase 5: P2P Mutual Credit Initializer
  initMutualCredit();

  // Phase 6: Financial Literacy Initializer
  initFinancialLiteracy();

  // Phase 7: President's Desk Initializer
  initPresidentDesk();

  // Phase 8: AI Chatbot Initializer
  initChatbot();

  // Phase 9: Debate Arena Enhancements
  renderDebateTopics();
  renderSuggestedTopics();
  initProposeTopicForm();

  // Phase 10 & 11: Gaming & Forum Initializers
  initGamingCorner();
  initForum();

  // Phase 15: Supabase Auth, Live Feed, and Submissions Arena Initializers
  initSupabaseAuth();
  initLiveFeed();
  initSubmissionsHub();
  initBillionaireLoopholeSimulator();
  initPredictionMarkets();
  initForumLobbyChat();

  // Phase 16: $CITZ Ecosystem — Dashboard, Store, Challenges, Quiz
  initCITZSystem();
  initCitizenDashboard();
  initCitizensStore();
  initDailyChallenges();
  initCivicQuiz();

  // Debate Tournaments
  initDebateTournaments();

  // Phase 17: Chair System, Crypto Wallet & Payments
  initChairSystem();
  initWeb3();
  checkStripeReturn();

  // Phase 18: Arena, Social, DevSpace, Stats, Omegle, Tug, Teams, Friends
  initDevSpace();
  initStatsLookup();
  initDebateOmegle();
  initTugLobbies();
  initTeamsHub();
  initFriendsHub();
});



/* ==========================================================================
   1. Main Tab Switcher
   ========================================================================== */
function initTabs() {
  const tabButtons = document.querySelectorAll('.tab-btn');
  const tabContents = document.querySelectorAll('.tab-content');

  tabButtons.forEach(btn => {
    btn.addEventListener('click', () => {
      const targetTab = btn.getAttribute('data-tab');

      // Update button active states
      tabButtons.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      // Update content visibility
      tabContents.forEach(content => {
        content.classList.remove('active');
        if (content.id === targetTab) {
          content.classList.add('active');
        }
      });
    });
  });
}

/* ==========================================================================
   2. SVG Interactive Diagram
   ========================================================================== */
const NODE_DATA = {
  capital: {
    title: 'Concentrated Capital',
    badge: 'Loop Origin & Destination',
    badgeClass: 'badge-capital',
    description: 'Corporate conglomerates, multi-national finance firms, and ultra-wealthy individuals who hold the vast majority of societal assets. Their main systemic goal is wealth preservation and compound accumulation.',
    filtered: 'The barrier of entry is sheer financial size. Without millions in surplus capital, regular citizens cannot participate in funding the political machinery that makes laws, meaning corporate goals dominate from day one.',
    quote: '“The preferences of the average American appear to have only a minuscule, near-zero, statistically non-significant impact on public policy.”',
    citation: 'Princeton University study by Gilens & Page',
    flowPaths: ['flow-capital-funding'],
    activeClass: 'active-capital'
  },
  funding: {
    title: 'Campaign Finance',
    badge: 'The Political Gatekeeper',
    badgeClass: 'badge-capital',
    description: 'The mechanism through which capital is injected into politics. Politicians require constant financial backing to win elections, transforming campaign contributions into a critical survival filter.',
    filtered: 'Voters can choose between candidates, but the donors decide WHO gets to run. Candidates who support public funding or threaten corporate profits are starved of funds and filtered out before ballots are cast.',
    quote: '“There are two things that are important in politics. The first is money, and I can\'t remember what the second one is.”',
    citation: 'Mark Hanna, US Senator & Campaign Manager (1895)',
    flowPaths: ['flow-funding-politicians'],
    activeClass: 'active-capital'
  },
  politicians: {
    title: 'Political Class',
    badge: 'Legislators & Executive Officers',
    badgeClass: 'badge-politicians',
    description: 'Elected officials, candidates, and their staffs. While theoretically accountable to the electorate, their reliance on funding and industry expertise binds their priorities to their donors.',
    filtered: 'Politicians spend up to 70% of their legislative time in "call time" fundraising from the ultra-rich. The time spent dialing wealthy donors is time stolen from listening to the grievances of ordinary working-class citizens.',
    quote: '“It is difficult to get a man to understand something, when his salary depends upon his not understanding it.”',
    citation: 'Upton Sinclair, Author',
    flowPaths: ['flow-politicians-policy'],
    activeClass: 'active-politicians'
  },
  policy: {
    title: 'Policy & Legislation',
    badge: 'Systemic Output',
    badgeClass: 'badge-politicians',
    description: 'The bills, laws, tax codes, and loopholes passed by the government. These policies shape the economy, dictating wages, market regulations, and the redistribution of wealth.',
    filtered: 'Corporate lobbyists frequently draft the actual text of complex tax codes and deregulation bills. Regular people have no seat at the drafting table, resulting in laws that shield wealth from taxation and crush competition.',
    quote: '“We have a system of legalized bribery... where the lobbyists write the laws and the politicians take the money.”',
    citation: 'Robert Reich, former US Secretary of Labor',
    flowPaths: ['flow-policy-regulatory'],
    activeClass: 'active-politicians'
  },
  regulatory: {
    title: 'Regulatory Capture',
    badge: 'The Enforcement Filter',
    badgeClass: 'badge-regulatory',
    description: 'The process where regulatory agencies (SEC, EPA, FDA, FCC) end up dominated or staffed by the very industries they are tasked with regulating, neutralizing public protections.',
    filtered: 'Regular citizens rely on agencies to protect their food, water, savings, and internet. Under regulatory capture, public complaints are ignored or classified as "unfeasible," while corporate violators receive wrist-slap fines.',
    quote: '“Regulatory capture occurs when an agency, created to act in the public interest, instead subverts that interest to satisfy the narrow commercial interests of the industry it is charged with regulating.”',
    citation: 'George Stigler, Nobel Laureate Economist',
    flowPaths: ['flow-regulatory-capital'],
    activeClass: 'active-regulatory'
  },
  public: {
    title: 'The Sidelined Public',
    badge: 'The Electorate',
    badgeClass: 'badge-public',
    description: 'The 90% of the population who rely on wages, public infrastructure, and consumer goods. They hold the voting power but lack the capital to direct the systemic loop.',
    filtered: 'Public opinion has a flat 30% likelihood of becoming law regardless of whether 0% or 100% of the population supports it. The system is statistically unresponsive to the democratic preferences of the working and middle class.',
    quote: '“The government is not responsiveness to the majority of its citizens. The average American is functionally powerless to influence public policy.”',
    citation: 'Gilens & Page Study Data Analysis',
    flowPaths: [],
    activeClass: 'active-public'
  }
};

function initSVGInteractivity() {
  const nodes = document.querySelectorAll('.diagram-node');
  const initialPanelState = document.querySelector('.detail-initial-state');
  const detailContent = document.getElementById('detail-content');
  const flowLines = document.querySelectorAll('.flow-line');

  // UI Detail Element Nodes
  const detailTitle = document.getElementById('detail-title');
  const detailBadge = document.getElementById('detail-badge');
  const detailDescription = document.getElementById('detail-description');
  const detailFiltered = document.getElementById('detail-filtered');
  const detailQuote = document.getElementById('detail-quote');
  const detailCitation = document.getElementById('detail-citation');

  nodes.forEach(node => {
    node.addEventListener('click', () => {
      const nodeId = node.getAttribute('data-node');
      const data = NODE_DATA[nodeId];

      if (!data) return;

      // 1. Reset all node active highlight classes
      nodes.forEach(n => {
        const id = n.getAttribute('data-node');
        const nodeClass = NODE_DATA[id].activeClass;
        n.classList.remove(nodeClass);
      });

      // 2. Add highlight class to clicked node
      node.classList.add(data.activeClass);

      // 3. Reset and toggle flow line animations
      flowLines.forEach(line => line.classList.add('hidden'));
      data.flowPaths.forEach(pathId => {
        const activePath = document.getElementById(pathId);
        if (activePath) {
          activePath.classList.remove('hidden');
        }
      });

      // 4. Update the Details Panel
      initialPanelState.classList.add('hidden');
      detailContent.classList.remove('hidden');

      detailTitle.textContent = data.title;
      detailBadge.textContent = data.badge;
      
      // Update badge styling
      detailBadge.className = 'node-badge'; // Reset classes
      detailBadge.classList.add(data.badgeClass);

      detailDescription.textContent = data.description;
      detailFiltered.textContent = data.filtered;
      detailQuote.textContent = data.quote;
      detailCitation.textContent = data.citation;
    });
  });
}

/* ==========================================================================
   3. Reflection Calculator Widget
   ========================================================================== */
function initReflectionCalculator() {
  const inputMoney = document.getElementById('input-money');
  const inputPeople = document.getElementById('input-people');
  const outputContainer = document.getElementById('reflection-result');

  if (!inputMoney || !inputPeople || !outputContainer) return;

  const calculateReflection = () => {
    const money = parseFloat(inputMoney.value) || 0;
    const people = parseFloat(inputPeople.value) || 0;

    let title = '';
    let badgeText = '';
    let badgeClass = '';
    let cardClass = '';
    let message = '';

    const formattedMoney = new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
      maximumFractionDigits: 0
    }).format(money);

    if (money > 10000000 && people <= 2) {
      title = 'Extreme Isolation / Spiritual Deficit';
      badgeText = 'Losing';
      badgeClass = 'badge-losing';
      cardClass = 'losing';
      message = `Hoarding ${formattedMoney} while helping only ${people} people is a form of spiritual sensory deprivation. Your life operates in a friction-free vacuum sustained by the labor of invisible workers (agricultural crews, manufacturers, services) whom you do not interact with. Every relationship around you is transactional; you do not hear raw human truths. The system tells you that you are winning because your number is growing, but humanly, you are trapped in a self-reinforcing loop of zero authentic value.`;
    } 
    else if (money > 1000000 && people <= 5) {
      title = 'The Transactional Bubble';
      badgeText = 'Losing';
      badgeClass = 'badge-losing';
      cardClass = 'losing';
      message = `At ${formattedMoney} in hoarded assets and only ${people} people positively impacted daily, you are drifting into the second layer of isolation. When your primary output is capital extraction rather than human relief, the people around you become accessories or costs. You are trading actual human happiness for abstract security. To begin winning, you must shift your day-to-day energy away from accumulation and toward generative service.`;
    } 
    else if (money > 5000000 && people > 15) {
      title = 'The Extractive Paradox';
      badgeText = 'Extractive Stasis';
      badgeClass = 'badge-losing';
      cardClass = 'losing';
      message = `Although you are helping ${people} people, hoarding ${formattedMoney} creates a structural paradox. The systemic loop of plutocracy shows that hoarded capital of this scale actively drives political lobbying and regulatory capture, suppressing the wages, rights, and choices of the working class. You are putting band-aids on individuals while your capital supports a system that breaks them. True winning means dissolving the hoard to dismantle the barriers that keep people down.`;
    } 
    else if (people > 0) {
      title = 'Generative Human Purpose';
      badgeText = 'Winning';
      badgeClass = 'badge-winning';
      cardClass = 'winning';
      message = `With a direct daily impact on ${people} people and a focused effort to better yourself, you are actively winning. You are bypassing the systemic lie that wealth equals human value. Every day you go out to improve your capabilities (strength, knowledge, empathy) so that you can lighten the burdens of others, you build genuine human communication. Making other people happy is the only currency that doesn't depreciate. Keep growing, keep serving.`;
    } 
    else {
      title = 'Passive Observer';
      badgeText = 'Idle';
      badgeClass = 'badge-public';
      cardClass = '';
      message = 'Adjust the sliders. Compare a life focused on compounding dollar-values against a life focused on compounding human happiness. The systemic loop depends on your belief that money is the ultimate goal. Reclaim your focus.';
    }

    outputContainer.className = `reflection-output ${cardClass}`;
    outputContainer.innerHTML = `
      <div class="reflection-header">
        <span class="reflection-title">${title}</span>
        <span class="reflection-badge ${badgeClass}">${badgeText}</span>
      </div>
      <p class="reflection-text">${message}</p>
    `;
  };

  inputMoney.addEventListener('input', calculateReflection);
  inputPeople.addEventListener('input', calculateReflection);

  calculateReflection();
}

/* ==========================================================================
   4. Public Square Subtab Controller
   ========================================================================== */
function initSubTabs() {
  const subNavs = document.querySelectorAll('.square-subnav');
  
  subNavs.forEach(nav => {
    const buttons = nav.querySelectorAll('.subtab-btn');
    buttons.forEach(btn => {
      btn.addEventListener('click', () => {
        const targetSubTab = btn.getAttribute('data-subtab');
        
        buttons.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        
        buttons.forEach(b => {
          const tabId = b.getAttribute('data-subtab');
          const content = document.getElementById(`subtab-${tabId}`);
          if (content) {
            content.classList.remove('active');
          }
        });
        
        const activeContent = document.getElementById(`subtab-${targetSubTab}`);
        if (activeContent) {
          activeContent.classList.add('active');
        }
      });
    });
  });
}

/* ==========================================================================
   5. Debate Arena (Omegle-like Matchmaker Simulator)
   ========================================================================== */
let localStream = null;
let matchTimerInterval = null;
let chatInterval = null;
let matchDurationSeconds = 180;
let userEloRating = 1200;

const OPPONENT_POOL = [
  { name: 'Liberty_Patriot', elo: 1315, stream: 'avatar-patriot' },
  { name: 'VoxPopuli_33', elo: 1195, stream: 'avatar-vox' },
  { name: 'Citizen_Socrates', elo: 1420, stream: 'avatar-socrates' },
  { name: 'NullHypothesis', elo: 1250, stream: 'avatar-null' },
  { name: 'Capitalist_Edge', elo: 1350, stream: 'avatar-edge' }
];

const AUDIENCE_COMMENTS = [
  "Wow, that is a strong point.",
  "Citizen_X is cooking right now.",
  "But wait, what about the lobbying stats?",
  "Let's look at the database citation.",
  "This is way better than corporate news.",
  "Opponent is shifting goalposts, call him out!",
  "Great rebuttal.",
  "This debate is intense.",
  "Public funding argument is solid.",
  "Elo checks out.",
  "Audience vote going crazy right now.",
  "Valid point on regulatory capture.",
  "I support Citizen_X's stance here.",
  "Both of them are bringing heat.",
  "Unfiltered truth right here."
];

function initDebateArena() {
  const btnMatch = document.getElementById('btn-match');
  const btnDisconnect = document.getElementById('btn-disconnect');
  const matchStatusText = document.getElementById('match-status-text');
  const matchIndicator = document.getElementById('match-indicator');
  const arenaTimer = document.getElementById('arena-timer');
  const localVideo = document.getElementById('local-video');
  const localOverlay = document.getElementById('local-overlay');
  const remoteAvatar = document.getElementById('remote-avatar');
  const remoteName = document.getElementById('remote-name');
  const remotePlaceholderText = document.getElementById('remote-placeholder-text');
  const agreementBar = document.getElementById('agreement-bar');
  const labelUser = document.getElementById('label-user');
  const labelPartner = document.getElementById('label-partner');
  const voteCount = document.getElementById('vote-count');
  const chatBox = document.getElementById('audience-chat-box');

  const btnRandom = document.getElementById('btn-random-topic');
  const btnSwap = document.getElementById('btn-swap-topic');
  const btnArgue = document.getElementById('btn-debate-argue');
  const btnRebut = document.getElementById('btn-debate-rebut');
  const btnTipRemote = document.getElementById('btn-tip-remote');
  const localTipsCounter = document.getElementById('local-tips-counter');
  let userTipsEarned = 0;

  if (!btnMatch || !btnDisconnect) return;

  const startCamera = async () => {
    try {
      localStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: false });
      localVideo.srcObject = localStream;
      localOverlay.style.opacity = '0';
      setTimeout(() => localOverlay.classList.add('hidden'), 300);
    } catch (err) {
      console.warn("Webcam access denied or unavailable. Using placeholder.", err);
      const overlaySpan = localOverlay.querySelector('span');
      if (overlaySpan) {
        overlaySpan.textContent = 'Webcam Blocked (Active Avatar)';
      }
      const overlayIcon = localOverlay.querySelector('.overlay-icon');
      if (overlayIcon) {
        overlayIcon.classList.add('animated-pulse');
        overlayIcon.textContent = '🎙️';
      }
      localOverlay.style.background = 'linear-gradient(135deg, #1e3a8a 0%, #0d9488 100%)';
    }
  };

  const stopCamera = () => {
    if (localStream) {
      localStream.getTracks().forEach(track => track.stop());
      localStream = null;
    }
    localVideo.srcObject = null;
    localOverlay.classList.remove('hidden');
    localOverlay.style.opacity = '1';
  };

  const setMatchingState = (state) => {
    if (state === 'idle') {
      matchStatusText.textContent = 'Idle';
      matchIndicator.className = 'status-indicator';
      btnMatch.classList.remove('hidden');
      btnDisconnect.classList.add('hidden');
      if (btnArgue) btnArgue.classList.add('hidden');
      if (btnRebut) btnRebut.classList.add('hidden');
      if (btnTipRemote) btnTipRemote.classList.add('hidden');
      if (localTipsCounter) {
        localTipsCounter.style.display = 'none';
      }
      userTipsEarned = 0;
      remotePlaceholderText.textContent = 'Searching for debate partner...';
      remoteAvatar.classList.remove('hidden');
      remoteName.textContent = 'Partner';
      arenaTimer.textContent = '03:00';
      
      stopCamera();
      clearInterval(matchTimerInterval);
      clearInterval(chatInterval);
      
      agreementBar.style.width = '50%';
      labelUser.textContent = 'You: 50%';
      labelPartner.textContent = 'Partner: 50%';
    } 
    else if (state === 'searching') {
      matchStatusText.textContent = 'Searching...';
      matchIndicator.className = 'status-indicator searching';
      btnMatch.classList.add('hidden');
      btnDisconnect.classList.remove('hidden');
      if (btnArgue) btnArgue.classList.add('hidden');
      if (btnRebut) btnRebut.classList.add('hidden');
      if (btnTipRemote) btnTipRemote.classList.add('hidden');
      if (localTipsCounter) {
        localTipsCounter.style.display = 'none';
      }
      
      startCamera();

      setTimeout(() => {
        if (matchStatusText.textContent === 'Searching...') {
          connectMatch();
        }
      }, 2500);
    }
    else if (state === 'connected') {
      matchStatusText.textContent = 'Connected';
      matchIndicator.className = 'status-indicator connected';
      if (btnArgue) btnArgue.classList.remove('hidden');
      if (btnRebut) btnRebut.classList.remove('hidden');
      if (btnTipRemote) btnTipRemote.classList.remove('hidden');
      if (localTipsCounter) {
        localTipsCounter.style.display = 'block';
        localTipsCounter.textContent = 'Tips Earned: $0';
      }
    }
  };

  const connectMatch = () => {
    setMatchingState('connected');
    
    let opponent;
    if (TOURNAMENT_STATE && TOURNAMENT_STATE.status === 'active' && TOURNAMENT_STATE.userPlayingTournamentMatch) {
      const currentRound = TOURNAMENT_STATE.rounds[TOURNAMENT_STATE.currentRoundIdx];
      const nextMatchIdx = getNextMatchIndex();
      if (nextMatchIdx !== -1) {
        const match = currentRound.find(m => m.id === nextMatchIdx);
        opponent = match.p1.isUser ? match.p2 : match.p1;
      }
    }
    if (!opponent) {
      opponent = OPPONENT_POOL[Math.floor(Math.random() * OPPONENT_POOL.length)];
    }
    
    remoteName.textContent = `${opponent.name} (Elo: ${opponent.elo})`;
    remoteAvatar.classList.add('hidden');

    const remotePanel = document.getElementById('panel-remote');
    const existingOpponentVideo = document.getElementById('simulated-remote-video');
    if (existingOpponentVideo) existingOpponentVideo.remove();

    const simVideo = document.createElement('div');
    simVideo.id = 'simulated-remote-video';
    simVideo.style.cssText = 'width:100%;height:100%;background:linear-gradient(135deg, #111827 0%, #1e293b 100%);display:flex;align-items:center;justify-content:center;z-index:1;font-size:4rem;';
    simVideo.textContent = '👤';
    remotePanel.appendChild(simVideo);

    let secondsLeft = matchDurationSeconds;
    arenaTimer.textContent = formatTime(secondsLeft);
    
    matchTimerInterval = setInterval(() => {
      secondsLeft--;
      arenaTimer.textContent = formatTime(secondsLeft);
      
      if (secondsLeft <= 0) {
        endMatch(true);
      }
    }, 1000);

    const activeTopicSelect = document.getElementById('arena-topic');
    const activeTopicText = activeTopicSelect && activeTopicSelect.selectedIndex >= 0 ? activeTopicSelect.options[activeTopicSelect.selectedIndex].text : "General Debate";

    chatBox.innerHTML = `<div class="chat-system-message">Audience joined. Live stream connected.</div><div class="chat-system-message" style="color:var(--color-blue); font-weight:bold;">Debate Topic: "${activeTopicText}"</div>`;
    let currentVotes = 120;
    voteCount.textContent = currentVotes;

    chatInterval = setInterval(() => {
      const user = `DebateWatcher_${Math.floor(Math.random() * 900) + 100}`;
      const text = AUDIENCE_COMMENTS[Math.floor(Math.random() * AUDIENCE_COMMENTS.length)];
      
      const commentDiv = document.createElement('div');
      commentDiv.className = 'chat-message';
      commentDiv.innerHTML = `<span class="chat-user">${user}:</span> <span class="chat-text">${text}</span>`;
      chatBox.appendChild(commentDiv);
      chatBox.scrollTop = chatBox.scrollHeight;

      const variance = (Math.random() * 8) - 4;
      let userPercent = Math.max(15, Math.min(85, parseInt(agreementBar.style.width) + variance));
      let partnerPercent = 100 - userPercent;
      
      agreementBar.style.width = `${userPercent}%`;
      labelUser.textContent = `You: ${Math.round(userPercent)}%`;
      labelPartner.textContent = `Partner: ${Math.round(partnerPercent)}%`;

      currentVotes += Math.floor(Math.random() * 6);
      voteCount.textContent = currentVotes;
    }, 2000);
  };

  const endMatch = (normalExit) => {
    const simVideo = document.getElementById('simulated-remote-video');
    if (simVideo) simVideo.remove();

    const userPercent = parseInt(agreementBar.style.width);
    const userWin = userPercent > 50;

    if (normalExit) {
      const eloDiff = userWin ? 16 : -12;
      userEloRating += eloDiff;
      
      updateLeaderboardSelf(userEloRating);

      alert(`Match ended! You secured ${userPercent}% agreement. Elo change: ${eloDiff > 0 ? '+' : ''}${eloDiff} (${userEloRating} Elo)`);
    }

    // Unlock topic select
    const topicSelect = document.getElementById('arena-topic');
    if (topicSelect) {
      topicSelect.disabled = false;
      const tempOpt = topicSelect.querySelector('option[value="tournament-temp"]');
      if (tempOpt) tempOpt.remove();
    }

    // Check if tournament match
    if (TOURNAMENT_STATE && TOURNAMENT_STATE.status === 'active' && TOURNAMENT_STATE.userPlayingTournamentMatch) {
      TOURNAMENT_STATE.userPlayingTournamentMatch = false;
      
      const currentRound = TOURNAMENT_STATE.rounds[TOURNAMENT_STATE.currentRoundIdx];
      const nextMatchIdx = getNextMatchIndex();
      if (nextMatchIdx !== -1) {
        const match = currentRound.find(m => m.id === nextMatchIdx);
        
        let p1Score, p2Score;
        if (match.p1.isUser) {
          p1Score = userPercent;
          p2Score = 100 - userPercent;
          match.winner = userWin ? match.p1 : match.p2;
        } else {
          p2Score = userPercent;
          p1Score = 100 - userPercent;
          match.winner = userWin ? match.p2 : match.p1;
        }

        match.p1Score = p1Score;
        match.p2Score = p2Score;
        match.played = true;

        saveTournamentState();

        if (!userWin) {
          alert(`❌ Eliminated! You lost your match in the tournament against ${match.p1.isUser ? match.p2.name : match.p1.name} (${userPercent}% to ${100 - userPercent}%). Better luck next time!`);
        } else {
          alert(`🎉 Victory! You won your match in the tournament against ${match.p1.isUser ? match.p2.name : match.p1.name} (${userPercent}% to ${100 - userPercent}%). You advance to the next round!`);
        }

        setTimeout(() => {
          const publicSquareTabBtn = document.getElementById('tab-public-square');
          if (publicSquareTabBtn) publicSquareTabBtn.click();
          const tourneyBtn = document.querySelector('[data-subtab="tournaments"]');
          if (tourneyBtn) tourneyBtn.click();
          renderTournamentUI();
        }, 1000);
      }
    }

    setMatchingState('idle');
  };

  const formatTime = (totalSeconds) => {
    const mins = Math.floor(totalSeconds / 60);
    const secs = totalSeconds % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  btnMatch.addEventListener('click', () => setMatchingState('searching'));
  btnDisconnect.addEventListener('click', () => endMatch(false));

  const DEBATE_ARGUMENTS = {
    lobbying: [
      "We must restrict donor groups; corporate cash has completely drowned out citizen voices.",
      "Lobbyists write 90% of regulatory tax exemptions before Congress even debates them.",
      "If money equals speech under law, then democracy is just a commercial auction."
    ],
    wealth: [
      "Compounding returns on assets are mathematically outpacing labor wages globally.",
      "No single person needs billions while millions lack basic housing and healthcare.",
      "A wealth cap returns hoarded capital back to active circulation."
    ],
    united: [
      "Super PACs hide the true identity of corporate election buying campaigns.",
      "Restoring election limits is the only way to establish equal citizen protection.",
      "Corporations are legal constructs, not actual human voters."
    ],
    default: [
      "We need structural reform, not incremental policy adjustments.",
      "Local P2P mutual aid and co-ops bypass banking extractions completely.",
      "True value lies in generative human service, not compounding ledgers."
    ]
  };

  const speakArgument = (type) => {
    if (matchStatusText.textContent !== 'Connected') return;

    const topicSelect = document.getElementById('arena-topic');
    const topicVal = topicSelect ? topicSelect.value : 'default';
    
    let key = 'default';
    if (topicVal.includes('lobby') || topicVal.includes('president')) key = 'lobbying';
    else if (topicVal.includes('wealth') || topicVal.includes('piketty')) key = 'wealth';
    else if (topicVal.includes('united') || topicVal.includes('citizens')) key = 'united';

    const pool = DEBATE_ARGUMENTS[key] || DEBATE_ARGUMENTS.default;
    const randomQuote = pool[Math.floor(Math.random() * pool.length)];

    // Append user bubble to chat stream
    const commentDiv = document.createElement('div');
    commentDiv.className = 'chat-message';
    commentDiv.style.fontWeight = 'bold';
    commentDiv.innerHTML = `<span class="chat-user" style="color:var(--color-blue);">Citizen_X (You):</span> <span class="chat-text" style="color:var(--color-text);">${type === 'argue' ? '🎤 ' : '👂 '}${randomQuote}</span>`;
    chatBox.appendChild(commentDiv);
    chatBox.scrollTop = chatBox.scrollHeight;

    // Shift audience poll in user's favor
    const boost = Math.floor(Math.random() * 5) + 5; // +5% to +9% boost
    let userPercent = Math.max(15, Math.min(85, parseInt(agreementBar.style.width) + boost));
    let partnerPercent = 100 - userPercent;

    agreementBar.style.width = `${userPercent}%`;
    labelUser.textContent = `You: ${Math.round(userPercent)}%`;
    labelPartner.textContent = `Partner: ${Math.round(partnerPercent)}%`;

    // Disable button briefly to prevent spamming
    const btn = type === 'argue' ? btnArgue : btnRebut;
    if (btn) {
      btn.disabled = true;
      btn.style.opacity = '0.5';
      setTimeout(() => {
        btn.disabled = false;
        btn.style.opacity = '1';
      }, 2000);
    }

    // 25% chance of receiving a tip from the audience watcher
    if (Math.random() < 0.25) {
      const tipAmount = [5, 10, 20, 50][Math.floor(Math.random() * 4)];
      userTipsEarned += tipAmount;
      if (localTipsCounter) {
        localTipsCounter.textContent = `Tips Earned: $${userTipsEarned}`;
      }
      
      const viewer = `DebateWatcher_${Math.floor(Math.random() * 900) + 100}`;
      const tipDiv = document.createElement('div');
      tipDiv.className = 'chat-message';
      tipDiv.style.cssText = 'color:var(--color-gold); font-weight:bold;';
      tipDiv.innerHTML = `🎉 ${viewer} tipped you $${tipAmount} for a great point!`;
      chatBox.appendChild(tipDiv);
      chatBox.scrollTop = chatBox.scrollHeight;
    }
  };

  if (btnArgue) btnArgue.addEventListener('click', () => speakArgument('argue'));
  if (btnRebut) btnRebut.addEventListener('click', () => speakArgument('rebut'));

  if (btnRandom) {
    btnRandom.addEventListener('click', () => {
      const allTopics = [];
      for (const genre in DEFAULT_DEBATE_TOPICS) {
        DEFAULT_DEBATE_TOPICS[genre].forEach(topic => {
          allTopics.push(topic.value);
        });
      }
      if (allTopics.length > 0) {
        const select = document.getElementById('arena-topic');
        select.value = allTopics[Math.floor(Math.random() * allTopics.length)];
      }
    });
  }

  if (btnSwap) {
    btnSwap.addEventListener('click', () => {
      const select = document.getElementById('arena-topic');
      if (!select) return;
      const currentVal = select.value;
      const allTopics = [];
      for (const genre in DEFAULT_DEBATE_TOPICS) {
        DEFAULT_DEBATE_TOPICS[genre].forEach(topic => {
          if (topic.value !== currentVal) {
            allTopics.push(topic);
          }
        });
      }
      if (allTopics.length > 0) {
        const randomTopic = allTopics[Math.floor(Math.random() * allTopics.length)];
        select.value = randomTopic.value;
        
        if (chatBox && matchStatusText.textContent === 'Connected') {
          const msg = document.createElement('div');
          msg.className = 'chat-message chat-system-message';
          msg.style.cssText = 'color:var(--color-gold); font-weight:bold;';
          msg.innerHTML = `🔄 Question Swapped: "${randomTopic.text}"`;
          chatBox.appendChild(msg);
          chatBox.scrollTop = chatBox.scrollHeight;
        }
      }
    });
  }

  // Tipping opponent click event
  if (btnTipRemote) {
    btnTipRemote.addEventListener('click', () => {
      if (matchStatusText.textContent !== 'Connected') return;
      const opponentName = remoteName.textContent;
      const amtStr = prompt(`How much would you like to tip ${opponentName}?`, "5");
      const amt = parseInt(amtStr);
      
      if (amt > 0) {
        alert(`Tipped $${amt} successfully to ${opponentName}! Transferred via peer-to-peer network ledger.`);
        
        const tipMsg = document.createElement('div');
        tipMsg.className = 'chat-message';
        tipMsg.style.cssText = 'color:var(--color-green); font-weight:bold;';
        tipMsg.innerHTML = `💸 Citizen_X (You) tipped $${amt} to ${opponentName}!`;
        chatBox.appendChild(tipMsg);
        chatBox.scrollTop = chatBox.scrollHeight;
      }
    });
  }
}

/* ==========================================================================
   6. Social Debate Feed Logic
   ========================================================================== */
let DEBATE_POSTS = [
  {
    id: 1,
    author: 'Socrates_99',
    tag: 'Wealth Gap',
    time: '2 hours ago',
    body: 'The super-wealthy live in a complete sensory deprivation chamber. When you own private estates, private travel, and hire intermediaries for everything, you forget the basic physical struggles of survival. Their laws reflect this absolute isolation. They write laws to crush unions because labor is just an abstract number on their balance sheet.',
    agrees: 142,
    disagrees: 12
  },
  {
    id: 2,
    author: 'Publius_Secundus',
    tag: 'Campaign Finance',
    time: '4 hours ago',
    body: 'We talk about free speech, but Citizens United converted free speech into financial bidding. If money equals speech, then the billionaire speaks a billion times louder than the teacher or nurse. How is that democracy? It is a systemic auction where policies go to the highest bidder.',
    agrees: 98,
    disagrees: 5
  },
  {
    id: 3,
    author: 'Antigravity_Thinker',
    tag: 'Lobbying',
    time: '1 day ago',
    body: 'ALEC and other corporate lobby networks are rewriting our state policies. They hand pre-written legislation to lawmakers who act as little more than human copy machines. If we want systemic reform, we must enact a minimum 5-year ban before a lawmaker can transition into lobbying.',
    agrees: 230,
    disagrees: 18
  }
];

function initDebateFeed() {
  const form = document.getElementById('debate-post-form');
  const feedContainer = document.getElementById('feed-container');

  if (!feedContainer) return;

  const renderFeed = () => {
    feedContainer.innerHTML = '';
    DEBATE_POSTS.forEach(post => {
      const card = document.createElement('div');
      card.className = 'card feed-post';
      card.innerHTML = `
        <div class="post-header">
          <div class="post-meta">
            <span class="post-author">@${post.author}</span>
            <span class="post-tag">${post.tag}</span>
          </div>
          <span class="post-time">${post.time}</span>
        </div>
        <div class="post-body">
          <p>${post.body}</p>
        </div>
        <div class="post-actions">
          <button class="action-btn agree" onclick="votePost(${post.id}, 'agree')">
            👍 Agree (<span id="agree-count-${post.id}">${post.agrees}</span>)
          </button>
          <button class="action-btn disagree" onclick="votePost(${post.id}, 'disagree')">
            👎 Disagree (<span id="disagree-count-${post.id}">${post.disagrees}</span>)
          </button>
        </div>
      `;
      feedContainer.appendChild(card);
    });
  };

  if (form) {
    form.addEventListener('submit', (e) => {
      e.preventDefault();
      const username = document.getElementById('post-username').value;
      const topic = document.getElementById('post-topic').value;
      const text = document.getElementById('post-text').value;

      const newPost = {
        id: DEBATE_POSTS.length + 1,
        author: username.replace('@', ''),
        tag: topic,
        time: 'Just now',
        body: text,
        agrees: 0,
        disagrees: 0
      };

      DEBATE_POSTS.unshift(newPost);
      renderFeed();
      form.reset();
      document.getElementById('post-username').value = username;
    });
  }

  window.votePost = (postId, type) => {
    const post = DEBATE_POSTS.find(p => p.id === postId);
    if (!post) return;

    if (type === 'agree') {
      post.agrees++;
      document.getElementById(`agree-count-${postId}`).textContent = post.agrees;
    } else {
      post.disagrees++;
      document.getElementById(`disagree-count-${postId}`).textContent = post.disagrees;
    }
  };

  renderFeed();
}

/* ==========================================================================
   7. Leaderboard Standings
   ========================================================================== */
let LEADERBOARD_USERS = [
  { rank: 1, name: 'Socrates_99', wins: 242, losses: 14, elo: 1680, status: 'online' },
  { rank: 2, name: 'CitizensUnited_Exposed', wins: 184, losses: 32, elo: 1540, status: 'online' },
  { rank: 3, name: 'Publius_Secundus', wins: 198, losses: 41, elo: 1490, status: 'offline' },
  { rank: 4, name: 'Antigravity_Thinker', wins: 142, losses: 28, elo: 1390, status: 'online' },
  { rank: 5, name: 'Your_Username (You)', wins: 0, losses: 0, elo: 1200, status: 'online', isSelf: true },
  { rank: 6, name: 'Capitalist_Edge', wins: 95, losses: 82, elo: 1150, status: 'online' },
  { rank: 7, name: 'NullHypothesis', wins: 62, losses: 65, elo: 1090, status: 'offline' }
];

function initLeaderboard() {
  renderLeaderboard();
}

function renderLeaderboard() {
  const tbody = document.getElementById('leaderboard-body');
  if (!tbody) return;

  tbody.innerHTML = '';
  
  LEADERBOARD_USERS.sort((a, b) => b.elo - a.elo);
  
  LEADERBOARD_USERS.forEach((user, index) => {
    user.rank = index + 1;
  });

  LEADERBOARD_USERS.forEach(user => {
    const tr = document.createElement('tr');
    if (user.isSelf) {
      tr.style.background = 'rgba(59, 130, 246, 0.08)';
      tr.style.fontWeight = 'bold';
    }

    let rankClass = 'rank-badge';
    if (user.rank === 1) rankClass += ' rank-1';
    else if (user.rank === 2) rankClass += ' rank-2';
    else if (user.rank === 3) rankClass += ' rank-3';

    tr.innerHTML = `
      <td><div class="${rankClass}">${user.rank}</div></td>
      <td>${user.name}</td>
      <td>${user.wins}W - ${user.losses}L</td>
      <td>${user.elo}</td>
      <td><span class="status-badge ${user.status === 'online' ? 'status-active' : 'status-offline'}">${user.status}</span></td>
    `;
    tbody.appendChild(tr);
  });
}

function updateLeaderboardSelf(newElo) {
  const selfUser = LEADERBOARD_USERS.find(u => u.isSelf);
  if (selfUser) {
    selfUser.elo = newElo;
    if (newElo > 1200) {
      selfUser.wins++;
    } else {
      selfUser.losses++;
    }
    renderLeaderboard();
  }
}

/* ==========================================================================
   8. Unfiltered News Feed Hub (Filterable News)
   ========================================================================== */
let NEWS_ARTICLES = [
  {
    category: 'latest',
    source: 'OpenSecrets.org Lobbying Database',
    date: 'June 29, 2026',
    title: 'US Lobbying Expenditures Reach Record $5.24 Billion in Surge of Corporate Spending',
    excerpt: 'Federal lobbying spending broke records in 2025, marking an unprecedented 17% year-over-year increase. Tech conglomerates (Meta, Coinbase) and pharmaceutical lobbies lead advocacy spending in preparation for the 2026 elections.'
  },
  {
    category: 'latest',
    source: 'Federal Election Commission (FEC) Filings',
    date: 'June 20, 2026',
    title: 'Dark Money Spending Outpaces Public Campaigns as 501(c)(4) Outlays Escalate',
    excerpt: 'Independent expenditures from groups that hide their primary funding sources have reached new peaks. Campaign ad tracking shows corporate-backed dark money groups dominant in local legislative districts.'
  },
  {
    category: 'latest',
    source: 'Securities and Exchange Commission Records',
    date: 'June 18, 2026',
    title: 'SEC Capture: Former Regulatory Chief Appointed to Lead Investment Bank Advisory',
    excerpt: 'Criticism rises as another key financial regulator transitions directly to a high-paying executive advisory role on Wall Street, exemplifying the revolving door loop.'
  },
  {
    category: 'global',
    source: 'World Inequality Report 2026',
    date: 'June 27, 2026',
    title: 'Global Wealth Concentration Hits Historic Highs: Top 10% Owns 75% of Total Personal Assets',
    excerpt: 'Transnational wealth auditing reports that the bottom 50% of the global population holds only 2% of personal net worth, while billionaire assets grew by 81% since 2020.'
  },
  {
    category: 'global',
    source: 'Oxfam International Report',
    date: 'June 25, 2026',
    title: 'The 12 Richest Billionaires Hold More Wealth Than Entire Bottom Half of Humanity Combined',
    excerpt: 'Oxfam\'s latest economic inequality report highlights that 12 individuals own more combined assets than the bottom 3.9 billion people, driving concerns over top-end tax tax loopholes.'
  },
  {
    category: 'global',
    source: 'Tax Justice Network Audit',
    date: 'June 22, 2026',
    title: 'Transnational Corporations Funnel $480 Billion Annually into Offshore Haven Networks',
    excerpt: 'Global tax avoidance tracking indicates multi-nationals continue to exploit shifting jurisdictions, bypassing national corporate tax codes to protect profits.'
  },
  {
    category: 'local',
    source: 'System Dispatch',
    date: 'June 30, 2026',
    title: 'Unlock Local Dispatches',
    excerpt: 'Bypass isolation. Use the Geolocation or ZIP lookup controls on the Local Board tab to sync your neighborhood cooperative news feed.'
  }
];

function initNewsHub() {
  const newsContainer = document.getElementById('news-container');
  const filterBtns = document.querySelectorAll('.news-filter-btn');
  if (!newsContainer) return;

  const renderNews = (filter) => {
    newsContainer.innerHTML = '';
    
    const filtered = NEWS_ARTICLES.filter(art => {
      if (filter === 'all') return true;
      return art.category === filter;
    });

    if (filtered.length === 0) {
      newsContainer.innerHTML = `
        <div class="empty-state-local" style="grid-column: 1 / -1; min-height: 150px;">
          No local dispatches found. Use the Geolocation or ZIP lookup controls on the Local Board tab to sync your neighborhood feed.
        </div>`;
      return;
    }

    filtered.forEach(art => {
      const card = document.createElement('div');
      card.className = 'card news-card';
      card.innerHTML = `
        <span class="news-source">${art.source}</span>
        <h3>${art.title}</h3>
        <p class="news-excerpt">${art.excerpt}</p>
        <div class="news-meta">
          <span>Unfiltered News Dispatch</span>
          <span>${art.date}</span>
        </div>
      `;
      newsContainer.appendChild(card);
    });
  };

  filterBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      filterBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      const filter = btn.getAttribute('data-filter');
      renderNews(filter);
    });
  });

  // Initial render
  renderNews('all');

  // Expose filter updates globally
  window.updateNewsFeedCategory = (filter) => {
    const activeBtn = document.querySelector(`.news-filter-btn[data-filter="${filter}"]`);
    if (activeBtn) {
      filterBtns.forEach(b => b.classList.remove('active'));
      activeBtn.classList.add('active');
    }
    renderNews(filter);
  };
}

/* ==========================================================================
   9. Developer Hub (Showcase & Thumbs Up)
   ========================================================================== */
let DEV_PROJECTS = [
  {
    id: 1,
    title: 'PAC-Tracker API',
    desc: 'An open-source Node/Express JSON API that aggregates Super PAC filings and updates corporate lobbying databases weekly. Fully documented endpoint outputs.',
    url: 'https://github.com/Resteral/Ol',
    tag: 'Transparency',
    upvotes: 84
  },
  {
    id: 2,
    title: 'CoopFinder Mobile',
    desc: 'A decentralized geolocation lookup tool listing verified worker-owned co-ops, mutual aid gardens, and community fridges across major US regions.',
    url: 'https://coopfinder.org',
    tag: 'Mutual Aid',
    upvotes: 62
  },
  {
    id: 3,
    title: 'MediaFilter Extension',
    desc: 'Chrome browser extension that tags articles from media conglomerates with their parent company assets and lobbying history directly in the search results.',
    url: 'https://mediafilter.net',
    tag: 'Alternative Media',
    upvotes: 49
  }
];

function initDeveloperHub() {
  const form = document.getElementById('dev-upload-form');
  const gallery = document.getElementById('dev-gallery');

  if (!gallery) return;

  const renderGallery = () => {
    gallery.innerHTML = '';
    
    // Sort projects by upvotes descending
    DEV_PROJECTS.sort((a, b) => b.upvotes - a.upvotes);

    DEV_PROJECTS.forEach(proj => {
      const card = document.createElement('div');
      card.className = 'card dev-card';
      card.innerHTML = `
        <div class="dev-card-header">
          <h4>${proj.title}</h4>
          <span class="post-tag">${proj.tag}</span>
        </div>
        <p class="dev-card-desc">${proj.desc}</p>
        <div class="dev-card-links">
          <a href="${proj.url}" target="_blank" class="dev-link">Open Project ↗</a>
        </div>
        <div class="dev-card-footer">
          <button class="upvote-btn" onclick="upvoteProject(${proj.id})">
            👍 Upvote (<span class="upvote-count" id="upvote-count-${proj.id}">${proj.upvotes}</span>)
          </button>
        </div>
      `;
      gallery.appendChild(card);
    });
  };

  if (form) {
    form.addEventListener('submit', (e) => {
      e.preventDefault();
      
      const title = document.getElementById('dev-title').value;
      const desc = document.getElementById('dev-desc').value;
      const url = document.getElementById('dev-url').value;
      const tag = document.getElementById('dev-tag').value;

      const newProject = {
        id: DEV_PROJECTS.length + 1,
        title: title,
        desc: desc,
        url: url,
        tag: tag,
        upvotes: 1
      };

      DEV_PROJECTS.unshift(newProject);
      renderGallery();
      form.reset();
    });
  }

  // Global callback for upvotes
  window.upvoteProject = (id) => {
    const proj = DEV_PROJECTS.find(p => p.id === id);
    if (proj) {
      proj.upvotes++;
      const countEl = document.getElementById(`upvote-count-${id}`);
      if (countEl) {
        countEl.textContent = proj.upvotes;
      }
      // Re-render gallery after slight delay to allow smooth resorting
      setTimeout(renderGallery, 400);
    }
  };

  window.renderDevGallery = renderGallery;
  renderGallery();
}

/* ==========================================================================
   10. Local Board Logic (Deals & Events with Geolocation)
   ========================================================================== */
const LOCALDATA_BY_REGION = {
  california: {
    name: 'Southern California Co-ops',
    coords: 'Lat: 34.0522, Lon: -118.2437',
    deals: [
      { shop: 'Los Angeles Food Co-op', title: '15% Off Organic Produce', desc: 'Present coupon at register. Worker-owned and sourced from regional family farms.', value: '15% OFF' },
      { shop: 'Silverlake Cooperative Books', title: 'Buy One Get One Free', desc: 'Valid on all economic history, labor studies, and political science books.', value: 'BOGO' },
      { shop: 'People’s Cafe Collective', title: 'Free Coffee with Reusable Cup', desc: 'Encouraging local ecology. 100% fair-trade beans sourced directly.', value: 'FREE COFFEE' }
    ],
    events: [
      { month: 'Jul', day: '12', title: 'LA Tenants Union Assembly', time: '6:30 PM', loc: 'Silverlake Community Hall', desc: 'Organizing tenant protection seminars and discussing local rent control proposals.', action: 'Join Meeting' },
      { month: 'Jul', day: '18', title: 'Echo Park Mutual Aid Food Drive', time: '9:00 AM', loc: 'Echo Park Methodist', desc: 'Volunteers needed to package surplus food deliveries for sidelined families.', action: 'Volunteer' }
    ],
    localNews: [
      { category: 'local', source: 'SoCal Cooperative Coalition', date: 'June 28, 2026', title: 'LA Food Co-op Expands Direct-From-Farmer Network to Bypass Corporate Logistics', excerpt: 'By sourcing directly from regional agricultural cooperatives, LA Co-op bypassed conglomerate logistics, saving members 15% and directly funding local farms.' },
      { category: 'local', source: 'LA Municipal Audit Office', date: 'June 24, 2026', title: 'Lobbying Disclosures Reveal Real Estate PAC Funding of Local Housing Officers', excerpt: 'Disclosures show corporate real estate developers funded campaign mailers for city housing officers, raising conflict of interest warnings.' }
    ]
  },
  newyork: {
    name: 'Metro New York Civic Board',
    coords: 'Lat: 40.7128, Lon: -74.0060',
    deals: [
      { shop: 'Brooklyn Independent Books', title: '10% Off Union Members', desc: 'Show your union card at check-out. Celebrating community organizing.', value: '10% OFF' },
      { shop: 'Manhattan Co-op Market', title: 'Free Member Trial Pass', desc: 'Access member-owner discounts on locally manufactured goods.', value: 'MEMBER PASS' },
      { shop: 'The Commons Cafe', title: 'Co-working Session Discount', desc: '50% off day pass. Independent community-owned co-working space.', value: '50% OFF' }
    ],
    events: [
      { month: 'Jul', day: '15', title: 'Rethinking Capital Loop Forum', time: '7:00 PM', loc: 'The Commons Brooklyn', desc: 'A town-hall discussion on Citizens United and public funding amendments.', action: 'RSVP' },
      { month: 'Jul', day: '22', title: 'Astoria Community Garden Soil Work', time: '10:00 AM', loc: 'Astoria Green Lot', desc: 'Bring gloves. Planting summer vegetables and repairing irrigation pipes.', action: 'Volunteer' }
    ],
    localNews: [
      { category: 'local', source: 'NYC Commons Gazette', date: 'June 27, 2026', title: 'Brooklyn Community Fridge Network Deploys 3 New Sites to Fight Wage Stagnation', excerpt: 'Organized entirely by volunteers, the new fridge locations provide free organic produce and food, bypassing retail price hikes.' },
      { category: 'local', source: 'New York City Lobby Registry', date: 'June 23, 2026', title: 'Tech Giants Spend $4.2 Million Lobbying City Council for Municipal Data Contracts', excerpt: 'Filings show lobbying outlays directed at the municipal technology committee, raising debate over open-source public alternatives.' }
    ]
  },
  general: {
    name: 'General US Cooperative Board',
    coords: 'Lat: 39.8283, Lon: -98.5795',
    deals: [
      { shop: 'Union Thread Co-op', title: 'Free Nationwide Shipping', desc: '100% union-made clothing. Enter code COOP-SHIP at check-out.', value: 'FREE SHIP' },
      { shop: 'National Farmers Assembly', title: '10% Off Direct Box Orders', desc: 'Sourced directly from agricultural cooperatives bypass corporate stores.', value: '10% OFF' }
    ],
    events: [
      { month: 'Aug', day: '05', title: 'National Virtual Debate Matchup', time: '4:00 PM EST', loc: 'Decentralized Arena', desc: 'Connecting debaters from all states to discuss campaign lobbying caps.', action: 'Register' }
    ],
    localNews: [
      { category: 'local', source: 'Cooperative Alliance USA', date: 'June 26, 2026', title: 'National Cooperative Registrations Surge 22% in Consumer Retail', excerpt: 'A nationwide study shows consumer co-ops are growing at record rates as citizens seek economic models that return wealth to the community.' },
      { category: 'local', source: 'Mutual Aid USA Directory', date: 'June 21, 2026', title: 'National Registry Maps 42 New Free Clinics and Mutual Aid Gardens', excerpt: 'The registry connects under-served communities with free medical, legal, and nutritional resources organized entirely by volunteers.' }
    ]
  }
};

/* ==========================================================================
   10b. Micro-Gigs & Mutual Aid Tasks database
   ========================================================================== */
let LOCAL_GIGS = [
  {
    id: 1,
    title: 'Audit Super PAC Disclosures',
    category: 'Digital',
    bounty: 120,
    desc: 'Verify 2026 Q1 FEC filings for real estate PACs operating in LA/NY. Put results into a CSV format.',
    status: 'Open',
    worker: null
  },
  {
    id: 2,
    title: 'Translate Co-op Bylaws to Spanish',
    category: 'Writing',
    bounty: 75,
    desc: 'Translate the standard worker-owned cooperative template (20 pages) for local Hispanic entrepreneurs.',
    status: 'Open',
    worker: null
  },
  {
    id: 3,
    title: 'Repair Echo Park Community Cooler',
    category: 'Labor',
    bounty: 50,
    desc: 'Replace the temperature regulator relay on the outdoor community fridge. Parts provided.',
    status: 'Claimed',
    worker: '@Citizen_Socrates'
  }
];

function initLocalBoard() {
  const btnGeo = document.getElementById('btn-geolocation');
  const btnZip = document.getElementById('btn-zip-submit');
  const inputZip = document.getElementById('input-zip');
  const statusBadge = document.getElementById('location-status-badge');
  const coordsLabel = document.getElementById('location-coords');
  const dealsList = document.getElementById('deals-list');
  const eventsList = document.getElementById('events-list');

  if (!btnGeo || !dealsList || !eventsList) return;

  const renderRegion = (regionKey) => {
    const data = LOCALDATA_BY_REGION[regionKey];
    if (!data) return;

    statusBadge.textContent = data.name;
    statusBadge.className = 'status-badge status-active node-badge';
    coordsLabel.textContent = data.coords;

    // Update Local News array in NEWS_ARTICLES
    const localArticles = data.localNews || [];
    NEWS_ARTICLES = NEWS_ARTICLES.filter(art => art.category !== 'local');
    NEWS_ARTICLES.push(...localArticles);
    if (window.updateNewsFeedCategory) {
      window.updateNewsFeedCategory('local');
    }

    // Render Deals
    dealsList.innerHTML = '';
    data.deals.forEach(deal => {
      const card = document.createElement('div');
      card.className = 'deal-card';
      card.innerHTML = `
        <div class="deal-left">
          <span class="deal-shop">${deal.shop}</span>
          <span class="deal-title">${deal.title}</span>
          <span class="deal-desc">${deal.desc}</span>
        </div>
        <div class="deal-right">
          <span class="deal-badge">${deal.value}</span>
          <button class="btn btn-secondary" onclick="alert('Deal Redeemed: Use code CITIZEN-COOP')">Redeem</button>
        </div>
      `;
      dealsList.appendChild(card);
    });

    // Render Events
    eventsList.innerHTML = '';
    data.events.forEach(evt => {
      const card = document.createElement('div');
      card.className = 'card event-card';
      card.innerHTML = `
        <div class="event-date-box">
          <span class="event-month">${evt.month}</span>
          <span class="event-day">${evt.day}</span>
        </div>
        <div class="event-details">
          <h4>${evt.title}</h4>
          <span class="event-time-loc">${evt.time} | ${evt.loc}</span>
          <p class="event-desc">${evt.desc}</p>
          <a href="#" class="event-action" onclick="alert('Registered successfully!')">${evt.action} ↗</a>
        </div>
      `;
      eventsList.appendChild(card);
    });
  };

  // Browser Geolocation
  btnGeo.addEventListener('click', () => {
    statusBadge.textContent = 'Locating...';
    coordsLabel.textContent = '';

    if (!navigator.geolocation) {
      alert("Geolocation is not supported by your browser.");
      renderRegion('general');
      return;
    }

    navigator.geolocation.getCurrentPosition(
      (position) => {
        const lat = position.coords.latitude;
        const lon = position.coords.longitude;
        
        // Map coordinates to region
        let matchedRegion = 'general';
        
        // Simple bounding box logic for simulation
        if (lat > 38 && lon < -70) {
          matchedRegion = 'newyork';
        } else if (lat < 36 && lon < -110) {
          matchedRegion = 'california';
        }
        
        renderRegion(matchedRegion);
      },
      (error) => {
        console.warn("Geolocation lookup failed, falling back to General.", error);
        alert("Could not retrieve location. Loading fallback General US Board.");
        renderRegion('general');
      }
    );
  });

  // ZIP Code Fallback
  if (btnZip && inputZip) {
    btnZip.addEventListener('click', () => {
      const zip = inputZip.value.trim();
      if (!/^\d{5}$/.test(zip)) {
        alert("Please enter a valid 5-digit ZIP code.");
        return;
      }

      let matchedRegion = 'general';
      if (zip.startsWith('9')) {
        matchedRegion = 'california';
      } else if (zip.startsWith('1') || zip.startsWith('0')) {
        matchedRegion = 'newyork';
      }

      renderRegion(matchedRegion);
    });
  }

  // Micro-Gigs Board Engine
  const gigsContainer = document.getElementById('local-gigs-list');
  const gigForm = document.getElementById('local-gig-form');

  const renderGigs = () => {
    if (!gigsContainer) return;
    gigsContainer.innerHTML = '';

    LOCAL_GIGS.forEach(gig => {
      const row = document.createElement('div');
      row.className = 'loan-card';
      row.style.background = 'rgba(255, 255, 255, 0.03)';
      row.style.border = '1px solid var(--color-border)';

      const left = document.createElement('div');
      left.className = 'loan-card-info';

      const title = document.createElement('span');
      title.className = 'reg-folder-title';
      title.textContent = gig.title;

      const catBadge = `<span class="post-tag" style="margin-left: 0.5rem; font-size:0.65rem; padding:0.1rem 0.4rem; vertical-align:middle; background:rgba(255,255,255,0.05); color:var(--color-text-muted);">${gig.category}</span>`;
      title.innerHTML += catBadge;

      const desc = document.createElement('span');
      desc.className = 'loan-details-meta';
      desc.style.display = 'block';
      desc.style.marginTop = '0.25rem';
      desc.textContent = gig.desc;

      const statusLine = document.createElement('span');
      statusLine.className = 'loan-details-meta';
      statusLine.style.fontSize = '0.75rem';
      statusLine.style.marginTop = '0.25rem';
      statusLine.style.display = 'block';
      
      if (gig.status === 'Open') {
        statusLine.style.color = 'var(--color-green)';
        statusLine.textContent = '🟢 Open for Claims';
      } else {
        statusLine.style.color = 'var(--color-text-muted)';
        statusLine.textContent = `🔒 Claimed by ${gig.worker}`;
      }

      left.appendChild(title);
      left.appendChild(desc);
      left.appendChild(statusLine);

      const right = document.createElement('div');
      right.className = 'loan-card-actions';

      const bountyAmt = document.createElement('span');
      bountyAmt.className = 'loan-amount';
      bountyAmt.textContent = `$${gig.bounty}`;

      const claimBtn = document.createElement('button');
      claimBtn.className = `btn ${gig.status === 'Open' ? 'btn-primary' : 'btn-secondary'}`;
      claimBtn.style.padding = '0.3rem 0.8rem';
      claimBtn.style.marginTop = '0.25rem';
      claimBtn.textContent = gig.status === 'Open' ? 'Claim Gig' : 'Claimed';
      claimBtn.disabled = gig.status !== 'Open';

      claimBtn.addEventListener('click', () => {
        gig.status = 'Claimed';
        gig.worker = '@Citizen_X (You)';
        alert(`Gig Claimed successfully! Submit deliverables to claiming@resolve.bet to receive your $${gig.bounty} payment.`);
        renderGigs();
      });

      right.appendChild(bountyAmt);
      right.appendChild(claimBtn);

      row.appendChild(left);
      row.appendChild(right);
      gigsContainer.appendChild(row);
    });
  };

  if (gigForm) {
    gigForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const title = document.getElementById('gig-title').value;
      const bounty = parseInt(document.getElementById('gig-bounty').value) || 10;
      const category = document.getElementById('gig-category').value;
      const desc = document.getElementById('gig-desc').value;

      LOCAL_GIGS.unshift({
        id: LOCAL_GIGS.length + 1,
        title: title,
        category: category,
        bounty: bounty,
        desc: desc,
        status: 'Open',
        worker: null
      });

      document.getElementById('gig-title').value = '';
      document.getElementById('gig-bounty').value = '';
      document.getElementById('gig-desc').value = '';

      renderGigs();
    });
  }

  // Draw gigs initially
  renderGigs();
}

/* ==========================================================================
   11. P2P Mutual Credit Loan System
   ========================================================================== */
let LOAN_REQUESTS = [
  { id: 1, borrower: '@Gardener_Dave', amount: 450, term: 6, interest: 2.0, purpose: 'Purchase heirloom tomato seeds and organic compost for local community garden.' },
  { id: 2, borrower: '@Coop_Bakery', amount: 1200, term: 12, interest: 3.5, purpose: 'Upgrade commercial convection oven motor to keep production active.' }
];

let LOAN_OFFERS = [
  { id: 1, lender: '@Eco_Investor', amount: 2000, term: 12, interest: 1.5, details: 'Surplus credit available specifically for local green initiatives.' },
  { id: 2, lender: '@Mutual_Alice', amount: 500, term: 6, interest: 0.0, details: 'Interest-free micro-lending to support single parents and co-op workers.' }
];

let USER_LEDGER = [
  { id: 1, type: 'Borrowed', partner: '@Mutual_Alice', principal: 300, remaining: 150, term: 6, interest: 0.0 }
];

function initMutualCredit() {
  const reqList = document.getElementById('loan-requests-list');
  const offList = document.getElementById('loan-offers-list');
  const ledgerBody = document.getElementById('p2p-ledger-body');
  
  const borrowForm = document.getElementById('p2p-borrow-form');
  const lendForm = document.getElementById('p2p-lend-form');

  if (!reqList || !offList || !ledgerBody) return;

  // Render Loan Requests Bulletin Board
  const renderRequests = () => {
    reqList.innerHTML = '';
    if (LOAN_REQUESTS.length === 0) {
      reqList.innerHTML = '<div class="empty-state-local" style="padding: 2rem;">No active borrow requests.</div>';
      return;
    }

    LOAN_REQUESTS.forEach(req => {
      const div = document.createElement('div');
      div.className = 'loan-card';
      div.innerHTML = `
        <div class="loan-card-info">
          <span class="loan-user">${req.borrower}</span>
          <span class="loan-details-meta">Term: ${req.term} Months | Interest Offer: ${req.interest}%</span>
          <p class="loan-purpose-text">"${req.purpose}"</p>
        </div>
        <div class="loan-card-actions">
          <span class="loan-amount">$${req.amount}</span>
          <button class="btn btn-primary" onclick="fundRequest(${req.id})" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;">Fund Loan</button>
        </div>
      `;
      reqList.appendChild(div);
    });
  };

  // Render Loan Offers Bulletin Board
  const renderOffers = () => {
    offList.innerHTML = '';
    if (LOAN_OFFERS.length === 0) {
      offList.innerHTML = '<div class="empty-state-local" style="padding: 2rem;">No active capital offers.</div>';
      return;
    }

    LOAN_OFFERS.forEach(off => {
      const div = document.createElement('div');
      div.className = 'loan-card';
      div.innerHTML = `
        <div class="loan-card-info">
          <span class="loan-user">${off.lender}</span>
          <span class="loan-details-meta">Max Term: ${off.term} Months | Interest: ${off.interest}%</span>
          <p class="loan-purpose-text">"${off.details}"</p>
        </div>
        <div class="loan-card-actions">
          <span class="loan-amount">$${off.amount}</span>
          <button class="btn btn-primary" onclick="requestFundingFromOffer(${off.id})" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;">Request</button>
        </div>
      `;
      offList.appendChild(div);
    });
  };

  // Render User's Mutual Credit Ledger
  const renderLedger = () => {
    ledgerBody.innerHTML = '';
    if (USER_LEDGER.length === 0) {
      ledgerBody.innerHTML = '<tr><td colspan="5" style="text-align:center;color:var(--color-text-muted);">No active credit contracts.</td></tr>';
      return;
    }

    USER_LEDGER.forEach(item => {
      const tr = document.createElement('tr');
      const isLent = item.type === 'Lent';
      
      tr.innerHTML = `
        <td><span class="status-badge ${isLent ? 'status-active' : 'status-offline'}">${item.type}</span></td>
        <td style="font-weight: 500;">${item.partner}</td>
        <td>$${item.principal}</td>
        <td style="color:${isLent ? 'var(--color-green)' : 'var(--color-red)'}; font-weight: bold;">$${Math.round(item.remaining)}</td>
        <td>
          <button class="upvote-btn" onclick="makeRepayment(${item.id})" style="padding: 0.25rem 0.6rem; font-size: 0.75rem;">
            ${isLent ? 'Collect payment' : 'Pay Installment'}
          </button>
        </td>
      `;
      ledgerBody.appendChild(tr);
    });
  };

  // Fund a borrower request (User acts as Lender)
  window.fundRequest = (id) => {
    const idx = LOAN_REQUESTS.findIndex(r => r.id === id);
    if (idx === -1) return;
    const req = LOAN_REQUESTS[idx];

    // Deduct listing and append to ledger
    LOAN_REQUESTS.splice(idx, 1);
    
    // Remaining is principal + interest
    const interestCharge = req.amount * (req.interest / 100);
    const totalRepay = req.amount + interestCharge;

    USER_LEDGER.push({
      id: Date.now(),
      type: 'Lent',
      partner: req.borrower,
      principal: req.amount,
      remaining: totalRepay,
      term: req.term,
      interest: req.interest
    });

    alert(`Success! You funded ${req.borrower}'s loan of $${req.amount}. Contract is now active on your ledger.`);
    renderRequests();
    renderLedger();
  };

  // Request from a lender offer (User acts as Borrower)
  window.requestFundingFromOffer = (id) => {
    const idx = LOAN_OFFERS.findIndex(o => o.id === id);
    if (idx === -1) return;
    const off = LOAN_OFFERS[idx];

    LOAN_OFFERS.splice(idx, 1);

    const interestCharge = off.amount * (off.interest / 100);
    const totalRepay = off.amount + interestCharge;

    USER_LEDGER.push({
      id: Date.now(),
      type: 'Borrowed',
      partner: off.lender,
      principal: off.amount,
      remaining: totalRepay,
      term: off.term,
      interest: off.interest
    });

    alert(`Success! Requested micro-loan of $${off.amount} from ${off.lender}. Capital is credited to your account.`);
    renderOffers();
    renderLedger();
  };

  // Repayment simulation
  window.makeRepayment = (id) => {
    const item = USER_LEDGER.find(l => l.id === id);
    if (!item) return;

    const installment = Math.min(item.remaining, Math.round(item.principal / item.term));
    item.remaining -= installment;

    if (item.remaining <= 0) {
      USER_LEDGER = USER_LEDGER.filter(l => l.id !== id);
      alert(`Success! The loan contract with ${item.partner} has been fully settled and closed.`);
    } else {
      alert(`Payment successful! Paid installment of $${installment}. Remaining balance with ${item.partner}: $${Math.round(item.remaining)}`);
    }

    renderLedger();
  };

  // Form submit handlers
  if (borrowForm) {
    borrowForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const borrower = document.getElementById('borrow-name').value;
      const amount = parseInt(document.getElementById('borrow-amount').value);
      const term = parseInt(document.getElementById('borrow-term').value);
      const interest = parseFloat(document.getElementById('borrow-interest').value);
      const purpose = document.getElementById('borrow-purpose').value;

      LOAN_REQUESTS.unshift({
        id: Date.now(),
        borrower: borrower.startsWith('@') ? borrower : '@' + borrower,
        amount,
        term,
        interest,
        purpose
      });

      renderRequests();
      borrowForm.reset();
    });
  }

  if (lendForm) {
    lendForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const lender = document.getElementById('lend-name').value;
      const amount = parseInt(document.getElementById('lend-amount').value);
      const term = parseInt(document.getElementById('lend-term').value);
      const interest = parseFloat(document.getElementById('lend-interest').value);

      LOAN_OFFERS.unshift({
        id: Date.now(),
        lender: lender.startsWith('@') ? lender : '@' + lender,
        amount,
        term,
        interest,
        details: `Community micro-funding available for local initiatives.`
      });

      renderOffers();
      lendForm.reset();
    });
  }

  // Initial tab form toggle helpers
  window.toggleP2PForm = (mode) => {
    const btnBorrow = document.getElementById('btn-subform-borrow');
    const btnLend = document.getElementById('btn-subform-lend');
    
    if (mode === 'borrow') {
      btnBorrow.classList.add('active');
      btnLend.classList.remove('active');
      borrowForm.classList.remove('hidden');
      lendForm.classList.add('hidden');
    } else {
      btnBorrow.classList.remove('active');
      btnLend.classList.add('active');
      borrowForm.classList.add('hidden');
      lendForm.classList.remove('hidden');
    }
  };

  renderRequests();
  renderOffers();
  renderLedger();
}

/* ==========================================================================
   12. Financial Literacy & Calculators
   ========================================================================== */
const PLATFORM_DATA = {
  youtube: {
    name: 'YouTube Partner Program',
    rate: 4.00, // RPM per 1000 views
    metric: 'Views',
    requirements: '1,000 Subscribers and 4,000 valid public watch hours in the last 12 months, or 10 million Shorts views.',
    note: 'CPM varies widely based on audience geography and niche (finance/tech has high RPM; gaming/comedy has low RPM).'
  },
  tiktok_rewards: {
    name: 'TikTok Creator Rewards',
    rate: 0.75, // RPM per 1000 views
    metric: 'Qualified Views',
    requirements: 'At least 10,000 followers and 100,000 video views in the last 30 days. Videos must be longer than 1 minute.',
    note: 'Requires high engagement and retention. TikTok pays only on "qualified views" (first view per user, watched > 5 seconds).'
  },
  tiktok_fund: {
    name: 'TikTok Creator Fund (Shorts)',
    rate: 0.03, // RPM per 1000 views
    metric: 'Shorts Views',
    requirements: '10,000 followers and 100,000 video views in the last 30 days.',
    note: 'Extremely low payouts. Chasing short viral loops is highly extraction-prone for creators; it drives platform traffic but returns pennies.'
  },
  spotify: {
    name: 'Spotify Artist Streaming',
    rate: 3.50, // per 1000 streams
    metric: 'Streams',
    requirements: 'Minimum of 1,000 streams annually on the track to start generating payouts.',
    note: 'Payouts are pooled and distributed based on market share, meaning small artists receive less than the absolute rate.'
  },
  apple_music: {
    name: 'Apple Music Streaming',
    rate: 7.50, // per 1000 streams
    metric: 'Streams',
    requirements: 'No minimum track stream count, but requires account distribution setup (DistroKid/TuneCore).',
    note: 'Generally pays roughly double Spotify’s rate due to Apple’s subscription-only model (no free ad-supported tier).'
  },
  x_ads: {
    name: 'X (Twitter) Ads Revenue Sharing',
    rate: 0.015, // per 1000 impressions
    metric: 'Impressions',
    requirements: 'Subscribe to X Premium, and have at least 5 million organic impressions on your posts in the last 3 months.',
    note: 'Highly volatile. Payouts depend strictly on ads served in the replies of verified users.'
  }
};

function initFinancialLiteracy() {
  const platSelect = document.getElementById('platform-select');
  const targetIncomeInput = document.getElementById('input-target-income');
  const calcOutput = document.getElementById('platform-calc-output');

  const ccBalanceInput = document.getElementById('cc-balance');
  const ccAprInput = document.getElementById('cc-apr');
  const ccMinRateSelect = document.getElementById('cc-min-rate');
  const ccOutput = document.getElementById('cc-trap-output');

  if (!platSelect || !targetIncomeInput || !calcOutput || !ccBalanceInput || !ccAprInput || !ccMinRateSelect || !ccOutput) return;

  // Platform calculator engine
  const calculatePlatformMonetization = () => {
    const platKey = platSelect.value;
    const target = parseFloat(targetIncomeInput.value) || 0;
    const info = PLATFORM_DATA[platKey];

    if (!info) return;

    // views needed = target / (rate / 1000)
    const viewsNeeded = Math.round(target / (info.rate / 1000));
    
    calcOutput.innerHTML = `
      <div class="reflection-header">
        <span class="reflection-badge badge-winning">${info.name}</span>
        <span class="reflection-title">${viewsNeeded.toLocaleString()} ${info.metric} / month</span>
      </div>
      <div class="reflection-text">
        <p><strong>Average Revenue Rate:</strong> $${info.rate.toFixed(3)} per 1,000 ${info.metric.toLowerCase()}</p>
        <p class="margin-top-small"><strong>Monetization Requirements:</strong> ${info.requirements}</p>
        <p class="margin-top-small" style="font-style: italic; font-size: 0.82rem; color: var(--color-text-muted);">${info.note}</p>
      </div>
    `;
  };

  // Credit Card Debt Trap Calculator engine
  const calculateDebtTrap = () => {
    const balanceStart = parseFloat(ccBalanceInput.value) || 0;
    const apr = parseFloat(ccAprInput.value) || 0;
    const minSelectVal = ccMinRateSelect.value;

    let balance = balanceStart;
    const r = apr / 12 / 100;
    let months = 0;
    let totalPaid = 0;
    let totalInterest = 0;

    const isFixed = minSelectVal === '100';
    const minRate = isFixed ? 0 : parseFloat(minSelectVal) / 100;

    // Check for infinite debt loop:
    const initialInterest = balance * r;
    const initialPayment = isFixed ? 100 : Math.max(25, balance * minRate);

    if (initialInterest >= initialPayment && balance > 0) {
      ccOutput.className = 'reflection-output losing';
      ccOutput.innerHTML = `
        <div class="reflection-header">
          <span class="reflection-badge badge-losing">INDEFINITE DEBT LOOP</span>
          <span class="reflection-title" style="color: var(--color-red);">Warning: Debt Grows Indefinitely!</span>
        </div>
        <div class="reflection-text">
          <p>Your interest charge this month ($${Math.round(initialInterest)}) exceeds or equals your starting payment ($${Math.round(initialPayment)}). Under this payment scheme, the card balance will grow forever, trapping you in interest obligations indefinitely.</p>
          <p class="margin-top-small"><strong>Action required:</strong> Increase your monthly payment to at least $${Math.round(initialInterest + 20)} to start paying down the principal.</p>
        </div>
      `;
      return;
    }

    while (balance > 0.01 && months < 600) { // Limit to 50 years to prevent browser freeze
      months++;
      const interest = balance * r;
      totalInterest += interest;
      balance += interest;

      let payment = 0;
      if (isFixed) {
        payment = Math.min(balance, 100);
      } else {
        payment = Math.min(balance, Math.max(25, balance * minRate));
      }

      totalPaid += payment;
      balance -= payment;
    }

    const years = Math.floor(months / 12);
    const remainingMonths = months % 12;
    const timeString = `${years > 0 ? years + ' years ' : ''}${remainingMonths} months`;
    const interestPercentage = Math.round((totalInterest / balanceStart) * 100);

    ccOutput.className = 'reflection-output losing';
    ccOutput.innerHTML = `
      <div class="reflection-header">
        <span class="reflection-badge badge-losing">Debt payoff results</span>
        <span class="reflection-title">${timeString} to pay off</span>
      </div>
      <div class="reflection-text">
        <p><strong>Total Interest Extracted:</strong> $${Math.round(totalInterest).toLocaleString()} (${interestPercentage}% of original balance)</p>
        <p><strong>Total Cash Paid to Bank:</strong> $${Math.round(totalPaid).toLocaleString()}</p>
        <p class="margin-top-small" style="font-style: italic; font-size: 0.85rem; color: var(--color-text-muted);">
          *Paying only the bank's minimum rate ensures they maximize their extraction from your labor. Always prioritize paying the STATEMENT BALANCE in full every month to force the bank to extend interest-free credit rather than extracting your savings.
        </p>
      </div>
    `;
  };

  const calcBtn = document.getElementById('btn-platform-calc');
  if (calcBtn) {
    calcBtn.addEventListener('click', calculatePlatformMonetization);
  }

  platSelect.addEventListener('change', calculatePlatformMonetization);
  targetIncomeInput.addEventListener('input', calculatePlatformMonetization);
  
  ccBalanceInput.addEventListener('input', calculateDebtTrap);
  ccAprInput.addEventListener('input', calculateDebtTrap);
  ccMinRateSelect.addEventListener('change', calculateDebtTrap);

  // Initial runs
  calculatePlatformMonetization();
  calculateDebtTrap();
}

/* ==========================================================================
   13. The President's Desk (Regulations Tracker)
   ========================================================================== */
const REGULATIONS_DATABASE = [
  {
    id: 'cfpb-late-fees',
    title: 'Credit Card Late Fee Cap ($8 limit)',
    agency: 'CFPB',
    status: 'blocked',
    statusText: 'Injunction / Blocked by Court',
    agenda: 'Capping credit card late fees at $8 (down from the current average of $32), potentially saving consumers $10 billion annually.',
    lobbying: 'Chamber of Commerce and banking associations successfully filed a federal injunction in Texas, arguing the cap harms banking liquidity.',
    spend: '$24.2M',
    tags: ['cfpb', 'late fee', 'bank', 'credit card', 'finance', 'court', 'injunction']
  },
  {
    id: 'sec-climate',
    title: 'Climate Emissions Disclosure (Scope 1 & 2)',
    agency: 'SEC',
    status: 'stayed',
    statusText: 'Legal Stay / Under Litigation',
    agenda: 'Requiring large public corporations to disclose their direct Scope 1 & 2 greenhouse gas emissions in annual filings.',
    lobbying: 'Energy companies and state attorneys general filed lawsuits claiming the SEC is overstepping its financial mandate. SEC paused the rule voluntarily pending legal outcomes.',
    spend: '$18.4M',
    tags: ['sec', 'climate', 'emissions', 'greenhouse', 'fossil fuel', 'lawsuit', 'energy']
  },
  {
    id: 'ftc-mergers',
    title: 'HSR Merger Review Guidelines',
    agency: 'FTC',
    status: 'active',
    statusText: 'Active / Reviewing Filings',
    agenda: 'Expanding the reporting data required for corporate mergers under the Hart-Scott-Rodino Act to check anti-competitive behavior early.',
    lobbying: 'Tech conglomerates and defense lobbies spend heavily to water down disclosure categories (such as internal employee chats/emails).',
    spend: '$15.5M',
    tags: ['ftc', 'merger', 'monopoly', 'acquisition', 'tech', 'antitrust']
  },
  {
    id: 'omb-penalties',
    title: 'OMB Memo M-26-026 (Penalty Freeze)',
    agency: 'OMB',
    status: 'active',
    statusText: 'Enacted / Active Freeze',
    agenda: 'Directing all federal agencies to freeze annual inflation adjustments for civil penalty caps, maintaining them at 2025 levels.',
    lobbying: 'Triggered by standard CPI data delays during late 2025 budget standoffs. Ensures corporate penalty limits do not increase for the fiscal year.',
    spend: '$0.0M',
    tags: ['omb', 'penalty', 'inflation', 'freeze', 'budget', 'shutdown']
  },
  {
    id: 'eo-frontier-ai',
    title: 'Frontier AI Safety Reporting (10^26 FLOPs)',
    agency: 'Executive Order',
    status: 'active',
    statusText: 'Enacted / Compliance Reporting',
    agenda: 'Requiring developers of frontier AI models training on compute power exceeding 10^26 FLOPs to report safety test results to the federal government.',
    lobbying: 'Tech firms lobby to limit the scope of reporting, arguing compute thresholds stifle startup innovation.',
    spend: '$12.5M',
    tags: ['eo', 'executive order', 'ai', 'safety', 'frontier', 'compute', 'tech']
  },
  {
    id: 'fcc-neutrality',
    title: 'Net Neutrality Title II Reclassification',
    agency: 'FCC',
    status: 'stayed',
    statusText: 'Stayed by Sixth Circuit Court',
    agenda: 'Reclassifying broadband internet access as a common carrier service under Title II of the Communications Act to prevent ISPs from throttling or blocking traffic.',
    lobbying: 'Telecom monopolies (Comcast, Verizon, AT&T) litigated the rule, winning a temporary stay in court.',
    spend: '$29.1M',
    tags: ['fcc', 'net neutrality', 'internet', 'broadband', 'telecom', 'court']
  },
  {
    id: 'epa-powerplants',
    title: 'Power Plant Carbon Standards',
    agency: 'EPA',
    status: 'blocked',
    statusText: 'Supreme Court Challenges',
    agenda: 'Setting strict carbon pollution standards for coal and gas-fired power plants, forcing carbon capture or transitions.',
    lobbying: 'Utility companies and mining associations appealed, citing compliance costs and grid instability.',
    spend: '$22.8M',
    tags: ['epa', 'carbon', 'power plant', 'coal', 'energy', 'climate']
  },
  {
    id: 'dol-overtime',
    title: 'Overtime Pay Salary Threshold Expansion',
    agency: 'DOL',
    status: 'active',
    statusText: 'Enacted / Partially Challenged',
    agenda: 'Expanding salary caps under which white-collar workers are guaranteed 1.5x overtime pay (increasing threshold to $58,656).',
    lobbying: 'Retail and restaurant lobbies filed injunction attempts to delay or block salary adjustments.',
    spend: '$9.7M',
    tags: ['dol', 'overtime', 'salary', 'labor', 'wages', 'workers']
  },
  {
    id: 'irs-wealth-audits',
    title: 'Wealthy Tax Audit Initiative',
    agency: 'IRS',
    status: 'active',
    statusText: 'Enacted / Funding Review',
    agenda: 'Directing audits and recovery pipelines targeting individuals earning over $400,000 who haven\'t filed or underreported income.',
    lobbying: 'Financial wealth managers and corporate groups lobby Congress to defund IRS enforcement budgets.',
    spend: '$14.3M',
    tags: ['irs', 'tax', 'audit', 'wealth', 'tax cuts', 'finance']
  }
];

function initPresidentDesk() {
  const searchInput = document.getElementById('reg-search-input');
  const blotterContainer = document.getElementById('desk-blotter-container');
  
  const detailPanel = document.getElementById('reg-detail-panel');
  const detailInitial = detailPanel ? detailPanel.querySelector('.detail-initial-state') : null;
  const detailContent = document.getElementById('reg-detail-content');
  
  const detailTitle = document.getElementById('reg-detail-title');
  const detailAgency = document.getElementById('reg-detail-agency');
  const detailStatus = document.getElementById('reg-detail-status');
  const detailAgenda = document.getElementById('reg-detail-agenda');
  const detailLobbying = document.getElementById('reg-detail-lobbying');
  const detailSpend = document.getElementById('reg-detail-spend');

  if (!blotterContainer || !searchInput) return;

  const renderBlotter = (filteredRules) => {
    blotterContainer.innerHTML = '';
    
    if (filteredRules.length === 0) {
      blotterContainer.innerHTML = '<div class="empty-state-local">No matching regulations found.</div>';
      return;
    }

    filteredRules.forEach(rule => {
      const slot = document.createElement('div');
      slot.className = 'reg-folder-slot';
      slot.setAttribute('data-reg-id', rule.id);
      
      const leftDiv = document.createElement('div');
      leftDiv.className = 'loan-card-info';
      
      const titleSpan = document.createElement('span');
      titleSpan.className = 'reg-folder-title';
      titleSpan.textContent = rule.title;
      
      const agencySpan = document.createElement('span');
      agencySpan.className = 'reg-folder-agency';
      agencySpan.textContent = rule.agency;
      
      leftDiv.appendChild(titleSpan);
      leftDiv.appendChild(agencySpan);
      
      const rightDiv = document.createElement('div');
      rightDiv.className = 'loan-card-actions';
      
      const badgeSpan = document.createElement('span');
      badgeSpan.className = `reg-status-badge reg-status-${rule.status}`;
      badgeSpan.textContent = rule.statusText;
      
      rightDiv.appendChild(badgeSpan);
      
      slot.appendChild(leftDiv);
      slot.appendChild(rightDiv);
      
      slot.addEventListener('click', () => {
        document.querySelectorAll('.reg-folder-slot').forEach(s => s.classList.remove('active-folder'));
        slot.classList.add('active-folder');
        
        if (detailInitial) detailInitial.classList.add('hidden');
        if (detailContent) detailContent.classList.remove('hidden');
        
        if (detailTitle) detailTitle.textContent = rule.title;
        if (detailAgency) {
          detailAgency.textContent = rule.agency;
          detailAgency.className = 'node-badge badge-regulatory';
        }
        if (detailStatus) detailStatus.textContent = rule.statusText;
        if (detailAgenda) detailAgenda.textContent = rule.agenda;
        if (detailLobbying) detailLobbying.textContent = rule.lobbying;
        if (detailSpend) detailSpend.textContent = rule.spend;
      });
      
      blotterContainer.appendChild(slot);
    });
  };

  const handleSearch = () => {
    const query = searchInput.value.toLowerCase().trim();
    
    if (query === '') {
      renderBlotter(REGULATIONS_DATABASE);
      return;
    }

    const filtered = REGULATIONS_DATABASE.filter(rule => {
      const matchTitle = rule.title.toLowerCase().includes(query);
      const matchAgency = rule.agency.toLowerCase().includes(query);
      const matchTags = rule.tags.some(tag => tag.toLowerCase().includes(query));
      return matchTitle || matchAgency || matchTags;
    });

    renderBlotter(filtered);
  };

  searchInput.addEventListener('input', handleSearch);
  
  // Initial draw
  renderBlotter(REGULATIONS_DATABASE);
}

/* ==========================================================================
   14. Lexis AI Chatbot (Navigation, Law & Feedback Assistant)
   ========================================================================== */
function initChatbot() {
  const chatbotTrigger = document.getElementById('chatbot-trigger-btn');
  const chatbotPanel = document.getElementById('chatbot-window-panel');
  const chatbotClose = document.getElementById('chatbot-close-btn');
  
  const chatbotInput = document.getElementById('chatbot-input');
  const chatbotSend = document.getElementById('chatbot-send-btn');
  const chatbotLog = document.getElementById('chatbot-log');
  
  const suggestionChips = document.querySelectorAll('.suggestion-chip');

  if (!chatbotTrigger || !chatbotPanel || !chatbotClose || !chatbotInput || !chatbotSend || !chatbotLog) return;

  // Toggle Panel open/closed
  chatbotTrigger.addEventListener('click', () => {
    chatbotPanel.classList.toggle('hidden');
  });

  chatbotClose.addEventListener('click', () => {
    chatbotPanel.classList.add('hidden');
  });

  const appendMessage = (text, sender) => {
    const bubble = document.createElement('div');
    bubble.className = `chat-bubble ${sender}-bubble`;
    bubble.innerHTML = text;
    chatbotLog.appendChild(bubble);
    chatbotLog.scrollTop = chatbotLog.scrollHeight;
  };

  const getAIResponse = (userText) => {
    const text = userText.toLowerCase();

    // Check for Feedback collection intent
    if (text.includes('feedback') || text.includes('suggest') || text.includes('add a') || text.includes('recommend') || text.includes('improve')) {
      return `Thank you for sharing your feedback on <strong>resolve.bet</strong>! I have recorded your suggestion: <em>"${userText}"</em>. We review all community feature requests weekly to expand the tools available on this network.`;
    }

    // Check for credit questions
    if (text.includes('credit') || text.includes('fico') || text.includes('utilization') || text.includes('rebuild') || text.includes('debt')) {
      return `To fix or rebuild your credit score, open the <strong>Financial Literacy</strong> tab and review the FICO breakdowns. Keep your utilization below 10%, automate payments, and dispute errors. You can also simulate interest rates in our <strong>Credit Card Debt Trap Simulator</strong> at the bottom of that page!`;
    }

    // Check for Rich giving back / philanthropy
    if (text.includes('giving back') || text.includes('philanthropy') || text.includes('charity') || text.includes('rich give') || text.includes('foundation') || text.includes('donation')) {
      return `Billionaire philanthropy is often a structural illusion (philanthropic theater). Instead of paying taxes to be democratically distributed, the ultra-wealthy use <strong>private family foundations</strong> to secure massive tax write-offs while keeping 95% of the assets invested in the market, compounding tax-free under their control. This allows them to bypass democratic processes and dictate public programs according to personal preference. Real "giving back" requires <strong>surrendering control</strong>—such as allocating wealth to public reserves, community land trusts, or worker-owned cooperatives. Check the hot thread in our new <strong>Community Forum</strong> tab for a full breakdown!`;
    }

    // Check for Regulatory capture questions
    if (text.includes('capture') || text.includes('citizens united') || text.includes('lobbying') || text.includes('dark money') || text.includes('revolving door')) {
      return `Regulatory Capture happens when federal agencies (like the SEC, FTC, FCC) get staffed or pressured by the corporations they regulate. Check out the <strong>Mechanics of Control</strong> tab and select <strong>The President's Desk</strong> to search active filings and see how lobbying money halts rules.`;
    }

    // Check for Specific agency items on the President's Desk
    if (text.includes('cfpb') || text.includes('late fee') || text.includes('sec') || text.includes('emissions') || text.includes('ftc') || text.includes('merger') || text.includes('omb') || text.includes('ai safety') || text.includes('net neutrality')) {
      return `That regulation is currently under adjustment! If you go to the <strong>Mechanics of Control</strong> tab, select <strong>The President's Desk</strong>, and search for that agency or keyword, you can click the folder to see the exact rule details and target lobbying spend.`;
    }

    // Navigation maneuvering guides
    if (text.includes('navigate') || text.includes('tab') || text.includes('where is') || text.includes('how do i') || text.includes('find')) {
      return `Here is a map of <strong>resolve.bet</strong>:
      <ul>
        <li><strong>Systemic Loop:</strong> View Piketty's Formula and click nodes to see how money flows.</li>
        <li><strong>Mechanics of Control:</strong> Explore campaign finance, lobbying, revolving doors, and track active rules on <strong>The President's Desk</strong>.</li>
        <li><strong>Public Square:</strong> Compete in the Debate Arena, view Unfiltered News, and share social arguments.</li>
        <li><strong>Developer Hub:</strong> Upload or view community-created transparency tools.</li>
        <li><strong>Local Board:</strong> Locate cooperative shops and mutual aid events near you.</li>
        <li><strong>P2P Lending:</strong> Request loans directly from other citizens at interest-free terms.</li>
        <li><strong>Financial Literacy:</strong> Learn how money works and simulate credit card debt interest.</li>
      </ul>`;
    }

    // Default Fallback
    return `I can help you navigate <strong>resolve.bet</strong>, answer lawyer/regulation questions (like Citizens United or Regulatory Capture), or log your feedback. What would you like to know?`;
  };

  const handleSend = () => {
    const text = chatbotInput.value.trim();
    if (!text) return;

    appendMessage(text, 'user');
    chatbotInput.value = '';

    // Simulate AI response delay
    setTimeout(() => {
      const response = getAIResponse(text);
      appendMessage(response, 'bot');
    }, 450);
  };

  chatbotSend.addEventListener('click', handleSend);
  
  chatbotInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
      handleSend();
    }
  });

  // Suggestion Chips handler
  suggestionChips.forEach(chip => {
    chip.addEventListener('click', () => {
      const msg = chip.getAttribute('data-msg');
      if (msg) {
        appendMessage(msg, 'user');
        setTimeout(() => {
          const response = getAIResponse(msg);
          appendMessage(response, 'bot');
        }, 400);
      }
    });
  });
}

/* ==========================================================================
   15. Custom Debate Topics & Voting Queue
   ========================================================================== */
const DEFAULT_DEBATE_TOPICS = {
  political: [
    { value: 'lobbying', text: 'Is Corporate Lobbying Legalized Bribery?' },
    { value: 'wealth', text: 'Should there be a Maximum Wealth Cap?' },
    { value: 'united', text: 'Is Citizens United Destroying Democracy?' },
    { value: 'funding', text: 'Should Elections be 100% Publicly Funded?' },
    { value: 'gerrymandering', text: 'Should AI Draw Congressional District Maps to Prevent Gerrymandering?' },
    { value: 'lobbying-ban', text: 'Should Former Politicians be Banned from Lobbying for Life?' },
    { value: 'bitcoin-currency', text: 'Will Cryptocurrency Ever Fully Replace Sovereign Fiat Currencies?' },
    { value: 'ubi-automation', text: 'Is Universal Basic Income Necessary to Survive the AI Automation Wave?' }
  ],
  spiritual: [
    { value: 'greed-soul', text: 'Does Extreme Greed Cause Spiritual Deprivation?' },
    { value: 'value-service', text: 'Is the True Purpose of Life Selfless Service?' },
    { value: 'wealth-happiness', text: 'Does Hoarded Wealth Prevent Authentic Connections?' },
    { value: 'mindfulness-tech', text: 'Does Constant Connectivity Destroy the Human Capacity for Inner Silence?' },
    { value: 'nature-therapy', text: 'Is Modern Society Suffocated by Nature Deficit Disorder?' },
    { value: 'karma-real', text: 'Does What Goes Around Actually Come Around, or is Life Purely Random?' },
    { value: 'consciousness-machine', text: 'Can a Machine Ever Possess a Soul or True Consciousness?' }
  ],
  news: [
    { value: 'penalty-freeze', text: 'Is the 2026 Inflation Penalty Freeze Pro-Corporate?' },
    { value: 'fee-cap-stay', text: 'Should Judges Block Credit Card Fee Caps?' },
    { value: 'ai-thresholds', text: 'Should Compute Limits on AI Training be Regulated?' },
    { value: 'social-media-news', text: 'Is Algorithmic Censorship a Greater Threat than Fake News?' },
    { value: 'space-commercialization', text: 'Should Space Mining be Governed by an International UN Treaty?' },
    { value: 'synthetic-meat', text: 'Will Lab-Grown Meat Completely Replace Livestock Farming by 2040?' }
  ],
  fun: [
    { value: 'mars-colonies', text: 'Should We Colonize Mars or Fix Earth First?' },
    { value: 'ai-art', text: 'Is AI-Generated Art Real Creative Expression?' },
    { value: 'social-detox', text: 'Should Social Media be Banned for Under-18s?' },
    { value: 'pineapple-pizza', text: 'Is Pineapple on Pizza a Culinary Masterpiece or an Abomination?' },
    { value: 'cats-vs-dogs', text: 'Are Cats Secretly Planning World Domination, or are Dogs the Superior Companion?' },
    { value: 'cereal-milk', text: 'Does the Cereal go in Before the Milk, or the Milk Before the Cereal?' },
    { value: 'hotdog-sandwich', text: 'Is a Hot Dog Classified as a Sandwich?' },
    { value: 'superpower-flight-invis', text: 'Would you rather have the Power of Flight or Invisibility?' },
    { value: 'time-travel-past-future', text: 'Is it Better to Travel 500 Years into the Past or 500 Years into the Future?' },
    { value: 'toilet-paper-roll', text: 'Should Toilet Paper Hang Over the Front or Under the Back?' },
    { value: 'simulation-theory', text: 'Are We Living in a Matrix-style Computer Simulation?' },
    { value: 'aliens-among-us', text: 'Have Aliens Already Visited Earth and Blended into Human Society?' },
    { value: 'taco-vs-pizza', text: 'If you could only eat one for the rest of your life, is it Tacos or Pizza?' },
    { value: 'superhero-identity', text: 'Should Superheroes be Legally Required to Reveal their Secret Identities?' },
    { value: 'zombie-apocalypse', text: 'Could you survive a Zombie Apocalypse with only a frying pan?' }
  ]
};

const SUGGESTED_TOPICS = [
  { text: 'Should lobbying records be published on the blockchain?', genre: 'political', upvotes: 4, status: 'pending' },
  { text: 'Is modern advertising a form of psychological capture?', genre: 'spiritual', upvotes: 2, status: 'pending' },
  { text: 'Does fractional reserve banking constitute structural theft?', genre: 'political', upvotes: 5, status: 'approved' },
  { text: 'Should we introduce a 4-day workweek globally?', genre: 'fun', upvotes: 1, status: 'pending' }
];

function renderDebateTopics() {
  const select = document.getElementById('arena-topic');
  if (!select) return;

  const currentVal = select.value;
  select.innerHTML = '';

  for (const genre in DEFAULT_DEBATE_TOPICS) {
    const group = document.createElement('optgroup');
    group.label = genre.charAt(0).toUpperCase() + genre.slice(1) + ' Debates';
    
    DEFAULT_DEBATE_TOPICS[genre].forEach(topic => {
      const opt = document.createElement('option');
      opt.value = topic.value;
      opt.textContent = topic.text;
      group.appendChild(opt);
    });

    select.appendChild(group);
  }

  if (currentVal) {
    select.value = currentVal;
  }
}

function renderSuggestedTopics() {
  const container = document.getElementById('suggested-topics-list');
  if (!container) return;

  container.innerHTML = '';

  SUGGESTED_TOPICS.forEach((topic, idx) => {
    const card = document.createElement('div');
    card.className = 'loan-card';
    card.style.padding = '0.9rem 1.1rem';
    
    const info = document.createElement('div');
    info.className = 'loan-card-info';
    
    const textSpan = document.createElement('span');
    textSpan.className = 'reg-folder-title';
    textSpan.style.fontSize = '0.9rem';
    textSpan.textContent = topic.text;
    
    const badge = document.createElement('span');
    badge.className = `genre-badge genre-${topic.genre}`;
    badge.textContent = topic.genre;
    
    info.appendChild(textSpan);
    info.appendChild(badge);
    
    const actions = document.createElement('div');
    actions.className = 'loan-card-actions';
    actions.style.alignItems = 'center';
    
    if (topic.status === 'approved') {
      const approvedBadge = document.createElement('span');
      approvedBadge.className = 'reg-status-badge reg-status-active';
      approvedBadge.style.fontSize = '0.65rem';
      approvedBadge.textContent = 'Approved';
      actions.appendChild(approvedBadge);
    } else {
      const upvoteBtn = document.createElement('button');
      upvoteBtn.className = 'upvote-btn';
      upvoteBtn.style.padding = '0.2rem 0.6rem';
      upvoteBtn.innerHTML = `▲ <span class="upvote-count">${topic.upvotes}</span>`;
      
      upvoteBtn.addEventListener('click', () => {
        topic.upvotes++;
        upvoteBtn.querySelector('.upvote-count').textContent = topic.upvotes;
        
        if (topic.upvotes >= 5) {
          topic.status = 'approved';
          const uniqueVal = 'custom-' + idx;
          const exists = DEFAULT_DEBATE_TOPICS[topic.genre].some(t => t.value === uniqueVal);
          if (!exists) {
            DEFAULT_DEBATE_TOPICS[topic.genre].push({ value: uniqueVal, text: topic.text });
            renderDebateTopics();
          }
          renderSuggestedTopics();
        }
      });
      actions.appendChild(upvoteBtn);
    }
    
    card.appendChild(info);
    card.appendChild(actions);
    container.appendChild(card);
  });
}

function initProposeTopicForm() {
  const form = document.getElementById('propose-topic-form');
  const textInput = document.getElementById('propose-text');
  const genreSelect = document.getElementById('propose-genre');

  if (!form || !textInput || !genreSelect) return;

  form.addEventListener('submit', (e) => {
    e.preventDefault();
    const text = textInput.value.trim();
    const genre = genreSelect.value;

    if (!text) return;

    SUGGESTED_TOPICS.push({
      text: text,
      genre: genre,
      upvotes: 1,
      status: 'pending'
    });

    textInput.value = '';
    renderSuggestedTopics();
  });
}

/* ==========================================================================
   16. Gaming Corner (Tournament Brackets & Snake/Auction Drafts)
   ========================================================================== */
let TOURNAMENTS = [
  {
    id: 'tourney-1',
    name: 'resolve.bet Chess Classic',
    game: 'Speed Chess',
    prize: 500,
    bracket: 'single',
    draft: 'snake',
    players: ['Liberty_Patriot', 'VoxPopuli_33', 'Citizen_Socrates', 'NullHypothesis', 'Capitalist_Edge', 'Citizen_X', 'Player_Alpha', 'Player_Beta'],
    status: 'In Progress',
    round: 1,
    matches: [
      { p1: 'Liberty_Patriot', p2: 'VoxPopuli_33', s1: 2, s2: 1, winner: 'Liberty_Patriot', round: 1 },
      { p1: 'Citizen_Socrates', p2: 'NullHypothesis', s1: 0, s2: 2, winner: 'NullHypothesis', round: 1 },
      { p1: 'Capitalist_Edge', p2: 'Citizen_X', s1: 1, s2: 2, winner: 'Citizen_X', round: 1 },
      { p1: 'Player_Alpha', p2: 'Player_Beta', s1: 2, s2: 0, winner: 'Player_Alpha', round: 1 }
    ],
    draftLog: [
      'Round 1: Liberty_Patriot drafted Magnus Carlson (Bot)',
      'Round 1: VoxPopuli_33 drafted Hikaru Nakamura (Bot)',
      'Round 1: Citizen_Socrates drafted Garry Kasparov (Bot)',
      'Round 1: NullHypothesis drafted AlphaZero (Bot)',
      'Round 2: Capitalist_Edge drafted Stockfish (Bot)',
      'Round 2: Citizen_X drafted Deep Blue (Bot)',
      'Round 2: Player_Alpha drafted Leela Chess Zero (Bot)',
      'Round 2: Player_Beta drafted Fritz (Bot)'
    ]
  }
];

let activeTourneyId = 'tourney-1';

function initGamingCorner() {
  const form = document.getElementById('tournament-creator-form');
  const tName = document.getElementById('tourney-name');
  const tGame = document.getElementById('tourney-game');
  const tPrize = document.getElementById('tourney-prize');
  const tBracket = document.getElementById('tourney-bracket');
  const tDraft = document.getElementById('tourney-draft');

  const btnSimulate = document.getElementById('btn-simulate-round');

  if (!form) return;

  // Listen to Developer Hub dynamic game submissions
  const originalDraw = window.renderDevGallery;
  window.renderDevGallery = function() {
    if (typeof originalDraw === 'function') {
      originalDraw();
    }
    updateGameSelectDropdown();
  };

  const updateGameSelectDropdown = () => {
    if (!tGame) return;
    // Get all game submissions
    const gameSubmissions = DEV_PROJECTS.filter(p => p.tag === 'Game');
    
    // Clear default select options except basic ones
    tGame.innerHTML = `
      <option value="chess">Speed Chess</option>
      <option value="blockmaker">BlockMaker Sandbox</option>
      <option value="capital-exploit">Capital Exploit Runner</option>
    `;

    gameSubmissions.forEach(game => {
      const opt = document.createElement('option');
      opt.value = game.title.toLowerCase().replace(/\s+/g, '-');
      opt.textContent = game.title;
      tGame.appendChild(opt);
    });
  };

  form.addEventListener('submit', (e) => {
    e.preventDefault();
    const id = 'tourney-' + (TOURNAMENTS.length + 1);
    const draftType = tDraft.value;
    
    const participants = ['Liberty_Patriot', 'VoxPopuli_33', 'Citizen_Socrates', 'NullHypothesis', 'Capitalist_Edge', 'Citizen_X', 'Player_Alpha', 'Player_Beta'];
    const matches = [
      { p1: participants[0], p2: participants[1], s1: 0, s2: 0, winner: null, round: 1 },
      { p1: participants[2], p2: participants[3], s1: 0, s2: 0, winner: null, round: 1 },
      { p1: participants[4], p2: participants[5], s1: 0, s2: 0, winner: null, round: 1 },
      { p1: participants[6], p2: participants[7], s1: 0, s2: 0, winner: null, round: 1 }
    ];

    const logs = [];
    if (draftType === 'snake') {
      participants.forEach((p, idx) => {
        logs.push(`Round ${Math.floor(idx/8)+1}: ${p} drafted Agent_${idx + 1}`);
      });
    } else if (draftType === 'auction') {
      participants.forEach((p, idx) => {
        const bid = Math.floor(Math.random() * 80) + 40;
        logs.push(`${p} secured Roster_Hero_${idx + 1} for $${bid}`);
      });
    } else {
      logs.push('Direct seeding selected. Draft bypassed.');
    }

    const newTourney = {
      id: id,
      name: tName.value,
      game: tGame.options[tGame.selectedIndex].text,
      prize: parseInt(tPrize.value),
      bracket: tBracket.value,
      draft: draftType,
      players: participants,
      status: 'In Progress',
      round: 1,
      matches: matches,
      draftLog: logs
    };

    TOURNAMENTS.push(newTourney);
    activeTourneyId = id;
    
    tName.value = '';
    renderTournamentsList();
    loadTourneyDetails(id);
  });

  if (btnSimulate) {
    btnSimulate.addEventListener('click', () => {
      const tourney = TOURNAMENTS.find(t => t.id === activeTourneyId);
      if (!tourney || tourney.status === 'Completed') return;

      if (tourney.round === 1) {
        // Simulate Round 1 results
        tourney.matches.forEach(m => {
          if (m.round === 1) {
            m.s1 = Math.floor(Math.random() * 3);
            m.s2 = Math.floor(m.s1 === 2 ? Math.random() * 2 : 2);
            m.winner = m.s1 > m.s2 ? m.p1 : m.p2;
          }
        });

        // Generate Round 2 (Semifinals)
        const winners = tourney.matches.filter(m => m.round === 1).map(m => m.winner);
        tourney.matches.push({ p1: winners[0], p2: winners[1], s1: 0, s2: 0, winner: null, round: 2 });
        tourney.matches.push({ p1: winners[2], p2: winners[3], s1: 0, s2: 0, winner: null, round: 2 });
        tourney.round = 2;
      } 
      else if (tourney.round === 2) {
        // Simulate Round 2
        tourney.matches.forEach(m => {
          if (m.round === 2) {
            m.s1 = Math.floor(Math.random() * 3);
            m.s2 = Math.floor(m.s1 === 2 ? Math.random() * 2 : 2);
            m.winner = m.s1 > m.s2 ? m.p1 : m.p2;
          }
        });

        // Generate Finals
        const winners = tourney.matches.filter(m => m.round === 2).map(m => m.winner);
        tourney.matches.push({ p1: winners[0], p2: winners[1], s1: 0, s2: 0, winner: null, round: 3 });
        tourney.round = 3;
      } 
      else if (tourney.round === 3) {
        // Simulate Finals
        const finalMatch = tourney.matches.find(m => m.round === 3);
        if (finalMatch) {
          finalMatch.s1 = Math.floor(Math.random() * 3);
          finalMatch.s2 = Math.floor(finalMatch.s1 === 2 ? Math.random() * 2 : 2);
          finalMatch.winner = finalMatch.s1 > finalMatch.s2 ? finalMatch.p1 : finalMatch.p2;
          tourney.status = 'Completed';
        }
      }

      loadTourneyDetails(tourney.id);
      renderTournamentsList();
    });
  }

  // Draw initial list
  renderTournamentsList();
  updateGameSelectDropdown();
}

function renderTournamentsList() {
  const container = document.getElementById('active-tournaments-list');
  if (!container) return;

  container.innerHTML = '';

  TOURNAMENTS.forEach(t => {
    const card = document.createElement('div');
    card.className = `loan-card ${t.id === activeTourneyId ? 'active-folder' : ''}`;
    card.style.cursor = 'pointer';

    card.addEventListener('click', () => {
      activeTourneyId = t.id;
      renderTournamentsList();
      loadTourneyDetails(t.id);
    });

    const info = document.createElement('div');
    info.className = 'loan-card-info';

    const title = document.createElement('span');
    title.className = 'reg-folder-title';
    title.textContent = t.name;

    const desc = document.createElement('span');
    desc.className = 'loan-details-meta';
    desc.textContent = `${t.game} • Bracket: ${t.bracket} • Status: ${t.status}`;

    info.appendChild(title);
    info.appendChild(desc);

    const stakes = document.createElement('div');
    stakes.className = 'loan-card-actions';
    
    const amt = document.createElement('span');
    amt.className = 'loan-amount';
    amt.textContent = `$${t.prize}`;

    const label = document.createElement('span');
    label.className = 'loan-rate';
    label.textContent = 'Prize Pool';

    stakes.appendChild(amt);
    stakes.appendChild(label);

    card.appendChild(info);
    card.appendChild(stakes);
    container.appendChild(card);
  });
}

function loadTourneyDetails(id) {
  const tourney = TOURNAMENTS.find(t => t.id === id);
  const detailInitial = document.getElementById('tourney-detail-initial');
  const detailActive = document.getElementById('tourney-detail-active');

  if (!tourney || !detailActive) return;

  if (detailInitial) detailInitial.classList.add('hidden');
  detailActive.classList.remove('hidden');

  document.getElementById('active-tourney-title').textContent = tourney.name;
  document.getElementById('active-tourney-meta').textContent = `${tourney.game} • Draft: ${tourney.draft} • Stake: $${tourney.prize}`;
  document.getElementById('active-tourney-draft-desc').textContent = `Roster Drafting Method: ${tourney.draft.toUpperCase()}`;

  // Renders logs
  const logContainer = document.getElementById('tourney-draft-log');
  if (logContainer) {
    logContainer.innerHTML = '';
    tourney.draftLog.forEach(log => {
      const row = document.createElement('div');
      row.className = 'chat-message';
      row.innerHTML = `<span class="chat-system-message" style="text-align:left; color:var(--color-text-muted);">${log}</span>`;
      logContainer.appendChild(row);
    });
  }

  // Renders visual Bracket columns
  const treeContainer = document.getElementById('bracket-viewer-tree');
  if (treeContainer) {
    treeContainer.innerHTML = '';
    const wrapper = document.createElement('div');
    wrapper.className = 'bracket-rounds-wrapper';

    // Quarterfinals col (Round 1)
    const qCol = document.createElement('div');
    qCol.className = 'bracket-round-col';
    const qMatches = tourney.matches.filter(m => m.round === 1);
    qMatches.forEach(m => {
      qCol.appendChild(createMatchupBox(m));
    });
    wrapper.appendChild(qCol);

    // Semifinals col (Round 2)
    const sCol = document.createElement('div');
    sCol.className = 'bracket-round-col';
    const sMatches = tourney.matches.filter(m => m.round === 2);
    if (sMatches.length > 0) {
      sMatches.forEach(m => sCol.appendChild(createMatchupBox(m)));
    } else {
      sCol.innerHTML = `
        <div class="matchup-box" style="opacity: 0.35;"><div class="matchup-participant-row">TBD</div><div class="matchup-participant-row">TBD</div></div>
        <div class="matchup-box" style="opacity: 0.35;"><div class="matchup-participant-row">TBD</div><div class="matchup-participant-row">TBD</div></div>
      `;
    }
    wrapper.appendChild(sCol);

    // Finals col (Round 3)
    const fCol = document.createElement('div');
    fCol.className = 'bracket-round-col';
    const fMatch = tourney.matches.find(m => m.round === 3);
    if (fMatch) {
      fCol.appendChild(createMatchupBox(m => createMatchupBox(fMatch)));
      fCol.innerHTML = '';
      fCol.appendChild(createMatchupBox(fMatch));
    } else {
      fCol.innerHTML = `<div class="matchup-box" style="opacity: 0.35;"><div class="matchup-participant-row">TBD</div><div class="matchup-participant-row">TBD</div></div>`;
    }
    wrapper.appendChild(fCol);

    treeContainer.appendChild(wrapper);
  }
}

function createMatchupBox(match) {
  const box = document.createElement('div');
  box.className = 'matchup-box';

  const row1 = document.createElement('div');
  row1.className = `matchup-participant-row ${match.winner === match.p1 ? 'winner-row' : ''}`;
  row1.innerHTML = `<span>${match.p1}</span> <span class="matchup-score ${match.winner === match.p1 ? 'winner-highlight' : ''}">${match.s1}</span>`;

  const row2 = document.createElement('div');
  row2.className = `matchup-participant-row ${match.winner === match.p2 ? 'winner-row' : ''}`;
  row2.innerHTML = `<span>${match.p2}</span> <span class="matchup-score ${match.winner === match.p2 ? 'winner-highlight' : ''}">${match.s2}</span>`;

  box.appendChild(row1);
  box.appendChild(row2);
  return box;
}

/* ==========================================================================
   17. Community Forum Engine (Categorized Thread replies & OPs)
   ========================================================================== */
let DEFAULT_FORUM_THREADS = [
  {
    id: 'thread-1',
    title: 'Why the ultra-rich don\'t "give back" (and what happens when they pretend to)',
    category: 'Reform',
    author: 'Socrates_99',
    body: 'We are told billionaire charity saves the world. But look at the numbers. Private family foundations allow billionaires to bypass taxes, direct social programs to their personal whims (like charter schools), and keep 95% of the assets compounding tax-free in the stock market. True giving is not charity; it is surrendering control of the assets back to workers and communities via land trusts and co-ops.',
    replies: [
      { author: 'Citizen_X', text: 'This is the most critical post here. Philanthropic foundations are just tax shields that preserve dynastic control.' },
      { author: 'LobbyWatcher', text: 'Exactly. If they really wanted to give back, they would stop lobbying for corporate tax breaks.' }
    ],
    date: '1 hour ago',
    upvotes: 48
  },
  {
    id: 'thread-2',
    title: 'Why the FICO credit system is fundamentally rigged',
    category: 'Mutual Aid',
    author: 'DebtDisputer_99',
    body: 'The FICO system is designed as a compliance indicator. It does not measure wealth; it measures how profitable you are to credit card companies. If you carry debt and pay interest, you are valued. If you live debt-free, you are invisible. We need a P2P Mutual Credit ledger to declare our own community trustworthiness!',
    replies: [
      { author: 'Citizen_X', text: 'Agree. The utilization ratio is particularly ridiculous. If I use my own money, why does it drop my score?' }
    ],
    date: '2 hours ago',
    upvotes: 24
  }
];

let FORUM_THREADS = JSON.parse(localStorage.getItem('FORUM_THREADS')) || DEFAULT_FORUM_THREADS;

let activeThreadId = 'thread-1';
let forumCategoryFilter = 'all';

function initForum() {
  const threadForm = document.getElementById('forum-thread-form');
  const tAuthor = document.getElementById('thread-author');
  const tTitle = document.getElementById('thread-title');
  const tCategory = document.getElementById('thread-category');
  const tBody = document.getElementById('thread-body');

  const replyForm = document.getElementById('thread-reply-form');
  const rAuthor = document.getElementById('reply-author');
  const rText = document.getElementById('reply-text');

  const btnClose = document.getElementById('btn-close-thread-view');

  if (!threadForm || !replyForm) return;

  // Category filters
  const filterButtons = document.querySelectorAll('#forum-filter-bar button');
  filterButtons.forEach(btn => {
    btn.addEventListener('click', () => {
      filterButtons.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      forumCategoryFilter = btn.getAttribute('data-forum-filter');
      renderForumThreads();
    });
  });

  threadForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const id = 'thread-' + (FORUM_THREADS.length + 1);
    const author = tAuthor.value;
    
    FORUM_THREADS.unshift({
      id: id,
      title: tTitle.value,
      category: tCategory.value,
      author: author,
      body: tBody.value,
      replies: [],
      date: 'Just now',
      upvotes: 1
    });

    tTitle.value = '';
    tBody.value = '';
    
    // Reward reputation (+15 Rep!)
    rewardUserReputation(author, 15);

    localStorage.setItem('FORUM_THREADS', JSON.stringify(FORUM_THREADS));
    renderForumThreads();
    const leaderboardList = document.getElementById('reputation-leaderboard-list');
    if (leaderboardList && typeof renderLeaderboard === 'function') renderLeaderboard();
  });

  replyForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const thread = FORUM_THREADS.find(t => t.id === activeThreadId);
    if (!thread) return;

    const author = rAuthor.value;
    thread.replies.push({
      author: author,
      text: rText.value
    });

    rText.value = '';
    
    // Reward reputation (+10 Rep!)
    rewardUserReputation(author, 10);

    localStorage.setItem('FORUM_THREADS', JSON.stringify(FORUM_THREADS));
    loadThreadDetails(activeThreadId);
    renderForumThreads();
    const leaderboardList = document.getElementById('reputation-leaderboard-list');
    if (leaderboardList && typeof renderLeaderboard === 'function') renderLeaderboard();
  });

  if (btnClose) {
    btnClose.addEventListener('click', () => {
      document.getElementById('forum-thread-detail-panel').classList.add('hidden');
    });
  }

  // Draw list
  renderForumThreads();
}

function renderForumThreads() {
  const container = document.getElementById('forum-threads-list');
  if (!container) return;

  container.innerHTML = '';

  const filtered = FORUM_THREADS.filter(t => {
    if (forumCategoryFilter === 'all') return true;
    return t.category === forumCategoryFilter;
  });

  // Sort threads by upvotes descending
  filtered.sort((a, b) => (b.upvotes || 0) - (a.upvotes || 0));

  filtered.forEach(t => {
    const row = document.createElement('div');
    row.className = 'thread-row-item';
    row.style.display = 'flex';
    row.style.alignItems = 'center';
    
    row.addEventListener('click', () => {
      activeThreadId = t.id;
      loadThreadDetails(t.id);
    });

    // Left upvote controller
    const upvoteBtn = document.createElement('button');
    upvoteBtn.className = 'upvote-btn';
    upvoteBtn.style.cssText = 'padding: 0.2rem 0.5rem; margin-right: 0.75rem; font-size: 0.75rem;';
    upvoteBtn.innerHTML = `▲ <span class="thread-up-count">${t.upvotes || 0}</span>`;
    upvoteBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      t.upvotes = (t.upvotes || 0) + 1;
      upvoteBtn.querySelector('.thread-up-count').textContent = t.upvotes;
      rewardUserReputation(t.author, 15);
      localStorage.setItem('FORUM_THREADS', JSON.stringify(FORUM_THREADS));
      renderForumThreads();
    });

    const info = document.createElement('div');
    info.className = 'thread-row-info';
    info.style.flex = '1';

    const title = document.createElement('span');
    title.className = 'thread-row-title';
    title.textContent = t.title;

    const meta = document.createElement('span');
    meta.className = 'thread-row-meta';
    meta.innerHTML = `
      <span class="genre-badge genre-political" style="font-size:0.65rem; margin-top:0;">${t.category}</span>
      <span>By ${t.author}</span>
      <span>${t.date}</span>
    `;

    info.appendChild(title);
    info.appendChild(meta);

    const replies = document.createElement('div');
    replies.className = 'thread-row-actions';

    const count = document.createElement('span');
    count.className = 'thread-comment-count';
    count.textContent = `${t.replies.length} replies`;

    replies.appendChild(count);

    row.appendChild(upvoteBtn);
    row.appendChild(info);
    row.appendChild(replies);
    container.appendChild(row);
  });
}

function loadThreadDetails(id) {
  const thread = FORUM_THREADS.find(t => t.id === id);
  const detailPanel = document.getElementById('forum-thread-detail-panel');

  if (!thread || !detailPanel) return;

  detailPanel.classList.remove('hidden');
  detailPanel.scrollIntoView({ behavior: 'smooth' });

  document.getElementById('active-thread-title').textContent = thread.title;
  document.getElementById('active-thread-tag').textContent = thread.category;
  document.getElementById('active-thread-author').textContent = `Started by @${thread.author} • ${thread.date}`;
  document.getElementById('active-thread-op-body').textContent = thread.body;

  const repliesContainer = document.getElementById('thread-replies-list');
  if (repliesContainer) {
    repliesContainer.innerHTML = '';
    
    if (thread.replies.length === 0) {
      repliesContainer.innerHTML = '<div class="chat-system-message">No comments yet. Start the conversation!</div>';
      return;
    }

    thread.replies.forEach(r => {
      const msg = document.createElement('div');
      msg.className = 'chat-message';
      msg.innerHTML = `<span class="chat-user">@${r.author}:</span> <span class="chat-text" style="color:var(--color-text);">${r.text}</span>`;
      repliesContainer.appendChild(msg);
    });
    repliesContainer.scrollTop = repliesContainer.scrollHeight;
  }
}

/* ==========================================================================
   18. Supabase Auth Controller
   ========================================================================== */
let SUPABASE_USER = {
  authenticated: false,
  email: '',
  name: 'Guest'
};

function initSupabaseAuth() {
  const trigger = document.getElementById('btn-auth-trigger');
  const modal = document.getElementById('supabase-auth-modal');
  const btnClose = document.getElementById('btn-close-auth');
  
  const tabLogin = document.getElementById('auth-tab-login');
  const tabSignup = document.getElementById('auth-tab-signup');
  const loginForm = document.getElementById('auth-login-form');
  const signupForm = document.getElementById('auth-signup-form');

  if (!trigger || !modal) return;

  trigger.addEventListener('click', () => {
    modal.classList.remove('hidden');
  });

  const closeModal = () => modal.classList.add('hidden');
  if (btnClose) btnClose.addEventListener('click', closeModal);

  if (tabLogin && tabSignup && loginForm && signupForm) {
    tabLogin.addEventListener('click', () => {
      tabLogin.classList.add('active');
      tabSignup.classList.remove('active');
      loginForm.classList.remove('hidden');
      signupForm.classList.add('hidden');
    });

    tabSignup.addEventListener('click', () => {
      tabSignup.classList.add('active');
      tabLogin.classList.remove('active');
      signupForm.classList.remove('hidden');
      loginForm.classList.add('hidden');
    });
  }

  // Handle Login
  loginForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const email = document.getElementById('login-email').value;
    
    SUPABASE_USER = {
      authenticated: true,
      email: email,
      name: email.split('@')[0]
    };

    updateGlobalHandles();
    trigger.textContent = `👤 @${SUPABASE_USER.name}`;
    trigger.style.color = 'var(--color-green)';
    trigger.style.borderColor = 'var(--color-green)';
    alert(`Logged in successfully via Supabase! Connected as @${SUPABASE_USER.name}.`);
    closeModal();
  });

  // Handle Signup
  signupForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const email = document.getElementById('signup-email').value;
    const name = document.getElementById('signup-name').value.trim();

    SUPABASE_USER = {
      authenticated: true,
      email: email,
      name: name.replace('@', '')
    };

    updateGlobalHandles();
    trigger.textContent = `👤 @${SUPABASE_USER.name}`;
    trigger.style.color = 'var(--color-green)';
    trigger.style.borderColor = 'var(--color-green)';
    alert(`Account created and authenticated via Supabase! Welcome @${SUPABASE_USER.name}.`);
    closeModal();
  });
}

function updateGlobalHandles() {
  const username = SUPABASE_USER.name;
  
  // Update inputs across composer/reply interfaces
  const composer = document.getElementById('composer-handle');
  if (composer) composer.value = username;

  const reply = document.getElementById('reply-author');
  if (reply) reply.value = username;

  const thread = document.getElementById('thread-author');
  if (thread) thread.value = username;

  const borrow = document.getElementById('borrow-name');
  if (borrow) borrow.value = username;

  const feedUsername = document.getElementById('post-username');
  if (feedUsername) feedUsername.value = username;
}

/* ==========================================================================
   19. Live Loop Feed (X / Twitter Clone)
   ========================================================================== */
let LIVE_FEED_POSTS = JSON.parse(localStorage.getItem('LIVE_FEED_POSTS')) || [
  {
    id: 1,
    author: 'Socrates_99',
    tag: 'PikettyLoop',
    body: 'Capital returns (r) are systematically outgrowing active wages (g). Local mutual credit and cooperatives are the only way to build real neighborhood resilience.',
    time: '5m ago',
    upvotes: 42,
    downvotes: 2
  },
  {
    id: 2,
    author: 'LobbyWatcher',
    tag: 'BanishLobbying',
    body: 'Campaign finance spending under Citizens United converted democratic speech into commercial auctions. We need a direct public funding amendment.',
    time: '18m ago',
    upvotes: 28,
    downvotes: 1
  },
  {
    id: 3,
    author: 'DebtDisputer_99',
    tag: 'DirectMutualCredit',
    body: 'Every dollar bank-lent is debt-ridden. Peer mutual credit registers eliminate fractional reserve extraction and keep cash local.',
    time: '1h ago',
    upvotes: 19,
    downvotes: 3
  }
];

function initLiveFeed() {
  const composerForm = document.getElementById('feed-post-composer');
  const compText = document.getElementById('composer-text');
  const charCounter = document.getElementById('composer-char-counter');

  if (!composerForm) return;

  if (compText && charCounter) {
    compText.addEventListener('input', () => {
      const remaining = 280 - compText.value.length;
      charCounter.textContent = `${remaining} characters remaining`;
    });
  }

  composerForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const handle = document.getElementById('composer-handle').value;
    const tag = document.getElementById('composer-tag').value;
    const text = compText.value;

    LIVE_FEED_POSTS.unshift({
      id: LIVE_FEED_POSTS.length + 1,
      author: handle.replace('@', ''),
      tag: tag,
      body: text,
      time: 'Just now',
      upvotes: 1,
      downvotes: 0
    });

    compText.value = '';
    if (charCounter) charCounter.textContent = '280 characters remaining';
    
    localStorage.setItem('LIVE_FEED_POSTS', JSON.stringify(LIVE_FEED_POSTS));
    renderLiveFeed();
  });

  window.upvoteFeedPost = (id) => {
    const post = LIVE_FEED_POSTS.find(p => p.id === id);
    if (post) {
      post.upvotes++;
      localStorage.setItem('LIVE_FEED_POSTS', JSON.stringify(LIVE_FEED_POSTS));
      renderLiveFeed();
    }
  };

  window.downvoteFeedPost = (id) => {
    const post = LIVE_FEED_POSTS.find(p => p.id === id);
    if (post) {
      post.downvotes++;
      localStorage.setItem('LIVE_FEED_POSTS', JSON.stringify(LIVE_FEED_POSTS));
      renderLiveFeed();
    }
  };

  renderLiveFeed();
}

function renderLiveFeed() {
  const container = document.getElementById('live-feed-stream');
  if (!container) return;

  container.innerHTML = '';

  LIVE_FEED_POSTS.forEach(post => {
    const item = document.createElement('div');
    item.className = 'card';
    item.style.cssText = 'padding:1rem; border:1px solid var(--color-border); border-radius:8px; display:flex; flex-direction:column; gap:0.5rem; background:rgba(255,255,255,0.02);';
    item.innerHTML = `
      <div style="display:flex; justify-content:space-between; align-items:center; font-size:0.8rem; color:var(--color-text-muted);">
        <span><strong style="color:#fff;">@${post.author}</strong> <span style="color:var(--color-blue); margin-left:0.4rem;">#${post.tag}</span></span>
        <span>${post.time}</span>
      </div>
      <p style="font-size:0.85rem; line-height:1.4; color:var(--color-text); margin:0.25rem 0;">${post.body}</p>
      <div style="display:flex; gap:1rem; font-size:0.75rem; color:var(--color-text-muted); margin-top:0.4rem;">
        <button style="background:transparent; border:none; color:var(--color-green); cursor:pointer; font-weight:bold;" onclick="upvoteFeedPost(${post.id})">👍 ${post.upvotes}</button>
        <button style="background:transparent; border:none; color:var(--color-red); cursor:pointer; font-weight:bold;" onclick="downvoteFeedPost(${post.id})">👎 ${post.downvotes}</button>
      </div>
    `;
    container.appendChild(item);
  });
}

/* ==========================================================================
   20. Submissions Hub & Voting Arena (Decentralized Approvals)
   ========================================================================== */
let PENDING_DEV_APPS = JSON.parse(localStorage.getItem('PENDING_DEV_APPS')) || [
  { id: 1, title: 'OpenLobby Ledger', desc: 'Saves active senate lobbying logs to decentralized Web3 chains.', url: 'https://openlobby.io', tag: 'Transparency', upvotes: 3 },
  { id: 2, title: 'CoopExchange Hub', desc: 'P2P commodity exchange for independent worker-owned co-ops.', url: 'https://coopexchange.org', tag: 'Mutual Aid', upvotes: 4 }
];

let PENDING_GIGS = JSON.parse(localStorage.getItem('PENDING_GIGS')) || [
  { id: 1, title: 'Draft Community Charter', category: 'Writing', bounty: 60, desc: 'Draft the mutual aid bylaws for the Echo Park community fridge coalition.', upvotes: 4 },
  { id: 2, title: 'Build Open Source Lobby Map', category: 'Digital', bounty: 180, desc: 'Create an interactive D3.js node map linking donors to specific congressional bills.', upvotes: 2 }
];

function initSubmissionsHub() {
  // Override suggest topic upvote from Phase 9 to also trigger approvals here
  const originalRenderSuggested = renderSuggestedTopics;
  renderSuggestedTopics = function() {
    originalRenderSuggested();
    renderVotingDebates();
  };

  window.upvoteSubmissionDebate = (idx) => {
    const topic = SUGGESTED_TOPICS[idx];
    if (!topic) return;
    
    topic.upvotes++;
    if (topic.upvotes >= 5) {
      topic.status = 'approved';
      const uniqueVal = 'custom-' + idx;
      const exists = DEFAULT_DEBATE_TOPICS[topic.genre].some(t => t.value === uniqueVal);
      if (!exists) {
        DEFAULT_DEBATE_TOPICS[topic.genre].push({ value: uniqueVal, text: topic.text });
        renderDebateTopics();
        alert(`Debate Topic approved! "${topic.text}" is now selectable in the Debate Arena.`);
      }
    }
    
    localStorage.setItem('SUGGESTED_TOPICS', JSON.stringify(SUGGESTED_TOPICS));
    renderSuggestedTopics();
  };

  window.upvoteSubmissionDev = (id) => {
    const app = PENDING_DEV_APPS.find(p => p.id === id);
    if (!app) return;

    app.upvotes++;
    if (app.upvotes >= 5) {
      DEV_PROJECTS.push({
        id: DEV_PROJECTS.length + 1,
        title: app.title,
        desc: app.desc,
        url: app.url,
        tag: app.tag,
        upvotes: 5
      });
      // Remove from pending
      PENDING_DEV_APPS = PENDING_DEV_APPS.filter(p => p.id !== id);
      alert(`Developer App approved! "${app.title}" has been integrated into the Developer Hub showcase.`);
      if (window.renderDevGallery) window.renderDevGallery();
    }

    localStorage.setItem('PENDING_DEV_APPS', JSON.stringify(PENDING_DEV_APPS));
    renderVotingDevs();
  };

  window.upvoteSubmissionGig = (id) => {
    const gig = PENDING_GIGS.find(g => g.id === id);
    if (!gig) return;

    gig.upvotes++;
    if (gig.upvotes >= 5) {
      LOCAL_GIGS.unshift({
        id: LOCAL_GIGS.length + 1,
        title: gig.title,
        category: gig.category,
        bounty: gig.bounty,
        desc: gig.desc,
        status: 'Open',
        worker: null
      });
      // Remove from pending
      PENDING_GIGS = PENDING_GIGS.filter(g => g.id !== id);
      alert(`Micro-Gig approved! "${gig.title}" is now open for claims on the Local Board Tasks board.`);
      // redraw local Board gigs
      const localBoardContainer = document.getElementById('local-gigs-list');
      if (localBoardContainer && typeof renderGigs === 'function') renderGigs();
    }

    localStorage.setItem('PENDING_GIGS', JSON.stringify(PENDING_GIGS));
    renderVotingGigs();
  };

  // Listen to debate submissions from Phase 9 proposed form
  const originalProposeForm = initProposeTopicForm;
  initProposeTopicForm = function() {
    originalProposeForm();
    const form = document.getElementById('propose-topic-form');
    if (form) {
      form.addEventListener('submit', () => {
        // Redraw lists
        renderVotingDebates();
      });
    }
  };

  // Listen to dev uploads to also insert them into pending devs instead of directly
  const devForm = document.getElementById('dev-upload-form');
  if (devForm) {
    // Replace default submit behavior to send to pending instead of direct
    devForm.addEventListener('submit', (e) => {
      e.stopPropagation();
      e.preventDefault();
      
      const title = document.getElementById('dev-title').value;
      const desc = document.getElementById('dev-desc').value;
      const url = document.getElementById('dev-url').value;
      const tag = document.getElementById('dev-tag').value;

      PENDING_DEV_APPS.push({
        id: PENDING_DEV_APPS.length + 1,
        title: title,
        desc: desc,
        url: url,
        tag: tag,
        upvotes: 1
      });

      document.getElementById('dev-title').value = '';
      document.getElementById('dev-desc').value = '';
      document.getElementById('dev-url').value = '';
      
      localStorage.setItem('PENDING_DEV_APPS', JSON.stringify(PENDING_DEV_APPS));
      renderVotingDevs();
      alert(`Developer Application submitted! It will appear in the Submissions Hub. Upvote it to 5 to approve.`);
    }, true);
  }

  // Listen to local board gig creations to insert into pending instead of directly
  const localGigForm = document.getElementById('local-gig-form');
  if (localGigForm) {
    localGigForm.addEventListener('submit', (e) => {
      e.stopPropagation();
      e.preventDefault();

      const title = document.getElementById('gig-title').value;
      const bounty = parseInt(document.getElementById('gig-bounty').value) || 10;
      const category = document.getElementById('gig-category').value;
      const desc = document.getElementById('gig-desc').value;

      PENDING_GIGS.push({
        id: PENDING_GIGS.length + 1,
        title: title,
        bounty: bounty,
        category: category,
        desc: desc,
        upvotes: 1
      });

      document.getElementById('gig-title').value = '';
      document.getElementById('gig-bounty').value = '';
      document.getElementById('gig-desc').value = '';

      localStorage.setItem('PENDING_GIGS', JSON.stringify(PENDING_GIGS));
      renderVotingGigs();
      alert(`Micro-Gig task submitted! It will appear in the Submissions Hub. Upvote it to 5 to approve.`);
    }, true);
  }

  renderVotingDebates();
  renderVotingDevs();
  renderVotingGigs();
  if (typeof renderVotingMarkets === 'function') renderVotingMarkets();
}

function renderVotingDebates() {
  const container = document.getElementById('voting-debate-list');
  if (!container) return;
  container.innerHTML = '';

  const pending = SUGGESTED_TOPICS.filter(t => t.status === 'pending');
  if (pending.length === 0) {
    container.innerHTML = '<div class="chat-system-message">No pending debate topics.</div>';
    return;
  }

  pending.forEach((topic, idx) => {
    const item = document.createElement('div');
    item.className = 'loan-card';
    item.style.padding = '0.75rem';
    item.innerHTML = `
      <div class="loan-card-info" style="gap:0.15rem;">
        <span class="reg-folder-title" style="font-size:0.85rem;">"${topic.text}"</span>
        <span class="genre-badge genre-${topic.genre}" style="width:fit-content; font-size:0.6rem; padding:0.1rem 0.3rem;">${topic.genre}</span>
      </div>
      <div class="loan-card-actions">
        <button class="upvote-btn" style="padding:0.2rem 0.5rem; font-size:0.7rem;" onclick="upvoteSubmissionDebate(${idx})">
          ▲ Upvote (<span style="font-weight:bold;">${topic.upvotes}/5</span>)
        </button>
      </div>
    `;
    container.appendChild(item);
  });
}

function renderVotingDevs() {
  const container = document.getElementById('voting-dev-list');
  if (!container) return;
  container.innerHTML = '';

  if (PENDING_DEV_APPS.length === 0) {
    container.innerHTML = '<div class="chat-system-message">No pending developer apps.</div>';
    return;
  }

  PENDING_DEV_APPS.forEach(app => {
    const item = document.createElement('div');
    item.className = 'loan-card';
    item.style.padding = '0.75rem';
    item.innerHTML = `
      <div class="loan-card-info" style="gap:0.15rem;">
        <span class="reg-folder-title" style="font-size:0.85rem;">${app.title}</span>
        <span class="loan-details-meta" style="font-size:0.72rem; line-height:1.2; display:block;">${app.desc}</span>
        <span class="genre-badge genre-political" style="width:fit-content; font-size:0.6rem; padding:0.1rem 0.3rem;">${app.tag}</span>
      </div>
      <div class="loan-card-actions">
        <button class="upvote-btn" style="padding:0.2rem 0.5rem; font-size:0.7rem;" onclick="upvoteSubmissionDev(${app.id})">
          ▲ Upvote (<span style="font-weight:bold;">${app.upvotes}/5</span>)
        </button>
      </div>
    `;
    container.appendChild(item);
  });
}

function renderVotingGigs() {
  const container = document.getElementById('voting-gigs-list');
  if (!container) return;
  container.innerHTML = '';

  if (PENDING_GIGS.length === 0) {
    container.innerHTML = '<div class="chat-system-message">No pending micro-gigs.</div>';
    return;
  }

  PENDING_GIGS.forEach(gig => {
    const item = document.createElement('div');
    item.className = 'loan-card';
    item.style.padding = '0.75rem';
    item.innerHTML = `
      <div class="loan-card-info" style="gap:0.15rem;">
        <span class="reg-folder-title" style="font-size:0.85rem;">${gig.title} ($${gig.bounty})</span>
        <span class="loan-details-meta" style="font-size:0.72rem; line-height:1.2; display:block;">${gig.desc}</span>
        <span class="genre-badge genre-fun" style="width:fit-content; font-size:0.6rem; padding:0.1rem 0.3rem;">${gig.category}</span>
      </div>
      <div class="loan-card-actions">
        <button class="upvote-btn" style="padding:0.2rem 0.5rem; font-size:0.7rem;" onclick="upvoteSubmissionGig(${gig.id})">
          ▲ Upvote (<span style="font-weight:bold;">${gig.upvotes}/5</span>)
        </button>
      </div>
    `;
    container.appendChild(item);
  });
}

/* ==========================================================================
   21. Billionaire Tax Loophole Simulator
   ========================================================================== */
function initBillionaireLoopholeSimulator() {
  const incomeInput = document.getElementById('loop-income');
  const sourceSelect = document.getElementById('loop-source');
  
  const chkBuyBorrow = document.getElementById('chk-buy-borrow');
  const chkOffshore = document.getElementById('chk-offshore');
  const chkFoundation = document.getElementById('chk-foundation');
  
  const outputPanel = document.getElementById('loop-output-panel');

  if (!incomeInput || !sourceSelect || !outputPanel) return;

  const calculateTax = () => {
    const income = parseFloat(incomeInput.value) || 0;
    const isW2 = sourceSelect.value === 'w2';
    
    // W-2 pays 37% federal rate on income over $600k + state (approx 45% flat for high-earning bracket)
    // Assets pays 20% capital gains rate
    const baseRate = isW2 ? 0.45 : 0.20;
    const baseTax = income * baseRate;
    
    let activeLoopholes = [];
    let reductionFactor = 1.0;
    let rateExplanation = '';
    
    // Loophole adjustments
    if (isW2) {
      // W-2 earners cannot use these loopholes because taxes are withheld by payroll
      chkBuyBorrow.disabled = true;
      chkOffshore.disabled = true;
      chkFoundation.disabled = true;
      
      chkBuyBorrow.checked = false;
      chkOffshore.checked = false;
      chkFoundation.checked = false;
      
      rateExplanation = `W-2 wages are subject to mandatory employer withholding. As a salary earner, you cannot write off personal assets, shelter royalties offshore, or borrow against wages interest-free. You pay the full <strong>45%</strong> marginal rate.`;
    } else {
      chkBuyBorrow.disabled = false;
      chkOffshore.disabled = false;
      chkFoundation.disabled = false;

      rateExplanation = `Asset appreciation is legally untaxed until sold. This allows you to apply billionaire asset preservation strategies.`;
      
      if (chkBuyBorrow.checked) {
        reductionFactor = 0.0; // Buy, Borrow, Die drops effective income to 0
        activeLoopholes.push('Buy, Borrow, Die (Portfolio Lending)');
      } else {
        if (chkOffshore.checked) {
          reductionFactor -= 0.40;
          activeLoopholes.push('Offshore IP royalties shelter');
        }
        if (chkFoundation.checked) {
          reductionFactor -= 0.30;
          activeLoopholes.push('Family Foundation stock write-off');
        }
      }
    }
    
    reductionFactor = Math.max(0.0, reductionFactor);
    const finalTax = baseTax * reductionFactor;
    const effectiveRate = income > 0 ? (finalTax / income) * 100 : 0;
    const savings = baseTax - finalTax;
    const netKept = income - finalTax;

    const isLosing = effectiveRate > 15;
    outputPanel.className = `reflection-output ${isLosing ? 'losing' : 'winning'}`;
    
    let loopholesHTML = '';
    if (activeLoopholes.length > 0) {
      loopholesHTML = `
        <p style="margin-top:0.5rem; font-size:0.8rem; color:#fff;"><strong>Loopholes Applied:</strong></p>
        <ul style="padding-left:1rem; font-size:0.78rem; color:var(--color-text-muted); margin-top:0.25rem;">
          ${activeLoopholes.map(loop => `<li>✅ ${loop}</li>`).join('')}
        </ul>
      `;
    }

    outputPanel.innerHTML = `
      <div class="reflection-header">
        <span class="reflection-badge ${isLosing ? 'badge-losing' : 'badge-winning'}">
          ${isLosing ? 'Standard Tax Rate' : 'Billionaire Status'}
        </span>
        <span class="reflection-title" style="${isLosing ? 'color:var(--color-red);' : 'color:var(--color-green);'}">
          ${effectiveRate.toFixed(1)}% Effective Rate
        </span>
      </div>
      <div class="reflection-text">
        <p><strong>Base Tax Rate:</strong> ${(baseRate * 100).toFixed(0)}%</p>
        <p><strong>Standard Liability:</strong> $${Math.round(baseTax).toLocaleString()}</p>
        <p style="margin-top:0.4rem;"><strong>Final Tax Due:</strong> $${Math.round(finalTax).toLocaleString()}</p>
        <p><strong>Net Cash Kept:</strong> $${Math.round(netKept).toLocaleString()}</p>
        <p style="color:var(--color-green); font-weight:bold; margin-top:0.4rem;">Net Tax Savings: $${Math.round(savings).toLocaleString()}</p>
        ${loopholesHTML}
        <p class="margin-top-small" style="font-size:0.8rem; line-height:1.4; color:var(--color-text-muted); border-top:1px solid rgba(255,255,255,0.05); padding-top:0.5rem;">
          ${rateExplanation}
        </p>
      </div>
    `;
  };

  incomeInput.addEventListener('input', calculateTax);
  sourceSelect.addEventListener('change', calculateTax);
  
  chkBuyBorrow.addEventListener('change', calculateTax);
  chkOffshore.addEventListener('change', calculateTax);
  chkFoundation.addEventListener('change', calculateTax);

  // Initial calculation
  calculateTax();
}

/* ==========================================================================
   22. resolve.bet Prediction Markets System
   ========================================================================== */
let CITIZEN_WALLET = parseFloat(localStorage.getItem('CITIZEN_WALLET')) || 2500.0;

let DEFAULT_PREDICTION_CONTRACTS = [
  { id: 1, question: "Will the FTC block the Kroger-Albertsons supermarket merger by Oct 2026?", category: "FTC", yesOdds: 65, totalPool: 15000 },
  { id: 2, question: "Will the compute-limit threshold for frontier AI training be reduced to 10^24 FLOPs?", category: "SEC", yesOdds: 42, totalPool: 9000 },
  { id: 3, question: "Will campaign finance limits be capped under a public election funding amendment?", category: "FEC", yesOdds: 15, totalPool: 24000 }
];

let PREDICTION_CONTRACTS = JSON.parse(localStorage.getItem('PREDICTION_CONTRACTS')) || DEFAULT_PREDICTION_CONTRACTS;
let USER_POSITIONS = JSON.parse(localStorage.getItem('USER_POSITIONS')) || [];
let PENDING_MARKETS = JSON.parse(localStorage.getItem('PENDING_MARKETS')) || [
  { id: 1, question: "Will the EPA mandate 60% EV vehicle production by 2030?", category: "EPA", upvotes: 3 }
];

function initPredictionMarkets() {
  const contractsList = document.getElementById('prediction-contracts-list');
  const positionsList = document.getElementById('market-positions-list');
  const walletDisplay = document.getElementById('market-wallet-display');
  const proposeForm = document.getElementById('propose-market-form');

  if (!contractsList || !proposeForm) return;

  const updateWalletDisplay = () => {
    if (walletDisplay) walletDisplay.textContent = `$${CITIZEN_WALLET.toLocaleString(undefined, {minimumFractionDigits: 2, maximumFractionDigits: 2})}`;
    localStorage.setItem('CITIZEN_WALLET', CITIZEN_WALLET.toString());
  };

  const renderContracts = () => {
    contractsList.innerHTML = '';
    PREDICTION_CONTRACTS.forEach(contract => {
      const card = document.createElement('div');
      card.className = 'card';
      card.style.cssText = 'padding:1.25rem; border:1px solid var(--color-border); border-radius:10px; background:rgba(0,0,0,0.2); display:flex; flex-direction:column; gap:0.75rem;';
      
      const noOdds = 100 - contract.yesOdds;
      const yesPayout = (100 / contract.yesOdds).toFixed(2);
      const noPayout = (100 / noOdds).toFixed(2);

      card.innerHTML = `
        <div style="display:flex; justify-content:space-between; align-items:center; font-size:0.75rem; color:var(--color-text-muted);">
          <span class="genre-badge genre-political">#${contract.category} Market</span>
          <span>Liquidity Pool: $${contract.totalPool.toLocaleString()}</span>
        </div>
        <h4 style="font-size:1.05rem; margin:0.25rem 0; color:#fff; line-height:1.35;">${contract.question}</h4>
        
        <!-- Odds Bars -->
        <div>
          <div style="display:flex; justify-content:space-between; font-size:0.8rem; font-weight:bold; margin-bottom:4px;">
            <span style="color:var(--color-green);">Yes: ${contract.yesOdds}% (pays $${yesPayout})</span>
            <span style="color:var(--color-red);">No: ${noOdds}% (pays $${noPayout})</span>
          </div>
          <div style="height:8px; background:rgba(255,255,255,0.05); border-radius:10px; overflow:hidden; display:flex;">
            <div style="background:var(--color-green); width:${contract.yesOdds}%; height:100%; transition:width 0.3s ease;"></div>
            <div style="background:var(--color-red); width:${noOdds}%; height:100%; transition:width 0.3s ease;"></div>
          </div>
        </div>

        <!-- Action Bet controls -->
        <div style="display:flex; gap:0.8rem; align-items:center; margin-top:0.25rem;">
          <div class="input-group" style="margin:0; width:100px;">
            <input type="number" id="wager-amt-${contract.id}" value="50" min="5" max="${CITIZEN_WALLET}" style="padding:0.35rem; background:rgba(0,0,0,0.4); border:1px solid var(--color-border); color:#fff; border-radius:4px; font-size:0.8rem;">
          </div>
          <button class="btn btn-primary" style="flex:1; padding:0.4rem; font-size:0.8rem; background:var(--color-green); border-color:var(--color-green);" onclick="placeMarketBet(${contract.id}, 'Yes')">
            Buy YES
          </button>
          <button class="btn btn-primary" style="flex:1; padding:0.4rem; font-size:0.8rem; background:var(--color-red); border-color:var(--color-red);" onclick="placeMarketBet(${contract.id}, 'No')">
            Buy NO
          </button>
        </div>
      `;
      contractsList.appendChild(card);
    });
  };

  const renderPositions = () => {
    if (!positionsList) return;
    positionsList.innerHTML = '';
    
    if (USER_POSITIONS.length === 0) {
      positionsList.innerHTML = '<div class="chat-system-message">No active positions. Make a wager on resolve.bet markets to build leverage!</div>';
      return;
    }

    USER_POSITIONS.forEach((pos, idx) => {
      const contract = PREDICTION_CONTRACTS.find(c => c.id === pos.contractId);
      if (!contract) return;

      const card = document.createElement('div');
      card.className = 'card';
      card.style.cssText = 'padding:0.75rem; font-size:0.78rem; display:flex; flex-direction:column; gap:0.25rem; border-color:rgba(255,255,255,0.05); background:rgba(255,255,255,0.01);';
      card.innerHTML = `
        <div style="display:flex; justify-content:space-between; font-weight:bold;">
          <span style="color:#fff; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; max-width:180px;">${contract.question}</span>
          <span style="color:${pos.outcome === 'Yes' ? 'var(--color-green)' : 'var(--color-red)'};">${pos.outcome.toUpperCase()}</span>
        </div>
        <div style="display:flex; justify-content:space-between; color:var(--color-text-muted); margin-top:2px;">
          <span>Staked: $${pos.amount} (at ${pos.odds}%)</span>
          <span style="color:var(--color-gold); font-weight:bold;">Payout: $${pos.payout.toFixed(2)}</span>
        </div>
        <button class="btn btn-secondary" style="padding:0.15rem; font-size:0.65rem; margin-top:0.3rem;" onclick="sellMarketPosition(${idx})">
          Sell Position
        </button>
      `;
      positionsList.appendChild(card);
    });
  };

  window.placeMarketBet = (contractId, outcome) => {
    const wagerField = document.getElementById(`wager-amt-${contractId}`);
    if (!wagerField) return;

    const amount = parseFloat(wagerField.value) || 0;
    if (amount <= 0 || amount > CITIZEN_WALLET) {
      alert("Invalid wager amount or insufficient balance.");
      return;
    }

    const contract = PREDICTION_CONTRACTS.find(c => c.id === contractId);
    if (!contract) return;

    const rate = outcome === 'Yes' ? contract.yesOdds : (100 - contract.yesOdds);
    const payoutFactor = 100 / rate;
    const potentialPayout = amount * payoutFactor;

    // Deduct balance
    CITIZEN_WALLET -= amount;
    
    // Add position
    USER_POSITIONS.push({
      contractId: contractId,
      outcome: outcome,
      amount: amount,
      odds: rate,
      payout: potentialPayout
    });

    // Shift odds slightly (market impact of the trade)
    const shift = Math.max(1, Math.min(5, Math.round(amount / 100)));
    if (outcome === 'Yes') {
      contract.yesOdds = Math.min(95, contract.yesOdds + shift);
    } else {
      contract.yesOdds = Math.max(5, contract.yesOdds - shift);
    }

    contract.totalPool += amount;

    // Save
    localStorage.setItem('PREDICTION_CONTRACTS', JSON.stringify(PREDICTION_CONTRACTS));
    localStorage.setItem('USER_POSITIONS', JSON.stringify(USER_POSITIONS));
    
    updateWalletDisplay();
    renderContracts();
    renderPositions();
    alert(`Successfully bought $${amount} position in ${outcome.toUpperCase()}! Your leverage is registered.`);
  };

  window.sellMarketPosition = (idx) => {
    const pos = USER_POSITIONS[idx];
    if (!pos) return;

    // Return 85% of staked cash (liquidity fee)
    const returnCash = pos.amount * 0.85;
    CITIZEN_WALLET += returnCash;

    // Remove
    USER_POSITIONS.splice(idx, 1);

    localStorage.setItem('USER_POSITIONS', JSON.stringify(USER_POSITIONS));
    
    updateWalletDisplay();
    renderContracts();
    renderPositions();
    alert(`Sold position for $${returnCash.toFixed(2)} return cash.`);
  };

  // Submit proposal
  proposeForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const q = document.getElementById('market-question').value;
    const cat = document.getElementById('market-category').value;

    PENDING_MARKETS.push({
      id: PENDING_MARKETS.length + 1,
      question: q,
      category: cat,
      upvotes: 1
    });

    document.getElementById('market-question').value = '';
    localStorage.setItem('PENDING_MARKETS', JSON.stringify(PENDING_MARKETS));
    
    renderVotingMarkets();
    alert("Prediction Market proposal submitted! It will appear in the Submissions Hub. Upvote it to 5 to approve.");
  });

  updateWalletDisplay();
  renderContracts();
  renderPositions();
}

function renderVotingMarkets() {
  const container = document.getElementById('voting-markets-list');
  if (!container) return;
  container.innerHTML = '';

  if (PENDING_MARKETS.length === 0) {
    container.innerHTML = '<div class="chat-system-message">No pending prediction markets.</div>';
    return;
  }

  PENDING_MARKETS.forEach(market => {
    const item = document.createElement('div');
    item.className = 'loan-card';
    item.style.padding = '0.75rem';
    item.innerHTML = `
      <div class="loan-card-info" style="gap:0.15rem;">
        <span class="reg-folder-title" style="font-size:0.85rem;">"${market.question}"</span>
        <span class="genre-badge genre-news" style="width:fit-content; font-size:0.6rem; padding:0.1rem 0.3rem;">${market.category}</span>
      </div>
      <div class="loan-card-actions">
        <button class="upvote-btn" style="padding:0.2rem 0.5rem; font-size:0.7rem;" onclick="upvoteSubmissionMarket(${market.id})">
          ▲ Upvote (<span style="font-weight:bold;">${market.upvotes}/5</span>)
        </button>
      </div>
    `;
    container.appendChild(item);
  });
}

window.upvoteSubmissionMarket = (id) => {
  const market = PENDING_MARKETS.find(m => m.id === id);
  if (!market) return;

  market.upvotes++;
  if (market.upvotes >= 5) {
    PREDICTION_CONTRACTS.push({
      id: PREDICTION_CONTRACTS.length + 1,
      question: market.question,
      category: market.category,
      yesOdds: 50,
      totalPool: 5000
    });
    PENDING_MARKETS = PENDING_MARKETS.filter(m => m.id !== id);
    alert(`Prediction Market approved! "${market.question}" is now active in resolve.bet Markets.`);
    // Redraw active lists if current
    const contractsList = document.getElementById('prediction-contracts-list');
    if (contractsList) {
      localStorage.setItem('PREDICTION_CONTRACTS', JSON.stringify(PREDICTION_CONTRACTS));
      initPredictionMarkets();
    }
  }

  localStorage.setItem('PENDING_MARKETS', JSON.stringify(PENDING_MARKETS));
  renderVotingMarkets();
};

/* ==========================================================================
   23. Citizens Reputation Ledger & Live Chat Rooms
   ========================================================================== */
let CITIZEN_REPUTATION = JSON.parse(localStorage.getItem('CITIZEN_REPUTATION')) || [
  { name: 'Socrates_99', rep: 485, tag: 'Elder' },
  { name: 'DebtDisputer_99', rep: 310, tag: 'Activist' },
  { name: 'LobbyWatcher', rep: 245, tag: 'Observer' },
  { name: 'VoxPopuli_33', rep: 180, tag: 'Speaker' },
  { name: 'Citizen_X', rep: 120, tag: 'Contributor' }
];

let LOBBY_CHAT_MESSAGES = JSON.parse(localStorage.getItem('LOBBY_CHAT_MESSAGES')) || [
  { sender: 'Socrates_99', text: 'Welcome to the resolve.bet lobby! Let’s coordinate on campaign funding caps.', time: '10m ago' },
  { sender: 'VoxPopuli_33', text: 'I just upvoted the D3.js Lobby Map app in the submissions hub, it looks awesome.', time: '5m ago' }
];

function initForumLobbyChat() {
  const logContainer = document.getElementById('lobby-chat-log');
  const chatForm = document.getElementById('lobby-chat-form');
  const chatInput = document.getElementById('lobby-chat-input');
  const leaderboardList = document.getElementById('reputation-leaderboard-list');

  if (!logContainer || !chatForm || !chatInput || !leaderboardList) return;

  const renderLeaderboard = () => {
    leaderboardList.innerHTML = '';
    CITIZEN_REPUTATION.sort((a, b) => b.rep - a.rep);
    CITIZEN_REPUTATION.slice(0, 5).forEach((citizen, idx) => {
      const row = document.createElement('div');
      row.style.cssText = 'display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid rgba(255,255,255,0.03); padding-bottom:0.3rem;';
      
      let medal = '👤';
      if (idx === 0) medal = '🥇';
      if (idx === 1) medal = '🥈';
      if (idx === 2) medal = '🥉';

      row.innerHTML = `
        <span>${medal} <strong>@${citizen.name}</strong> <span class="genre-badge genre-fun" style="font-size:0.55rem; padding:0.05rem 0.2rem; margin:0;">${citizen.tag}</span></span>
        <span style="font-weight:bold; color:var(--color-gold);">${citizen.rep} Rep</span>
      `;
      leaderboardList.appendChild(row);
    });
  };

  const renderChat = () => {
    logContainer.innerHTML = '';
    LOBBY_CHAT_MESSAGES.forEach(msg => {
      const row = document.createElement('div');
      row.style.marginBottom = '0.4rem';
      row.innerHTML = `<strong style="color:var(--color-blue); font-size:0.75rem;">@${msg.sender}:</strong> <span style="color:#e2e8f0;">${msg.text}</span>`;
      logContainer.appendChild(row);
    });
    logContainer.scrollTop = logContainer.scrollHeight;
  };

  chatForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const text = chatInput.value.trim();
    if (!text) return;

    const sender = SUPABASE_USER.authenticated ? SUPABASE_USER.name : 'Guest';
    LOBBY_CHAT_MESSAGES.push({
      sender: sender,
      text: text,
      time: 'Just now'
    });

    chatInput.value = '';
    rewardUserReputation(sender, 10);
    localStorage.setItem('LOBBY_CHAT_MESSAGES', JSON.stringify(LOBBY_CHAT_MESSAGES));
    renderChat();
    renderLeaderboard();
  });

  const simulatedQuotes = [
    { sender: 'VoxPopuli_33', text: 'I just staked $200 on the Kroger merger YES contract inside prediction markets!' },
    { sender: 'Socrates_99', text: 'Excellent choice. If the merger goes through, corporate retail lobby wins, but prediction markets hedge citizen risks.' },
    { sender: 'LobbyWatcher', text: 'CFPB late fee caps are currently blocked by a judge in Texas. Check out the President\'s desk trackers.' },
    { sender: 'DebtDisputer_99', text: 'The CC debt simulator taught me how banks make 22% APR off of minimal payments. Absolute eye-opener.' },
    { sender: 'VoxPopuli_33', text: 'Has anyone claimed the open co-op fridge gig on the local board?' },
    { sender: 'Citizen_X', text: 'I just claimed it! Will publish the community charter drafts by tomorrow.' }
  ];

  const triggerSimulatedChat = () => {
    const quote = simulatedQuotes[Math.floor(Math.random() * simulatedQuotes.length)];
    LOBBY_CHAT_MESSAGES.push({
      sender: quote.sender,
      text: quote.text,
      time: 'Just now'
    });
    
    rewardUserReputation(quote.sender, 5);

    if (LOBBY_CHAT_MESSAGES.length > 15) {
      LOBBY_CHAT_MESSAGES.shift();
    }

    localStorage.setItem('LOBBY_CHAT_MESSAGES', JSON.stringify(LOBBY_CHAT_MESSAGES));
    renderChat();
    renderLeaderboard();
  };

  setInterval(triggerSimulatedChat, 18000);

  window.renderLeaderboard = renderLeaderboard;

  renderLeaderboard();
  renderChat();
}

window.rewardUserReputation = (username, amount) => {
  if (username === 'Guest') return;
  let citizen = CITIZEN_REPUTATION.find(c => c.name.toLowerCase() === username.toLowerCase());
  if (citizen) {
    citizen.rep += amount;
  } else {
    CITIZEN_REPUTATION.push({
      name: username,
      rep: amount,
      tag: 'Citizen'
    });
  }
  localStorage.setItem('CITIZEN_REPUTATION', JSON.stringify(CITIZEN_REPUTATION));
};

/* ==========================================================================
   24. $CITZ Token Core System
   ========================================================================== */
let CITZ_BALANCE = parseInt(localStorage.getItem('CITZ_BALANCE')) || 1250;
let CITZ_TRANSACTIONS = JSON.parse(localStorage.getItem('CITZ_TRANSACTIONS')) || [
  { type: 'earn', amount: 1000, desc: 'Genesis Citizen Airdrop', ts: Date.now() - 7200000 },
  { type: 'earn', amount: 250, desc: 'Welcome Forum Post Bonus', ts: Date.now() - 3600000 }
];
let CITZ_LAST_FAUCET = parseInt(localStorage.getItem('CITZ_LAST_FAUCET')) || 0;
let USER_STATS = JSON.parse(localStorage.getItem('USER_STATS')) || {
  posts: 0, upvotes: 0, challenges: 0, quizCitz: 0
};
let USER_BADGES = JSON.parse(localStorage.getItem('USER_BADGES')) || [];
let GOVERNANCE_PROPOSALS = JSON.parse(localStorage.getItem('GOVERNANCE_PROPOSALS')) || [
  { id: 1, title: 'Cap all lobby contributions at $1,000 per candidate per cycle', votes: 12, status: 'Active' },
  { id: 2, title: 'Mandate CEO pay ratio disclosure for S&P 500 firms', votes: 8, status: 'Active' }
];

const CITZ_LEVELS = [
  { level: 1, name: 'Observer', minCitz: 0 },
  { level: 2, name: 'Delegate', minCitz: 1000 },
  { level: 3, name: 'Advocate', minCitz: 3000 },
  { level: 4, name: 'Reformer', minCitz: 7000 },
  { level: 5, name: 'Strategist', minCitz: 15000 },
  { level: 6, name: 'Architect', minCitz: 30000 },
  { level: 7, name: 'Elder Statesman', minCitz: 60000 }
];

function getCITZLevel(balance) {
  let currentLevel = CITZ_LEVELS[0];
  for (const lvl of CITZ_LEVELS) {
    if (balance >= lvl.minCitz) currentLevel = lvl;
    else break;
  }
  return currentLevel;
}

function getNextLevelData(balance) {
  const current = getCITZLevel(balance);
  const nextIdx = CITZ_LEVELS.findIndex(l => l.level === current.level) + 1;
  if (nextIdx >= CITZ_LEVELS.length) return { next: null, progress: 100, needed: 0, currentMin: current.minCitz };
  const next = CITZ_LEVELS[nextIdx];
  const currentMin = current.minCitz;
  const progress = Math.round(((balance - currentMin) / (next.minCitz - currentMin)) * 100);
  return { next, progress: Math.min(100, Math.max(0, progress)), needed: next.minCitz - balance, currentMin };
}

function addCITZ(amount, description) {
  CITZ_BALANCE += amount;
  CITZ_TRANSACTIONS.unshift({ type: 'earn', amount, desc: description, ts: Date.now() });
  if (CITZ_TRANSACTIONS.length > 50) CITZ_TRANSACTIONS.pop();
  saveCITZData();
  updateAllCITZDisplays();
}

function spendCITZ(amount, description) {
  if (CITZ_BALANCE < amount) return false;
  CITZ_BALANCE -= amount;
  CITZ_TRANSACTIONS.unshift({ type: 'spend', amount: -amount, desc: description, ts: Date.now() });
  if (CITZ_TRANSACTIONS.length > 50) CITZ_TRANSACTIONS.pop();
  saveCITZData();
  updateAllCITZDisplays();
  return true;
}

function saveCITZData() {
  localStorage.setItem('CITZ_BALANCE', CITZ_BALANCE.toString());
  localStorage.setItem('CITZ_TRANSACTIONS', JSON.stringify(CITZ_TRANSACTIONS));
  localStorage.setItem('USER_STATS', JSON.stringify(USER_STATS));
}

function updateAllCITZDisplays() {
  const level = getCITZLevel(CITZ_BALANCE);
  const formatted = CITZ_BALANCE.toLocaleString();

  // Header
  const headerBal = document.getElementById('citz-balance');
  const headerLvl = document.getElementById('citz-level');
  if (headerBal) headerBal.textContent = formatted;
  if (headerLvl) headerLvl.textContent = `Lvl ${level.level}: ${level.name}`;

  // Dashboard balance
  const dashBal = document.getElementById('dashboard-citz-balance');
  if (dashBal) dashBal.textContent = formatted;

  const lvlBadge = document.getElementById('profile-level-badge');
  if (lvlBadge) lvlBadge.textContent = `Lvl ${level.level}: ${level.name}`;

  const { progress, needed, next, currentMin } = getNextLevelData(CITZ_BALANCE);
  const xpBar = document.getElementById('xp-progress-bar');
  const xpLabel = document.getElementById('xp-progress-label');
  if (xpBar) xpBar.style.width = `${progress}%`;
  if (xpLabel) {
    if (next) {
      xpLabel.textContent = `${(CITZ_BALANCE - currentMin).toLocaleString()} / ${(next.minCitz - currentMin).toLocaleString()} XP to Lvl ${next.level}`;
    } else {
      xpLabel.textContent = 'MAX LEVEL ACHIEVED 🏛️';
    }
  }

  // Store balance
  const storeBal = document.getElementById('store-citz-balance');
  if (storeBal) storeBal.textContent = `🪙 ${formatted} $CITZ`;

  // Quiz total
  const quizTotal = document.getElementById('quiz-total-citz');
  if (quizTotal) quizTotal.textContent = (USER_STATS.quizCitz || 0).toLocaleString();

  // Stat counters
  const username = (window.SUPABASE_USER && window.SUPABASE_USER.authenticated) ? window.SUPABASE_USER.name : 'Guest';
  const citizen = CITIZEN_REPUTATION.find(c => c.name === username);
  const statRep = document.getElementById('stat-rep');
  if (statRep) statRep.textContent = citizen ? citizen.rep : 0;
  const statPosts = document.getElementById('stat-posts');
  if (statPosts) statPosts.textContent = USER_STATS.posts || 0;
  const statUpvotes = document.getElementById('stat-upvotes');
  if (statUpvotes) statUpvotes.textContent = USER_STATS.upvotes || 0;
  const statChallenges = document.getElementById('stat-challenges');
  if (statChallenges) statChallenges.textContent = USER_STATS.challenges || 0;
}

function initCITZSystem() {
  const faucetBtn = document.getElementById('btn-claim-citz');
  const faucetTimer = document.getElementById('faucet-timer');

  if (faucetBtn) {
    faucetBtn.addEventListener('click', () => {
      const now = Date.now();
      const cooldown = 60000;
      if (now - CITZ_LAST_FAUCET < cooldown) {
        const remaining = Math.ceil((cooldown - (now - CITZ_LAST_FAUCET)) / 1000);
        if (faucetTimer) {
          faucetTimer.textContent = `Cooldown: ${remaining}s remaining`;
          faucetTimer.classList.remove('hidden');
        }
        return;
      }
      CITZ_LAST_FAUCET = now;
      localStorage.setItem('CITZ_LAST_FAUCET', CITZ_LAST_FAUCET.toString());
      addCITZ(50, 'Proof-of-Service Faucet Claim');
      faucetBtn.textContent = '✅ Minted! Claim again in 60s';
      if (faucetTimer) {
        faucetTimer.textContent = 'Cooldown active (60 seconds)';
        faucetTimer.classList.remove('hidden');
      }
      setTimeout(() => {
        faucetBtn.textContent = 'Mint 50 $CITZ Tokens';
        if (faucetTimer) faucetTimer.classList.add('hidden');
      }, 60000);
    });
  }

  updateAllCITZDisplays();
}

/* ==========================================================================
   25. Citizen Dashboard
   ========================================================================== */
const ALL_BADGES = [
  { id: 'first_post', emoji: '✍️', name: 'First Dispatch', desc: 'Published your first post', condition: () => USER_STATS.posts >= 1 },
  { id: 'ten_posts', emoji: '📣', name: 'Voice of Reason', desc: '10 posts published', condition: () => USER_STATS.posts >= 10 },
  { id: 'first_quiz', emoji: '🧠', name: 'Civic Scholar', desc: 'Completed first quiz question', condition: () => (USER_STATS.quizCitz || 0) >= 25 },
  { id: 'quiz_master', emoji: '🎓', name: 'Quiz Master', desc: 'Earned 500+ CITZ from quizzes', condition: () => (USER_STATS.quizCitz || 0) >= 500 },
  { id: 'first_challenge', emoji: '⚡', name: 'Challenger', desc: 'Completed a daily challenge', condition: () => (USER_STATS.challenges || 0) >= 1 },
  { id: 'challenge_streak', emoji: '🔥', name: 'Streak Keeper', desc: 'Completed 5+ challenges total', condition: () => (USER_STATS.challenges || 0) >= 5 },
  { id: 'first_upvote', emoji: '👍', name: 'Upvoter', desc: 'Cast a governance vote', condition: () => (USER_STATS.upvotes || 0) >= 1 },
  { id: 'delegate', emoji: '🏛️', name: 'Delegate', desc: 'Reached Lvl 2 Delegate', condition: () => CITZ_BALANCE >= 1000 },
  { id: 'advocate', emoji: '⚖️', name: 'Advocate', desc: 'Reached Lvl 3 Advocate', condition: () => CITZ_BALANCE >= 3000 },
  { id: 'thousand_citz', emoji: '🪙', name: 'Token Holder', desc: 'Accumulated 1,000+ $CITZ', condition: () => CITZ_BALANCE >= 1000 },
];

function initCitizenDashboard() {
  // Award new badges
  ALL_BADGES.forEach(badge => {
    if (!USER_BADGES.includes(badge.id) && badge.condition()) {
      USER_BADGES.push(badge.id);
      localStorage.setItem('USER_BADGES', JSON.stringify(USER_BADGES));
    }
  });

  const badgesGrid = document.getElementById('profile-badges-grid');
  if (badgesGrid) {
    badgesGrid.innerHTML = '';
    const earnedBadges = ALL_BADGES.filter(b => USER_BADGES.includes(b.id));
    if (earnedBadges.length === 0) {
      badgesGrid.innerHTML = '<div style="font-size:0.8rem; color:var(--color-text-muted);">Complete actions to earn badges!</div>';
    } else {
      earnedBadges.forEach(b => {
        const badge = document.createElement('div');
        badge.title = `${b.name}: ${b.desc}`;
        badge.style.cssText = 'background:rgba(245,158,11,0.1); border:1px solid rgba(245,158,11,0.25); border-radius:8px; padding:0.4rem 0.6rem; font-size:0.75rem; display:flex; align-items:center; gap:0.3rem; cursor:help;';
        badge.innerHTML = `${b.emoji} <strong>${b.name}</strong>`;
        badgesGrid.appendChild(badge);
      });
    }
  }

  const profileName = document.getElementById('profile-display-name');
  if (profileName && window.SUPABASE_USER && window.SUPABASE_USER.authenticated) {
    profileName.textContent = window.SUPABASE_USER.name;
  }

  const txLog = document.getElementById('citz-transaction-log');
  if (txLog) {
    txLog.innerHTML = '';
    if (CITZ_TRANSACTIONS.length === 0) {
      txLog.innerHTML = '<div style="color:var(--color-text-muted); font-size:0.8rem;">No transactions yet.</div>';
    } else {
      CITZ_TRANSACTIONS.slice(0, 20).forEach(tx => {
        const row = document.createElement('div');
        row.style.cssText = 'display:flex; justify-content:space-between; align-items:center; padding:0.4rem 0; border-bottom:1px solid rgba(255,255,255,0.04); gap:0.5rem;';
        const isEarn = tx.type === 'earn';
        row.innerHTML = `
          <span style="color:var(--color-text-muted); font-size:0.75rem; flex:1;">${tx.desc}</span>
          <span style="font-weight:bold; color:${isEarn ? 'var(--color-green)' : 'var(--color-red)'}; flex-shrink:0;">${isEarn ? '+' : ''}${tx.amount} $CITZ</span>
        `;
        txLog.appendChild(row);
      });
    }
  }

  const govList = document.getElementById('governance-proposals-list');
  if (govList) {
    govList.innerHTML = '';
    if (GOVERNANCE_PROPOSALS.length === 0) {
      govList.innerHTML = '<div style="font-size:0.8rem; color:var(--color-text-muted);">No proposals yet. Submit one below!</div>';
    } else {
      GOVERNANCE_PROPOSALS.forEach(p => {
        const row = document.createElement('div');
        row.style.cssText = 'padding:0.75rem; background:rgba(16,185,129,0.04); border:1px solid rgba(16,185,129,0.1); border-radius:8px; display:flex; justify-content:space-between; align-items:center; gap:0.5rem;';
        row.innerHTML = `
          <span style="font-size:0.82rem; color:#fff; flex:1;">${p.title}</span>
          <div style="display:flex; align-items:center; gap:0.5rem; flex-shrink:0;">
            <span style="font-size:0.75rem; color:var(--color-text-muted);">${p.votes} votes</span>
            <button class="btn btn-secondary" style="padding:0.2rem 0.5rem; font-size:0.7rem;" onclick="voteGovernance(${p.id})">Vote (10 $CITZ)</button>
          </div>
        `;
        govList.appendChild(row);
      });
    }
  }

  const btnGov = document.getElementById('btn-new-governance');
  if (btnGov && !btnGov._govBound) {
    btnGov._govBound = true;
    btnGov.addEventListener('click', () => {
      const title = prompt('Enter your governance proposal (min 20 characters):');
      if (!title || title.trim().length < 20) { alert('Proposal too short (min 20 chars).'); return; }
      if (!spendCITZ(200, `Governance Proposal: "${title.substring(0, 40)}..."`)) {
        alert('Insufficient $CITZ! You need 200 $CITZ to submit a governance proposal.'); return;
      }
      GOVERNANCE_PROPOSALS.push({ id: GOVERNANCE_PROPOSALS.length + 1, title: title.trim(), votes: 1, status: 'Active' });
      localStorage.setItem('GOVERNANCE_PROPOSALS', JSON.stringify(GOVERNANCE_PROPOSALS));
      initCitizenDashboard();
      alert('Governance proposal submitted! ✅');
    });
  }

  updateAllCITZDisplays();
}

window.voteGovernance = (id) => {
  if (!spendCITZ(10, 'Governance Vote Cast')) {
    alert('Need 10 $CITZ to vote!'); return;
  }
  const proposal = GOVERNANCE_PROPOSALS.find(p => p.id === id);
  if (proposal) {
    proposal.votes++;
    localStorage.setItem('GOVERNANCE_PROPOSALS', JSON.stringify(GOVERNANCE_PROPOSALS));
    USER_STATS.upvotes = (USER_STATS.upvotes || 0) + 1;
    saveCITZData();
    initCitizenDashboard();
    updateAllCITZDisplays();
  }
};

/* ==========================================================================
   26. Citizens Store
   ========================================================================== */
const STORE_ITEMS = [
  { id: 'badge_activist', emoji: '✊', name: 'Activist Badge', desc: 'Display the Activist flair next to your name in posts and comments.', cost: 150, category: 'Badge' },
  { id: 'badge_watchdog', emoji: '👁️', name: 'Watchdog Badge', desc: 'Show you watch lobbying and regulatory systems closely.', cost: 150, category: 'Badge' },
  { id: 'badge_reformer', emoji: '⚖️', name: 'Reformer Badge', desc: 'For citizens committed to structural reform advocacy.', cost: 200, category: 'Badge' },
  { id: 'badge_oracle', emoji: '🔮', name: 'Oracle Badge', desc: 'Granted to top prediction market players with strong accuracy.', cost: 350, category: 'Badge' },
  { id: 'boost_post', emoji: '📢', name: 'Post Amplifier', desc: 'Pin one of your Live Feed posts to the top of the stream for 24 hours.', cost: 100, category: 'Utility' },
  { id: 'boost_vote', emoji: '⚡', name: 'Power Vote', desc: 'Your next forum thread upvote counts as 3x weight.', cost: 75, category: 'Utility' },
  { id: 'boost_quiz', emoji: '🧠', name: 'Quiz Multiplier', desc: 'Double your CITZ earnings on the next quiz session.', cost: 80, category: 'Utility' },
  { id: 'market_free', emoji: '🎯', name: 'Free Market Entry', desc: 'Submit one prediction market proposal without needing upvotes for auto-approval.', cost: 300, category: 'Utility' },
  { id: 'faucet_boost', emoji: '💧', name: 'Faucet Upgrade', desc: 'Doubles your faucet claim to 100 $CITZ per minute for 7 days.', cost: 350, category: 'Utility' },
  { id: 'anon_post', emoji: '🎭', name: 'Anonymous Post Shield', desc: 'Post in the Live Feed anonymously with one click — no handle shown.', cost: 125, category: 'Utility' },
  { id: 'theme_gold', emoji: '🌟', name: 'Gold Profile Theme', desc: 'Unlock the gold border and star accents for your citizen profile card.', cost: 500, category: 'Cosmetic' },
  { id: 'theme_purple', emoji: '💜', name: 'Violet Profile Theme', desc: 'Unlock a violet gradient frame for your profile.', cost: 400, category: 'Cosmetic' },
  { id: 'avatar_eagle', emoji: '🦅', name: 'Eagle Avatar', desc: 'Replace your default profile avatar with a stylized civic eagle.', cost: 250, category: 'Cosmetic' },
  { id: 'avatar_scale', emoji: '⚖️', name: 'Justice Scale Avatar', desc: 'Use a golden justice scale as your citizen avatar.', cost: 200, category: 'Cosmetic' },
  { id: 'access_advanced', emoji: '🔓', name: 'Advanced Analytics Access', desc: 'Unlock detailed lobbying money flow charts and historical trend data.', cost: 600, category: 'Access' },
  { id: 'access_debate', emoji: '🎙️', name: 'Debate Host Pass', desc: 'Host pinned debate threads in the Public Square for 7 days.', cost: 450, category: 'Access' },
  { id: 'governance_slot', emoji: '🏛️', name: 'Extra Governance Slot', desc: 'Gain one additional active governance proposal slot.', cost: 500, category: 'Access' },
  { id: 'early_market', emoji: '📊', name: 'Market Early Signal', desc: 'See upcoming prediction market trends 24 hours before public release.', cost: 800, category: 'Access' }
];

let OWNED_ITEMS = JSON.parse(localStorage.getItem('OWNED_STORE_ITEMS')) || [];

function initCitizensStore() {
  const grid = document.getElementById('store-items-grid');
  if (!grid) return;

  const categories = [...new Set(STORE_ITEMS.map(i => i.category))];
  grid.innerHTML = '';

  categories.forEach(cat => {
    const catHeader = document.createElement('div');
    catHeader.style.cssText = 'grid-column:1/-1; font-size:0.78rem; text-transform:uppercase; letter-spacing:0.08em; color:var(--color-text-muted); font-weight:700; padding:0.4rem 0; border-bottom:1px solid rgba(255,255,255,0.05); margin-top:0.75rem;';
    catHeader.textContent = `— ${cat}`;
    grid.appendChild(catHeader);

    STORE_ITEMS.filter(i => i.category === cat).forEach(item => {
      const isOwned = OWNED_ITEMS.includes(item.id);
      const card = document.createElement('div');
      card.className = 'card';
      card.style.cssText = `padding:1.25rem; border-radius:12px; background:rgba(0,0,0,0.3); border:1px solid ${isOwned ? 'rgba(16,185,129,0.3)' : 'rgba(255,255,255,0.06)'}; display:flex; flex-direction:column; gap:0.75rem; position:relative; transition:all 0.2s ease;`;
      card.innerHTML = `
        ${isOwned ? '<div style="position:absolute; top:0.75rem; right:0.75rem; background:var(--color-green); color:#fff; font-size:0.6rem; font-weight:700; padding:0.2rem 0.4rem; border-radius:4px;">OWNED</div>' : ''}
        <div style="font-size:2rem;">${item.emoji}</div>
        <div>
          <h4 style="font-size:0.95rem; font-weight:700; color:#fff; margin-bottom:0.25rem;">${item.name}</h4>
          <p style="font-size:0.75rem; color:var(--color-text-muted); line-height:1.4;">${item.desc}</p>
        </div>
        <div style="display:flex; justify-content:space-between; align-items:center; margin-top:auto;">
          <span style="font-size:0.9rem; font-weight:800; color:var(--color-green);">🪙 ${item.cost.toLocaleString()}</span>
          <button class="btn ${isOwned ? 'btn-secondary' : 'btn-primary'}" style="padding:0.35rem 0.8rem; font-size:0.78rem; ${isOwned ? 'opacity:0.5; cursor:default;' : ''}" onclick="purchaseStoreItem('${item.id}')" ${isOwned ? 'disabled' : ''}>
            ${isOwned ? '✅ Owned' : 'Purchase'}
          </button>
        </div>
      `;
      grid.appendChild(card);
    });
  });

  updateAllCITZDisplays();
}

window.purchaseStoreItem = (itemId) => {
  if (OWNED_ITEMS.includes(itemId)) { alert('Already owned!'); return; }
  const item = STORE_ITEMS.find(i => i.id === itemId);
  if (!item) return;
  if (CITZ_BALANCE < item.cost) {
    alert(`Insufficient $CITZ! Need ${item.cost.toLocaleString()}, have ${CITZ_BALANCE.toLocaleString()}.`); return;
  }
  if (!confirm(`Purchase "${item.name}" for ${item.cost.toLocaleString()} $CITZ?`)) return;
  spendCITZ(item.cost, `Store Purchase: ${item.name}`);
  OWNED_ITEMS.push(itemId);
  localStorage.setItem('OWNED_STORE_ITEMS', JSON.stringify(OWNED_ITEMS));
  if (itemId.startsWith('badge_') && !USER_BADGES.includes(itemId)) {
    USER_BADGES.push(itemId);
    localStorage.setItem('USER_BADGES', JSON.stringify(USER_BADGES));
  }
  const confirmBox = document.getElementById('store-purchase-confirm');
  const confirmMsg = document.getElementById('store-purchase-msg');
  if (confirmBox && confirmMsg) {
    confirmMsg.textContent = `🎉 "${item.name}" unlocked! ${item.emoji} It's now active on your profile.`;
    confirmBox.classList.remove('hidden');
    setTimeout(() => confirmBox.classList.add('hidden'), 4000);
  }
  initCitizensStore();
};

/* ==========================================================================
   27. Daily Civic Challenges
   ========================================================================== */
const DAILY_CHALLENGE_POOL = [
  { id: 'read_reform', title: 'Study the Reform Tab', desc: 'Navigate to Pathways to Reform and read about Citizen Action.', reward: 50, type: 'Education', emoji: '📖' },
  { id: 'post_dispatch', title: 'Post a Live Dispatch', desc: 'Share a thought in the Live Feed tab (min 50 chars).', reward: 75, type: 'Community', emoji: '📢' },
  { id: 'forum_comment', title: 'Comment in the Forum', desc: 'Open a forum thread and submit a comment reply.', reward: 60, type: 'Community', emoji: '💬' },
  { id: 'quiz_3', title: 'Answer 3 Quiz Questions', desc: 'Complete at least 3 questions in the Civic Quiz tab.', reward: 100, type: 'Education', emoji: '🧠' },
  { id: 'market_vote', title: 'Upvote a Prediction Market', desc: 'Go to resolve.bet Markets and upvote a pending proposal.', reward: 50, type: 'Civic', emoji: '🗳️' },
  { id: 'reform_calc', title: 'Run the Wealth Reflection Calculator', desc: 'Input values in the calculator on the Systemic Loop tab.', reward: 50, type: 'Education', emoji: '🔮' },
  { id: 'governance_vote', title: 'Vote on a Governance Proposal', desc: 'Visit My Dashboard and cast a governance vote.', reward: 80, type: 'Civic', emoji: '⚖️' },
  { id: 'local_claim', title: 'Claim a Local Board Task', desc: 'Pick up an open task from the Local Board tab.', reward: 120, type: 'Civic', emoji: '📍' },
  { id: 'invite_friend', title: 'Share the Platform', desc: 'Copy the site URL and share it with someone who cares about reform.', reward: 150, type: 'Growth', emoji: '🤝' },
  { id: 'faucet_claim', title: 'Claim the $CITZ Faucet', desc: 'Click "Mint 50 $CITZ Tokens" in the Forum sidebar.', reward: 25, type: 'Civic', emoji: '💧' },
];

let TODAY_CHALLENGES = JSON.parse(localStorage.getItem('TODAY_CHALLENGES')) || null;
let CHALLENGES_DATE = localStorage.getItem('CHALLENGES_DATE') || '';
let COMPLETED_TODAY = JSON.parse(localStorage.getItem('COMPLETED_TODAY')) || [];
let CHALLENGE_STREAK = parseInt(localStorage.getItem('CHALLENGE_STREAK')) || 0;
let WEEKLY_CITZ = parseInt(localStorage.getItem('WEEKLY_CITZ')) || 0;
let CHALLENGE_HOF = JSON.parse(localStorage.getItem('CHALLENGE_HOF')) || [
  { name: 'Socrates_99', count: 42 },
  { name: 'DebtDisputer_99', count: 31 },
  { name: 'VoxPopuli_33', count: 24 }
];

function getTodayKey() {
  const d = new Date();
  return `${d.getFullYear()}-${d.getMonth()}-${d.getDate()}`;
}

function initDailyChallenges() {
  const todayKey = getTodayKey();
  if (CHALLENGES_DATE !== todayKey) {
    const shuffled = [...DAILY_CHALLENGE_POOL].sort(() => Math.random() - 0.5);
    TODAY_CHALLENGES = shuffled.slice(0, 6);
    COMPLETED_TODAY = [];
    CHALLENGES_DATE = todayKey;
    localStorage.setItem('TODAY_CHALLENGES', JSON.stringify(TODAY_CHALLENGES));
    localStorage.setItem('CHALLENGES_DATE', CHALLENGES_DATE);
    localStorage.setItem('COMPLETED_TODAY', JSON.stringify(COMPLETED_TODAY));
  }

  const timerEl = document.getElementById('challenge-reset-timer');
  if (timerEl) {
    const updateTimer = () => {
      const now = new Date();
      const midnight = new Date(now); midnight.setHours(24, 0, 0, 0);
      const diff = midnight - now;
      const h = Math.floor(diff / 3600000);
      const m = Math.floor((diff % 3600000) / 60000);
      const s = Math.floor((diff % 60000) / 1000);
      timerEl.textContent = `${String(h).padStart(2,'0')}:${String(m).padStart(2,'0')}:${String(s).padStart(2,'0')}`;
    };
    updateTimer();
    setInterval(updateTimer, 1000);
  }

  const streakEl = document.getElementById('streak-count');
  if (streakEl) streakEl.textContent = CHALLENGE_STREAK;
  const weeklyEl = document.getElementById('weekly-citz-earned');
  if (weeklyEl) weeklyEl.textContent = `${WEEKLY_CITZ.toLocaleString()} $CITZ`;

  const hofEl = document.getElementById('challenge-hall-of-fame');
  if (hofEl) {
    hofEl.innerHTML = '';
    [...CHALLENGE_HOF].sort((a,b) => b.count - a.count).slice(0, 5).forEach((entry, idx) => {
      const medals = ['🥇','🥈','🥉','4️⃣','5️⃣'];
      const row = document.createElement('div');
      row.style.cssText = 'display:flex; justify-content:space-between; padding:0.3rem 0; border-bottom:1px solid rgba(255,255,255,0.04);';
      row.innerHTML = `<span>${medals[idx]} @${entry.name}</span><span style="color:var(--color-gold); font-weight:bold;">${entry.count} done</span>`;
      hofEl.appendChild(row);
    });
  }

  const challengesList = document.getElementById('challenges-list');
  if (!challengesList || !TODAY_CHALLENGES) return;
  challengesList.innerHTML = '';
  TODAY_CHALLENGES.forEach(challenge => {
    const isDone = COMPLETED_TODAY.includes(challenge.id);
    const card = document.createElement('div');
    card.style.cssText = `padding:1rem; border-radius:10px; border:1px solid ${isDone ? 'rgba(16,185,129,0.3)' : 'rgba(255,255,255,0.06)'}; background:${isDone ? 'rgba(16,185,129,0.06)' : 'rgba(0,0,0,0.2)'}; display:flex; justify-content:space-between; align-items:center; gap:1rem; transition:all 0.2s;`;
    card.innerHTML = `
      <div style="flex:1;">
        <div style="display:flex; align-items:center; gap:0.5rem; margin-bottom:0.25rem;">
          <span>${challenge.emoji}</span>
          <strong style="font-size:0.88rem; color:${isDone ? 'var(--color-green)' : '#fff'};">${challenge.title}</strong>
          <span class="genre-badge genre-news" style="font-size:0.55rem; padding:0.05rem 0.3rem; margin:0;">${challenge.type}</span>
        </div>
        <p style="font-size:0.75rem; color:var(--color-text-muted); line-height:1.3;">${challenge.desc}</p>
      </div>
      <div style="text-align:center; flex-shrink:0;">
        <div style="font-size:0.85rem; font-weight:700; color:var(--color-green); margin-bottom:0.35rem;">+${challenge.reward} $CITZ</div>
        <button class="btn ${isDone ? 'btn-secondary' : 'btn-primary'}" style="padding:0.3rem 0.7rem; font-size:0.72rem; min-width:70px; ${isDone ? 'opacity:0.6; cursor:default;' : ''}" onclick="completeChallenge('${challenge.id}')" ${isDone ? 'disabled' : ''}>
          ${isDone ? '✅ Done' : 'Complete'}
        </button>
      </div>
    `;
    challengesList.appendChild(card);
  });
}

window.completeChallenge = (challengeId) => {
  if (COMPLETED_TODAY.includes(challengeId)) return;
  const challenge = TODAY_CHALLENGES.find(c => c.id === challengeId);
  if (!challenge) return;

  COMPLETED_TODAY.push(challengeId);
  localStorage.setItem('COMPLETED_TODAY', JSON.stringify(COMPLETED_TODAY));
  addCITZ(challenge.reward, `Daily Challenge: ${challenge.title}`);
  USER_STATS.challenges = (USER_STATS.challenges || 0) + 1;
  WEEKLY_CITZ = (WEEKLY_CITZ || 0) + challenge.reward;
  localStorage.setItem('WEEKLY_CITZ', WEEKLY_CITZ.toString());

  if (COMPLETED_TODAY.length === 1) {
    CHALLENGE_STREAK++;
    if (CHALLENGE_STREAK % 7 === 0) {
      addCITZ(500, '🔥 7-Day Challenge Streak Bonus!');
      alert('🔥 7-Day Streak! +500 $CITZ bonus earned!');
    }
    localStorage.setItem('CHALLENGE_STREAK', CHALLENGE_STREAK.toString());
  }

  const username = (window.SUPABASE_USER && window.SUPABASE_USER.authenticated) ? window.SUPABASE_USER.name : 'You';
  let hofEntry = CHALLENGE_HOF.find(e => e.name === username);
  if (hofEntry) hofEntry.count++;
  else CHALLENGE_HOF.push({ name: username, count: 1 });
  localStorage.setItem('CHALLENGE_HOF', JSON.stringify(CHALLENGE_HOF));

  saveCITZData();
  initDailyChallenges();
  updateAllCITZDisplays();
};

/* ==========================================================================
   28. Civic Intelligence Quiz
   ========================================================================== */
const CIVIC_QUIZ_BANK = {
  'Democracy & Elections': [
    { q: 'What Supreme Court ruling declared corporate political spending a form of free speech?', options: ['Buckley v. Valeo', 'Citizens United v. FEC', 'McCutcheon v. FEC', 'Shelby County v. Holder'], answer: 1, explain: 'Citizens United v. FEC (2010) ruled corporations can spend unlimited money on political campaigns as First Amendment speech.' },
    { q: 'Which constitutional amendment gave women the right to vote in the United States?', options: ['15th Amendment', '17th Amendment', '19th Amendment', '24th Amendment'], answer: 2, explain: 'The 19th Amendment (1920) prohibited denying the right to vote on the basis of sex.' },
    { q: 'What is "gerrymandering"?', options: ['Eliminating polling locations in minority areas', 'Manipulating district boundaries to benefit one party', 'Requiring ID at voting booths', 'Limiting early voting hours'], answer: 1, explain: 'Gerrymandering is manipulating electoral district boundaries to give one party an unfair advantage.' },
    { q: 'How many electoral votes are required to win the U.S. presidency?', options: ['218', '270', '300', '435'], answer: 1, explain: '270 of 538 electoral votes are needed. The total: 435 House seats + 100 Senate + 3 for D.C.' },
    { q: 'What is "dark money" in politics?', options: ['Untraceable cryptocurrency donations', 'Nonprofit political spending where donors are not publicly disclosed', 'Campaign funds kept offshore', 'Illegal corporate bribes'], answer: 1, explain: 'Dark money refers to political spending by nonprofits (501c4s) with no required donor disclosure.' },
  ],
  'Systemic Power & Lobbying': [
    { q: 'According to Princeton research, how much impact do average Americans have on public policy?', options: ['Major impact', 'Moderate impact', 'Near-zero statistical impact', 'Same as wealthy donors'], answer: 2, explain: 'Gilens & Page (Princeton) found average citizens have near-zero statistically significant impact on policy while economic elites dominate outcomes.' },
    { q: 'What is "regulatory capture"?', options: ['Citizens taking over agencies via elections', 'Industries dominating the agencies that regulate them', 'Regulations captured in legislative records', 'Regulators fining corporations'], answer: 1, explain: 'Regulatory capture occurs when regulatory agencies prioritize industry interests over the public interest they are meant to protect.' },
    { q: 'Approximately how much does lobbying spend annually in Washington D.C.?', options: ['~$500 million', '~$2 billion', '~$4 billion', '~$10 billion'], answer: 2, explain: 'The lobbying industry spends approximately $4 billion annually, led by financial, health, and energy sectors.' },
    { q: 'What is the "revolving door" in American politics?', options: ['Turnover of officials every 2 years', 'Officials becoming lobbyists for regulated industries and back again', 'Campaign fundraising cycles', 'Presidential term limits'], answer: 1, explain: 'The revolving door describes movement between government regulatory roles and private sector lobbying positions, creating conflicts of interest.' },
    { q: 'What does "astroturfing" mean in political advocacy?', options: ['Real grassroots civic movements', 'Fake grassroots campaigns funded by corporations or special interests', 'Government-funded awareness programs', 'Third-party ballot initiatives'], answer: 1, explain: 'Astroturfing creates the illusion of grassroots public support for a corporate-funded agenda.' },
  ],
  'Personal Finance & Debt': [
    { q: 'What is the "minimum payment trap" on credit cards?', options: ['Paying minimum keeps score perfect', 'Paying only the minimum can result in decades of debt due to compound interest', 'Minimum payments waive interest for 6 months', 'It triggers an automatic balance transfer'], answer: 1, explain: 'On a $10,000 balance at 22% APR, minimum payments alone can take 30+ years and cost $20,000+ in interest.' },
    { q: 'What is the "Buy, Borrow, Die" tax strategy?', options: ['Buy treasury bonds, borrow against them, die tax-free', 'Acquire assets, borrow against them tax-free, pass them on with stepped-up basis at death', 'Buy real estate, borrow and declare bankruptcy', 'Buy stocks, reinvest, liquidate at death'], answer: 1, explain: 'Ultra-wealthy accumulate appreciating assets, borrow against them (no tax event), and pass them at death where heirs get a "stepped-up" cost basis, eliminating capital gains tax.' },
    { q: 'What percentage of Americans live paycheck to paycheck as of 2024?', options: ['28%', '42%', '59%', '78%'], answer: 2, explain: 'Approximately 59% of Americans live paycheck to paycheck, meaning they cannot easily cover major unexpected expenses.' },
    { q: 'What is a "529 plan"?', options: ['Retirement savings for federal workers', 'Tax-advantaged savings for education expenses', 'Healthcare emergency savings', 'Treasury-backed bonds for low-income families'], answer: 1, explain: 'A 529 plan grows tax-free for qualified education expenses including tuition, books, and room & board.' },
    { q: 'What does APR stand for and why does it matter?', options: ['Annual Payment Rate — the minimum annual payment', 'Annual Percentage Rate — the true yearly cost of borrowing', 'Average Principal Rate — a credit risk metric', 'Aggregate Payment Ratio — balance across lenders'], answer: 1, explain: 'APR (Annual Percentage Rate) is the total annual cost of borrowing including interest and fees — crucial for comparing loan costs.' },
  ],
  'Civic Action & Reform': [
    { q: 'What is a "regulatory comment period"?', options: ['Agency press conferences on new rules', 'A public window for citizens to formally comment on proposed regulations', 'Congressional hearings on agency rules', 'Quarterly agency updates to Congress'], answer: 1, explain: 'Comment periods allow any person to formally influence pending regulations — agencies must respond to significant ones.' },
    { q: 'What is "participatory budgeting"?', options: ['Citizens voting on politicians controlling the budget', 'Community members directly deciding how to spend part of a public budget', 'The Congressional budget committee process', 'Crowdfunding for government services'], answer: 1, explain: 'Participatory budgeting lets communities directly allocate part of public funds — used successfully in NYC and internationally.' },
    { q: 'What is a "cooperative" business structure?', options: ['Shareholder-owned company', 'Enterprise owned and democratically controlled by its members/workers', 'Nonprofit charity', 'Government-owned utility'], answer: 1, explain: 'Cooperatives distribute profits to their member-owners and operate on democratic one-member-one-vote principles.' },
    { q: 'What does "mutual aid" mean in civic organizing?', options: ['Government welfare programs', 'Community members directly helping each other outside market/state structures', 'Corporate charitable donations', 'International foreign aid'], answer: 1, explain: 'Mutual aid is non-hierarchical reciprocal community support — distinct from charity because participants both give and receive.' },
    { q: 'What is the "public banking" model?', options: ['FDIC-regulated private banks', 'Financial institutions owned by a government serving public interest over profit', 'National banks with all-state branches', 'Credit unions for government employees'], answer: 1, explain: 'The Bank of North Dakota — the only U.S. state-owned bank — has operated profitably for a century while funding local agriculture and schools.' },
  ]
};

let QUIZ_STATE = {
  category: 'Democracy & Elections',
  questions: [],
  currentIdx: 0,
  score: 0,
  answered: false,
  quizCitzThisSession: 0
};

let QUIZ_LEADERBOARD_DATA = JSON.parse(localStorage.getItem('QUIZ_LEADERBOARD')) || [
  { name: 'Socrates_99', score: 450 },
  { name: 'VoxPopuli_33', score: 325 },
  { name: 'DebtDisputer_99', score: 200 }
];

function loadQuizCategory(category) {
  QUIZ_STATE.category = category;
  QUIZ_STATE.questions = [...(CIVIC_QUIZ_BANK[category] || [])].sort(() => Math.random() - 0.5);
  QUIZ_STATE.currentIdx = 0;
  QUIZ_STATE.score = 0;
  QUIZ_STATE.answered = false;
  QUIZ_STATE.quizCitzThisSession = 0;
  renderQuizQuestion();
}

function renderQuizQuestion() {
  const q = QUIZ_STATE.questions[QUIZ_STATE.currentIdx];
  if (!q) return;

  const qNumEl = document.getElementById('quiz-q-num');
  const qTotalEl = document.getElementById('quiz-q-total');
  const qTextEl = document.getElementById('quiz-question-text');
  const optionsGrid = document.getElementById('quiz-options-grid');
  const feedbackEl = document.getElementById('quiz-feedback');
  const progressBar = document.getElementById('quiz-progress-bar');
  const categoryBadge = document.getElementById('quiz-category-badge');
  const scoreDisplay = document.getElementById('quiz-score-display');
  const nextBtn = document.getElementById('quiz-next-btn');
  if (!qTextEl || !optionsGrid) return;

  const total = QUIZ_STATE.questions.length;
  const current = QUIZ_STATE.currentIdx + 1;
  if (qNumEl) qNumEl.textContent = current;
  if (qTotalEl) qTotalEl.textContent = total;
  if (progressBar) progressBar.style.width = `${(current / total) * 100}%`;
  if (categoryBadge) categoryBadge.textContent = `Category: ${QUIZ_STATE.category}`;
  if (scoreDisplay) scoreDisplay.innerHTML = `Score: <strong style="color:var(--color-gold);">${QUIZ_STATE.score} pts</strong>`;

  qTextEl.textContent = q.q;
  QUIZ_STATE.answered = false;
  if (feedbackEl) feedbackEl.classList.add('hidden');
  if (nextBtn) nextBtn.classList.add('hidden');

  optionsGrid.innerHTML = '';
  q.options.forEach((opt, idx) => {
    const btn = document.createElement('button');
    btn.style.cssText = 'width:100%; padding:0.75rem 1rem; background:rgba(59,130,246,0.06); border:1px solid rgba(59,130,246,0.2); border-radius:8px; color:#fff; font-size:0.88rem; text-align:left; cursor:pointer; transition:all 0.2s; font-family:inherit;';
    btn.textContent = `${['A','B','C','D'][idx]}. ${opt}`;
    btn.addEventListener('mouseenter', () => { if (!QUIZ_STATE.answered) btn.style.background = 'rgba(59,130,246,0.15)'; });
    btn.addEventListener('mouseleave', () => { if (!QUIZ_STATE.answered) btn.style.background = 'rgba(59,130,246,0.06)'; });
    btn.addEventListener('click', () => answerQuiz(idx));
    optionsGrid.appendChild(btn);
  });
}

function answerQuiz(selectedIdx) {
  if (QUIZ_STATE.answered) return;
  QUIZ_STATE.answered = true;
  const q = QUIZ_STATE.questions[QUIZ_STATE.currentIdx];
  const isCorrect = selectedIdx === q.answer;

  const optionsGrid = document.getElementById('quiz-options-grid');
  const feedbackEl = document.getElementById('quiz-feedback');
  const scoreDisplay = document.getElementById('quiz-score-display');
  const nextBtn = document.getElementById('quiz-next-btn');

  if (optionsGrid) {
    Array.from(optionsGrid.children).forEach((btn, idx) => {
      btn.style.cursor = 'default';
      if (idx === q.answer) {
        btn.style.background = 'rgba(16,185,129,0.2)';
        btn.style.border = '1px solid var(--color-green)';
        btn.style.color = 'var(--color-green)';
        btn.style.fontWeight = 'bold';
      } else if (idx === selectedIdx && !isCorrect) {
        btn.style.background = 'rgba(239,68,68,0.2)';
        btn.style.border = '1px solid var(--color-red)';
        btn.style.color = 'var(--color-red)';
      }
    });
  }

  if (isCorrect) {
    QUIZ_STATE.score += 25;
    QUIZ_STATE.quizCitzThisSession += 25;
    addCITZ(25, `Quiz Correct: "${QUIZ_STATE.category}"`);
    USER_STATS.quizCitz = (USER_STATS.quizCitz || 0) + 25;
    saveCITZData();
  }

  if (scoreDisplay) scoreDisplay.innerHTML = `Score: <strong style="color:var(--color-gold);">${QUIZ_STATE.score} pts</strong>`;

  if (feedbackEl) {
    feedbackEl.classList.remove('hidden');
    feedbackEl.style.background = isCorrect ? 'rgba(16,185,129,0.1)' : 'rgba(239,68,68,0.1)';
    feedbackEl.style.border = `1px solid ${isCorrect ? 'var(--color-green)' : 'var(--color-red)'}`;
    feedbackEl.innerHTML = `
      <strong style="color:${isCorrect ? 'var(--color-green)' : 'var(--color-red)'};">${isCorrect ? '✅ Correct! +25 $CITZ' : '❌ Incorrect'}</strong>
      <p style="margin-top:0.5rem; color:#cbd5e1; font-size:0.85rem;">${q.explain}</p>
    `;
  }

  const isLast = QUIZ_STATE.currentIdx >= QUIZ_STATE.questions.length - 1;
  if (nextBtn) {
    nextBtn.classList.remove('hidden');
    nextBtn.textContent = isLast ? '🏁 Finish Quiz' : 'Next Question →';
  }

  updateAllCITZDisplays();
}

function initCivicQuiz() {
  const catSelectorEl = document.getElementById('quiz-category-selector');
  if (catSelectorEl) {
    catSelectorEl.innerHTML = '';
    Object.keys(CIVIC_QUIZ_BANK).forEach(cat => {
      const btn = document.createElement('button');
      btn.className = 'btn btn-secondary';
      btn.style.cssText = `width:100%; text-align:left; padding:0.5rem 0.8rem; font-size:0.8rem; ${cat === QUIZ_STATE.category ? 'border-color:var(--color-green); color:var(--color-green);' : ''}`;
      btn.textContent = cat;
      btn.addEventListener('click', () => {
        catSelectorEl.querySelectorAll('button').forEach(b => { b.style.borderColor = ''; b.style.color = ''; });
        btn.style.borderColor = 'var(--color-green)';
        btn.style.color = 'var(--color-green)';
        loadQuizCategory(cat);
      });
      catSelectorEl.appendChild(btn);
    });
  }

  const quizLB = document.getElementById('quiz-leaderboard');
  if (quizLB) {
    quizLB.innerHTML = '';
    [...QUIZ_LEADERBOARD_DATA].sort((a,b) => b.score - a.score).slice(0, 5).forEach((entry, idx) => {
      const medals = ['🥇','🥈','🥉','4️⃣','5️⃣'];
      const row = document.createElement('div');
      row.style.cssText = 'display:flex; justify-content:space-between; padding:0.3rem 0; border-bottom:1px solid rgba(255,255,255,0.04);';
      row.innerHTML = `<span>${medals[idx]} @${entry.name}</span><span style="color:var(--color-gold); font-weight:bold;">${entry.score} pts</span>`;
      quizLB.appendChild(row);
    });
  }

  const nextBtn = document.getElementById('quiz-next-btn');
  if (nextBtn && !nextBtn._quizBound) {
    nextBtn._quizBound = true;
    nextBtn.addEventListener('click', () => {
      const isLast = QUIZ_STATE.currentIdx >= QUIZ_STATE.questions.length - 1;
      if (isLast) {
        const username = (window.SUPABASE_USER && window.SUPABASE_USER.authenticated) ? window.SUPABASE_USER.name : 'You';
        let entry = QUIZ_LEADERBOARD_DATA.find(e => e.name === username);
        if (entry) entry.score += QUIZ_STATE.score;
        else QUIZ_LEADERBOARD_DATA.push({ name: username, score: QUIZ_STATE.score });
        localStorage.setItem('QUIZ_LEADERBOARD', JSON.stringify(QUIZ_LEADERBOARD_DATA));
        alert(`Quiz complete! Scored ${QUIZ_STATE.score} pts, earned ${QUIZ_STATE.quizCitzThisSession} $CITZ! 🎓`);
        loadQuizCategory(QUIZ_STATE.category);
        initCivicQuiz();
        return;
      }
      QUIZ_STATE.currentIdx++;
      renderQuizQuestion();
    });
  }

  loadQuizCategory(QUIZ_STATE.category);
}

/* ==========================================================================
   25. Debate Tournaments & Bracket System
   ========================================================================== */
const BOT_NAMES = [
  "Liberty_Patriot", "VoxPopuli_33", "Citizen_Socrates", "NullHypothesis", "Capitalist_Edge",
  "Aletheia_Now", "Egalitarian_1", "SystemRebel", "ProtestCommoner", "Spiritualist_A",
  "NewsJunkie", "TrollStopper", "PolicyWonk_9", "Agora_Citizen", "LogicLover", "DialecticDream"
];

let TOURNAMENT_STATE = JSON.parse(localStorage.getItem('DEBATE_TOURNAMENT')) || null;
let TOURNAMENT_HISTORY = JSON.parse(localStorage.getItem('DEBATE_TOURNAMENT_HISTORY')) || [
  { id: 1, name: "Autumn Governance Cup", size: 8, fee: 10, prize: 230, winner: "Citizen_Socrates", ts: Date.now() - 86400000 * 3 },
  { id: 2, name: "Freedom of Speech Open", size: 4, fee: 50, prize: 350, winner: "VoxPopuli_33", ts: Date.now() - 86400000 }
];

function initDebateTournaments() {
  const hostForm = document.getElementById('host-tournament-form');
  const forfeitBtn = document.getElementById('btn-forfeit-tournament');
  const tourneyBtn = document.querySelector('[data-subtab="tournaments"]');

  if (tourneyBtn) {
    tourneyBtn.addEventListener('click', renderTournamentUI);
  }

  if (hostForm) {
    hostForm.addEventListener('submit', (e) => {
      e.preventDefault();
      createTournament();
    });
  }

  if (forfeitBtn) {
    forfeitBtn.addEventListener('click', () => {
      if (confirm("Are you sure you want to forfeit this tournament? You will lose your entry fee and be eliminated!")) {
        forfeitActiveTournament();
      }
    });
  }

  renderTournamentUI();
}

function createTournament() {
  const nameInput = document.getElementById('tournament-name');
  const sizeSelect = document.getElementById('tournament-size');
  const feeSelect = document.getElementById('tournament-fee');
  const genreSelect = document.getElementById('tournament-genre');

  if (!nameInput || !sizeSelect || !feeSelect || !genreSelect) return;

  const fee = parseInt(feeSelect.value);
  const size = parseInt(sizeSelect.value);
  const name = nameInput.value.trim() || "Civic Debate Cup";
  const genre = genreSelect.value;

  if (fee > 0) {
    const success = spendCITZ(fee, `Tournament Entry Fee: ${name}`);
    if (!success) {
      alert("❌ Insufficient $CITZ balance to pay the entry fee!");
      return;
    }
  }

  const competitors = [
    { name: "Citizen_X", isUser: true, elo: userEloRating, active: true }
  ];

  const availableBots = [...BOT_NAMES];
  while (competitors.length < size) {
    if (availableBots.length === 0) break;
    const randIdx = Math.floor(Math.random() * availableBots.length);
    const botName = availableBots.splice(randIdx, 1)[0];
    competitors.push({
      name: botName,
      isUser: false,
      elo: Math.floor(Math.random() * 300) + 1100,
      active: true
    });
  }

  competitors.sort(() => Math.random() - 0.5);

  const round0Matches = [];
  const totalMatches = size / 2;
  for (let i = 0; i < totalMatches; i++) {
    const p1 = competitors[i * 2];
    const p2 = competitors[i * 2 + 1];
    const topicText = getRandomTopicForGenre(genre);

    round0Matches.push({
      id: i,
      p1,
      p2,
      winner: null,
      p1Score: null,
      p2Score: null,
      topic: topicText,
      played: false
    });
  }

  TOURNAMENT_STATE = {
    name,
    size,
    genre,
    entryFee: fee,
    prizePool: fee * size + 150,
    rounds: [round0Matches],
    currentRoundIdx: 0,
    status: 'active',
    userPlayingTournamentMatch: false
  };

  saveTournamentState();
  renderTournamentUI();
  alert(`🏆 Tournament "${name}" successfully launched! Good luck in the bracket!`);
}

function getRandomTopicForGenre(genre) {
  let pool = [];
  if (genre === 'all') {
    for (const g in DEFAULT_DEBATE_TOPICS) {
      pool = pool.concat(DEFAULT_DEBATE_TOPICS[g]);
    }
  } else if (DEFAULT_DEBATE_TOPICS[genre]) {
    pool = DEFAULT_DEBATE_TOPICS[genre];
  }

  if (pool.length === 0) {
    return "Is the true purpose of life selfless service?";
  }

  const topicObj = pool[Math.floor(Math.random() * pool.length)];
  return topicObj.text;
}

function getNextMatchIndex() {
  if (!TOURNAMENT_STATE) return -1;
  const currentRound = TOURNAMENT_STATE.rounds[TOURNAMENT_STATE.currentRoundIdx];
  if (!currentRound) return -1;
  
  const unplayed = currentRound.find(m => !m.played);
  return unplayed ? unplayed.id : -1;
}

function renderTournamentUI() {
  const setupCard = document.getElementById('tournament-setup-card');
  const historyCard = document.getElementById('tournament-history-card');
  const activeCard = document.getElementById('tournament-active-card');

  if (!setupCard || !historyCard || !activeCard) return;

  if (TOURNAMENT_STATE && TOURNAMENT_STATE.status === 'active') {
    setupCard.classList.add('hidden');
    historyCard.classList.add('hidden');
    activeCard.classList.remove('hidden');

    document.getElementById('active-tournament-title').textContent = `🏆 ${TOURNAMENT_STATE.name}`;
    
    const totalRounds = Math.log2(TOURNAMENT_STATE.size);
    let roundLabel = `Round ${TOURNAMENT_STATE.currentRoundIdx + 1}`;
    if (TOURNAMENT_STATE.currentRoundIdx === totalRounds - 1) roundLabel = "Finals";
    else if (TOURNAMENT_STATE.currentRoundIdx === totalRounds - 2) roundLabel = "Semifinals";
    
    document.getElementById('active-tournament-meta').textContent = `${roundLabel} | Prize Pool: ${TOURNAMENT_STATE.prizePool} $CITZ`;

    renderTournamentBracket();
    renderNextMatchConsole();
  } else {
    setupCard.classList.remove('hidden');
    historyCard.classList.remove('hidden');
    activeCard.classList.add('hidden');

    renderTournamentHistory();
  }
}

function renderTournamentBracket() {
  const container = document.getElementById('tournament-bracket-tree');
  if (!container || !TOURNAMENT_STATE) return;

  container.innerHTML = '';
  const totalRounds = Math.log2(TOURNAMENT_STATE.size);
  
  for (let r = 0; r < totalRounds; r++) {
    const roundCol = document.createElement('div');
    roundCol.className = 'bracket-round';
    
    let roundTitle = "";
    if (r === totalRounds - 1) roundTitle = "🏆 Finals";
    else if (r === totalRounds - 2) roundTitle = "🔥 Semifinals";
    else if (r === totalRounds - 3) roundTitle = "Quarterfinals";
    else roundTitle = `Round of ${Math.pow(2, totalRounds - r)}`;
    
    const titleNode = document.createElement('div');
    titleNode.style.cssText = 'font-size:0.75rem; text-transform:uppercase; color:var(--color-text-muted); text-align:center; font-weight:800; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:0.4rem; margin-bottom:0.5rem;';
    titleNode.textContent = roundTitle;
    roundCol.appendChild(titleNode);

    const matchesInRound = TOURNAMENT_STATE.rounds[r];
    if (matchesInRound) {
      matchesInRound.forEach(match => {
        const matchNode = document.createElement('div');
        matchNode.className = 'bracket-match';
        
        const isCurrentMatch = (TOURNAMENT_STATE.currentRoundIdx === r && getNextMatchIndex() === match.id);
        if (isCurrentMatch) {
          matchNode.classList.add('active-match');
        }

        const p1Class = getPlayerClass(match, 'p1');
        const p2Class = getPlayerClass(match, 'p2');
        
        const p1Score = match.played ? `(${match.p1Score}%)` : '';
        const p2Score = match.played ? `(${match.p2Score}%)` : '';

        matchNode.innerHTML = `
          <div class="bracket-player ${p1Class}">
            <span>${match.p1.name}</span>
            <span>${p1Score}</span>
          </div>
          <div class="bracket-player ${p2Class}">
            <span>${match.p2.name}</span>
            <span>${p2Score}</span>
          </div>
        `;
        roundCol.appendChild(matchNode);
      });
    } else {
      const numMatches = Math.pow(2, totalRounds - 1 - r);
      for (let i = 0; i < numMatches; i++) {
        const matchNode = document.createElement('div');
        matchNode.className = 'bracket-match';
        matchNode.innerHTML = `
          <div class="bracket-player" style="opacity:0.3;">
            <span>TBD</span>
            <span></span>
          </div>
          <div class="bracket-player" style="opacity:0.3;">
            <span>TBD</span>
            <span></span>
          </div>
        `;
        roundCol.appendChild(matchNode);
      }
    }
    container.appendChild(roundCol);
  }

  const champCol = document.createElement('div');
  champCol.className = 'bracket-round';
  champCol.style.alignItems = 'center';
  champCol.style.justifyContent = 'center';

  const titleNode = document.createElement('div');
  titleNode.style.cssText = 'font-size:0.75rem; text-transform:uppercase; color:var(--color-gold); text-align:center; font-weight:800; border-bottom:1px solid rgba(255,255,255,0.05); padding-bottom:0.4rem; margin-bottom:0.5rem; width:100%;';
  titleNode.textContent = '👑 Champion';
  champCol.appendChild(titleNode);

  const finalRound = TOURNAMENT_STATE.rounds[totalRounds - 1];
  const finalMatch = finalRound ? finalRound[0] : null;
  let championName = "TBD";
  let championGlow = "opacity:0.3;";
  
  if (finalMatch && finalMatch.played && finalMatch.winner) {
    championName = finalMatch.winner.name;
    championGlow = "border: 2px solid var(--color-gold); background:rgba(245,158,11,0.1); color:var(--color-gold); font-weight:bold; box-shadow:0 0 15px rgba(245, 158, 11, 0.4);";
  }

  const champNode = document.createElement('div');
  champNode.style.cssText = `padding: 0.8rem 1.2rem; border-radius: 8px; font-size: 0.85rem; text-align: center; min-width: 140px; border: 1px solid var(--color-border); ${championGlow}`;
  champNode.innerHTML = `🏆 ${championName}`;
  champCol.appendChild(champNode);
  container.appendChild(champCol);
}

function getPlayerClass(match, playerKey) {
  const p = match[playerKey];
  if (!p) return '';
  let classes = [];
  if (p.isUser) classes.push('user-player');
  if (match.played) {
    if (match.winner && match.winner.name === p.name) {
      classes.push('winner');
    } else {
      classes.push('loser');
    }
  }
  return classes.join(' ');
}

function renderNextMatchConsole() {
  const detailsNode = document.getElementById('next-match-details');
  const actionsNode = document.getElementById('next-match-actions');
  const tickerNode = document.getElementById('tournament-sim-ticker');

  if (!detailsNode || !actionsNode || !TOURNAMENT_STATE) return;

  const currentRound = TOURNAMENT_STATE.rounds[TOURNAMENT_STATE.currentRoundIdx];
  const nextMatchIdx = getNextMatchIndex();
  
  if (nextMatchIdx === -1) {
    detailsNode.innerHTML = `
      <div style="text-align:center; padding:1rem 0;">
        <span style="font-size:2rem;">🍿</span>
        <div style="font-weight:bold; margin-top:0.5rem; color:#fff;">Round Complete!</div>
        <p style="font-size:0.8rem; color:var(--color-text-muted); margin:0.5rem 0 1rem;">All matches in this round have finished. Ready to construct the next round matchups.</p>
      </div>
    `;
    actionsNode.innerHTML = `
      <button class="btn btn-primary" onclick="advanceTournamentRound()" style="width:100%;">Advance Round ➔</button>
    `;
    if (tickerNode) tickerNode.style.display = 'none';
    return;
  }

  const match = currentRound.find(m => m.id === nextMatchIdx);
  const isUserMatch = match.p1.isUser || match.p2.isUser;

  detailsNode.innerHTML = `
    <div style="background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.05); padding:0.75rem; border-radius:6px; margin-bottom:0.75rem;">
      <div style="font-size:0.75rem; color:var(--color-text-muted); text-transform:uppercase; font-weight:bold; letter-spacing:0.02em;">Matchup</div>
      <div style="display:flex; justify-content:space-between; margin-top:0.3rem; font-weight:bold; color:#fff;">
        <span>${match.p1.name} (Elo: ${match.p1.elo})</span>
        <span style="color:var(--color-text-muted);">vs</span>
        <span>${match.p2.name} (Elo: ${match.p2.elo})</span>
      </div>
    </div>
    <div style="background:rgba(59,130,246,0.05); border:1px solid rgba(59,130,246,0.15); padding:0.75rem; border-radius:6px; font-size:0.8rem; line-height:1.4;">
      <span style="font-weight:bold; color:var(--color-blue);">Topic:</span> "${match.topic}"
    </div>
  `;

  if (isUserMatch) {
    actionsNode.innerHTML = `
      <div style="background:rgba(245,158,11,0.08); border:1px solid rgba(245,158,11,0.2); padding:0.6rem; border-radius:6px; font-size:0.78rem; color:#cbd5e1; margin-bottom:0.5rem; text-align:center;">
        ⚡ <strong>You are in this matchup!</strong>
      </div>
      <button class="btn btn-primary" onclick="playUserTournamentMatch()" style="width:100%; padding:0.65rem 1rem; font-weight:bold; background:var(--color-green); border-color:var(--color-green);">🎤 Play Live Match</button>
      <button class="btn btn-secondary" onclick="quickSimUserTournamentMatch()" style="width:100%; margin-top:0.3rem;">⚡ Quick Simulate (Sim-mode)</button>
    `;
  } else {
    actionsNode.innerHTML = `
      <button class="btn btn-primary" onclick="simulateMatchInConsole(${match.id})" style="width:100%; padding:0.65rem 1rem;">⚡ Simulate Match</button>
      <button class="btn btn-secondary" onclick="simulateWholeRoundInstant()" style="width:100%; margin-top:0.3rem;">⏩ Simulate Whole Round</button>
    `;
  }
  
  if (tickerNode) tickerNode.style.display = 'none';
}

function simulateMatchInConsole(matchId) {
  const currentRound = TOURNAMENT_STATE.rounds[TOURNAMENT_STATE.currentRoundIdx];
  const match = currentRound.find(m => m.id === matchId);
  if (!match || match.played) return;

  const ticker = document.getElementById('tournament-sim-ticker');
  const actions = document.getElementById('next-match-actions');
  if (ticker) {
    ticker.style.display = 'block';
    ticker.innerHTML = '';
  }

  if (actions) {
    actions.innerHTML = `<button class="btn btn-secondary" disabled style="width:100%; opacity:0.5;">Simulating Match...</button>`;
  }

  const logs = [
    `🎙️ Match started: ${match.p1.name} vs ${match.p2.name}`,
    `Topic: "${match.topic}"`,
    `${match.p1.name} introduces their main opening thesis...`,
    `${match.p2.name} counters with a structured rebuttal...`,
    `Audience reactions are streaming in. The agreement ratio shifts.`,
    `Both debaters submit final summary statements...`
  ];

  let step = 0;
  function printStep() {
    if (step < logs.length) {
      const line = document.createElement('div');
      line.textContent = logs[step];
      if (step === 0) line.style.color = 'var(--color-blue)';
      if (step === 1) line.style.color = 'var(--color-text-muted)';
      ticker.appendChild(line);
      ticker.scrollTop = ticker.scrollHeight;
      step++;
      setTimeout(printStep, 800);
    } else {
      const p1Elo = match.p1.elo;
      const p2Elo = match.p2.elo;
      let p1Chance = 0.5 + (p1Elo - p2Elo) / 1000;
      p1Chance = Math.min(0.85, Math.max(0.15, p1Chance));

      const p1Wins = Math.random() < p1Chance;
      
      let p1Score, p2Score;
      if (p1Wins) {
        p1Score = Math.floor(Math.random() * 15) + 51;
        p2Score = 100 - p1Score;
        match.winner = match.p1;
      } else {
        p2Score = Math.floor(Math.random() * 15) + 51;
        p1Score = 100 - p2Score;
        match.winner = match.p2;
      }

      match.p1Score = p1Score;
      match.p2Score = p2Score;
      match.played = true;

      const outcomeLine = document.createElement('div');
      outcomeLine.style.cssText = 'color:var(--color-gold); font-weight:bold; margin-top:0.4rem; border-top:1px solid rgba(255,255,255,0.1); padding-top:0.3rem;';
      outcomeLine.textContent = `🏆 Winner: ${match.winner.name} wins (${p1Wins ? p1Score : p2Score}% to ${p1Wins ? p2Score : p1Score}%)!`;
      ticker.appendChild(outcomeLine);
      ticker.scrollTop = ticker.scrollHeight;

      saveTournamentState();

      setTimeout(() => {
        renderTournamentUI();
      }, 1500);
    }
  }

  printStep();
}

function simulateWholeRoundInstant() {
  if (!TOURNAMENT_STATE) return;
  const currentRound = TOURNAMENT_STATE.rounds[TOURNAMENT_STATE.currentRoundIdx];
  if (!currentRound) return;

  currentRound.forEach(match => {
    if (match.played) return;
    
    const p1Elo = match.p1.elo;
    const p2Elo = match.p2.elo;
    let p1Chance = 0.5 + (p1Elo - p2Elo) / 1000;
    p1Chance = Math.min(0.85, Math.max(0.15, p1Chance));

    const p1Wins = Math.random() < p1Chance;
    let p1Score, p2Score;
    if (p1Wins) {
      p1Score = Math.floor(Math.random() * 15) + 51;
      p2Score = 100 - p1Score;
      match.winner = match.p1;
    } else {
      p2Score = Math.floor(Math.random() * 15) + 51;
      p1Score = 100 - p2Score;
      match.winner = match.p2;
    }

    match.p1Score = p1Score;
    match.p2Score = p2Score;
    match.played = true;
  });

  saveTournamentState();
  renderTournamentUI();
}

function quickSimUserTournamentMatch() {
  if (!TOURNAMENT_STATE) return;
  const currentRound = TOURNAMENT_STATE.rounds[TOURNAMENT_STATE.currentRoundIdx];
  const nextMatchIdx = getNextMatchIndex();
  if (nextMatchIdx === -1) return;

  const match = currentRound.find(m => m.id === nextMatchIdx);
  if (!match || match.played) return;

  const p1Elo = match.p1.elo;
  const p2Elo = match.p2.elo;
  let p1Chance = 0.5 + (p1Elo - p2Elo) / 1000;
  p1Chance = Math.min(0.85, Math.max(0.15, p1Chance));

  const p1Wins = Math.random() < p1Chance;
  let p1Score, p2Score;
  if (p1Wins) {
    p1Score = Math.floor(Math.random() * 15) + 51;
    p2Score = 100 - p1Score;
    match.winner = match.p1;
  } else {
    p2Score = Math.floor(Math.random() * 15) + 51;
    p1Score = 100 - p2Score;
    match.winner = match.p2;
  }

  match.p1Score = p1Score;
  match.p2Score = p2Score;
  match.played = true;

  saveTournamentState();
  renderTournamentUI();

  if (match.winner.isUser) {
    alert(`🎉 You won the simulated debate matchup against ${match.p1.isUser ? match.p2.name : match.p1.name} (${p1Wins ? p1Score : p2Score}% to ${p1Wins ? p2Score : p1Score}%)! You advance to the next round.`);
  } else {
    alert(`❌ You lost the simulated debate matchup against ${match.p1.isUser ? match.p2.name : match.p1.name} (${p1Wins ? p2Score : p1Score}% to ${p1Wins ? p1Score : p2Score}%). You have been knocked out!`);
  }
}

function playUserTournamentMatch() {
  if (!TOURNAMENT_STATE) return;
  const currentRound = TOURNAMENT_STATE.rounds[TOURNAMENT_STATE.currentRoundIdx];
  const nextMatchIdx = getNextMatchIndex();
  if (nextMatchIdx === -1) return;

  const match = currentRound.find(m => m.id === nextMatchIdx);
  if (!match || match.played) return;

  const topicSelect = document.getElementById('arena-topic');
  if (topicSelect) {
    let found = false;
    for (let i = 0; i < topicSelect.options.length; i++) {
      if (topicSelect.options[i].text === match.topic) {
        topicSelect.selectedIndex = i;
        found = true;
        break;
      }
    }
    if (!found) {
      const opt = document.createElement('option');
      opt.value = 'tournament-temp';
      opt.textContent = match.topic;
      topicSelect.appendChild(opt);
      topicSelect.value = 'tournament-temp';
    }
    topicSelect.disabled = true;
  }

  const opponent = match.p1.isUser ? match.p2 : match.p1;
  
  TOURNAMENT_STATE.userPlayingTournamentMatch = true;
  saveTournamentState();

  const publicSquareTabBtn = document.getElementById('tab-public-square');
  if (publicSquareTabBtn) {
    publicSquareTabBtn.click();
  }

  const arenaSubTabBtn = document.querySelector('[data-subtab="arena"]');
  if (arenaSubTabBtn) {
    arenaSubTabBtn.click();
  }

  alert(`🎙️ Welcome to your Tournament Match!\nTopic: "${match.topic}"\nOpponent: ${opponent.name} (Elo: ${opponent.elo})\n\nClick "Find Debate Partner" to connect and begin. Lock in your arguments to secure the audience agreement above 50%!`);
}

function advanceTournamentRound() {
  if (!TOURNAMENT_STATE) return;

  const currentRoundMatches = TOURNAMENT_STATE.rounds[TOURNAMENT_STATE.currentRoundIdx];
  const totalRounds = Math.log2(TOURNAMENT_STATE.size);

  const winners = currentRoundMatches.map(m => m.winner);
  const userSurvived = winners.some(w => w.isUser);

  if (TOURNAMENT_STATE.currentRoundIdx === totalRounds - 1) {
    const champion = winners[0];
    crownChampion(champion);
    return;
  }

  const nextRoundMatches = [];
  const numNextMatches = winners.length / 2;
  for (let i = 0; i < numNextMatches; i++) {
    const p1 = winners[i * 2];
    const p2 = winners[i * 2 + 1];
    const topicText = getRandomTopicForGenre(TOURNAMENT_STATE.genre);

    nextRoundMatches.push({
      id: i,
      p1,
      p2,
      winner: null,
      p1Score: null,
      p2Score: null,
      topic: topicText,
      played: false
    });
  }

  TOURNAMENT_STATE.rounds.push(nextRoundMatches);
  TOURNAMENT_STATE.currentRoundIdx++;

  saveTournamentState();
  renderTournamentUI();

  let roundLabel = `Round ${TOURNAMENT_STATE.currentRoundIdx + 1}`;
  if (TOURNAMENT_STATE.currentRoundIdx === totalRounds - 1) roundLabel = "Finals";
  else if (TOURNAMENT_STATE.currentRoundIdx === totalRounds - 2) roundLabel = "Semifinals";

  alert(`📣 Advancing to ${roundLabel}! Matches have been paired.`);
}

function crownChampion(champion) {
  if (!TOURNAMENT_STATE) return;

  const isUserChamp = champion.isUser;
  
  if (isUserChamp) {
    addCITZ(TOURNAMENT_STATE.prizePool, `Won Tournament: ${TOURNAMENT_STATE.name}`);
    
    if (!USER_BADGES.includes('debate-champion')) {
      USER_BADGES.push('debate-champion');
      localStorage.setItem('USER_BADGES', JSON.stringify(USER_BADGES));
      if (typeof updateDashboardBadges === 'function') {
        updateDashboardBadges();
      }
    }

    alert(`🏆 CONGRATULATIONS! You won the "${TOURNAMENT_STATE.name}" debate tournament! You have been awarded ${TOURNAMENT_STATE.prizePool} $CITZ and the "Tournament Champion" badge! 🎓👑`);
  } else {
    alert(`👑 Champion Crowned: ${champion.name} won the "${TOURNAMENT_STATE.name}" debate tournament!`);
  }

  const newRecord = {
    id: TOURNAMENT_HISTORY.length + 1,
    name: TOURNAMENT_STATE.name,
    size: TOURNAMENT_STATE.size,
    fee: TOURNAMENT_STATE.entryFee,
    prize: TOURNAMENT_STATE.prizePool,
    winner: champion.name,
    ts: Date.now()
  };

  TOURNAMENT_HISTORY.unshift(newRecord);
  if (TOURNAMENT_HISTORY.length > 20) TOURNAMENT_HISTORY.pop();
  localStorage.setItem('DEBATE_TOURNAMENT_HISTORY', JSON.stringify(TOURNAMENT_HISTORY));

  TOURNAMENT_STATE = null;
  localStorage.removeItem('DEBATE_TOURNAMENT');

  renderTournamentUI();
}

function forfeitActiveTournament() {
  if (!TOURNAMENT_STATE) return;

  alert(`❌ You forfeited the "${TOURNAMENT_STATE.name}" tournament. Entry fees are non-refundable.`);

  TOURNAMENT_STATE = null;
  localStorage.removeItem('DEBATE_TOURNAMENT');
  
  renderTournamentUI();
}

function renderTournamentHistory() {
  const container = document.getElementById('tournament-history-list');
  if (!container) return;

  container.innerHTML = '';
  if (TOURNAMENT_HISTORY.length === 0) {
    container.innerHTML = `<div style="text-align:center; padding:1.5rem; color:var(--color-text-muted); font-size:0.85rem;">No past tournaments found. Host one to start the legacy!</div>`;
    return;
  }

  TOURNAMENT_HISTORY.forEach(record => {
    const item = document.createElement('div');
    item.className = 'loan-listing-item';
    item.style.cssText = 'display:flex; justify-content:space-between; align-items:center; background:rgba(255,255,255,0.02); border:1px solid rgba(255,255,255,0.05); padding:0.75rem 1rem; border-radius:8px;';
    
    const dateStr = new Date(record.ts).toLocaleDateString();
    
    item.innerHTML = `
      <div>
        <div style="font-weight:bold; color:#fff; font-size:0.88rem;">${record.name}</div>
        <div style="font-size:0.75rem; color:var(--color-text-muted); margin-top:0.2rem;">
          Size: ${record.size} Competitors | Entry Fee: ${record.fee} $CITZ | ${dateStr}
        </div>
      </div>
      <div style="text-align:right;">
        <span style="font-size:0.75rem; color:var(--color-text-muted); display:block; margin-bottom:0.2rem;">Winner</span>
        <span style="background:rgba(245,158,11,0.12); color:var(--color-gold); font-size:0.78rem; font-weight:bold; padding:0.25rem 0.6rem; border-radius:4px; border:1px solid rgba(245,158,11,0.25);">
          👑 ${record.winner} (+${record.prize} $CITZ)
        </span>
      </div>
    `;
    container.appendChild(item);
  });
}

function saveTournamentState() {
  localStorage.setItem('DEBATE_TOURNAMENT', JSON.stringify(TOURNAMENT_STATE));
}

// Bind action methods to window for inline onclick attributes
window.simulateMatchInConsole = simulateMatchInConsole;
window.simulateWholeRoundInstant = simulateWholeRoundInstant;
window.playUserTournamentMatch = playUserTournamentMatch;
window.quickSimUserTournamentMatch = quickSimUserTournamentMatch;
window.advanceTournamentRound = advanceTournamentRound;
window.forfeitActiveTournament = forfeitActiveTournament;

/* ==========================================================================
   Phase 17. Chair System — Access Pass Gating & Tier Management
   ========================================================================== */

// Chair state — loaded from localStorage
let CHAIR_STATUS = localStorage.getItem('CHAIR_STATUS') || 'none'; // 'none' | 'basic' | 'pro' | 'gold'
let CHAIR_EXPIRY = parseInt(localStorage.getItem('CHAIR_EXPIRY')) || 0;

const CHAIR_TIERS = {
  basic: { name: 'Basic Chair',  emoji: '🪑',     color: '#3b82f6',  citzCost: 500,  canDebate: true,  canHostTournament: false, goldBadge: false },
  pro:   { name: 'Pro Chair',    emoji: '🪑✨',    color: '#a78bfa',  citzCost: 1200, canDebate: true,  canHostTournament: true,  goldBadge: false },
  gold:  { name: 'Gold Chair',   emoji: '👑',     color: '#f59e0b',  citzCost: 2500, canDebate: true,  canHostTournament: true,  goldBadge: true  }
};

// Stripe Payment Link URLs — REPLACE these with your actual Stripe payment links from dashboard.stripe.com
const STRIPE_LINKS = {
  basic: 'https://buy.stripe.com/REPLACE_WITH_BASIC_LINK',
  pro:   'https://buy.stripe.com/REPLACE_WITH_PRO_LINK',
  gold:  'https://buy.stripe.com/REPLACE_WITH_GOLD_LINK'
};

function hasValidChair() {
  if (CHAIR_STATUS === 'none') return false;
  if (CHAIR_STATUS === 'gold') return true; // lifetime, no expiry
  return Date.now() < CHAIR_EXPIRY;
}

function hasChairTier(tier) {
  if (!hasValidChair()) return false;
  if (CHAIR_STATUS === 'gold') return true;
  if (CHAIR_STATUS === 'pro') return tier === 'basic' || tier === 'pro';
  return tier === 'basic';
}

function grantChair(tier, source) {
  CHAIR_STATUS = tier;
  if (tier !== 'gold') {
    // 30 days for monthly subscriptions
    CHAIR_EXPIRY = Date.now() + (30 * 24 * 60 * 60 * 1000);
  } else {
    CHAIR_EXPIRY = 0; // no expiry
  }
  localStorage.setItem('CHAIR_STATUS', CHAIR_STATUS);
  localStorage.setItem('CHAIR_EXPIRY', CHAIR_EXPIRY.toString());
  updateChairUI();

  // Apply gold cosmetics if gold chair
  if (tier === 'gold') applyGoldChairCosmetics();

  // Log transaction
  if (source === 'citz') {
    const t = CHAIR_TIERS[tier];
    CITZ_TRANSACTIONS.unshift({ type: 'spend', amount: -t.citzCost, desc: `Chair Purchase: ${t.name}`, ts: Date.now() });
    saveCITZData();
  }

  updateAllCITZDisplays();
}

function updateChairUI() {
  const badge = document.getElementById('chair-status-badge');
  const badgeText = document.getElementById('chair-status-text');
  if (!badge || !badgeText) return;

  if (hasValidChair()) {
    const tier = CHAIR_TIERS[CHAIR_STATUS];
    badge.classList.remove('no-chair');
    badgeText.textContent = `${tier.emoji} ${tier.name}`;
    badge.title = `You have a ${tier.name}`;
    badge.style.borderColor = tier.color + '55';
    badge.style.color = tier.color;
  } else {
    badge.classList.add('no-chair');
    badgeText.textContent = 'No Chair';
    badge.title = 'Get a Chair to debate';
    badge.style.borderColor = '';
    badge.style.color = '';
  }

  // Update store status banner
  renderChairStoreBanner();
}

function renderChairStoreBanner() {
  const banner = document.getElementById('store-chair-status-banner');
  if (!banner) return;

  if (hasValidChair()) {
    const tier = CHAIR_TIERS[CHAIR_STATUS];
    let expText = '';
    if (CHAIR_STATUS !== 'gold') {
      const daysLeft = Math.ceil((CHAIR_EXPIRY - Date.now()) / (1000 * 60 * 60 * 24));
      expText = `Expires in ${daysLeft} days`;
    } else {
      expText = 'Lifetime access — never expires';
    }
    banner.innerHTML = `
      <div style="background:rgba(16,185,129,0.07); border:1px solid rgba(16,185,129,0.2); border-radius:10px; padding:0.85rem 1.1rem; display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:0.5rem;">
        <div style="display:flex; align-items:center; gap:0.6rem;">
          <span style="font-size:1.4rem;">${tier.emoji}</span>
          <div>
            <div style="font-weight:700; color:#fff; font-size:0.9rem;">Active: ${tier.name}</div>
            <div style="font-size:0.72rem; color:var(--color-text-muted);">${expText}</div>
          </div>
        </div>
        <span style="background:rgba(16,185,129,0.12); border:1px solid rgba(16,185,129,0.3); color:var(--color-green); font-size:0.7rem; font-weight:700; padding:0.25rem 0.7rem; border-radius:50px;">✓ ACTIVE</span>
      </div>
    `;
  } else {
    banner.innerHTML = `
      <div style="background:rgba(239,68,68,0.05); border:1px solid rgba(239,68,68,0.15); border-radius:10px; padding:0.75rem 1rem; font-size:0.8rem; color:var(--color-red); display:flex; align-items:center; gap:0.5rem;">
        <span>🚫</span> <span>No active Chair. Purchase one below to unlock debate access.</span>
      </div>
    `;
  }
}

function initChairSystem() {
  updateChairUI();
  // Refresh chair UI whenever store tab is clicked
  const storeTabBtn = document.getElementById('tab-citizens-store');
  if (storeTabBtn) {
    storeTabBtn.addEventListener('click', () => {
      setTimeout(renderChairStoreBanner, 50);
    });
  }
}

function applyGoldChairCosmetics() {
  const ring = document.getElementById('profile-avatar-ring');
  const name = document.getElementById('profile-display-name');
  if (ring) ring.classList.add('gold-chair-ring');
  if (name) name.classList.add('gold-chair-name');
}

// === Chair Paywall Modal ===
window.openChairPaywall = function(source) {
  if (hasValidChair()) {
    // Already has chair — show manage page
    const storeBtn = document.getElementById('tab-citizens-store');
    if (storeBtn) storeBtn.click();
    return;
  }
  const overlay = document.getElementById('chair-paywall-overlay');
  if (overlay) overlay.classList.remove('hidden');
  document.body.style.overflow = 'hidden';
};

window.closeChairPaywall = function() {
  const overlay = document.getElementById('chair-paywall-overlay');
  if (overlay) overlay.classList.add('hidden');
  document.body.style.overflow = '';
};

// Close on overlay background click
document.addEventListener('click', (e) => {
  const overlay = document.getElementById('chair-paywall-overlay');
  if (e.target === overlay) closeChairPaywall();
  const walletPanel = document.getElementById('wallet-panel');
  if (walletPanel && !walletPanel.contains(e.target)) {
    const walletBtn = document.getElementById('wallet-connect-btn');
    if (walletBtn && !walletBtn.contains(e.target)) {
      walletPanel.classList.add('hidden');
    }
  }
});

// === Chair Purchase via CITZ ===
window.buyCITZChair = function(tier) {
  const tierData = CHAIR_TIERS[tier];
  if (!tierData) return;
  if (hasChairTier(tier)) {
    alert(`✅ You already have ${tierData.name} or higher!`);
    closeChairPaywall();
    return;
  }
  if (CITZ_BALANCE < tierData.citzCost) {
    alert(`❌ Insufficient $CITZ!\nYou need ${tierData.citzCost.toLocaleString()} $CITZ.\nYou have ${CITZ_BALANCE.toLocaleString()} $CITZ.\n\nEarn more through Daily Challenges, Quizzes, or the Faucet!`);
    return;
  }
  if (!confirm(`Purchase ${tierData.emoji} ${tierData.name} for ${tierData.citzCost.toLocaleString()} $CITZ?\n\nThis grants you debate access for 30 days.`)) return;

  spendCITZ(tierData.citzCost, `Chair Purchase: ${tierData.name}`);
  grantChair(tier, 'citz');
  closeChairPaywall();
  alert(`🎉 ${tierData.emoji} ${tierData.name} activated! You now have full debate access.\n\nHead to the Public Square → Debate Arena to start debating!`);
  initCitizenDashboard();
};

// === Stripe Checkout ===
window.stripeCheckout = function(tier) {
  const tierData = CHAIR_TIERS[tier];
  const link = STRIPE_LINKS[tier];

  // Check if link is still a placeholder
  if (link.includes('REPLACE_WITH')) {
    // Demo mode — simulate successful payment
    const proceed = confirm(
      `💳 DEMO MODE: Stripe payment link not yet configured.\n\n` +
      `To set this up for real:\n` +
      `1. Create a free account at stripe.com\n` +
      `2. Create 3 Payment Links for Basic ($4.99/mo), Pro ($9.99/mo), Gold ($19.99)\n` +
      `3. Replace the STRIPE_LINKS URLs in app.js\n\n` +
      `For now, click OK to simulate a successful payment and get your ${tierData.name}.`
    );
    if (proceed) {
      grantChair(tier, 'stripe-demo');
      closeChairPaywall();
      alert(`✅ Demo: ${tierData.emoji} ${tierData.name} granted!\n\nIn production, Stripe redirects back to this page after payment with ?chair_activated=${tier} in the URL.`);
    }
    return;
  }

  // Real Stripe — append return URL so we can detect successful payment
  const returnUrl = encodeURIComponent(window.location.href.split('?')[0] + `?chair_activated=${tier}`);
  window.location.href = `${link}?success_url=${returnUrl}`;
};

// === Crypto Checkout (ETH/USDC on Base) ===
window.cryptoCheckout = function() {
  if (!WEB3_STATE.connected) {
    alert('Please connect your crypto wallet first using the "Connect Wallet" button in the top bar.');
    toggleWalletPanel();
    return;
  }

  const options = [
    'Basic Chair — 0.002 ETH (~$4.99)',
    'Pro Chair — 0.004 ETH (~$9.99)',
    'Gold Chair — 0.008 ETH (~$19.99) — Lifetime'
  ];

  const choice = prompt(
    '🔗 CRYPTO CHECKOUT (Base Network)\n\n' +
    'Enter tier number:\n' +
    '1 = Basic Chair — 0.002 ETH (~$4.99/mo)\n' +
    '2 = Pro Chair — 0.004 ETH (~$9.99/mo)\n' +
    '3 = Gold Chair — 0.008 ETH (~$19.99 lifetime)\n\n' +
    'Note: In production, this sends ETH to the platform wallet address and verifies on-chain.'
  );

  const tiers = ['basic', 'pro', 'gold'];
  const tierKey = tiers[parseInt(choice) - 1];
  if (!tierKey) { alert('Invalid selection.'); return; }

  const tierData = CHAIR_TIERS[tierKey];

  // In production: call a smart contract or send ETH to a treasury wallet and verify.
  // Demo mode: simulate successful on-chain payment.
  const confirm_ = confirm(
    `🔗 DEMO MODE: On-chain payment simulation.\n\n` +
    `In production this would:\n` +
    `1. Prompt MetaMask to send ${tierKey === 'basic' ? '0.002' : tierKey === 'pro' ? '0.004' : '0.008'} ETH to platform treasury\n` +
    `2. Contract emits ChairPurchased event\n` +
    `3. Frontend detects event and grants Chair\n\n` +
    `Simulate success and get ${tierData.name}?`
  );
  if (confirm_) {
    grantChair(tierKey, 'crypto');
    closeChairPaywall();
    alert(`✅ ${tierData.emoji} ${tierData.name} granted via crypto! Tx hash: 0x${Math.random().toString(16).substr(2, 40)} (simulated)`);
  }
};

// === Stripe Return URL Handler ===
function checkStripeReturn() {
  const params = new URLSearchParams(window.location.search);
  const activated = params.get('chair_activated');
  if (activated && CHAIR_TIERS[activated]) {
    grantChair(activated, 'stripe');
    // Clean URL
    const cleanUrl = window.location.href.split('?')[0];
    window.history.replaceState({}, document.title, cleanUrl);
    const tierData = CHAIR_TIERS[activated];
    setTimeout(() => {
      alert(`🎉 Payment successful! ${tierData.emoji} ${tierData.name} activated!\n\nHead to Public Square → Debate Arena to start debating.`);
    }, 500);
  }
}

// === Debate & Tournament Gating ===
// These wrap the existing connect/create functions to enforce Chair requirements

// Save original functions before wrapping
const _originalCreateTournament = typeof createTournament === 'function' ? createTournament : null;

window.guardedCreateTournament = function() {
  if (!hasChairTier('pro')) {
    openChairPaywall('tournament');
    // Show contextual message
    const overlay = document.getElementById('chair-paywall-overlay');
    if (overlay) {
      const subtitle = overlay.querySelector('.chair-paywall-subtitle');
      if (subtitle) subtitle.innerHTML = `<strong style="color:var(--color-gold);">Hosting tournaments requires a Pro Chair or higher.</strong> Choose a plan below to unlock tournament hosting.`;
    }
    return;
  }
  createTournament();
};

// Override the Host Tournament button to use the guarded version
document.addEventListener('DOMContentLoaded', () => {
  const hostBtn = document.getElementById('btn-host-tournament');
  if (hostBtn) {
    hostBtn.removeEventListener('click', createTournament);
    hostBtn.addEventListener('click', guardedCreateTournament);
  }
}, { once: true });

/* ==========================================================================
   Phase 17. Web3 Wallet Integration (ethers.js v6 + MetaMask)
   ========================================================================== */

let WEB3_STATE = {
  connected: false,
  address: null,
  provider: null,
  signer: null,
  chainId: null,
  citzBalance: 0
};

// REPLACE with your deployed ERC-20 contract address after deployment
const CITZ_CONTRACT_ADDRESS = '0x0000000000000000000000000000000000000000';

// Minimal ERC-20 ABI for reading balance
const CITZ_ABI_MINIMAL = [
  { name: 'balanceOf', type: 'function', stateMutability: 'view', inputs: [{ name: 'account', type: 'address' }], outputs: [{ name: '', type: 'uint256' }] },
  { name: 'decimals', type: 'function', stateMutability: 'view', inputs: [], outputs: [{ name: '', type: 'uint8' }] },
  { name: 'symbol', type: 'function', stateMutability: 'view', inputs: [], outputs: [{ name: '', type: 'string' }] }
];

function initWeb3() {
  // Restore persisted wallet connection on page load
  const savedAddress = localStorage.getItem('WEB3_ADDRESS');
  if (savedAddress && window.ethereum) {
    // Attempt silent reconnect
    window.ethereum.request({ method: 'eth_accounts' }).then(accounts => {
      if (accounts.length > 0 && accounts[0].toLowerCase() === savedAddress.toLowerCase()) {
        onWalletConnected(accounts[0]);
      }
    }).catch(() => {});
  }

  // Listen for account/chain changes
  if (window.ethereum) {
    window.ethereum.on('accountsChanged', (accounts) => {
      if (accounts.length === 0) disconnectWallet();
      else onWalletConnected(accounts[0]);
    });
    window.ethereum.on('chainChanged', () => window.location.reload());
  }
}

window.connectWallet = async function() {
  if (!window.ethereum) {
    alert('MetaMask not detected!\n\nPlease install MetaMask from metamask.io to connect your wallet.');
    window.open('https://metamask.io/download/', '_blank');
    return;
  }
  try {
    const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
    if (accounts.length > 0) {
      await onWalletConnected(accounts[0]);
    }
  } catch (err) {
    if (err.code === 4001) {
      alert('Wallet connection rejected. Please approve the MetaMask request to connect.');
    } else {
      console.error('Wallet connect error:', err);
    }
  }
};

window.connectWalletCoinbase = function() {
  alert('Coinbase Wallet connection coming soon! For now, please use MetaMask or any EVM-compatible wallet through MetaMask.');
};

async function onWalletConnected(address) {
  WEB3_STATE.connected = true;
  WEB3_STATE.address = address;
  localStorage.setItem('WEB3_ADDRESS', address);

  // Get chain ID
  try {
    const chainIdHex = await window.ethereum.request({ method: 'eth_chainId' });
    WEB3_STATE.chainId = parseInt(chainIdHex, 16);
  } catch (e) {}

  updateWalletPanelUI();
  await syncChainBalance();

  // Close wallet panel connect state, show connected state
  const notConnected = document.getElementById('wallet-not-connected');
  const connectedState = document.getElementById('wallet-connected-state');
  if (notConnected) notConnected.classList.add('hidden');
  if (connectedState) connectedState.classList.remove('hidden');

  // Update connect button
  const btn = document.getElementById('wallet-connect-btn');
  const label = document.getElementById('wallet-btn-label');
  if (btn) btn.classList.add('connected');
  if (label) label.textContent = formatAddress(address);
}

window.disconnectWallet = function() {
  WEB3_STATE = { connected: false, address: null, provider: null, signer: null, chainId: null, citzBalance: 0 };
  localStorage.removeItem('WEB3_ADDRESS');

  const notConnected = document.getElementById('wallet-not-connected');
  const connectedState = document.getElementById('wallet-connected-state');
  if (notConnected) notConnected.classList.remove('hidden');
  if (connectedState) connectedState.classList.add('hidden');

  const btn = document.getElementById('wallet-connect-btn');
  const label = document.getElementById('wallet-btn-label');
  if (btn) btn.classList.remove('connected');
  if (label) label.textContent = 'Connect Wallet';
};

window.syncChainBalance = async function() {
  if (!WEB3_STATE.connected || !WEB3_STATE.address) return;

  try {
    if (CITZ_CONTRACT_ADDRESS === '0x0000000000000000000000000000000000000000') {
      // Contract not deployed yet — show simulated balance
      WEB3_STATE.citzBalance = 0;
      const balEl = document.getElementById('onchain-citz-balance');
      if (balEl) balEl.textContent = 'Deploy contract first';
      return;
    }

    const provider = new ethers.BrowserProvider(window.ethereum);
    const contract = new ethers.Contract(CITZ_CONTRACT_ADDRESS, CITZ_ABI_MINIMAL, provider);
    const [raw, decimals] = await Promise.all([contract.balanceOf(WEB3_STATE.address), contract.decimals()]);
    WEB3_STATE.citzBalance = Number(ethers.formatUnits(raw, decimals));

    const balEl = document.getElementById('onchain-citz-balance');
    if (balEl) balEl.textContent = WEB3_STATE.citzBalance.toLocaleString();
  } catch (err) {
    console.warn('Chain balance sync failed:', err.message);
  }
};

function updateWalletPanelUI() {
  const shortAddr = document.getElementById('wallet-address-short');
  const simBal = document.getElementById('wallet-panel-sim-balance');
  if (shortAddr && WEB3_STATE.address) shortAddr.textContent = formatAddress(WEB3_STATE.address);
  if (simBal) simBal.textContent = CITZ_BALANCE.toLocaleString();
}

window.toggleWalletPanel = function() {
  const panel = document.getElementById('wallet-panel');
  if (!panel) return;
  if (panel.classList.contains('hidden')) {
    // Refresh panel data
    updateWalletPanelUI();
    panel.classList.remove('hidden');
  } else {
    panel.classList.add('hidden');
  }
};

window.copyWalletAddress = function() {
  if (!WEB3_STATE.address) return;
  navigator.clipboard.writeText(WEB3_STATE.address).then(() => {
    const el = document.getElementById('wallet-address-short');
    if (el) { const prev = el.textContent; el.textContent = 'Copied!'; setTimeout(() => el.textContent = prev, 1500); }
  }).catch(() => {
    prompt('Copy your wallet address:', WEB3_STATE.address);
  });
};

function formatAddress(addr) {
  if (!addr) return '0x0000...0000';
  return addr.substring(0, 6) + '...' + addr.substring(addr.length - 4);
}

/* ==========================================================================
   Phase 17. CITZToken.sol — ERC-20 Smart Contract Reference
   Deploy this to Base Sepolia (testnet) or Base Mainnet.
   Steps:
   1. Go to https://remix.ethereum.org
   2. Create new file CITZToken.sol, paste the contract below
   3. Install OpenZeppelin via Remix plugin manager
   4. Compile (Solidity 0.8.20)
   5. Deploy to Base Sepolia via MetaMask (free test ETH from faucet.base.org)
   6. Copy the deployed address and replace CITZ_CONTRACT_ADDRESS above
   ========================================================================== */

/*
SOLIDITY CONTRACT (paste into Remix IDE):
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CITZToken is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 100_000_000 * 10**18;
    mapping(address => uint8) public chairLevel; // 0=none,1=basic,2=pro,3=gold
    event ChairPurchased(address indexed buyer, uint8 tier, uint256 amount);

    constructor() ERC20("Citizens Token", "CITZ") Ownable(msg.sender) {
        _mint(msg.sender, 10_000_000 * 10**18); // Initial mint: 10M to owner
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
        _mint(to, amount);
    }

    function burnForChair(uint8 tier) external {
        uint256[4] memory costs = [uint256(0), 500e18, 1200e18, 2500e18];
        require(tier >= 1 && tier <= 3, "Invalid tier");
        require(balanceOf(msg.sender) >= costs[tier], "Insufficient CITZ");
        _burn(msg.sender, costs[tier]);
        chairLevel[msg.sender] = tier;
        emit ChairPurchased(msg.sender, tier, costs[tier]);
    }

    function hasChair(address user, uint8 minTier) external view returns (bool) {
        return chairLevel[user] >= minTier;
    }
}
*/

