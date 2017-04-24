function gadget:GetInfo()
	return {
		name    = "Awards",
		desc    = "v1.002 Awards players at end of battle with shiny trophies.",
		author  = "CarRepairer",
		date    = "2008-10-15", --2013-09-05
		license = "GNU GPL, v2 or later",
		layer   = 1000000, -- Must be after all other build steps and before unit_spawner.lua for queen kill award.
		enabled = true,
	}
end

include("LuaRules/Configs/constants.lua")

local spGetAllyTeamList = Spring.GetAllyTeamList
local spIsGameOver      = Spring.IsGameOver
local spGetTeamInfo     = Spring.GetTeamInfo
local gaiaTeamID        = Spring.GetGaiaTeamID()

local echo = Spring.Echo

local totalTeamList = {}

local awardDescs = VFS.Include("LuaRules/Configs/award_names.lua")
local IsAHero = VFS.Include("LuaRules/Configs/hero_list.lua")	

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
local spAreTeamsAllied      = Spring.AreTeamsAllied
local spGetGameSeconds      = Spring.GetGameSeconds
local spGetTeamStatsHistory = Spring.GetTeamStatsHistory
local spGetUnitHealth       = Spring.GetUnitHealth
local spGetAllUnits         = Spring.GetAllUnits
local spGetUnitTeam         = Spring.GetUnitTeam
local spGetUnitDefID        = Spring.GetUnitDefID
local spGetUnitExperience   = Spring.GetUnitExperience
local spGetTeamResources    = Spring.GetTeamResources
local GetUnitCost           = Spring.Utilities.GetUnitCost

local floor = math.floor

local mexDefID = {
	UnitDefNames['tc_metalextractor_lvl1'].id,
	UnitDefNames['tc_metalextractor_lvl2'].id,	
	UnitDefNames['euf_metalextractor_lvl1'].id,
	UnitDefNames['euf_metalextractor_lvl2'].id,	
}

local shareListTemp1 = {}
local shareListTemp2 = {}

local awardData = {}


local empFactor     = 4
local reclaimFactor = 0.2 -- wrecks aren't guaranteed to leave more than 0.2 of value

local minFriendRatio = 0.25
local minReclaimRatio = 0.15

local awardAbsolutes = {
	cap         = 10,
	share       = 5000,
	rezz        = 30,
	mex         = 15,
	mexkill     = 15,
	head        = 3,
	dragon      = 3,
	sweeper     = 20,
	heart       = 1*10^9, --we should not exceed 2*10^9 because math.floor-ing the value will return integer -2147483648. Reference: https://code.google.com/p/zero-k/source/detail?r=9681
	vet         = 3,
}


local expUnitTeam, expUnitDefID, expUnitExp = 0,0,0

local awardList = {}
local sentAwards = false

local shareList_update = TEAM_SLOWUPDATE_RATE*60*5 -- five minute frames

local boats, t3Units, comms = {}, {}, {}

local staticO_small = {}

local staticO_big = {}

local kamikaze = {
	tc_kaboom=1,
	tc_suicide=1,
}

local flamerWeaponDefs = {}

-------------------
-- Resource tracking


local allyTeamInfo = {}
--local resourceInfo = {count = 0, data = {}}

do
	local allyTeamList = Spring.GetAllyTeamList()
	for i=1,#allyTeamList do
		local allyTeamID = allyTeamList[i]
		allyTeamInfo[allyTeamID] = {
			team = {},
			teams = 0,
		}

		local teamList = Spring.GetTeamList(allyTeamID)
		for j=1,#teamList do
			local teamID = teamList[j]
			allyTeamInfo[allyTeamID].teams = allyTeamInfo[allyTeamID].teams + 1
			allyTeamInfo[allyTeamID].team[allyTeamInfo[allyTeamID].teams] = teamID
		end
	end
end

------------------------------------------------
-- functions

local function comma_value(amount)
	local formatted = amount .. ''
	local k
	while true do
		formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

local function getMeanDamageExcept(excludeTeam)
	local mean = 0
	local count = 0
	--for team,dmg in pairs(damageList) do
	for team,dmg in pairs(awardData.pwn) do
		if team ~= excludeTeam
			and dmg > 100
		then
			mean = mean + dmg
			count = count + 1
		end
	end
	return (count>0) and (mean/count) or 0
