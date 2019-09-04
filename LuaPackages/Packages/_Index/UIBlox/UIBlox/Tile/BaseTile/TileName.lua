local TextService = game:GetService("TextService")

local BaseTileRoot = script.Parent
local UIBloxRoot = BaseTileRoot.Parent.Parent
local Roact = require(UIBloxRoot.Parent.Roact)
local t = require(UIBloxRoot.Parent.t)
local withStyle = require(UIBloxRoot.Style.withStyle)

local ImageSetComponent = require(UIBloxRoot.ImageSet.ImageSetComponent)
local ShimmerPanel = require(UIBloxRoot.Loading.ShimmerPanel)

local ICON_PADDING = 4
local LINE_PADDING = 4

local ItemTileName = Roact.PureComponent:extend("ItemTileName")

local validateProps = t.strictInterface({
	LayoutOrder = t.optional(t.integer),

	maxHeight = t.intersection(t.integer, t.numberMin(0)),
	maxWidth =  t.intersection(t.integer, t.numberMin(0)),

	-- Loading skeleton will be rendered if name is not included
	name = t.optional(t.string),

	-- Optional image to be displayed in the title component
	-- Image information should be ImageSet compatible
	titleIcon = t.optional(t.table),
})

function ItemTileName:render()
	assert(validateProps(self.props))

	local layoutOrder = self.props.LayoutOrder
	local maxHeight = self.props.maxHeight
	local maxWidth = self.props.maxWidth
	local name = self.props.name
	local titleIcon = self.props.titleIcon

	return withStyle(function(stylePalette)
		local theme = stylePalette.Theme
		local font = stylePalette.Font
		local textSize = font.BaseSize * font.Header2.RelativeSize

		if name ~= nil then
			local titleIconSize = titleIcon and titleIcon.ImageRectSize or Vector2.new(0, 0)

			local labelWidth = titleIcon and (maxWidth - titleIconSize.X - ICON_PADDING) or maxWidth
			local labelTextSize = TextService:GetTextSize(name, textSize, font.Header2.Font, Vector2.new(labelWidth, maxHeight))

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder,
				Size = UDim2.new(0, maxWidth, 0, labelTextSize.Y),
			}, {
				Icon = titleIcon and Roact.createElement(ImageSetComponent.Label, {
					BackgroundTransparency = 1,
					Image = titleIcon,
					ImageColor3 = theme.IconEmphasis.Color,
					ImageTransparency = theme.IconEmphasis.Transparency,
					Size = UDim2.new(0, titleIconSize.X, 0, titleIconSize.Y),
				}),

				Name = Roact.createElement("TextLabel", {
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, 0, 0, 0),
					Size = UDim2.new(0, labelWidth, 1, 0),
					BackgroundTransparency = 1,
					TextSize = textSize,
					TextColor3 = theme.TextEmphasis.Color,
					TextTransparency = theme.TextEmphasis.Transparency,
					Font = font.Header2.Font,
					Text = name,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextWrapped = true,
				}),
			})
		else
			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder,
				Size = UDim2.new(0, maxWidth, 0, maxHeight),
			}, {
				FirstLine = Roact.createElement(ShimmerPanel, {
					Size = UDim2.new(1, 0, 0, textSize),
				}),

				SecondLine = Roact.createElement(ShimmerPanel, {
					Position = UDim2.new(0, 0, 0, textSize + LINE_PADDING),
					Size = UDim2.new(0.4, 0, 0, textSize),
				}),
			})
		end
	end)
end

return ItemTileName