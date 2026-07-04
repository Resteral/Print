-- ============================================================
-- CoAAbilityTrainer - Core Engine
-- Central state manager: tracks active class/spec, combat state,
-- dispatches updates to UI modules
-- ============================================================

CoAAT_Engine = {}

-- Internal state
local state = {
    classId      = nil,   -- e.g. "felsworn"
    specId       = nil,   -- e.g. "infernal_assault"
    inCombat     = false,
    resource     = 0,
    resourceMax  = 100,
    targetExists = false,
    targetHP     = 100,   -- % 0-100
    playerHP     = 100,   -- % 0-100
    petAlive     = false,
    -- Tracked buffs/debuffs (name → { active, remaining, applied })
    buffs    = {},
    debuffs  = {},
    -- Tracked cooldowns (abilityId → { start, duration })
    cooldowns = {},
    -- Tracked procs (procName → { active, remaining })
    procs = {},
    -- Ability objects for the active spec
    abilities = {},
    rotationRules = {},
}
CoAAT_Engine._state = state

-- ─────────────────────────────────────────────
-- Init / Setup
-- ─────────────────────────────────────────────
function CoAAT_Engine.Init()
    local db = CoAAT_DB
    if not db then return end

    if db.selectedClass and CoAAT_Abilities[db.selectedClass] then
        CoAAT_Engine.SetClass(db.selectedClass, db.selectedSpec)
    else
        -- Auto-read character class
        local _, classToken = UnitClass("player")
        if classToken then
            local detectId = classToken:lower()
            -- Replace spaces (if any class names have spaces, e.g. "Knight of Xoroth" -> "knight_of_xoroth")
            detectId = detectId:gsub(" ", "_")
            
            if CoAAT_Abilities[detectId] then
                local specId = nil
                if detectId == "felsworn" then
                    specId = "slayer"
                elseif detectId == "necromancer" then
                    specId = "reanimation"
                elseif detectId == "witch_hunter" then
                    specId = "inquisitor"
                else
                    local classDef = CoAAT_Abilities[detectId]
                    if classDef and classDef.specs then
                        for sId, _ in pairs(classDef.specs) do
                            specId = sId
                            break
                        end
                    end
                end

                if specId then
                    CoAAT_Engine.SetClass(detectId, specId)
                end
            end
        end
    end
end

-- ─────────────────────────────────────────────
-- Set active class + spec
-- ─────────────────────────────────────────────
function CoAAT_Engine.SetClass(classId, specId)
    if not CoAAT_Abilities[classId] then
        print("|cffff4444[CoAT]|r Unknown class: " .. tostring(classId))
        return
    end

    state.classId = classId
    state.specId  = specId

    local classDef = CoAAT_Abilities[classId]
    state.resourceMax  = classDef.resourceMax
    state.resourceColor = classDef.resourceColor

    -- Gather abilities for this spec
    state.abilities = {}
    if specId and classDef.specs and classDef.specs[specId] then
        local specDef = classDef.specs[specId]
        for _, ab in ipairs(specDef.abilities) do
            state.abilities[ab.id] = ab
        end
    end

    -- Gather rotation rules
    state.rotationRules = {}
    if CoAAT_RotationRules[classId] and specId and CoAAT_RotationRules[classId][specId] then
        state.rotationRules = CoAAT_RotationRules[classId][specId]
    end

    -- Save selection
    if CoAAT_DB then
        CoAAT_DB.selectedClass = classId
        CoAAT_DB.selectedSpec  = specId
    end

    -- Notify UI
    if CoAAT_CombatHUD.OnClassChanged then
        CoAAT_CombatHUD.OnClassChanged(classId, specId)
    end
    if CoAAT_RotationHelper.OnClassChanged then
        CoAAT_RotationHelper.OnClassChanged(classId, specId)
    end

    print("|cff00ccff[CoA Trainer]|r Class set to: |cffFFD700" ..
        (CoAAT_Abilities[classId].resource and (classId .. " (" .. specId .. ")") or classId) .. "|r")
