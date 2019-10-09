local FFlagTerrainToolsUIUpdate = settings():GetFFlag("TerrainToolsUIUpdate")
if not FFlagTerrainToolsUIUpdate then
	return
end

if not plugin then
	return
end

-- libraries
local Plugin = script.Parent.Parent
local Roact = require(Plugin.Packages.Roact)
local Rodux = require(Plugin.Packages.Rodux)
local UILibrary = require(Plugin.Packages.UILibrary)
local Manager = require(Plugin.Src.Components.Manager) -- top most ui component

-- components
local ServiceWrapper = require(Plugin.Src.Components.ServiceWrapper)

-- actions
local ChangeTool = require(Plugin.Src.Actions.ChangeTool)

-- data
local MainReducer = require(Plugin.Src.Reducers.MainReducer)

-- theme
local PluginTheme = require(Plugin.Src.Resources.PluginTheme)

-- localization
local DevelopmentReferenceTable = Plugin.Src.Resources.DevelopmentReferenceTable
local TranslationReferenceTable = Plugin.Src.Resources.TranslationReferenceTable
local Localization = UILibrary.Studio.Localization

local PLUGIN_NAME = "TerrainToolsV2"
local TOOLBAR_NAME = "TerrainToolsLuaToolbarName"
local DOCK_WIDGET_PLUGIN_NAME = "TerrainTools_PluginGui"

-- Plugin Specific Globals
local dataStore = Rodux.Store.new(MainReducer)
local theme = PluginTheme.new()
local localization = Localization.new({
	pluginName = PLUGIN_NAME,
	stringResourceTable = DevelopmentReferenceTable,
	translationResourceTable = TranslationReferenceTable,
})

-- Widget Gui Elements
local pluginHandle
local pluginGui

-- Fast flags

--Initializes and populates the plugin popup window
local function openPluginWindow()
	if pluginHandle then
		warn("Plugin handle already exists")
		return
	end

	-- create the roact tree
	local servicesProvider = Roact.createElement(ServiceWrapper, {
		plugin = plugin,
		localization = localization,
		theme = theme,
		store = dataStore,
	}, {
		UIManager = Roact.createElement(Manager, {
			Name = Manager,
		}),
	})

	pluginHandle = Roact.mount(servicesProvider, pluginGui)

	if plugin then
		plugin.Deactivation:connect(function()
			dataStore:dispatch(ChangeTool("None"))
		end)
	end
end

--Closes and unmounts the plugin popup window
local function closePluginWindow()
	--ToolActivation:ShutDown()
	if pluginHandle then
		Roact.unmount(pluginHandle)
		pluginHandle = nil
	end
end

local function toggleWidget()
	pluginGui.Enabled = not pluginGui.Enabled
end


--Binds a toolbar button
local function main()
	local pluginTitle = localization:getText("Meta", "PluginName")
	plugin.Name = "Terrain Editor"
	local toolbar = plugin:CreateToolbar(TOOLBAR_NAME)
	local exampleButton = toolbar:CreateButton(
		localization:getText("Meta", "PluginButtonEditor"),
		localization:getText("Main", "PluginButtonEditorTooltip"),
		"rbxasset://textures/TerrainTools/icon_terrain_big.png",
		localization:getText("Main", "ToolbarButton")
	)

	exampleButton.Click:connect(toggleWidget)

	local function showIfEnabled()
		if pluginGui.Enabled then
			openPluginWindow()
		else
			closePluginWindow()
		end

		-- toggle the plugin UI
		exampleButton:SetActive(pluginGui.Enabled)
	end

	-- create the plugin
	local widgetInfo = DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Left,  -- Widget will be initialized docked to the left
		true,   -- Widget will be initially enabled
		false,  -- Don't override the previous enabled state
		300,    -- Default width of the floating window
		600,    -- Default height of the floating window
		270,    -- Minimum width of the floating window (optional)
		150     -- Minimum height of the floating window (optional)
	)
	pluginGui = plugin:CreateDockWidgetPluginGui(DOCK_WIDGET_PLUGIN_NAME, widgetInfo)
	pluginGui.Name = localization:getText("Meta", "PluginName")
	pluginGui.Title = localization:getText("Main", "Title")

	pluginGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	pluginGui:GetPropertyChangedSignal("Enabled"):connect(showIfEnabled)

	-- configure the widget and button if its visible
	showIfEnabled()
end

main()