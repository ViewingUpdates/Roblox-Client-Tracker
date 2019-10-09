local Packages = script.Parent.Parent.Parent.Parent

local Roact = require(Packages.Roact)
local t = require(Packages.t)
local withStyle = require(Packages.UIBlox.Style.withStyle)
local Images = require(Packages.UIBlox.ImageSet.Images)
local InputButton = require(Packages.UIBlox.Core.InputButton.InputButton)

local RadioButton = Roact.PureComponent:extend("RadioButton")

local validateProps = t.strictInterface({
	text = t.string,
	isSelected = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	onActivated = t.callback,
	Size = t.UDim2,
	LayoutOrder = t.optional(t.number),
	key = t.number,
})

RadioButton.defaultProps = {
	text = "RadioButton Text",
	isSelected = false,
	isDisabled = false,
	LayoutOrder = 0,
}

local INNER_BUTTON_SIZE = 18

function RadioButton:init()
	self.onSetValue = function()
		if not self.props.isDisabled then
			self.props.onActivated(self.props.key)
		end
	end
end

function RadioButton:render()
	assert(validateProps(self.props))

	return withStyle(function(stylePalette)
		local theme = stylePalette.Theme

		local image = Images["circles/hollow"]
		local imageColor = theme.TextDefault.Color

		local fillImage = Images["circles/fill"]
		local fillImageColor = theme.TextDefault.Color

		local fillImageSize
		local isSelected = self.props.isSelected

		local textColor = theme.TextDefault.Color
		local transparency = theme.TextDefault.Transparency

		if self.props.isDisabled then
			transparency = 0.5
		end

		if isSelected then
			fillImageSize = UDim2.new(0, INNER_BUTTON_SIZE, 0, INNER_BUTTON_SIZE)
			textColor = theme.SystemPrimaryDefault.Color
			fillImageColor = theme.SystemPrimaryDefault.Color
			imageColor = theme.SystemPrimaryDefault.Color
		else
			fillImageSize = UDim2.new(0, 0, 0, 0)
		end

		return Roact.createElement(InputButton, {
			text = self.props.text,
			onActivated = self.onSetValue,
			Size = self.props.Size,
			image = image,
			imageColor = imageColor,
			fillImage = fillImage,
			fillImageSize = fillImageSize,
			fillImageColor = fillImageColor,
			selectedColor = theme.SystemPrimaryDefault.Color,
			textColor = textColor,
			transparency = transparency,
			LayoutOrder = self.props.LayoutOrder,
			isDisabled = self.props.isDisabled,
		})
	end)
end

return RadioButton