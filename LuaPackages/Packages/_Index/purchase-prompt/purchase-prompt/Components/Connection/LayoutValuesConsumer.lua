--[[
	LayoutValuesConsumer will extract the LayoutValues object
	from context and pass it into the given render callback
]]
local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Roact)

local LayoutValuesKey = require(script.Parent.Parent.Parent.LayoutValuesKey)

local LayoutValuesConsumer = Roact.Component:extend("LayoutValuesConsumer")

-- TODO(esauer): Add validation when adding t
-- local validateProps = t.strictInterface({
-- 	render = t.callback,
-- })

function LayoutValuesConsumer:init()
	self.layoutValues = self._context[LayoutValuesKey]
	self.state = {
		layout = self.layoutValues.layout,
	}
end

function LayoutValuesConsumer:render()
	-- assert(validateProps(self.props))
	return self.props.render(self.state.layout)
end

function LayoutValuesConsumer:didMount()
	self.disconnectLayoutListener = self.layoutValues.signal:subscribe(function(newLayout)
		self:setState({
			layout = newLayout,
		})
	end)
end

function LayoutValuesConsumer:willUnmount()
	self.disconnectLayoutListener()
end

return LayoutValuesConsumer