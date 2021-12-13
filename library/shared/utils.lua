cache = {}
cache.clear = function()
    cache = {}
end

function table.random ( theTable )
    return theTable[math.random ( #theTable )]
end

function math.round(number)
    local _, decimals = math.modf(number)
    if decimals < 0.5 then return math.floor(number) end
    return math.ceil(number)
end

function round(number)
    return math.round(number)
end

function bytesToSize(bytes)
	precision = 2
	kilobyte = 1024;
	megabyte = kilobyte * 1024;
	gigabyte = megabyte * 1024;
	terabyte = gigabyte * 1024;

	if((bytes >= 0) and (bytes < kilobyte)) then
		return bytes .. " Bytes";
	elseif((bytes >= kilobyte) and (bytes < megabyte)) then
		return math.stringround(bytes / kilobyte, true, 2) .. ' KB';
	elseif((bytes >= megabyte) and (bytes < gigabyte)) then
		return math.stringround(bytes / megabyte, true, 2) .. ' MB';
	elseif((bytes >= gigabyte) and (bytes < terabyte)) then
		return math.stringround(bytes / gigabyte, true, 2) .. ' GB';
	elseif(bytes >= terabyte) then
		return math.stringround(bytes / terabyte, true, 2) .. ' TB';
	else
		return bytes .. ' B';
	end
end

local fps = 0
local nextTick = 0
function getCurrentFPS() -- Setup the useful function
    return fps
end

local function updateFPS(msSinceLastFrame)
    local now = getTickCount()
    if (now >= nextTick) then
        fps = (1 / msSinceLastFrame) * 1000
        nextTick = now + 1000
    end
end
addEventHandler("onClientPreRender", root, updateFPS)

function returnRealTime(timeType)
    local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second
    local monthday = time.monthday
	local month = time.month
	local year = time.year
    if (not timeType or timeType == 1) then
        local formattedTime = string.format("%02d/%02d/%04d - %02d:%02d:%02d", monthday, month + 1,  year + 1900, hours, minutes, seconds)
        return formattedTime
    elseif (timeType == 2) then
        local formattedYear = string.format("%02d-%02d-%04d", monthday, month + 1,  year + 1900)
        local formattedHour = string.format("%02d:%02d:%02d", hours, minutes, seconds)
        return {formattedYear, formattedHour}
    end
end

function math.stringround(number, decimal, decimals)
    if (decimal) then
        decimals = decimals or 2
        return string.format("%.".. decimals .."f", number)
    else
        return string.format("%.0f", number)
    end
end

log = {
    error = function(text)
        outputDebugString("["..returnRealTime().."] $ "..getResourceName(getThisResource()).." error > "..text, 4, 163, 33, 33)
    end;

    warning = function(text)
        outputDebugString("["..returnRealTime().."] $ "..getResourceName(getThisResource()).." warning > "..text, 4, 201, 129, 40)
    end;

    success = function(text)
        outputDebugString("["..returnRealTime().."] $ "..getResourceName(getThisResource()).." > "..text, 4, 77, 158, 44)
    end;
}