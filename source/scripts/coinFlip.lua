import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("CoinFlip").extends(gfx.sprite)

function CoinFlip:init(call)
    CoinFlip.super.init(self)

    self.call = call
    local winningSide = math.random(2)
    self.result = (self.call == winningSide)
    self.finished = false
    self:drawResult(winningSide)
end

function CoinFlip:drawResult(winningSide)
    if (winningSide == 1) then
        -- SUN / HEADS
        self.coinImagetable_1 = gfx.imagetable.new("images/coin_flip_1-table-64-215")
        self.coinAnimation_1 = gfx.animation.loop.new(30, self.coinImagetable_1, false)
        self.coinAnimation_1.endFrame = 162
        self.coinSprite_1 = gfx.sprite.new(self.coinAnimation_1:image())
        self.coinSprite_1.update = function()
            self.coinSprite_1:setImage(self.coinAnimation_1:image())
            if (not self.coinAnimation_1:isValid()) then
                self.finished = true
                self.coinSprite_1:remove()
            end
        end
        self.coinSprite_1:moveTo(120, 120)
        self.coinSprite_1:add()
    elseif (winningSide == 2) then
        self.coinImagetable = gfx.imagetable.new("images/coin_flip-table-64-215")
        self.coinAnimation = gfx.animation.loop.new(30, self.coinImagetable, false)
        self.coinAnimation.endFrame = 162
        self.coinSprite = gfx.sprite.new(self.coinAnimation:image())
        self.coinSprite.update = function()
            self.coinSprite:setImage(self.coinAnimation:image())
            if (not self.coinAnimation:isValid()) then
                self.finished = true
                self.coinSprite:remove()
            end
        end
        self.coinSprite:moveTo(120, 120)
        self.coinSprite:add()
    end
end

function CoinFlip:isFinished()
    return self.finished
end

function CoinFlip:getResult()
    self:remove()
    return self.result
end