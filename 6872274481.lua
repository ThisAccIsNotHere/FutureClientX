if shared.GuiLibrary then
    shared.GuiLibrary["SelfDestruct"]()
end

wait(0.5)

loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua", true))()

wait(0.5)

-- Credits to Inf Yield & all the other scripts that helped me make bypasses
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService("UserInputService")
local localmouse = lplr:GetMouse()
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local getasset = getsynasset or getcustomasset

local RenderStepTable = {}
local StepTable = {}

local function BindToRenderStep(name, num, func)
	if RenderStepTable[name] == nil then
		RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
	end
end


local function UnbindFromRenderStep(name)
	if RenderStepTable[name] then
		RenderStepTable[name]:Disconnect()
		RenderStepTable[name] = nil
	end
end

local function BindToStepped(name, num, func)
	if StepTable[name] == nil then
		StepTable[name] = game:GetService("RunService").Stepped:connect(func)
	end
end
local function UnbindFromStepped(name)
	if StepTable[name] then
		StepTable[name]:Disconnect()
		StepTable[name] = nil
	end
end

local function infonotify(title, text, delay)
	pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/InfoNotification.png")
		frame.Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
		frame.Frame.Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
	end)
end
local function warnnotify(title, text, delay)
	pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
		frame.Frame.Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
	end)
end

local function friendCheck(plr, recolor)
	return (recolor and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] or (not recolor)) and GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] and table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name) and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)]
end

local function getPlayerColor(plr)
	return (friendCheck(plr, true) and Color3.fromHSV(GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Hue"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Sat"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Value"]) or tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color)
end

local function getcustomassetfunc(path)
	if not isfile(path) then
		spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Downloading "..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary["MainGui"]
			repeat wait() until isfile(path)
			textlabel:Remove()
		end)
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..path:gsub("vape/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	return getasset(path) 
end

shared.vapeteamcheck = function(plr)
	return (GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] and (plr.Team ~= lplr.Team or (lplr.Team == nil or #lplr.Team:GetPlayers() == #game:GetService("Players"):GetChildren())) or GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] == false)
end

local function targetCheck(plr, check)
	return (check and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
end

local function isAlive(plr)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Head") and lplr.Character:FindFirstChild("Humanoid")
end

local function isPlayerTargetable(plr, target, friend)
    return plr ~= lplr and plr and (friend and friendCheck(plr) == nil or (not friend)) and isAlive(plr) and targetCheck(plr, target) and shared.vapeteamcheck(plr)
end

local function vischeck(char, part)
	return not unpack(cam:GetPartsObscuringTarget({lplr.Character[part].Position, char[part].Position}, {lplr.Character, char}))
end

local function runcode(func)
	func()
end

local function GetAllNearestHumanoidToPosition(player, distance, amount)
	local returnedplayer = {}
	local currentamount = 0
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and currentamount < amount then
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if mag <= distance then
                    table.insert(returnedplayer, v)
					currentamount = currentamount + 1
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToPosition(player, distance)
	local closest, returnedplayer = distance, nil
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") then
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if mag <= closest then
                    closest = mag
                    returnedplayer = v
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToMouse(player, distance, checkvis)
    local closest, returnedplayer = distance, nil
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and (checkvis == false or checkvis and (vischeck(v.Character, "Head") or vischeck(v.Character, "HumanoidRootPart"))) then
                local vec, vis = cam:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                if vis then
                    local mag = (uis:GetMouseLocation() - Vector2.new(vec.X, vec.Y)).magnitude
                    if mag <= closest then
                        closest = mag
                        returnedplayer = v
                    end
                end
            end
        end
    end
    return returnedplayer
end

local function CalculateObjectPosition(pos)
	local newpos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(cam.CFrame:pointToObjectSpace(pos)))
	return Vector2.new(newpos.X, newpos.Y)
end

local function CalculateLine(startVector, endVector, obj)
	local Distance = (startVector - endVector).Magnitude
	obj.Size = UDim2.new(0, Distance, 0, 2)
	obj.Position = UDim2.new(0, (startVector.X + endVector.X) / 2, 0, ((startVector.Y + endVector.Y) / 2) - 36)
	obj.Rotation = math.atan2(endVector.Y - startVector.Y, endVector.X - startVector.X) * (180 / math.pi)
end

local function findTouchInterest(tool)
	for i,v in pairs(tool:GetDescendants()) do
		if v:IsA("TouchTransmitter") then
			return v
		end
	end
	return nil
end

infonotify("Smoke", "Loaded Successfully!", 5)
loadstring(game:HttpGet("https://raw.githubusercontent.com/SmokeXDev/SmokeXPubblic/main/SmokeXTeamDetector.lua", true))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/SmokeXDev/SmokeXPubblic/main/SmokeXTeam/NewDetect.lua", true))()

GuiLibrary.RemoveObject("XrayOptionsButton")
GuiLibrary.RemoveObject("SwimOptionsButton")

runcode(function()
	local NoAnim = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "NoAnim",
		["Function"] = function(callback)
			if callback then
				infonotify("NoAnim", "Enabled!", 5)
				game:GetService("Players").LocalPlayer.Character.Animate.Disabled = true
			else
				game:GetService("Players").LocalPlayer.Character.Animate.Disabled = false
				infonotify("NoAnim", "Disabled!", 5)
			end
		end
	})
end)

runcode(function()
	local mouse = game:GetService("Players").LocalPlayer:GetMouse()
	local Crosshair = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "Crosshair",
		["Function"] = function(callback)
			if callback then
				infonotify("Crosshair", "Enabled!", 5)
				mouse.Icon = "rbxassetid://9943168532"
			else
				infonotify("Crosshair", "Disabled!", 5)
				mouse.Icon = ""
			end
		end
	})
end)

