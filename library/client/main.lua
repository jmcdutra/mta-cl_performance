local screen = Vector2(guiGetScreenSize())
local tx, ty = ( screen.x / 1920 ), ( screen.y / 1080 )

-- Creating

cache.player = {} 
cache.ui_active = false
cache.performance = {["localplayer"] = getPlayerName(localPlayer), ["matrix"] = {dimension = getElementDimension(localPlayer), interior = getElementInterior(localPlayer)}}
cache.searchResource = false

-- Utils

function drawImage(x, y, w, h, ...)
    return dxDrawImage(tx * x, ty * y, tx * w, ty * h, ... )
end

function drawRectangle( x, y, w, h, ...)
    return dxDrawRectangle( tx * x, ty * y, tx * w, ty * h, ... )
end

function drawText(text, x, y, w, h, ...)
    return dxDrawText(text, tx * x, ty * y, tx * w, ty * h, ...)
end

-- Class

class 'performance' {
    ['openUI'] = function(self, input)
        if (cache.ui_active == false) then
            if (input and input == 1 or input == 2) then
                cache.ui_active = input
            end
        else
            if (not input or input == cache.ui_active) then
                cache.ui_active = false
            else
                cache.ui_active = input
            end
        end
    end;

    ['set'] = function()
        timing_columns, timing_rows = getPerformanceStats("Lua timing")
        memory_columns, memory_rows = getPerformanceStats("Lua memory")
    end;

    ['get'] = function(self, playerOptions)
        local cpu_usage = 0

        -- Lua memory
        if not (cache.searchResource) then
            memory_string = string.gsub(memory_rows[1][3], ' KB', '')
            memory_usage = bytesToSize(tonumber(memory_string) * 1000).."'s"
        else
            for i, v in pairs(memory_rows) do
                if (v[1] == cache.searchResource) then
                    memory_string = string.gsub(v[3], ' KB', '')
                    memory_usage = bytesToSize(tonumber(memory_string) * 1000).."'s"
                end
            end
        end
        -- Lua timing
        for i, v in pairs(timing_rows) do
            if not (cache.searchResource) then
                local cpu_string = string.gsub(v[2], '%%', '')
                if (cpu_string and tonumber(cpu_string)) then
                    cpu_usage = cpu_usage + tonumber(cpu_string)
                end
            else
                if (v[1] == cache.searchResource) then
                    local cpu_string = string.gsub(v[2], '%%', '')
                    if (cpu_string and tonumber(cpu_string)) then
                        cpu_usage = tonumber(cpu_string)
                    end
                end
            end
        end
        -- Cache
        cache.performance["localTime"] = returnRealTime()
        cache.performance["resources"] = {cpu_usage = tostring(cpu_usage)..'%', memory_usage = memory_usage}
        cache.performance["perfomance"] = {ping = getPlayerPing(localPlayer), fps = math.round(getCurrentFPS())}
        if (playerOptions) then
            local x, y, z = getElementPosition(localPlayer)
            local rx, ry, rz = getElementRotation(localPlayer)
            cache.performance["matrix"]["position"] = {math.stringround(x, true, 5), math.stringround(y, true, 5), math.stringround(z, true, 5)}
            cache.performance["matrix"]["rotation"] = {math.stringround(rx, true, 5), math.stringround(ry, true, 5), math.stringround(rz, true, 5)}
        end
    end;
}

-- Check
function check()
    if (cache.ui_active ~= false) then
        performance:set()
        if (cache.ui_active == 2) then
            if (cache.performance.matrix.dimension ~= getElementDimension(localPlayer)) then
                cache.performance.matrix.dimension = getElementDimension(localPlayer)
            end
            if (cache.performance.matrix.interior ~= getElementInterior(localPlayer)) then
                cache.performance.matrix.interior = getElementInterior(localPlayer)
            end
            if (cache.performance.localplayer ~= getPlayerName(localPlayer)) then
                cache.performance.localplayer = getPlayerName(localPlayer)
            end
        end
    end
end
setTimer(check, 1000, 0)
----------------------------------

-- Resource

function setPerformance() return performance:set() end
addEventHandler('onClientResourceStart', resourceRoot, setPerformance)

