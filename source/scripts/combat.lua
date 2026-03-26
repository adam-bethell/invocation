import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Combat").extends(gfx.sprite)

local combatArenaImage = gfx.image.new("images/combat_arena")
assert(combatArenaImage)

local wImTable = gfx.imagetable.new("images/white_knight-table-177-149")
assert(wImTable)
local wAnim = gfx.animation.loop.new(33, wImTable, true)
wAnim.endFrame = 85
local whiteKnight = gfx.sprite.new(wAnim:image())
whiteKnight.update = function()
    whiteKnight:setImage(wAnim:image())
end
whiteKnight:moveTo(300, 160)
whiteKnight:add()

local bImTable = gfx.imagetable.new("images/knight-table-177-149")
assert(bImTable)
local bAnim = gfx.animation.loop.new(33, bImTable, true)
bAnim.endFrame = 85
local blackKnight = gfx.sprite.new(bAnim:image())
blackKnight:setImageFlip("flipX")
blackKnight.update = function()
    blackKnight:setImage(bAnim:image())
    blackKnight:setImageFlip("flipX")
end
blackKnight:moveTo(350, 160)
blackKnight:add()

function Combat:init()
    self.combatArenaSprite = gfx.sprite.new(combatArenaImage)
    self.combatArenaSprite:moveTo(400 - 70 - 5, 240 - 70)
end