end

local function getMaxVal(valList)
	local winTeam, maxVal = false,0
	for team,val in pairs(valList) do
		if val and val > maxVal then
			winTeam = team
			maxVal = val
			--Spring.Echo(" Team ".. winTeam .." maxVal ".. maxVal) --debug
		end
	end

	return winTeam, maxVal
end

local function getMeanMetalIncome()
	local num, sum = 0, 0
	for _,team in pairs(totalTeamList) do
		sum = sum + select(2, Spring.GetTeamResourceStats(team, "metal"))
		num = num + 1
	end
	return (sum/num)
end

local function awardAward(team, awardType, record)
	if not awardList[team] then --random check for devving.
		echo('<Award Error> Missing award list for team ' .. team)
		return
	end
	awardList[team][awardType] = record
end

local function CopyTable(original) -- Warning: circular table references lead to
	local copy = {}                -- an infinite loop.
	for k, v in pairs(original) do
		if (type(v) == "table") then
			copy[k] = CopyTable(v)
		else
			copy[k] = v
		end
	end
	return copy
end

local function UpdateShareList()
	awardData.share = CopyTable(shareListTemp2)
	shareListTemp2 = CopyTable(shareListTemp1)
end

local function UpdateResourceStats(t)

	resourceInfo.count = resourceInfo.count + 1
	resourceInfo.data[resourceInfo.count] = {allyRes = {}, teamRes = {}, t = t}

	for allyTeamID, allyTeamData in pairs(allyTeamInfo) do
		local teams = allyTeamData.teams
		local team = allyTeamData.team


		resourceInfo.data[resourceInfo.count].allyRes[allyTeamID] = {
			metal_income_total = 0,
			metal_income_base = 0,
			metal_income_other = 0,

			metal_spend_total = 0,
			metal_spend_construction = 0,
			metal_spend_waste = 0,

			metal_storage_current = 0,
			metal_storage_free = 0,

			energy_income_total = 0,

			energy_spend_total = 0,
			energy_spend_construction = 0,
			energy_spend_other = 0,
			energy_spend_waste = 0,

			energy_storage_current = 0,
		}

		local aRes = resourceInfo.data[resourceInfo.count].allyRes[allyTeamID]

		for i = 1, teams do
			local teamID = team[i]
			local mCurr, mStor, mPull, mInco, mExpe, mShar, mSent, mReci = spGetTeamResources(teamID, "metal")
			aRes.metal_spend_construction = aRes.metal_spend_construction + mExpe
			aRes.metal_income_total = aRes.metal_income_total + mInco
			aRes.metal_spend_total = aRes.metal_spend_total + mExpe
			aRes.metal_storage_free = aRes.metal_storage_free + mStor - mCurr
			aRes.metal_storage_current = aRes.metal_storage_current + mCurr

			local eCurr, eStor, ePull, eInco, eExpe, eShar, eSent, eReci = spGetTeamResources(teamID, "energy")
			aRes.energy_spend_total = aRes.energy_spend_total + eExpe
			aRes.energy_storage_current = aRes.energy_storage_current + eCurr


			resourceInfo.data[resourceInfo.count].teamRes[teamID] = {
				metal_income_total = mInco + mReci,
				metal_income_base = 0,
				metal_income_other = 0,

				metal_spend_total = mExpe + mSent,
				metal_spend_construction = mExpe,

				metal_share_net = mReci - mSent,

				metal_storage_current = mCurr,

				energy_income_total = eInco,

				energy_spend_total = eExpe,
				energy_spend_construction = mExpe,
				energy_spend_other = 0,

				energy_share_net = 0,

				energy_storage_current = eCurr,
			}

			local tRes = resourceInfo.data[resourceInfo.count].teamRes[teamID]

			tRes.metal_income_other = tRes.metal_income_total - tRes.metal_income_base - mReci
			tRes.energy_spend_other = tRes.energy_spend_total - tRes.energy_spend_construction + math.min(0, tRes.energy_share_net)
		end

		aRes.metal_income_other = aRes.metal_income_total - aRes.metal_income_base
		aRes.metal_spend_waste = math.min(aRes.metal_storage_free - aRes.metal_income_total - aRes.metal_spend_total,0)

		aRes.energy_spend_construction = aRes.metal_spend_construction
		aRes.energy_spend_other = aRes.energy_spend_total - (aRes.energy_spend_construction + aRes.energy_spend_waste)
	end