ui = {
    slots = {
        {x = 0,   y = 0, width = 282, height = 37, color = tocolor(29, 29, 39, 224.4)};
        {x = 282 + (3), y = 0, width = 114, height = 37, color = tocolor(29, 29, 39, 224.4)};
        {x = 396 + (6), y = 0, width = 149, height = 37, color = tocolor(29, 29, 39, 224.4)};
        {x = 545 + (9), y = 0, width = 311, height = 37, color = tocolor(29, 29, 39, 224.4)};
        {x = 856 + (12), y = 0, width = 360, height = 37, color = tocolor(29, 29, 39, 224.4)};
    };
} s_positions = {}

addEventHandler("onClientRender",root,
    function( )
        if (cache.ui_active == 1) then
            performance:get()
            local t_width = 0
            for i, vector in pairs(ui.slots) do
                if not (s_positions[i]) then s_positions[i] = {vector.x, vector.y, vector.width, vector.height} end
                drawRectangle(vector.x, vector.y, vector.width, vector.height, vector.color, true)
                drawRectangle(vector.x + vector.width, vector.y, 3, vector.height, tocolor(interface.g_color[1], interface.g_color[2], interface.g_color[3], interface.g_color[4]), true)
                t_width = t_width + vector.width + 3
            end
            local resource = cache.searchResource and tostring(cache.searchResource) or 'resources'
            drawRectangle(0, s_positions[1][4], t_width, 3, tocolor(interface.g_color[1], interface.g_color[2], interface.g_color[3], interface.g_color[4]), true)
            drawText('Time: '..cache.performance.localTime, s_positions[1][1], s_positions[1][2], s_positions[1][3], s_positions[1][4], tocolor(255, 255, 255, 255), _, FONTS[16].Regular, 'center', 'center', false, false, true)
            drawText('FPS:  '..cache.performance.perfomance.fps, s_positions[2][1] + s_positions[2][3] * 2.5, s_positions[2][2], s_positions[2][3], s_positions[2][4], tocolor(255, 255, 255, 255), _, FONTS[16].Regular, 'center', 'center', false, false, true)
            drawText('Ping:  '..cache.performance.perfomance.ping..'ms', s_positions[3][1] + s_positions[3][3] * 2.7, s_positions[3][2], s_positions[3][3], s_positions[3][4], tocolor(255, 255, 255, 255), _, FONTS[16].Regular, 'center', 'center', false, false, true)
            drawText('CPU Usage ('..resource..'): '..cache.performance.resources.cpu_usage, s_positions[4][1] + s_positions[4][3] * 1.78, s_positions[4][2], s_positions[4][3], s_positions[4][4], tocolor(255, 255, 255, 255), _, FONTS[16].Regular, 'center', 'center', false, false, true)
            drawText("Memory Usage ("..resource.."): "..cache.performance.resources.memory_usage, s_positions[5][1] + s_positions[5][3] * 2.4, s_positions[5][2], s_positions[5][3], s_positions[5][4], tocolor(255, 255, 255, 255), _, FONTS[16].Regular, 'center', 'center', false, false, true)

        elseif (cache.ui_active == 2) then
            performance:get(true)
            dxDrawText(inspect(cache.performance), tx * 10, screen.y / 2, _, _, tocolor(255, 255, 255, 255), _, FONTS[16].Regular, 'left', 'center', false, false, true)
        end
    end
)

-- Commands

if (system.commands['Draw Performance']['enabled']) then
    addCommandHandler(system.commands['Draw Performance']['command'],
        function(commandName, input)
            if not input then
                return performance:openUI()
            elseif (tonumber(input) == 1 or tonumber(input) == 2) then 
                return performance:openUI(tonumber(input)) 
            end
        end
    )
end

if (system.commands['Output Performance']['enabled']) then
    addCommandHandler(system.commands['Output Performance']['command'],
        function(commandName)
            performance:get(true)
            outputChatBox('Performance copiada para o clipboard!', 0, 255, 0)
            return setClipboard(inspect(cache.performance))
        end
    )
end

if (system.commands['Resource Monitor']['enabled']) then
    addCommandHandler(system.commands['Resource Monitor']['command'], function(_, resource)
        local theResource = getResourceFromName(resource)
        if (theResource and getResourceState(theResource) == 'running') then
            if not cache.searchResource then
                cache.searchResource = resource
            else
                if (not resource or resource == cache.searchResource) then
                    cache.searchResource = false
                else
                    cache.searchResource = resource
                end
            end
        else
            log.error('Resource not found!')
        end
    end)
end