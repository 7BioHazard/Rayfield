local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character.PrimaryPart

local Knit = require(ReplicatedStorage.Packages.knit)
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

local infJumpConn

tab:CreateToggle("Бесконечный прыжок", function(Value)
    if Value then
        if infJumpConn then task.cancel(infJumpConn) infJumpConn = nil end
        local infJumpDebounce = false
        UserInputService.JumpRequest:Connect(function()
            if not infJumpDebounce then
                infJumpDebounce = true
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(0.01)
                infJumpDebounce = false
            end
        end)
    else
        if infJumpConn then task.cancel(infJumpConn) infJumpConn = nil end
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

local tab2 = main:CreateTab("Телепорты")

for _, v in next, workspace:WaitForChild("Buildings"):GetChildren() do
    tab2:CreateButton(v.Name, function()
        Root:PivoTo(v:FindFirstChildWhichIsA("Model").CollisionBox.CFrame + Vector3.new(0, 15, 0))
    end)
end

local tab3 = main:CreateTab("Основы")

tab3:CreateButton("Всегда критичиский дамаг", function()
    local AttackHook do
        AttackHook = hookfunction(Nuke.Attack, function(Self, Target, ...)
            rawset(Target, "nextAttackCritical", true)
            return AttackHook(Self, Target, ...)
        end)
     end
end)

Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = Character:WaitForChild("Humanoid")
    Root = Character:WaitForChild("HumanoidRootPart")
end)

Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

RunService.RenderStepped:Connect(function()
    if config.noclip then
        Noclip()
    end
end)
