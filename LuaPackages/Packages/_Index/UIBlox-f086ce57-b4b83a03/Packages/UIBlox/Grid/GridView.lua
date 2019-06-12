local GridRoot = script.Parent
local UIBloxRoot = GridRoot.Parent

local Roact = require(UIBloxRoot.Parent.Roact)
local t = require(UIBloxRoot.Parent.t)

local positiveVector2 = require(UIBloxRoot.Utility.isPositiveVector2)

local isGridViewProps = t.strictInterface({
	-- A function that, given an item, returns a Roact element representing that
	-- item. The item should expect to fill its parent. Setting LayoutOrder is
	-- not necessary.
	renderItem = t.callback,
	-- The size of a grid item, in pixels.
	itemSize = positiveVector2,
	-- The spacing between grid cells, on each axis.
	itemPadding = t.Vector2,
	-- All the items that can be displayed in the grid. renderItem should be
	-- able to use all values in this table. This must be an array (we don't
	-- check if it is for performance reasons).
	items = t.table,
	-- The maximum height the grid view is allowed to grow to.
	maxHeight = t.numberMin(0),
	-- The height of the visible window in the grid view. If nil, the grid view
	-- will render all of its items.
	windowHeight = t.optional(t.numberMin(0)),
	-- The layout order of the grid.
	LayoutOrder = t.optional(t.integer),
	-- Called when the grid view measures a change in its width. Used in
	-- DefaultMetricsGridView to resize the grid cells.
	onWidthChanged = t.optional(t.callback),
})

local GridView = Roact.PureComponent:extend("GridView")

GridView.defaultProps = {
	maxHeight = math.huge,
}

function GridView:init()
	self.state = {
		containerWidth = 0,
		containerYPosition = 0,
	}
end

function GridView:render()
	assert(isGridViewProps(self.props))
	local items = self.props.items
	local itemCount = #items

	local itemSize = self.props.itemSize
	local itemPadding = self.props.itemPadding
	local maxHeight = self.props.maxHeight
	local containerWidth = self.state.containerWidth
	local containerYOffset = self.state.containerYPosition
	local startIndex = 1
	local endIndex = itemCount
	local gridChildren = {}
	local x, y = 0, 0

	local itemsPerRow = math.floor((containerWidth + itemPadding.X) / (itemSize.X + itemPadding.X))
	local totalRows = math.ceil(itemCount / itemsPerRow)
	local maximumRenderableRows = math.floor((maxHeight + itemPadding.Y) / (itemSize.Y + itemPadding.Y))
	local displayedRows = math.min(maximumRenderableRows, totalRows)
	local containerHeight = displayedRows * itemSize.Y + math.max(displayedRows - 1, 0) * itemPadding.Y

	if self.props.windowHeight ~= nil then
		-- Add one to ensure that when you scroll you don't see items "pop" into existence with windowing.
		local visibleRows = math.floor((self.props.windowHeight + itemPadding.Y) / (itemSize.Y + itemPadding.Y)) + 1
		local startingRow = math.floor((containerYOffset + itemPadding.Y) / (itemSize.Y + itemPadding.Y))
		local endingRow = math.min(displayedRows, startingRow + visibleRows)

		startIndex = math.max(1, startingRow * itemsPerRow + 1)
		endIndex = math.min(itemCount, endingRow * itemsPerRow + itemsPerRow)
		y = startingRow * itemSize.Y + startingRow * itemPadding.Y
	end

	local visibleItems = math.abs(startIndex - endIndex) + 1

	-- If the item height is already greater than the maximum size we shouldn't
	-- render _anything_
	if containerHeight < maxHeight then
		for itemIndex = startIndex, endIndex do
			local renderKey = itemIndex % visibleItems
			gridChildren[renderKey] = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, x, 0, y),
				Size = UDim2.new(0, itemSize.X, 0, itemSize.Y),
			}, {
				Content = self.props.renderItem(items[itemIndex])
			})

			x = math.floor(x + itemSize.X + itemPadding.X)

			-- If the x position overflows the maximum size, wrap further content
			-- onto another row. We check for just itemSize because the final
			-- grid item doesn't have padding tacked onto the end of it.
			if x + itemSize.X > containerWidth and itemIndex < endIndex then
				x = 0
				y = y + itemPadding.Y + itemSize.Y
			end
		end
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = self.props.LayoutOrder,
		Size = UDim2.new(1, 0, 0, containerHeight),
		[Roact.Change.AbsolutePosition] = self.props.windowHeight ~= nil and function(rbx)
			self:setState({
				containerYPosition = -math.min(0, rbx.AbsolutePosition.Y),
			})
		end or nil,
		[Roact.Change.AbsoluteSize] = function(rbx)
			self:setState({
				containerWidth = rbx.AbsoluteSize.X,
			})

			if self.props.onWidthChanged ~= nil then
				self.props.onWidthChanged(rbx.AbsoluteSize.X)
			end
		end,
	}, gridChildren)
end

return GridView