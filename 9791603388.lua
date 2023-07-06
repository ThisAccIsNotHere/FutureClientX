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

infonotify("Smoke", "Loaded Successfully! [BETA]", 5)
loadstring(game:HttpGet("https://raw.githubusercontent.com/SmokeXDev/SmokeXPubblic/main/SmokeXTeamDetector.lua", true))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/SmokeXDev/SmokeXPubblic/main/SmokeXTeam/NewDetect.lua", true))()

GuiLibrary.RemoveObject("AutoClickerOptionsButton")
GuiLibrary.RemoveObject("SilentAimOptionsButton")
GuiLibrary.RemoveObject("AutoLeaveOptionsButton")
GuiLibrary.RemoveObject("GravityOptionsButton")
GuiLibrary.RemoveObject("HitBoxesOptionsButton")
GuiLibrary.RemoveObject("LongJumpOptionsButton")
GuiLibrary.RemoveObject("MouseTPOptionsButton")
GuiLibrary.RemoveObject("PhaseOptionsButton")
GuiLibrary.RemoveObject("SpeedOptionsButton")
GuiLibrary.RemoveObject("SpinBotOptionsButton")
GuiLibrary.RemoveObject("SwimOptionsButton")
GuiLibrary.RemoveObject("SongBeatsOptionsButton")
GuiLibrary.RemoveObject("ArrowsOptionsButton")
GuiLibrary.RemoveObject("SearchOptionsButton")
GuiLibrary.RemoveObject("AnimationPlayerOptionsButton")
GuiLibrary.RemoveObject("ClientKickDisablerOptionsButton")
GuiLibrary.RemoveObject("PanicOptionsButton")
GuiLibrary.RemoveObject("SafeWalkOptionsButton")
GuiLibrary.RemoveObject("XrayOptionsButton")

runcode(function()
    local RocketLauncher = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        ["Name"] = "RocketLauncher",
        ["Function"] = function(callback)
            if callback then
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("PreferenceChanged"):FireServer("GiveRocketLauncher", false)
            else
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("PreferenceChanged"):FireServer("GiveRocketLauncher", true)
            end
        end
    })
end)

runcode(function()
    local ChangeTeamList = {Value = "Red"}
    local ChangeTeam = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        ["Name"] = "ChangeTeam",
        ["Function"] = function()
            if ChangeTeamList.Value == "Red" then
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("PlayPressed"):InvokeServer("Red")
                GuiLibrary.ObjectsThatCanBeSaved.ChangeTeam.Api.ToggleButton(false)

            end
            if ChangeTeamList.Value == "Blue" then
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("PlayPressed"):InvokeServer("Blue")
                GuiLibrary.ObjectsThatCanBeSaved.ChangeTeam.Api.ToggleButton(false)
            end
        end
    })
    ChangeTeam.CreateDropdown({
        ["Name"] = "Teams",
        ["List"] = {"Red", "Blue"},
        ["Function"] = function(TeamsListFunc)
            CHangeTeamList.Value = TeamsListFunc
        end,
        ["Default"] = "Red"
    })
end)

