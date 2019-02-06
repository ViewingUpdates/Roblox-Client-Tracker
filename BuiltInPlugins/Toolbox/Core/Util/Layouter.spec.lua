return function()
	local Plugin = script.Parent.Parent.Parent

	local Layouter = require(Plugin.Core.Util.Layouter)

	describe("calculateAssetsHeight", function()
		it("should return the correct height", function()
			local assetCounts = {0, 2, 10, 100, 500, 1000}
			local maxWidths = {100, 200, 500, 1000}

			local heights = {
				{0, 0, 0, 0},
				{238, 111, 111, 111},
				{1254, 619, 238, 111},
				{12684, 6334, 2143, 1127},
				{63484, 31734, 10652, 5318},
				{126984, 63484, 21193, 10652}
			}

			for row, _ in ipairs(heights) do
				local assetCount = assetCounts[row]

				for column, height in ipairs(heights[row]) do
					local maxWidth = maxWidths[column]
					expect(height).to.equal(Layouter.calculateAssetsHeight(assetCount, maxWidth))
				end
			end
		end)
	end)
end
