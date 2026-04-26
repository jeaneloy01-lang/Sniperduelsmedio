-- [[ LOWHIGH STORE - MEDIO EDITION (Engine Premium) ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

_G.AimbotEnabled = false
_G.SilentAimEnabled = false -- NO MÉDIO TEM SILENT
_G.FOV = 150
_G.Smoothness = 0.135

local CachedTarget = nil
local CachedPredPos = nil

-- INTERFACE RAGE UI (SISTEMA DE GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LowHigh_Medio"
if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = CoreGui end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Active = true; MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel")
Title.Text = "LOWHIGH STORE - MÉDIO"
Title.Size = UDim2.new(1, 0, 0, 30); Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1; Title.Parent = MainFrame

-- [ HOOK DE SILENT AIM DO PREMIUM ] --
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    if _G.SilentAimEnabled and CachedTarget and CachedPredPos then
        if Method == "FireServer" or Method == "InvokeServer" then
            for i, v in pairs(Args) do
                if typeof(v) == "Vector3" then Args[i] = CachedPredPos end
            end
            return OldNamecall(self, unpack(Args))
        end
    end
    return OldNamecall(self, ...)
end)

-- LOOP DE ATUALIZAÇÃO
RunService.RenderStepped:Connect(function()
    -- Lógica de busca de alvo aqui...
    -- (Colocar a mesma função GetClosestPlayer do Simples)
end)
