import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Combat").extends(gfx.sprite)

function Combat:init()
    Combat.super.init(self)

    self.playerLife = {4, 4}

    self.combatArenaImage = gfx.image.new("images/combat_arena")
    assert(self.combatArenaImage)

    self.wImTable = gfx.imagetable.new("images/white_knight-table-177-149")
    assert(self.wImTable)
    self.wAnim = gfx.animation.loop.new(33, self.wImTable, false)
    self.wAnim.endFrame = 85
    self.wAnim.frame = 65
    self.whiteKnight = gfx.sprite.new(self.wAnim:image())
    self.whiteKnight.update = function()
        self.whiteKnight:setImage(self.wAnim:image())
    end
    self.whiteKnight:moveTo(300, 160)
    self.whiteKnight:add()

    self.bImTable = gfx.imagetable.new("images/knight-table-177-149")
    assert(self.bImTable)
    self.bAnim = gfx.animation.loop.new(33, self.bImTable, false)
    self.bAnim.endFrame = 85
    self.bAnim.frame = 65
    self.blackKnight = gfx.sprite.new(self.bAnim:image())
    self.blackKnight:setImageFlip("flipX")
    self.blackKnight.update = function()
        self.blackKnight:setImage(self.bAnim:image())
        self.blackKnight:setImageFlip("flipX")
    end
    self.blackKnight:moveTo(350, 160)
    self.blackKnight:add()

    self.combatArenaSprite = gfx.sprite.new(self.combatArenaImage)
    self.combatArenaSprite:moveTo(400 - 70 - 5, 240 - 70)

    self:add()
end

function Combat:update()
end

function Combat:blackAttack()
    self.bAnim.frame = 1
    self.playerLife[2] -= 1
end

function Combat:whiteAttack()
    self.wAnim.frame = 1
    self.playerLife[1] -= 1
end