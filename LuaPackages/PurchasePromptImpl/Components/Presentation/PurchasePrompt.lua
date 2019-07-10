local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local Roact = require(CorePackages.Roact)
local Otter = require(CorePackages.Otter)

local PromptState = require(script.Parent.Parent.Parent.PromptState)
local signalFinishedAndHidePrompt = require(script.Parent.Parent.Parent.Thunks.signalFinishedAndHidePrompt)

local ExternalEventConnection = require(script.Parent.Parent.Connection.ExternalEventConnection)
local PromptContents = require(script.Parent.PromptContents)
local InProgressContents = require(script.Parent.InProgressContents)
local connectToStore = require(script.Parent.Parent.Parent.connectToStore)

local withLayoutValues = require(script.Parent.Parent.Connection.withLayoutValues)

local PurchasePrompt = Roact.Component:extend(script.Name)

local SPRING_CONFIG = {
	dampingRatio = 1,
	frequency = 1.6,
}

function PurchasePrompt:init()
	local setPromptHidden = self.props.setPromptHidden

	self.motor = Otter.createSingleMotor(0)
	self.motor:start()

	self.ref = Roact.createRef()

	self.motor:onStep(function(value)
		local frame = self.ref.current

		if frame then
			frame.AnchorPoint = Vector2.new(0.5, 1 - 0.5 * value)
			frame.Position = UDim2.new(0.5, 0, 0.5 * value, 0)
		end
	end)

	self.onClose = function()
		local onCompleteDisconnector
		onCompleteDisconnector = self.motor:onComplete(function()
			setPromptHidden()
			onCompleteDisconnector()
		end)

		self.motor:setGoal(Otter.spring(0, SPRING_CONFIG))
	end
end

function PurchasePrompt:didUpdate(prevProps, prevState)
	if prevProps.promptState ~= self.props.promptState then

		local goal = self.props.promptState == PromptState.Hidden and 0 or 1
		self.motor:setGoal(Otter.spring(goal, SPRING_CONFIG))
	end
end

function PurchasePrompt:render()
	return withLayoutValues(function(values)
		local promptState = self.props.promptState

		local contents
		if promptState == PromptState.Hidden then
			--[[
				When the prompt is hidden, we'd rather not keep unused Roblox
				instances for it around, so we don't render them
			]]
			contents = nil
		elseif promptState == PromptState.PurchaseInProgress or promptState == PromptState.UpsellInProgress then
			contents = Roact.createElement(InProgressContents)
		else
			contents = Roact.createElement(PromptContents, {
				onClose = self.onClose,
			})
		end

		return Roact.createElement("Frame", {
			Size = values.Size.Dialog,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,

			[Roact.Ref] = self.ref
		}, {
			PromptContents = contents,
			OnCoreGuiMenuOpened = Roact.createElement(ExternalEventConnection, {
				event = GuiService.MenuOpened,
				callback = self.onClose,
			})
		})
	end)
end

local function mapStateToProps(state)
	return {
		promptState = state.promptState
	}
end

local function mapDispatchToProps(dispatch)
	return {
		setPromptHidden = function()
			dispatch(signalFinishedAndHidePrompt())
		end
	}
end

PurchasePrompt = connectToStore(
	mapStateToProps,
	mapDispatchToProps
)(PurchasePrompt)

return PurchasePrompt