local Players = game:GetService("Players")
local sss = game:GetService("ServerScriptService")

local profileservice = require(sss:FindFirstChild("ProfileService"))
local template = require(script.Template)

local Settings = require(game:GetService("ReplicatedStorage").Settings)
local dataKey = Settings.DataKey
local profileStore = profileservice.GetProfileStore(dataKey, template)

local dataManager = {}
dataManager.Profiles = {}

game.Players.PlayerAdded:Connect(function(player)
	assert(player)
	local profile = profileStore:LoadProfileAsync(tostring(player.UserId) .. "_playerdata")

	-- Admins are immune to bans - clear any ban data for admins
	--local isAdmin = false
	--for _, adminId in ipairs(Settings.Admins) do
	--	if player.UserId == adminId then
	--		isAdmin = true
	--		break
	--	end
	--end

	--if isAdmin then
	--	print("Admin " .. player.Name .. " joined - clearing any ban data")
	--	profile.Data.BanData.Banned = false
	--	profile.Data.BanData.Reason = nil
	--end

	if profile ~= nil then
		print(profile)
		profile:AddUserId(player.UserId)
		profile:Reconcile()

		profile:ListenToRelease(function()
			dataManager.Profiles[player] = nil
			player:Kick()
		end)

		if player:IsDescendantOf(Players) then
			dataManager.Profiles[player] = profile
		else
			profile:Release()
		end
	else
		player:Kick()
	end
end)

game.Players.PlayerRemoving:Connect(function(player)
	local profile = dataManager.Profiles[player]

	if profile ~= nil then
		profile:Release()
	end
end)

return dataManager