end

local function AddAwardPoints( awardType, teamID, amount )
	if (teamID and (teamID ~= gaiaTeamID)) then
		awardData[awardType][teamID] = awardData[awardType][teamID] + (amount or 0)
	end
end

local function ProcessAwardData()

	for awardType, data in pairs(awardData) do
		local winningTeam
		local maxVal
		local absolute = awardAbsolutes[awardType]
		local message

		if awardType == 'vet' then
			maxVal = expUnitExp
			winningTeam = expUnitTeam
		elseif awardType == 'friend' then

			maxVal = 0
			for team,dmg in pairs(data) do

				--local totalDamage = dmg+damageList[team]
				local totalDamage = dmg + awardData.pwn[team]
				local damageRatio = totalDamage>0 and dmg/totalDamage or 0

				if damageRatio > maxVal then
					winningTeam = team
					maxVal = damageRatio
				end
			end

		else
			winningTeam, maxVal = getMaxVal(data)

		end

		if winningTeam then

			local compare
			if absolute then
				compare = absolute

			else
				compare = getMeanDamageExcept(winningTeam)
			end

			--if reclaimTeam and maxReclaim > getMeanMetalIncome() * minReclaimRatio then
			if maxVal > compare then
				maxVal = floor(maxVal)
				maxValWrite = comma_value(maxVal)

				if awardType == 'cap' then
					message = 'Captured value: ' .. maxValWrite
				elseif awardType == 'share' then
					message = 'Shared value: ' .. maxValWrite
				elseif awardType == 'rezz' then
					message = 'Resurrected value: ' .. maxValWrite
				elseif awardType == 'fire' then
					message = 'Burnt value: ' .. maxValWrite
				elseif awardType == 'emp' then
					message = 'Stunned value: ' .. maxValWrite
				elseif awardType == 'slow' then
					message = 'Slowed value: ' .. maxValWrite
				elseif awardType == 'ouch' then
					message = 'Damage received: ' .. maxValWrite
				elseif awardType == 'reclaim' then
					message = 'Reclaimed value: ' .. maxValWrite
				elseif awardType == 'friend' then
					message = 'Damage to allies: '.. floor(maxVal * 100) ..'%'
				elseif awardType == 'mex' then
					message = 'Mexes built: '.. maxVal
				elseif awardType == 'mexkill' then
					message = 'Mexes destroyed: '.. maxVal
				elseif awardType == 'head' then
					message = maxVal .. ' Commanders eliminated'
				elseif awardType == 'dragon' then
					message = maxVal .. ' White Dragons annihilated'
				elseif awardType == 'heart' then
					local maxQueenKillDamage = maxVal - absolute --remove the queen kill signature: +1000000000 from the total damage
					message = 'Damage: '.. comma_value(maxQueenKillDamage)
				elseif awardType == 'sweeper' then
					message = maxVal .. ' Nests wiped out'

				elseif awardType == 'vet' then
					local vetName = UnitDefs[expUnitDefID] and UnitDefs[expUnitDefID].humanName
					local expUnitExpRounded = floor(expUnitExp * 100)
					message = vetName ..', '.. expUnitExpRounded .. "% cost made"
				else
					message = 'Damaged value: '.. maxValWrite
				end
			end
		end --if winningTeam
		if message then
			awardAward(winningTeam, awardType, message)
		end

	end
end

-------------------
-- Callins