end

-- ─────────────────────────────────────────────
-- Resource tracking (simulated for CoA custom resources)
-- Since CoA custom resources can't be read via UnitPower directly,
-- we simulate based on ability usage events + CLEU parsing
-- ─────────────────────────────────────────────
function CoAAT_Engine.SetResource(val)
    state.resource = math.max(0, math.min(state.resourceMax, val))
    if CoAAT_ResourceBar.Update then
        CoAAT_ResourceBar.Update(state.resource, state.resourceMax, state.resourceColor)
    end
end

function CoAAT_Engine.ModifyResource(delta)
    CoAAT_Engine.SetResource(state.resource + delta)
end

function CoAAT_Engine.GetResource()
    return state.resource, state.resourceMax
end

-- ─────────────────────────────────────────────
-- Buff / Debuff tracking
-- ─────────────────────────────────────────────
function CoAAT_Engine.SetBuff(name, remaining)
    state.buffs[name] = { active = true, remaining = remaining or 9999 }
end

function CoAAT_Engine.RemoveBuff(name)
    state.buffs[name] = { active = false, remaining = 0 }
end

function CoAAT_Engine.HasBuff(name)
    return state.buffs[name] and state.buffs[name].active
end

function CoAAT_Engine.SetDebuff(name, remaining)
    state.debuffs[name] = { active = true, remaining = remaining or 0 }
end

function CoAAT_Engine.RemoveDebuff(name)
    state.debuffs[name] = { active = false, remaining = 0 }
end

function CoAAT_Engine.HasDebuff(name)
    return state.debuffs[name] and state.debuffs[name].active
end

function CoAAT_Engine.GetDebuffRemaining(name)
    if state.debuffs[name] then return state.debuffs[name].remaining end
    return 0
end

-- ─────────────────────────────────────────────
-- Cooldown tracking
-- ─────────────────────────────────────────────
function CoAAT_Engine.StartCooldown(abilityId, duration)
    state.cooldowns[abilityId] = { start = GetTime(), duration = duration }
    if CoAAT_CooldownTracker.OnCooldownStart then
        CoAAT_CooldownTracker.OnCooldownStart(abilityId, duration)
    end
end

function CoAAT_Engine.IsReady(abilityId)
    local cd = state.cooldowns[abilityId]
    if not cd then return true end
    return (GetTime() - cd.start) >= cd.duration
end

function CoAAT_Engine.GetRemaining(abilityId)
    local cd = state.cooldowns[abilityId]
    if not cd then return 0 end
    local elapsed = GetTime() - cd.start
    return math.max(0, cd.duration - elapsed)
end

-- ─────────────────────────────────────────────
-- Proc tracking
-- ─────────────────────────────────────────────
function CoAAT_Engine.TriggerProc(procName, duration)
    state.procs[procName] = { active = true, expires = GetTime() + (duration or 5) }
    if CoAAT_ProcAlert.OnProc then
        CoAAT_ProcAlert.OnProc(procName, duration)
    end
    -- Also update rotation helper
    if CoAAT_RotationHelper.OnProcTriggered then
        CoAAT_RotationHelper.OnProcTriggered(procName)
    end
end

function CoAAT_Engine.HasProc(procName)
    local p = state.procs[procName]
    if not p or not p.active then return false end
    if GetTime() > p.expires then
        state.procs[procName].active = false
        return false
    end
    return true
end

function CoAAT_Engine.ConsumeProc(procName)
    if state.procs[procName] then
        state.procs[procName].active = false
    end
end

-- ─────────────────────────────────────────────
-- Combat state
-- ─────────────────────────────────────────────
function CoAAT_Engine.SetCombat(inCombat)
    state.inCombat = inCombat
    if CoAAT_CombatHUD.OnCombatChange then
        CoAAT_CombatHUD.OnCombatChange(inCombat)
    end
    if CoAAT_RotationHelper.OnCombatChange then
        CoAAT_RotationHelper.OnCombatChange(inCombat)
    end
