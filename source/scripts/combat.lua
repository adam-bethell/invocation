import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Combat").extends(gfx.sprite)

local combatArenaImage = gfx.image.new("images/combat_arena")
assert(combatArenaImage)


function Combat:init()
    self.combatArenaSprite = gfx.sprite.new(combatArenaImage)
    self.combatArenaSprite:moveTo(400 - 70 - 5, 240 - 70)
    self.combatArenaSprite:add()
end