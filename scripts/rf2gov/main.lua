--[[
set crsf_flight_mode_reuse = GOV_ADJFUNC
]] --


refresh = true
local environment = system.getVersion()
local oldsensors = {
    "govmode"
}

function sensorMakeNumber(x)
    if x == nil or x == "" then
        x = 0
    end

    x = string.gsub(x, "%D+", "")
    x = tonumber(x)
    if x == nil or x == "" then
        x = 0
    end

    return x
end

local function create(widget)
    return WidgetTable
end

local function paint(widget)


    local w, h = lcd.getWindowSize()
	 
	lcd.font(FONT_XXL)
	str = sensors.govmode
	tsizeW, tsizeH = lcd.getTextSize(str)

	offsetY = 5
	
	
	posX = w/2 - tsizeW/2
	posY = h/2 - tsizeH/2 + offsetY

	lcd.drawText(posX, posY, str)

end



function getSensors()

    if environment.simulation == true then
        govmode = "DISABLED"
    else
        if system.getSource("Rx RSSI1") ~= nil then
            -- we are running crsf
            if system.getSource("Flight mode") ~= nil then
                govmode = system.getSource("Flight mode"):stringValue()
            end
        else
            -- we are run sport
            if system.getSource({category = CATEGORY_TELEMETRY_SENSOR, appId = 0x5450}) ~= nil then
                govId = system.getSource({category = CATEGORY_TELEMETRY_SENSOR, appId = 0x5450}):stringValue()
                govId = sensorMakeNumber(govId)
                --print(govId)
                if govId == 0 then
                    govmode = "OFF"
                elseif govId == 1 then
                    govmode = "IDLE"
                elseif govId == 2 then
                    govmode = "SPOOLUP"
                elseif govId == 3 then
                    govmode = "RECOVERY"
                elseif govId == 4 then
                    govmode = "ACTIVE"
                elseif govId == 5 then
                    govmode = "THR-OFF"
                elseif govId == 6 then
                    govmode = "LOST-HS"
                elseif govId == 7 then
                    govmode = "SPOOLUP"
                elseif govId == 8 then
                    govmode = "BAILOUT"
                elseif govId == 100 then
                    govmode = "DISABLED"
                elseif govId == 101 then
                    govmode = "DISARMED"
                else
                    govmode = "UNKNOWN"
                end
            else
                govmode = ""
            end
        end
	end

	if oldsensors.govmode ~= govmode then
		refresh = true
	end
 
	ret = {
		govmode = govmode
	}
	oldsensors = ret

	return ret
end


local function wakeup(widget)
    refresh = false
    sensors = getSensors()

    if refresh == true then
        lcd.invalidate()
    end

    return
end


local function init()
    system.registerWidget(
        {
            key = "rf2gov",
            name = "RF GOVERNOR",
            create = create,
            paint = paint,
            wakeup = wakeup,
        }
    )
end

return {init = init}