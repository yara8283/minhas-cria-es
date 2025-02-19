-- LocalScript para o cliente
local player = game.Players.LocalPlayer -- Obtém o jogador local
local character = player.Character or player.CharacterAdded:Wait() -- Espera o personagem carregar
local backpack = player:WaitForChild("Backpack") -- Acessa a mochila do jogador
local monitorEnabled = false -- Variável de controle para ligar/desligar o script

-- Função que verifica continuamente o inventário
local function monitorInventory()
    while monitorEnabled do -- Só executa se o monitoramento estiver ativado
        task.wait(0.5) -- Verifica a cada 0.5 segundos

        local hasTool = false

        -- Verifica se há ferramentas no inventário (Backpack e Character)
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                hasTool = true
                break
            end
        end

        for _, item in ipairs(character:GetChildren()) do
            if item:IsA("Tool") then
                hasTool = true
                break
            end
        end

        -- Se não houver ferramentas, força a morte do personagem
        if not hasTool then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Health = 0 -- Mata o personagem ajustando a vida para 0
                break -- Encerra o loop após matar o jogador
            end
        end
    end
end

-- Comandos de ativação/desativação no chat
player.Chatted:Connect(function(message)
    if player.Name == "rbxV1P3R" then -- Garante que apenas você possa usar os comandos
        local command = message:lower()
        if command == ".on" then -- Comando para ativar
            if not monitorEnabled then
                monitorEnabled = true
                print("Monitoramento ativado!")
                monitorInventory() -- Inicia o monitoramento
            end
        elseif command == ".off" then -- Comando para desativar
            if monitorEnabled then
                monitorEnabled = false
                print("Monitoramento desativado!")
            end
        end
    end
end)

-- Garante que o script reinicie após o personagem resetar
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    task.wait(1) -- Dá tempo para carregar o novo personagem
    if monitorEnabled then
        monitorInventory() -- Reinicia o monitoramento no novo personagem
    end
end)
