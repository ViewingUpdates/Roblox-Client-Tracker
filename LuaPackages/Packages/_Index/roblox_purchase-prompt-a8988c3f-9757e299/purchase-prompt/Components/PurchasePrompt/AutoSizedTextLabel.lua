local Root = script.Parent.Parent.Parent
local TextService = game:GetService("TextService")

local LuaPackages = Root.Parent
local Roact = require(LuaPackages.Roact)
local Cryo = require(LuaPackages.Cryo)

local AutoSizedTextLabel = Roact.PureComponent:extend("AutoSizedTextLabel")

function AutoSizedTextLabel:render()
	local text = self.props.Text
	local textSize = self.props.TextSize
	local font = self.props.Font
	local width = self.props.width

	local totalTextSize
	if text ~= nil then
		totalTextSize = TextService:GetTextSize(text, textSize, font, Vector2.new(width, 10000))
	else
		totalTextSize = Vector2.new(0, 0)
	end

	local textLabelProps = Cryo.Dictionary.join(self.props, {
		width = Cryo.None,
		Size = UDim2.new(0, width, 0, totalTextSize.Y),
	})

	return Roact.createElement("TextLabel", textLabelProps)
end

return AutoSizedTextLabel