runcode(function()
	local NightVal = false
	local Night = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({ 
		["Name"] = "Night",
		["Function"] = function(callback)
			if callback then
					infonotify("Night", "Loaded!", 5)
					NightVal = true
					while NightVal and task.wait(0.3) do
						game:GetService("Lighting").TimeOfDay = "00:00:00"
					end
				else
					infonotify("Night", "Night Removed!", 5)
					NightVal = false
					wait(0.3)
				game:GetService("Lighting").TimeOfDay = "13:00:00"
			end
		end
	})
end)

runcode(function()
	local DayVal = false
	local Day = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "Day",
		["Function"] = function(callback)
			if callback then
				infonotify("Day", "Loaded!", 5)
				DayVal = true
				while DayVal and task.wait(0.3) do
					game:GetService("Lighting").TimeOfDay = "07:00:00"
				end
			else
				infonotify("Day", "Day Removed!", 5)
				DayVal = false
				wait(0.3)
				game:GetService("Lighting").TimeOfDay = ""
			end
		end
	})
end)

runcode(function()
	local AntiVoidV2 = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		["Name"] = "AntiVoidV2",
		["Function"] = function(callback)
			if callback then
				infonotify("AntiVoidV2", "Loaded!", 5)
					gshared.AntiVoidV2 = true
					local part = Instance.new("Part")
					part.Name = "AntiVoidV2"
					part.Anchored = true
					part.Transparency = 1
					part.Size = Vector3.new(5000,2,5000)
					part.Parent = game:GetService("Workspace")
					part.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame - Vector3.new(0,20,0)
					shared.AntiVoidV2 = part
					part.Touched:Connect(function()
					game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
						task.wait(.20)
					game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
				end)
			else
				infonotify("AntiVoidV2", "Deleted Successfully!", 5)
				shared.AntiVoidV2 = false
				workspace.AntiVoidV2:Destroy()
			end
		end
	})
end)

runcode(function()
	local AFKFarm = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		["Name"] = "AFKFarm",
		["Function"] = function(callback)
			if callback then
				infonotify("AFKFarm", "Enabled!", "5")
				local char = game:GetService("Players").LocalPlayer.Character
				char:FindFirstChild("HumanoidRootPart").CFrame = char:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0,99,0)
				char:FindFirstChild("Head").Anchored = true
				char:FindFirstChild("UpperTorso").Anchored = true
				char:FindFirstChild("UpperTorso").Anchored = true
			else
				infonotify("AFKFarm", "Disabled!", "5")
				local char = game:GetService("Players").LocalPlayer.Character
				char:FindFirstChild("HumanoidRootPart").CFrame = char:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0,99,0)
				char:FindFirstChild("Head").Anchored = false
				char:FindFirstChild("UpperTorso").Anchored = false
				char:FindFirstChild("UpperTorso").Anchored = false
			end
		end
	})
end)

runcode(function()
	local ChatDisabler = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "ChatDisabler",
		["Function"] = function(callback)
			if callback then
				local succ, err = pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false) end)
				if succ then
					infonotify('ChatDisabler', "Chat disabled!", 5)
				elseif err then
					warnnotify('ChatDisabler', "Patched", 5)
				end
			else
				local succ, err = pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true) end)
				if succ then
					infonotify('ChatDisabler', "Chat enabled!", 5)
				elseif err then
					warnnotify('ChatDisabler', "Patched", 5)
				end
			end
		end
	})
end)