function gadget:Initialize()

	GG.Awards = GG.Awards or {}
	GG.Awards.AddAwardPoints = AddAwardPoints
	
	--_G.resourceInfo = resourceInfo

	local tempTeamList = Spring.GetTeamList()
	for i=1, #tempTeamList do
		local team = tempTeamList[i]
		--Spring.Echo('team', team)
		if team ~= gaiaTeamID then
			totalTeamList[team] = team
		end
	end

	--new
	for awardType, _ in pairs(awardDescs) do
		awardData[awardType] = {}
	end
	for _,team in pairs(totalTeamList) do
		awardList[team] = {}

		shareListTemp1[team] = 0
		shareListTemp2[team] = 0

		for awardType, _ in pairs(awardDescs) do
			awardData[awardType][team] = 0
		end

	end

	local boatFacs = {'factoryship', 'striderhub'}
	for _, boatFac in pairs(boatFacs) do
		local udBoatFac = UnitDefNames[boatFac]
		if udBoatFac then
			for _, boatDefID in pairs(udBoatFac.buildOptions) do
				if (UnitDefs[boatDefID].minWaterDepth > 0) then -- because striderhub
					boats[boatDefID] = true
				end
			end
		end
	end

	--[[
	local t3Facs = {'armshltx', 'corgant', }
	for _, t3Fac in pairs(t3Facs) do
		local udT3Fac = UnitDefNames[t3Fac]
		for _, t3DefID in pairs(udT3Fac.buildOptions) do
			t3Units[t3DefID] = true
		end
	end
	--]]

	for i=1,#WeaponDefs do
		local wcp = WeaponDefs[i].customParams or {}
		if (wcp.setunitsonfire) then
			flamerWeaponDefs[i] = true
		end
	end

	for i=1,#UnitDefs do
		if(UnitDefs[i].customParams.dynamic_comm) then comms[i] = true
	end
 end

end --Initialize

function gadget:UnitTaken(unitID, unitDefID, oldTeam, newTeam)
	-- Units given to neutral?
	if oldTeam == gaiaTeamID or newTeam == gaiaTeamID then
		return
	end
	if not spAreTeamsAllied(oldTeam,newTeam) then
		if awardData['cap'][newTeam] then --if team exist, then:
			local ud = UnitDefs[unitDefID]
			local mCost = GetUnitCost(unitID, unitDefID)
			AddAwardPoints( 'cap', newTeam, mCost )
			if (ud.customParams.dynamic_comm) then
				if (not IsAHero[unitID]) then
					IsAHero[unitID] = select(6, spGetTeamInfo(oldTeam))
				elseif (IsAHero[unitID] == select(6, spGetTeamInfo(newTeam))) then
					IsAHero[unitID] = nil
				end
			end
		end
	else -- teams are allied
		if shareListTemp1[oldTeam] and shareListTemp1[newTeam] then
			local mCost = GetUnitCost(unitID, unitDefID)

			shareListTemp1[oldTeam] = shareListTemp1[oldTeam] + mCost
			shareListTemp1[newTeam] = shareListTemp1[newTeam] - mCost

			--[[
			AddAwardPoints( 'share', oldTeam, mCost )
			AddAwardPoints( 'share', newTeam, 0-mCost )
			--]]
		end
	end
end

function gadget:FeatureDestroyed(featureID, allyTeamID)
--	Spring.Echo("Feature destroyed:" .. featureID)
	local UnitDefName, buildFacing = Spring.GetFeatureResurrect(featureID)
	if (UnitDefName ~= nil) then
--		Spring.Echo("Rezzed")
		local fx,fy,fz = Spring.GetFeaturePosition(featureID)
--		Spring.Echo(fx .. " " .. fz)
		local UnitsClose = Spring.GetUnitsInCylinder(fx, fz, 10)
		for _,eUnitID in ipairs(UnitsClose) do
			local eUnitDefID = Spring.GetUnitDefID(eUnitID)
			local eUnitDefName = UnitDefs[eUnitDefID].name
