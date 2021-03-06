--[[
	Creates the theme for the plugin.

	Extends the default StudioFrameworkStyles, and also defines values specific
	to components created within this plugin and constant values shared across components.
]]

local Plugin = script.Parent.Parent.Parent

local Framework = Plugin.Packages.Framework
local ContextServices = require(Framework.ContextServices)
local Theme = ContextServices.Theme

local StudioFrameworkStyles = require(Framework.StudioUI.StudioFrameworkStyles)
local Common = require(Framework.StudioUI.StudioFrameworkStyles.Common)

local Util = require(Plugin.Packages.Framework.Util)
local Style = Util.Style
local StyleModifier = Util.StyleModifier
local StyleTable = Util.StyleTable
local StyleValue = Util.StyleValue

local function makeTheme()
	return Theme.new(function(theme, getColor)
		local studioFrameworkStyles = StudioFrameworkStyles.new(theme, getColor)
		local common = Common(theme, getColor)

		local helpIconImage = StyleValue.new("HelpIconImage", {
			Light = "rbxasset://textures/AlignTool/Help_Light.png",
			Dark = "rbxasset://textures/AlignTool/Help_Dark.png",
		})

		local image = StyleTable.new("Image", function()
			local helpIcon = Style.new({
				Image = helpIconImage:get(theme.Name),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.fromOffset(14, 14),

				[StyleModifier.Disabled] = {
					Transparency = 0.5,
				},
			})

			return {
				HelpIcon = helpIcon,
			}
		end)

		return {
			Plugin = Style.new({
				-- Size of leading labels "Align In" and "Relative To".
				-- Once localization is added, we should use the width of the
				-- localized text from TextService, clamped to a range.
				SectionLabelSize = UDim2.fromOffset(80, 20),

				ErrorTextColor = theme:GetColor("ErrorText"),
				WarningTextColor = theme:GetColor("WarningText"),
				InfoTextColor = theme:GetColor("InfoText"),

				MainView = {
					ListItemPadding = UDim.new(0, 10),
					Padding = 10,
					ButtonContainerPadding = {
						Top = 10,
					},
					PrimaryButtonSize = UDim2.fromOffset(200, 32),
				},

				ModeSection = {
					ButtonContainerSize = UDim2.fromOffset(175, 55),
					CellPadding = UDim2.fromOffset(5, 0),
					CellSize = UDim2.new(0, 55, 0, 55),
					Size = UDim2.new(1, 0, 0, 60),
				},

				AxesSection = {
					ListItemPadding = 5,
					Size = UDim2.new(1, 0, 0, 22),
				},

				RelativeToSection = {
					ListItemPadding = 5,
					Size = UDim2.new(1, 0, 0, 22),
				},

				Checkbox = StyleTable.new("Checkbox", function()
					local Default = Style.extend(common.MainText, {
						Padding = 5,
						ImageSize = UDim2.new(0, 20, 0, 20),
					})

					return {
						Default = Default,
					}
				end),

				ImageButton = StyleTable.new("ImageButton", function()
					local Default = Style.extend(common.MainText, {
						BackgroundTransparency = 1,
						Padding = 6,

						Image = {
							Size = UDim2.new(0, 26, 0, 27),
							AnchorPoint = Vector2.new(0.5, 0),
							Position = UDim2.new(0.5, 0, 0, 0),
						},

						Label = {
							Position = UDim2.new(0, 0, 1, -15),
							Size = UDim2.new(1, 0, 0, 15),
						},
					})

					return {
						Default = Default,
					}
				end),
			}),

			Framework = StyleTable.extend(studioFrameworkStyles, {
				Image = image,
			}),
		}
	end)
end

return makeTheme
