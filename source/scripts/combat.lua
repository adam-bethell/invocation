import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Combat").extends(gfx.sprite)

local text_0 = gfx.image.new("images/text/0")
local text_1 = gfx.image.new("images/text/1")
local text_2 = gfx.image.new("images/text/2")
local text_3 = gfx.image.new("images/text/3")
local text_4 = gfx.image.new("images/text/4")
local text_nums = {text_0, text_1, text_2, text_3, text_4}

function Combat:init()
    Combat.super.init(self)

    self.playerLife = {4, 4}

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


    self.whiteLifeSprite = gfx.sprite.new(text_4)
    self.whiteLifeSprite:moveTo(280, 220)
    self.whiteLifeSprite:add()
    self.blackLifeSprite = gfx.sprite.new(text_4)
    self.blackLifeSprite:moveTo(370, 220)
    self.blackLifeSprite:add()

    self:add()
end

function Combat:update()
end

function Combat:blackAttack()
    self.bAnim.frame = 1
    self.playerLife[2] -= 1
    self.blackLifeSprite:setImage(self:getTextNum(self.playerLife[2]))
end

function Combat:whiteAttack()
    self.wAnim.frame = 1
    self.playerLife[1] -= 1
    self.whiteLifeSprite:setImage(self:getTextNum(self.playerLife[1]))
end

function Combat:getTextNum(value)
    assert(value >= 0 and value <= 4)
    return text_nums[value + 1]
end