runcode(function()
    local AutoBuySniper = {Enabled = false}
    local SniperVal = {Enabled = false}
    local AutoBuySword = {Enabled = false}
    local SwordVal = {Enabled = false}
    local AutoBuyShovel = {Enabled = false}
    local ShovelVal = {Enabled = false}
    local AutoBuyMedkit = {Enabled = false}
    local MedkitVal = {Enabled = false}
    local AutoBuyAll = {Enabled = false}
    local BuyAllVal =  {Enabled = false}
    local AutoBuy = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
        ["Name"] = "AutoBuy",
        ["Function"] = function()
            if AutoBuySniper.Enabled == true and SniperVal.Enabled == true then
                while SniperVal and task.wait(.5) do
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("Upgrade"):InvokeServer("Sniper")
                end
            else
                SniperVal.Enabled = false
            end
            if AutoBuySword.Enabled == true and SwordVal.Enabled == true then
                while SwordVal and task.wait(.5) do
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("Upgrade"):InvokeServer("Sword")
                end
            else
                SwordVal.Enabled = false
            end
            if AutoBuyShovel.Enabled == true and ShovelVal.Enabled == true then
                while ShovelVal and task.wait(.5) do
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("Upgrade"):InvokeServer("Shovel")
                end
            else
                ShovelVal.Enabled = false
            end
            if AutoBuyMedkit.Enabled == true and MedkitVal.Enabled == true then
                while MedkitVal and task.wait(.5) do
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("Upgrade"):InvokeServer("Medkit")
                end
            else
                MedkitVal.Enabled = false
            end
            if AutoBuyAll.Enabled == true and BuyAllVal.Enabled == true then
                while BuyAllVal and task.wait(.5) do
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("Upgrade"):InvokeServer("Sniper")
                    wait(.3)
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("Upgrade"):InvokeServer("Sword")
                    wait(.3)
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("Upgrade"):InvokeServer("Shovel")
                    wait(.3)
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("Upgrade"):InvokeServer("Medkit")
                end
            else
                BuyAllVal.Enabled = false
            end
        end
    })
    AutoBuy.CreateToggle({
        ["Name"] = "Sniper",
        ["Function"] = function(callback)
            if callback then
                infonotify("AutoBuy", "Sniper - Actived!", 5)
                AutoBuySniper.Enabled = true
                    wait(.2)
                SniperVal.Enabled = true
            else
                AutoBuySniper.Enabled = false
                    wait(.2)
                SniperVal.Enabled = false
                if AutoBuySniper.Enalbed == false and SniperVal.Enabled == false then
                    infonotify("AutoBuy", "Sniper - Disabled!", 5)
                end
            end
        end
    })
    AutoBuy.CreateToggle({
        ["Name"] = "Sword",
        ["Function"] = function(callback)
            if callback then
                infonotify("AutoBuy", "Sword - Actived!", 5)
                AutoBuySword.Enabled = true
                    wait(.2)
                SwordVal.Enabled = true
            else
                AutoBuySword.Enabled = false
                    wait(.2)
                SwordVal.Enabled = false
                if AutoBuySword.Enalbed == false and SwordVal.Enabled == false then
                    infonotify("AutoBuy", "Sword - Disabled!", 5)
                end
            end
        end
    })
    AutoBuy.CreateToggle({
        ["Name"] = "Shovel",
        ["Function"] = function(callback)
            if callback then
                infonotify("AutoBuy", "Shovel - Actived!", 5)
                AutoBuyShovel.Enabled = true
                    wait(.2)
                ShovelVal.Enabled = true
            else
                AutoBuyShovel.Enabled = false
                    wait(.2)
                ShovelVal.Enabled = false
                if AutoBuyShovel.Enalbed == false and ShovelVal.Enabled == false then
                    infonotify("AutoBuy", "Shovel - Disabled!", 5)
                end
            end
        end
    })
    AutoBuy.CreateToggle({
        ["Name"] = "Medkit",
        ["Function"] = function(callback)
            if callback then
                infonotify("AutoBuy", "Medkit - Actived!", 5)
                AutoBuyMedkit.Enabled = true
                    wait(.2)
                MedkitVal.Enabled = true
            else
                AutoBuyMedkit.Enabled = false
                    wait(.2)
                MedkitVal.Enabled = false
                if AutoBuyMedkit.Enalbed == false and MedkitVal.Enabled == false then
                    infonotify("AutoBuy", "Medkit - Disabled!", 5)
                end
            end
        end
    })
    AutoBuy.CreateToggle({
        ["Name"] = "All",
        ["Function"] = function(callback)
            if callback then
                infonotify("AutoBuy", "All - Actived!", 5)
                AutoBuyAll.Enabled = true
                    wait(.2)
                BuyAllVal.Enabled = true
            else
                AutoBuyAll.Enabled = false
                    wait(.2)
                BuyAllVal.Enabled = false
                if AutoBuyAll.Enalbed == false and BuyAllVal.Enabled == false then
                    infonotify("AutoBuy", "All - Disabled!", 5)
                end
            end
        end
    })
end)

runcode(function()
    local AutoMedkitVal = {Enabled = false}
    local AutoMedkit = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        ["Name"] = "AutoMedkit",
        ["Function"] = function(callback)
            if callback then
                local succ, err = pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("PlayerUseMedkit"):FireServer() end)
                if succ then
                    infonotify("AutoMedkit", "Enabled!", 5)
                    AutoMedkitVal.Enabled = true
                    while AutoMedkitVal and task.wait(75) do
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("PlayerUseMedkit"):FireServer()
                    end
                elseif err then
                    AutoMedkitVal.Enabled = false
                    GuiLibrary.ObjectsThatCanBeSaved.AutoMedkitOptionsButton.Api.ToggleButton(false)
                    warnnotify("AutoMedkit", "AutoMedkit got patched, wait until an update", 5)
                end
            else
                AutoMedkitVal.Enabled = false
                infonotify("AutoMedkit", "Disabled!", 5)
            end
        end
    })
end)

runcode(function()
    local player = game.Players.LocalPlayer
    local DefaultMessage = "Im using Smokex client. And my user is: "..player.DisplayName.. " | Smoke Client on top"
    local SpamFeedBacksVal = {Enabled = false}
    local SpamFeedBacksDelay = {Value = 0.5}
    local SpamFeedBacks = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
        ["Name"] = "SpamFeedBacks",
        ["Function"] = function(callback)
            if callback then
                infonotify("SpamFeedBacks", "Message Default: ", DefaultMessage)
                SpamFeedBacksVal.Enabled = true
                while SpamFeedBacksVal do
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SendReport"):FireServer("Keyboard", "Im using Smx Client. And my user is: "..player.name.. " | Smoke Client on top")
                end
            else
                infonotify("SpamFeedBacks", "Disabled!", 5)
                SpamFeedBacksVal.Enabled = false
            end
        end
    })
    SpamFeedBacks.CreateSlider({
        ["Name"] = "Delay",
        ["Mix"] = 0,
        ["Max"] = 50,
        ["Function"] = function(callback)
            infonotify("SpamFeedBacks", "Delay is comming soon.", 5)
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