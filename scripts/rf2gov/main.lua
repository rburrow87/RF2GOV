
local config = {}
config.widgetName = "RF Governor"
config.widgetKey = "rf2gov"
config.widgetDir = "/scripts/rf2gov/"
config.useCompiler = true

compile = assert(loadfile(config.widgetDir .. "compile.lua"))(config)

rf2gov = assert(compile.loadScript(config.widgetDir .. "rf2gov.lua"))(config,compile)

local function paint()
	return rf2gov.paint()
end


local function wakeup()
	return rf2gov.wakeup()
end

local function read()
	return rf2gov.read()
end

local function write()
	return rf2gov.write()
end



local function create()
	return rf2gov.create()
end




local function init()
    system.registerWidget({
        key = config.widgetKey,
        name = config.widgetName,
        create = create,
        paint = paint,
        wakeup = wakeup,
        persistent = false
    })

end

return {init = init}
