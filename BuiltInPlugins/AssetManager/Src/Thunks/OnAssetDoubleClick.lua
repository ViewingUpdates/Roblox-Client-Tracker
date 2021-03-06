local Plugin = script.Parent.Parent.Parent

local SetScreen = require(Plugin.Src.Actions.SetScreen)

local FFlagAssetManagerAddAnalytics = game:GetFastFlag("AssetManagerAddAnalytics")

local AssetManagerService = game:GetService("AssetManagerService")

return function(analytics, assetData)
    return function(store)
        local isFolder = assetData.ClassName == "Folder"
        if isFolder then
            if FFlagAssetManagerAddAnalytics then
                analytics:report("openFolder", assetData.Screen.Key)
            end
            store:dispatch(SetScreen(assetData.Screen))
        else
            local assetType = assetData.assetType
            if assetType == Enum.AssetType.Place then
                AssetManagerService:OpenPlace(assetData.id)
            elseif assetType == Enum.AssetType.Package then
                AssetManagerService:InsertPackage(assetData.id)
            elseif assetType == Enum.AssetType.Image then
                AssetManagerService:InsertImage(assetData.id)
            elseif assetType == Enum.AssetType.MeshPart then
                AssetManagerService:InsertMesh("Meshes/".. assetData.name, false)
            elseif assetType == Enum.AssetType.Lua then
                AssetManagerService:OpenLinkedSource("Scripts/" .. assetData.name)
            end
            if FFlagAssetManagerAddAnalytics then
                analytics:report("doubleClickInsert")
                local state = store:getState()
                local searchTerm = state.AssetManagerReducer.searchTerm
                if utf8.len(searchTerm) ~= 0 then
                    analytics:report("insertAfterSearch")
                end
            end
        end
    end
end