--			Spring.Echo("udname:" .. eUnitDefName)
			if (UnitDefName == eUnitDefName) then
				local eUnitTeam = Spring.GetUnitTeam(eUnitID)
				Spring.Echo("Rezz point given to:" .. eUnitTeam)
				AddAwardPoints( 'rezz', eUnitTeam, 1 )
			end
		end
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, _, _, killerTeam)
	local experience = spGetUnitExperience(unitID)
	if experience > expUnitExp and (experience*UnitDefs[unitDefID].metalCost > 1000) then
		expUnitExp = experience
		expUnitTeam = unitTeam
		expUnitDefID = unitDefID
	end

	if (IsAHero[unitID]) then
		IsAHero[unitID] = nil
		if (unitTeam ~= gaiaTeamID) then
			AddAwardPoints( 'head', unitTeam, 1 )
		end
		return
	end

	if (killerTeam == unitTeam) or (killerTeam == gaiaTeamID) or (unitTeam == gaiaTeamID) or (killerTeam == nil) then
		return
	elseif (unitDefID == mexDefID) then
		if ((not spIsGameOver()) and (select(5, spGetUnitHealth(unitID)) > 0.9) and (not spAreTeamsAllied(killerTeam, unitTeam))) then
			AddAwardPoints( 'mexkill', killerTeam, 1 )
		end
	else
		local ud = UnitDefs[unitDefID]
		if (ud.customParams.dynamic_comm and (not spAreTeamsAllied(killerTeam, unitTeam))) then
			AddAwardPoints( 'head', killerTeam, 1 )
		elseif ud.name == "tc_dragon" then
			AddAwardPoints( 'dragon', killerTeam, 1 )
		elseif ud.name == "tc_dragonqueen" then
			for killerFrienz, _ in pairs(awardData['heart']) do --give +1000000000 points for all frienz that kill queen and won
				AddAwardPoints( 'heart', killerFrienz, awardAbsolutes['heart']) --the extra points is for id purpose. Will deduct later
			end
		elseif ud.name == "tc_pitt" then
			AddAwardPoints( 'sweeper', killerTeam, 1 )
		else
			--
		end
	end
end

function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponID,
		attackerID, attackerDefID, attackerTeam)
	if (unitTeam == gaiaTeamID) then return end
	local hp, maxHP = spGetUnitHealth(unitID)
	if (hp < 0) then
		damage = damage + hp
	end
	AddAwardPoints( 'ouch', unitTeam, damage )

	if (not attackerTeam)
		or (attackerTeam == unitTeam)
		or (attackerTeam == gaiaTeamID)
		then return end

	local ud = UnitDefs[unitDefID]
	local costdamage = (damage / maxHP) * GetUnitCost(unitID, unitDefID)

	if spAreTeamsAllied(attackerTeam, unitTeam) then
		if not paralyzer then
			AddAwardPoints( 'friend', attackerTeam, costdamage )
		end
	else
		if paralyzer then
			AddAwardPoints( 'emp', attackerTeam, costdamage )
		else
			if ud.name == "chickenflyerqueen" or ud.name == "chickenlandqueen" then
				AddAwardPoints( 'heart', attackerTeam, damage )
			end
			local ad = UnitDefs[attackerDefID]

			if (flamerWeaponDefs[weaponID]) then
				AddAwardPoints( 'fire', attackerTeam, costdamage )
			end

			-- Static Weapons
			if (not ad.canMove) then

				-- bignukes, zenith, starlight
				if staticO_big[ad.name] then
					AddAwardPoints( 'nux', attackerTeam, costdamage )

				-- not lrpc, tacnuke, emp missile
				elseif not staticO_small[ad.name] then
					AddAwardPoints( 'shell', attackerTeam, costdamage )
				end

			elseif kamikaze[ad.name] then
				AddAwardPoints( 'kam', attackerTeam, costdamage )

			elseif ad.canFly and not (ad.customParams.dontcount or ad.customParams.is_drone) then
				AddAwardPoints( 'air', attackerTeam, costdamage )

			elseif boats[attackerDefID] then
				AddAwardPoints( 'navy', attackerTeam, costdamage )

			elseif t3Units[attackerDefID] then
				AddAwardPoints( 't3', attackerTeam, costdamage )

			elseif comms[attackerDefID] then
				AddAwardPoints( 'comm', attackerTeam, costdamage )

			end
		end
	end
end

function gadget:UnitFinished(unitID, unitDefID, teamID)
	if unitDefID == mexDefID then
		AddAwardPoints( 'mex', teamID, 1 )
	end
end

function gadget:GameFrame(n)

	if n % shareList_update == 1 and not spIsGameOver() then
		UpdateShareList()
	end

	if not spIsGameOver() then return end

	if not sentAwards then
		local units = spGetAllUnits()
		for i=1,#units do
			local unitID = units[i]
			local teamID = spGetUnitTeam(unitID)
			local unitDefID = spGetUnitDefID(unitID)
			gadget:UnitDestroyed(unitID, unitDefID, teamID)
		end

		-- read externally tracked values
		local teams = Spring.GetTeamList()
		for i = 1, #teams do
			local team = teams[i]
			if team ~= gaiaTeamID then
				AddAwardPoints('reclaim', team, Spring.GetTeamRulesParam(team, "stats_history_metal_reclaim_current") or 0)
				AddAwardPoints('pwn', team, Spring.GetTeamRulesParam(team, "stats_history_damage_dealt_current") or 0)
			end
		end

		ProcessAwardData()

		_G.awardList = awardList
		sentAwards = true
	end
