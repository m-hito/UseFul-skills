local DataService = {}
local RPS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

function DataService.loadServer()
	RPS.shared.Network.GetProfile.OnServerInvoke = function(Player)
		return DataService.getProfile(Player)
	end
end

function DataService.getProfile(player : Player)
	print(player)
	if game.Players.LocalPlayer then
		repeat
			task.wait()
		until RPS.shared.Network.GetProfile:InvokeServer() ~= nil
		if player and player == game.Players.LocalPlayer then
			
			return RPS.shared.Network.GetProfile:InvokeServer()
		end
	else
		repeat
			task.wait()
			if not player then break end
		until require(SSS.DataManager).Profiles[player]
		if player then
			return require(SSS.DataManager).Profiles[player]
		end
	end
end

return DataService