end

function CoAAT_Engine.IsInCombat()
    return state.inCombat
end

-- ─────────────────────────────────────────────
-- Unit state
-- ─────────────────────────────────────────────
function CoAAT_Engine.UpdateUnitState()
    -- Player HP %
    local hp   = UnitHealth("player")
    local hpMax = UnitHealthMax("player")
    state.playerHP = (hpMax > 0) and math.floor((hp / hpMax) * 100) or 100

    -- Target exists?
    state.targetExists = UnitExists("target") and not UnitIsDead("target")

    -- Target HP %
    if state.targetExists then
        local thp    = UnitHealth("target")
        local thpMax = UnitHealthMax("target")
        state.targetHP = (thpMax > 0) and math.floor((thp / thpMax) * 100) or 100
    else
        state.targetHP = 100
    end

    -- Pet alive?
    state.petAlive = UnitExists("pet") and not UnitIsDead("pet")
end

function CoAAT_Engine.GetPlayerHP()   return state.playerHP   end
function CoAAT_Engine.GetTargetHP()   return state.targetHP   end
function CoAAT_Engine.HasTarget()     return state.targetExists end
function CoAAT_Engine.IsPetAlive()    return state.petAlive   end

-- ─────────────────────────────────────────────
-- Rotation evaluator
-- Returns the highest-priority ability to use right now
-- ─────────────────────────────────────────────
function CoAAT_Engine.EvaluateRotation()
    if not state.classId then return nil end
    local res, resMax = state.resource, state.resourceMax
    local rules = state.rotationRules

    local matches = {}
    local seen = {}

    for _, rule in ipairs(rules) do
        local matched = false

        if rule.condition == "always" then
            matched = true
        elseif rule.condition == "buff_missing" then
            matched = not CoAAT_Engine.HasBuff(rule.buffName)
        elseif rule.condition == "debuff_missing" then
            matched = not CoAAT_Engine.HasDebuff(rule.debuffName)
        elseif rule.condition == "debuff_expiring" then
            matched = CoAAT_Engine.HasDebuff(rule.debuffName) and
                      CoAAT_Engine.GetDebuffRemaining(rule.debuffName) <= 2.5
        elseif rule.condition == "cd_ready" then
            matched = CoAAT_Engine.IsReady(rule.abilityId)
        elseif rule.condition == "proc_active" then
            matched = CoAAT_Engine.HasProc(rule.procName)
        elseif rule.condition == "resource_gte" then
            matched = res >= rule.threshold
        elseif rule.condition == "pet_dead" then
            matched = not CoAAT_Engine.IsPetAlive()
        elseif rule.condition == "health_lt" then
            matched = CoAAT_Engine.GetPlayerHP() < rule.threshold
        end

        if matched then
            local aId = rule.abilityId
            if not seen[aId] then
                seen[aId] = true
                table.insert(matches, {
                    abilityId = aId,
                    urgency = rule.urgency,
                    abilityDef = state.abilities[aId]
                })
                if #matches >= 3 then
                    break
                end
            end
        end
    end

    return matches[1], matches[2], matches[3]
end

