local Plugin = script.Parent.Parent.Parent

local Libs = Plugin.Libs
local Util = require(Libs.Framework.Util)
local Action = Util.Action

return Action(script.Name, function(elapsedTime)
	assert(type(elapsedTime) == "number", "Expected elapsedTime to be a number")
	return {
		elapsedTime = elapsedTime,
	}
end)