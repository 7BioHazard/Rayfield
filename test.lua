if not game:IsLoaded() then game.Loaded:Wait() end

local API = loadstring(game:HttpGet("https://raw.githubusercontent.com/7BioHazard/Utils/main/API.lua"))()
local Connection_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/7BioHazard/Utils/main/Connection_Library.lua"))()
local Tasks_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/7BioHazard/Utils/main/Task_Library.lua"))()

API:Load()

local Services = API.Services
local Players = Services.Players
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService
local RunService = Services.RunService
local ReplicatedStorage = Services.ReplicatedStorage
local VirtualUser = Services.VirtualUser
local Lighting = Services.Lighting
local TextChatService = Services.TextChatService

local Player = API:Player()
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

local Connections = Connection_Library.New()
local Tasks = Tasks_Library.New()

local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)
local Nuke = Knit.GetController("NukeController")


local function Noclip()
    for _, v in next, Character:GetDescendants() do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end

local config = {
    noclip = false
}

local library = loadui()()
local main = library:CreateMain("Nuke Simulator", "xZyn?", Enum.KeyCode.F)

local tab = main:CreateTab("Персонаж")
local tab2 = main:CreateTab("Телепорты")
local tab3 = main:CreateTab("Основы")
main:CreateSettings()

tab:CreateToggle("Бесконечный прыжок", function(Value)
    if Value then
        if Connections:Get("InfJump") then Connections:Disconnect("InfJump") end
        local infJumpDebounce = false
        Connections:Add("InfJump", UserInputService.JumpRequest:Connect(function()
            if not infJumpDebounce then
                infJumpDebounce = true
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(0.01)
                infJumpDebounce = false
            end
        end))
    else
        if Connections:Get("InfJump") then Connections:Disconnect("InfJump") end
    end
end)

tab:CreateToggle("Ноклип", function(Value)
    config.noclip = Value
end)

tab:CreateSlider("Скорость Бега", 0, 150, function(Value)
    Humanoid.WalkSpeed = Value
end)

tab:CreateSlider("Высота Прыжка", 0, 300, function(Value)
    Humanoid.JumpPower = Value
end)


--[[for _, v in next, workspace:WaitForChild("Buildings"):GetChildren() do
    tab2:CreateButton(v.Name, function()
        Root:PivoTo(v:FindFirstChildWhichIsA("Model").CollisionBox.CFrame + Vector3.new(0, 15, 0))
    end)
end]]

tab3:CreateButton("Всегда критичиский дамаг", function()
    local AttackHook do
        AttackHook = hookfunction(Nuke.Attack, function(Self, Target, ...)
            rawset(Target, "nextAttackCritical", true)
            return AttackHook(Self, Target, ...)
        end)
     end
end)

Connections:Add("CharacterAddition", Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = Character:WaitForChild("Humanoid")
    Root = Character:WaitForChild("HumanoidRootPart")
end))

Connections:Add("AntiAFK", Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end))

Connections:Add("RenderStepped", RunService.RenderStepped:Connect(function()
    if config.noclip then
        Noclip()
    end
end))