-- ─────────────────────────────────────────────
-- Tick: called every 0.1s OnUpdate
-- ─────────────────────────────────────────────
local tickAccum = 0
function CoAAT_Engine.OnUpdate(dt)
    tickAccum = tickAccum + dt
    if tickAccum < 0.1 then return end
    tickAccum = 0

    CoAAT_Engine.UpdateUnitState()

    -- Update debuff remaining timers
    local now = GetTime()
    for name, db in pairs(state.debuffs) do
        if db.active and db.remaining then
            db.remaining = db.remaining - 0.1
            if db.remaining <= 0 then
                db.active = false
            end
        end
    end

    -- Update proc expirations
    for name, proc in pairs(state.procs) do
        if proc.active and now > proc.expires then
            proc.active = false
            if CoAAT_ProcAlert.OnProcExpired then
                CoAAT_ProcAlert.OnProcExpired(name)
            end
        end
    end

    -- Evaluate rotation and push to helper
    local m1, m2, m3 = CoAAT_Engine.EvaluateRotation()
    if CoAAT_RotationHelper.SetNextAbilities then
        CoAAT_RotationHelper.SetNextAbilities(m1, m2, m3)
    end

    -- Update cooldown tracker
    if CoAAT_CooldownTracker.Tick then
        CoAAT_CooldownTracker.Tick(state.cooldowns, state.abilities)
    end
end

-- ─────────────────────────────────────────────
-- CLEU event parser: detect ability usage
-- ─────────────────────────────────────────────
function CoAAT_Engine.OnCLEU(...)
    local ts, event, _, srcGUID, _, _, _, destGUID, _, _, _,
          spellId, spellName = ...

    -- Only care about player-sourced events
    local playerGUID = UnitGUID("player")
    if srcGUID ~= playerGUID then return end

    local lowerName = spellName and spellName:lower() or ""

    -- Spell cast: start cooldown + resource change
    if event == "SPELL_CAST_SUCCESS" then
        -- Find matching ability by name fragment
        for id, ab in pairs(state.abilities) do
            if ab.name:lower() == lowerName then
                -- Start cooldown if it has one
                if ab.cooldown and ab.cooldown > 0 then
                    CoAAT_Engine.StartCooldown(id, ab.cooldown)
                end
                -- Apply resource cost/gain
                if ab.resourceCost then
                    CoAAT_Engine.ModifyResource(-ab.resourceCost)
                end
                if ab.resourceGain then
                    CoAAT_Engine.ModifyResource(ab.resourceGain)
                end
                -- Apply buff/debuff tracking
                if ab.type == "buff" then
                    CoAAT_Engine.SetBuff(ab.name, ab.duration)
                elseif ab.type == "debuff" then
                    CoAAT_Engine.SetDebuff(ab.name, ab.duration)
                end
                -- Consume proc if this ability was a proc spend
                if ab.type == "proc" then
                    CoAAT_Engine.ConsumeProc(ab.name)
                end
                break
            end
        end
    end

    -- Buff/debuff gain on player
    if event == "SPELL_AURA_APPLIED" and destGUID == playerGUID then
        CoAAT_Engine.SetBuff(spellName, 10)
        -- Check if this is a proc
        for id, ab in pairs(state.abilities) do
            if ab.type == "proc" and ab.name:lower() == lowerName then
                CoAAT_Engine.TriggerProc(ab.name, 8)
            end
        end
    end

    -- Buff removed
    if event == "SPELL_AURA_REMOVED" and destGUID == playerGUID then
        CoAAT_Engine.RemoveBuff(spellName)
    end

    -- Debuff applied on target
    if event == "SPELL_AURA_APPLIED" and destGUID ~= playerGUID and srcGUID == playerGUID then
        for id, ab in pairs(state.abilities) do
            if ab.type == "debuff" and ab.name:lower() == lowerName then
                CoAAT_Engine.SetDebuff(ab.name, ab.duration or 10)
            end
        end
    end
end

-- Get all abilities for the active spec
function CoAAT_Engine.GetAbilities()
    return state.abilities
end

function CoAAT_Engine.GetClassId()  return state.classId end
function CoAAT_Engine.GetSpecId()   return state.specId  end
function CoAAT_Engine.GetClassDef()
    if state.classId then return CoAAT_Abilities[state.classId] end
    return nil
end
function CoAAT_Engine.GetSpecDef()
    if state.classId and state.specId then
        local c = CoAAT_Abilities[state.classId]
        if c and c.specs then return c.specs[state.specId] end
    end
    return nil
end
