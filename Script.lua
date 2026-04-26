-- [[ LOWHIGH STORE - MEDIO EDITION (Elite Hub Engine) ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- CONFIGURAÇÕES (LÓGICA DO PREMIUM)
_G.AimbotEnabled = false
_G.SilentAimEnabled = false
_G.TeamCheck = false 
_G.WallCheck = false
_G.FOV = 150
_G.Smoothness = 0.135
_G.PredictionEnabled = true 
_G.BulletSpeed = 2500 

local CachedTarget = nil
local CachedPredPos = nil

-- [[ FUNÇÕES MATEMÁTICAS DO PREMIUM - NÃO BUGAM ]] --
local function GetAimbotPart(char)
    return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
end

local function GetPredictedPosition(Target)
    local TargetPart = GetAimbotPart(Target.Character)
    if not TargetPart then return Target.Character:GetPivot().Position end
    local Distance = (Camera.CFrame.Position - TargetPart.Position).Magnitude
    local TimeToTarget = Distance / _G.BulletSpeed
    local Velocity = TargetPart.AssemblyLinearVelocity or Vector3.new(0,0,0)
    return TargetPart.Position + (Velocity * (TimeToTarget + 0.1))
end

local function GetClosestPlayer()
    local Target, MaxDist = nil, _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local AimPart = GetAimbotPart(v.Character)
            if not AimPart or (_G.TeamCheck and v.Team == LocalPlayer.Team) then continue end
            local SP, OnS = Camera:WorldToScreenPoint(AimPart.Position)
            if OnS then
                local Dist = (Vector2.new(SP.X, SP.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if Dist < MaxDist then Target = v; MaxDist = Dist end
            end
        end
    end
    return Target
end

-- [[ SILENT AIM HOOK (O CORAÇÃO DO MÉDIO/PREMIUM) ]] --
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    if _G.SilentAimEnabled and CachedTarget and CachedPredPos then
        if Method == "FireServer" or Method == "InvokeServer" then
            for i, arg in pairs(Args) do
                if typeof(arg) == "Vector3" then Args[i] = CachedPredPos
                elseif typeof(arg) == "CFrame" then Args[i] = CFrame.new(Camera.CFrame.Position, CachedPredPos)
                end
            end
            return OldNamecall(self, unpack(Args))
        end
    end
    return OldNamecall(self, ...)
end)

-- [[ AQUI VOCÊ COLA TODA A PARTE DA "RAGE UI" QUE VOCÊ MANDOU NO CÓDIGO GIGANTE ]] --
-- [[ Certifique-se de que os Toggles de Silent Aim e Aimbot apontem para as variáveis certas ]] --

RunService:BindToRenderStep("LowHighMedioLoop", 201, function()
    CachedTarget = GetClosestPlayer()
    CachedPredPos = CachedTarget and GetPredictedPosition(CachedTarget) or nil

    -- Lógica de Aimbot de Câmera (também do Premium)
    if _G.AimbotEnabled and CachedTarget and CachedTarget.Character then
        local AimPart = GetAimbotPart(CachedTarget.Character)
        if AimPart then
            local aimPos = _G.PredictionEnabled and (AimPart.Position + (AimPart.AssemblyLinearVelocity * 0.135)) or AimPart.Position
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, aimPos), _G.Smoothness)
        end
    end
end)