end --GameFrame

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
else -- UNSYNCED
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local spSendCommands  = Spring.SendCommands

local gameOver = false

local teamNames     = {}
local awardList

function gadget:Initialize()
	local tempTeamList = Spring.GetTeamList()
	for i=1, #tempTeamList do
		local team = tempTeamList[i]
		--Spring.Echo('team', team)
		if team ~= gaiaTeamID then
			totalTeamList[team] = team
		end
	end

	for _,team in pairs(totalTeamList) do
		local _, leaderPlayerID, _, isAI = spGetTeamInfo(team)
		local name
		if isAI then
			local _, aiName, _, shortName = Spring.GetAIInfo(team)
			name = aiName ..' ('.. shortName .. ')'
		else
			name = Spring.GetPlayerInfo(leaderPlayerID)
		end
		teamNames[team] = name
	end
end

local function SendEconomyDataToWidget()

	if (Script.LuaUI('WriteResourceStatsToFile')) then
		Spring.Echo("Awards: Writing resource data to widget")
		local resourceInfo = SYNCED.resourceInfo
		local count = resourceInfo.count
		local data = resourceInfo.data
		local reallyBigString = ""

		for i = 1, count do
			if data[i] then
				local toSend = data[i].t .. " "
				for allyTeamID, allyData in spairs(data[i].allyRes) do
					toSend = toSend .. " " .. allyTeamID .. " " ..
					allyData.metal_income_total .. " " ..
					allyData.metal_income_base .. " " ..
					allyData.metal_income_other .. " " ..

					allyData.metal_spend_total .. " " ..
					allyData.metal_spend_construction .. " " ..
					allyData.metal_spend_waste .. " " ..

					allyData.metal_storage_current .. " " ..
					allyData.metal_storage_free .. " " ..

					allyData.energy_income_total .. " " ..

					allyData.energy_spend_total .. " " ..
					allyData.energy_spend_construction .. " " ..
					allyData.energy_spend_other .. " " ..
					allyData.energy_spend_waste .. " " ..

					allyData.energy_storage_current
				end
				--Spring.SendCommands("wbynum 255 SPRINGIE: allyResourceData " .. toSend)
				reallyBigString = reallyBigString .. toSend .. "\n"

				toSend = data[i].t .. " "

				for teamID, teamData in spairs(data[i].teamRes) do
					toSend = toSend .. " " .. teamID .. " " ..
					teamData.metal_income_total .. " " ..
					teamData.metal_income_base .. " " ..
					teamData.metal_income_other .. " " ..

					teamData.metal_spend_total .. " " ..
					teamData.metal_spend_construction .. " " ..

					teamData.metal_share_net .. " " ..

					teamData.metal_storage_current .. " " ..

					teamData.energy_income_total .. " " ..

					teamData.energy_spend_total .. " " ..
					teamData.energy_spend_construction .. " " ..
					teamData.energy_spend_other .. " " ..

					teamData.energy_share_net .. " " ..

					teamData.energy_storage_current
				end

				reallyBigString = reallyBigString .. toSend .. "\n"
			end
		end

		Script.LuaUI.WriteResourceStatsToFile(reallyBigString, teamNames)
	end

end

function gadget:GameOver()
	gameOver = true
	--Spring.Echo("Game over (awards unsynced)")
		
	--// Resources
	--SendEconomyDataToWidget()
end

-- function to convert SYNCED table to regular table. assumes no self referential loops
local function ConvertToRegularTable(stable)
	local ret = {}
	local stableLocal = stable
	for k,v in spairs(stableLocal) do
		if type(v) == 'table' then
			v = ConvertToRegularTable(v)
		end
		ret[k] = v
	end
	return ret
end

function gadget:Update()
	if not gameOver then
		return
	end
	if (not awardList) and SYNCED.awardList then
		awardList = ConvertToRegularTable( SYNCED.awardList )
		Script.LuaUI.SetAwardList( awardList )
	end
end

--unsynced
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
end