runcode(function()
	local FlyBetaVal = false
	local FlyGrav = 3
	local FlySpeed = 23
	local FlyGravDefault = 192
	local FlySpeedDefault = 16
	local FlyBeta = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		["Name"] = "FlyBeta",
		["Function"] = function(FlyFunc, DelayFlyVal)
			if FlyFunc then
				wait(DelayFlyVal)
				FlyBetaVal = true
				while FlyBetaVal do
					workspace.Gravity = FlyGrav
					game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = FlySpeed
					task.wait()
				end
			else
				FlyBetaVal = false
				workspace.Gravity = FlyGravDefault
				game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = FlySpeedDefault
			end
		end
	})
	FlyBeta.CreateSlider({
		["Name"] = "Delay",
		["Min"] = 0,
		["Max"] = 10,
		["Function"] = function(DelayFlyVal)
		end,
		["Default"] = 1
	})
end)

runcode(function()
	local ResetMethod = {Value = "InstaReset"}
	local ResetDelay = 0
	local ResetV2 = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		["Name"] = "ResetV2",
		["Function"] = function()
			if ResetMethod.Value == "InstaReset" then
				wait(ResetDelay)
				game.Players.LocalPlayer.Character.Humanoid:TakeDamage(999999)
			end

			if ResetMethod.Value == "Lagback" then
				wait(ResetDelay)
				game.Players.LocalPlayer.Character.Humanoid.JumpPower = 500
				game.Players.LocalPlayer.Character.Humanoid.Jump = true
				wait(1)
				game.Players.LocalPlayer.Character.Humanoid:TakeDamage(999999)
			end

			if ResetMethod.Value == "Cya" then
				wait(ResetDelay)
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Cya", "All")
				game.Players.LocalPlayer.Character.Humanoid:TakeDamage(10000)
			end

			if ResetMethod.Value == "Fling" then
				wait(ResetDelay)
				game.Players.LocalPlayer.Character:MoveTo(Vector3.new(0,1000,0))
				wait(1)
				game.Players.LocalPlayer.Character.Humanoid:TakeDamage(999999)
			end
		end
	})
	ResetV2.CreateSlider({
		["Name"] = "Reset Delay",
		["Min"] = 0,
		["Max"] = 30,
		["Function"] = function(ResetDelayFunc)
			ResetDelay = ResetDelayFunc
		end,
		["Default"] = 0
	})
	ResetV2.CreateDropdown({
		["Name"] = "Method",
		["List"] = {"InstaReset", "Lagback", "Fling", "Cya"},
		["Function"] = function(ResetMethodFunc)
			ResetMethod.Value = ResetMethodFunc
		end
	})
end)

runcode(function()
	local BuyingVal = false
	local AutoWool = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		["Name"] = "AutoWool",
		["Function"] = function(callback)
			if callback then
				infonotify("AutoWool", "Enabled", 5)
				BuyingVal = true
				while BuyingVal and task.wait() do
			local args = {
				[1] = {
					["shopItem"] = {
						["currency"] = "iron",
						["itemType"] = "wool_white",
						["amount"] = 16,
						["price"] = 8,
						["category"] = "Blocks"
				}}}
				game:GetService("ReplicatedStorage").rbxts_include.node_modules["@rbxts"].net.out._NetManaged.BedwarsPurchaseItem:InvokeServer(unpack(args))
			end
		else
			BuyingVal = false
				infonotify("AutoWool", "Disabled", 5)
			end
		end
	})
end)

runcode(function()
	local BetterSpeedVal = false
	local BetterSpeed = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		["Name"] = "BetterSpeed",
		["Function"] = function(callback)
			if callback then
				BetterSpeedVal = true
				while BetterSpeedVal and task.wait() do
					game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 52
					wait(0.2)
					game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 10
					wait(0.4)
					game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 52
					wait(0.2)
					game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 10
				end
			else
				infonotify("BetterSpeed", "Restoring your speed...")
				BetterSpeedVal = false
				wait(1)
				game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 6
			end
		end
	})
end)

runcode(function()
	local LightingValue = 1
	local PermLight = false
	local Lighting = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "Lighting",
		["Function"] = function(callback)
			if callback then
				PermLight = true
				while PermLight and task.wait() do
					game.Lighting.Brightness = LightingValue
				end
			else
				PermLight = false
				infonotify("Lighting", "Restoring normal lights...")
				wait(1)
				game.Lighting.Brightness = 2.5
				infonotify("Lighting", "Light Restored!")
			end
		end
	})
	Lighting.CreateSlider({
		["Name"] = "Value",
		["Max"] = 100,
		["Min"] = 0,
		["Function"] = function(lightvalfunc)
			LightingValue = lightvalfunc
		end
	})
