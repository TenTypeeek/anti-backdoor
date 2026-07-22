-- =============
-- CONFIGURATION
-- =============
local webhookUrl = "YOUR_DISCORD_WEBHOOK"

-- ===================================
-- DONT EDIT ANYTHING PAST THIS LINE
-- IF YOU DONT KNOW WHAT YOU ARE DOING
-- I AS THE DEVELOPER DONT EVEN KNOW
-- SO DONT TRY TO FIX IT OR ANYTHING
-- ===================================

local apiEndpoint = "https://fivembackdoor.info/malicious-domains"

local maliciousDomains = {
    "0resmon.net", "0xchitado.com", "108tour.info", "10bridgestreet.ie",
    "1912.lt", "1ls2.org", "2312321321321213.com", "2nit32.com", "2tjo3nehu3taxi.xyz"
}

Citizen.CreateThread(function()
    print("^3[Anti-Backdoor]^0 Initializing... Fetching latest domain list...")
    
    PerformHttpRequest(apiEndpoint, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 and resultData then
            local fetchedDomains = {}
            for line in string.gmatch(resultData, "[^\r\n]+") do
                local domain = string.match(line, "%s*([^%s]+)$")
                if domain and domain ~= "0.0.0.0" and domain ~= "localhost" then
                    table.insert(fetchedDomains, domain)
                end
            end
            
            if #fetchedDomains > 0 then
                maliciousDomains = fetchedDomains
                print("^2[Anti-Backdoor]^0 Loaded " .. #maliciousDomains .. " known malicious domains from database!")
            end
        else
            print("^1[Anti-Backdoor]^0 Failed to reach website API. Using fallback list.")
        end
        
        print("^2[Anti-Backdoor]^0 Ready! Actively monitoring newly started resources.")
    end, "GET", "", "")
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then return end
    
    SetTimeout(500, function()
        local findings = ScanSingleResource(resourceName)
        if #findings > 0 then
            print("^1[Anti-Backdoor]^0 WARNING: Started resource (^3" .. resourceName .. "^0) contains a backdoor!")
            print("^1[Anti-Backdoor]^0 Force-stopping ^3" .. resourceName .. "^0 to protect the server...")
            
            ExecuteCommand("stop " .. resourceName)
            
            SendDiscordWebhook(findings)
        else
            print("^2[Anti-Backdoor]^0 Checked resource '^3" .. resourceName .. "^0' — Clean.")
        end
    end)
end)

function ScanSingleResource(resourceName)
    local manifestNames = {"fxmanifest.lua", "__resource.lua"}
    local allFindings = {}

    for _, manifestName in ipairs(manifestNames) do
        local manifestData = LoadResourceFile(resourceName, manifestName)
        
        if manifestData then
            local mfFindings = CheckContentForDomains(resourceName, manifestName, manifestData)
            for _, f in ipairs(mfFindings) do table.insert(allFindings, f) end
            
            local filesToScan = {}
            for filename in string.gmatch(manifestData, "['\"]([^'\"]+%.%w+)['\"]") do
                if not string.find(filename, "%*") then
                    filesToScan[filename] = true
                end
            end
            
            local commonFiles = {"server.lua", "client.lua", "server/main.lua", "client/main.lua", "config.lua"}
            for _, cFile in ipairs(commonFiles) do
                filesToScan[cFile] = true
            end

            for filename, _ in pairs(filesToScan) do
                local fileData = LoadResourceFile(resourceName, filename)
                if fileData then
                    local fileFindings = CheckContentForDomains(resourceName, filename, fileData)
                    for _, f in ipairs(fileFindings) do table.insert(allFindings, f) end
                end
            end
            
            break 
        end
    end
    
    return allFindings
end

function CheckContentForDomains(resourceName, fileName, content)
    local findings = {}
    content = string.lower(content)
    
    for _, domain in ipairs(maliciousDomains) do
        local pattern = string.gsub(domain, "%.", "%%.")
        pattern = string.gsub(pattern, "%-", "%%-")
        
        if string.find(content, pattern) then
            print("^1[Anti-Backdoor]^0 ^3ALERT:^0 Found domain ^1" .. domain .. "^0 in ^3" .. resourceName .. "^0 (" .. fileName .. ")")
            table.insert(findings, {
                resource = resourceName,
                file = resourceName .. "/" .. fileName,
                domain = domain
            })
        end
    end
    
    return findings
end

function SendDiscordWebhook(infectionsTable)
    if webhookUrl == "YOUR_WEBHOOK_URL_HERE" or webhookUrl == "" then
        print("^1[Anti-Backdoor]^0 Webhook not set. Skipping Discord alert.")
        return
    end

    local contentString = "## Backdoors found\n\n"

    for _, inf in ipairs(infectionsTable) do
        contentString = contentString .. string.format("> - %s\n>  - %s\n>  - %s\n\n", inf.resource, inf.file, inf.domain)
    end

    local dateStr = os.date("%Y-%m-%d %H:%M:%S")
    contentString = contentString .. string.format("%s • Eclipse Development • AntiBackdoor", dateStr)

    local payload = {
        username = "Eclipse AntiBackdoor",
        content = contentString
    }

    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end