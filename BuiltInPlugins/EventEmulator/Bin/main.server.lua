--[[
	Event Emulator main script.
	Mounts and unmounts the Roact tree.
]]

local FFlagDebugEnableEventEmulator = game:DefineFastFlag("DebugEnableEventEmulator", false)
if not (game:GetService("StudioService"):HasInternalPermission() and FFlagDebugEnableEventEmulator) then
	return
end

local main = script.Parent.Parent
local Roact = require(main.Packages.Roact)

local MainPlugin = require(main.Src.MainPlugin)
local handle

local function init()
	plugin.Name = "Event Emulator"

	local mainPlugin = Roact.createElement(MainPlugin, {
		Plugin = plugin,
		ClickableWhenViewportHidden = true,
	})

	handle = Roact.mount(mainPlugin)
end

plugin.Unloading:Connect(function()
	if handle then
		Roact.unmount(handle)
		handle = nil
	end
end)

init()