end)

runcode(function()
	local ZoomVal = 100
	local PermZoom = false
	local CameraZoom = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "CameraZoom",
		["Function"] = function(callback)
			if callback then
				PermZoom = true
				while PermZoom and task.wait() do
					game.Players.LocalPlayer.CameraMaxZoomDistance = ZoomVal
				end
			else
				PermZoom = false
				game.Players.LocalPlayer.CameraMaxZoomDistance = 50
			end
		end
	})
	CameraZoom.CreateSlider({
		["Name"] = "Max",
		["Max"] = 5000,
		["Min"] = 0,
		["Function"] = function(zoomvaluefunc)
			ZoomVal = zoomvaluefunc
		end
	})
end)

runcode(function()
local RainbowSkinVal = false
	local RainbowSkin = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "RainbowSkin",
		["Function"] = function(callback)
			if callback then
				infonotify("RainbowSkin", "Enabled!", 5)
				RainbowSkinVal = true
				while RainbowSkinVal and task.wait() do
					local player = game.Players.LocalPlayer
					local character = player.Character or player.CharacterAdded:Wait()
					for _,part in pairs(character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.Color = Color3.new(math.random(), math.random(), math.random())
					end
					end
				end
			else
				RainbowSkinVal = false
				infonotify("RainbowSkin", "Disabled!", 5)
			end
		end
	})
end)

runcode(function()
	local InvisibleVal = false
	local Invisible = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "Invisible",
		["Function"] = function(callback)
			if callback then
				InvisibleVal = true
				while InvisibleVal and task.wait() do
					for _,part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
						if part:IsA("BasePart") then
							part.Transparency = 1
						end
					end
				end
			else
				InvisibleVal = false
				for _,part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.Transparency = 0
					end
				end
			end
		end
	})
end)

runcode(function()
	local Noclip = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		["Name"] = "Noclip",
		["Function"] = function(callback)
			if callback then
				infonotify("Noclip", "BETA Feature", 5)
				game:GetService("RunService").Stepped:connect(function()
					for _,part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CanCollide = false
						end
					end
				end)
			else
				infonotify("Noclip", "Disabled!", 5)
				game:GetService("RunService").Stepped:connect(function()
					for _,part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CanCollide = true
						end
					end
				end)
			end
		end
	})
end)

runcode(function()
	local SuperPanic = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		["Name"] = "SuperPanic",
		["Function"] = function(callback)
			if callback then
				game.Players.LocalPlayer:Kick("You has been kicked from SuperPanic.")
					wait()
				game:Shutdown()
				GuiLibrary.ObjectsThatCanBeSaved.SuperPanicOptionsButton.Api.ToggleButton(false)
			end
		end
	})
end)

runcode(function()
	local LegitMode = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		["Name"] = "LegitMode",
		["Function"] = function(callback)
			if callback then
				loadstring(game:HttpGet("https://raw.githubusercontent.com/SmokeXDev/SmokeXPubblic/main/GameLoader/BedwarsData.lua", true))()
			end
		end
	})
end)

runcode(function()
	local ErrorTimeVal = false
	local ErrorTime = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "ErrorTime",
		["Function"] = function(callback)
			if callback then
				infonotify("ErrorTime", "Enabled!", 5)
				ErrorTimeVal = true
				while ErrorTimeVal and task.wait(0.1) do
					game.Lighting.ClockTime = 1
						wait(0.1)
					game.Lighting.ClockTime = 13
				end
			else
				infonotify("ErrorTime", "Disabled!", 5)
				ErrorTimeVal = false
			end
		end
	})
end)

runcode(function()
	local MassReportChat = {Enabled = false}
	local AutoChatVal = false
	local MassReport = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		["Name"] = "MassReport",
		["Function"] = function()
			infonotify("MassReport", "Enabled!", 5)
			loadstring(game:HttpGet("https://raw.githubusercontent.com/SmokeXDev/SmokeXPubblic/main/Resources/MassReport.lua", true))()
		end,
		["HoverText"] = "Can't be reversed"
	})
	MassReportChat = MassReport.CreateToggle({
		["Name"] = "AutoChat",
		["Function"] = function(callback)
			if callback and MassReport.Enabled == true then
				AutoChatVal = true
				while AutoChatVal and task.wait(1) do
					game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Server getting mass reported!", "All")
						wait(2)
					game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Reported Everyone Successfully", "All")
				end
			else
				AutoChatVal = false
			end
		end
})
end)

