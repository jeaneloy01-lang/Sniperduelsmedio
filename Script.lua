-- [[ LOWHIGH STORE - MEDIO EDITION (Elite Hub Engine) ]] --
-- [Mantenha as variáveis e a Rage UI que você já tem]

-- ADICIONE ESTA PARTE DO PREMIUM PARA O SILENT AIM FUNCIONAR:
local CachedTarget = nil
local CachedPredPos = nil

local function GetPredictedPosition(Target)
    local TargetPart = GetAimbotPart(Target.Character)
    if not TargetPart then return Target.Character:GetPivot().Position end
    local Distance = (Camera.CFrame.Position - TargetPart.Position).Magnitude
    local TimeToTarget = Distance / 2500 
    local TotalTime = TimeToTarget + 0.1
    local Velocity = TargetPart.AssemblyLinearVelocity or Vector3.new(0,0,0)
    return TargetPart.Position + (Velocity * TotalTime)
end

-- HOOKS DO PREMIUM (O QUE FAZ O TIRO GRUDAR)
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

RunService:BindToRenderStep("LowHighMedio", 201, function()
    CachedTarget = GetClosestPlayer()
    CachedPredPos = CachedTarget and GetPredictedPosition(CachedTarget) or nil
    -- [Aqui você mantém a lógica de lerp da câmera se o Aimbot estiver ativado]
end)