runcode(function()
	local GravityV2 = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		["Name"] = "GravityV2",
		["Function"] = function(callback)
		if callback then
				workspace.Gravity = GravitiyVal
			end
		end,
		["Hovertext"] = "Change your gravity"
	})
	GravityV2.CreateSlider({
		["Name"] = "GravityV2",
		["Min"] = 0,
		["Max"] = 192.2,
		["Function"] = function(GravitiyVal)
			if GravityV2.Enabled then
				workspace.Gravity = GravitiyVal
			end
		end,
		["Default"] = 192.2
	})
end)

runcode(function()
	local SkyScytheVal = false
	local SkyScytheExploit = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		["Name"] = "SkyScytheExploit",
		["Function"] = function(callback)
			if callback then
				local success, err = pcall(function()
					game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("SkyScytheSpin"):FireServer()
				end)
				if success then
					SkyScytheVal = true
					while SkyScytheVal and task.wait() do
						game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("SkyScytheSpin"):FireServer()
					end
				else
					warnnotify("SkyScytheExploit", "Item not found 'sky_scythe'")
				end
			elseif not callback then
				SkyScytheVal = false
			end
		end
	})
end)

runcode(function()
	local roles = {"Junior Moderator", "Moderator", "Anticheat Mod", "Anticheat Manager", "Senior Moderator", "Lead Moderator", "Community Manager", "Engineer", "Engineer (devops)", "Full", "Owner"}
	local groupid = game.CreatorId
	local plrservice = game:GetService("Players")
	local minrank = 55
	local checkrank = true
	local function groupcheck(ranks, title, desc, time)
		for i,v in pairs(plrservice:GetPlayers()) do
			if v ~= plrservice.LocalPlayer then
				for _,c in pairs(roles) do
					if v:GetRoleInGroup(groupid) == roles[c] or v:GetRankInGroup(groupid) >= ranks then
						warnnotify("Smoke", "A Staff is here! Be careful! [BETA] If you think this is an error contact https://dsc.gg/smokex", 20)
						break
					end
				end
			end
		end
	end
	local StaffDetectorV2 = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		["Name"] = "StaffDetectorV2",
		["Function"] = function(callback)
			if callback then
				groupcheck(minrank, "Smoke", "A Staff is here! Be careful! [BETA] If you think this is an error contact https://dsc.gg/smokex", 20)
				plrservice.PlayerAdded:connect(function(plr)
					groupcheck(minrank)
				end)
			end
		end,
		["HoverText"] = "If AC Mod don't use their main account they can't get detected."
	})
	StaffDetectorV2.CreateSlider({
		["Name"] = "Rank check",
		["Min"] = 0,
		["Max"] = 255,
		["Default"] = 55,
		["Function"] = function(RankCheckFunc)
			minrank = RankCheckFunc
		end
	})
	StaffDetectorV2.CreateToggle({
		["Name"] = "Check Rank",
		["Function"] = function(checkRankValue)
			checkrank = checkRankValue
		end,
		["Default"] = checkrank
	})
end)

runcode(function()
	local AnnoyingVal = false
	local AnnoyingSoundAura = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		["Name"] = "AnnoyingSoundAura",
		["Function"] = function(callback)
			if callback then
				local success, err = pcall(function()
					game:GetService("TextChatService").ChatInputBarConfiguration.TargetTextChannel:SendAsync(" ")
				end)
				if success then
					AnnoyingVal = true
					game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
					while AnnoyingVal and task.wait() do
						game:GetService("TextChatService").ChatInputBarConfiguration.TargetTextChannel:SendAsync(" ")
					end
				else
					warnnotify("AnnoyingSoundAura", "Chat is not found!")
				end
			elseif not callback then
				AnnoyingVal = false
				game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
			end
		end
	})
end)

runcode(function()
	local ScytheDisablerVal = false
	local ScytheDisabler = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		["Name"] = "ScytheDisabler",
		["Function"] = function(callback)
			if callback then
				local success, err = pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("ScytheDash"):InvokeServer({["direction"] = Vector3.new(0, 0, 0)}) end)
				if success then
					infonotify("ScytheDisabler", "Enabled!", 5)
					ScytheDisablerVal = true
					while ScytheDisablerVal and task.wait(.2) do
						game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("ScytheDash"):InvokeServer({["direction"] = Vector3.new(0, 0, 0)})
					end
				elseif err then
					warnnotify("ScytheDisabler", "Code Error / Patched", 5)
				end
			else
				infonotify("ScytheDisabler", "Disabled!", 5)
				ScytheDisablerVal = false
			end
		end,
		["HoverText"] = "Needed an Scythe and you can Inf Fly with the normal Fly, remember to equip the Scythe"
	})
end)