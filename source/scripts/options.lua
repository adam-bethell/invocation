import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Options").extends(gfx.sprite)

function Options:init(data)
    Options.super.init(self)

    self.bgImage = gfx.image.new(100,100,gfx.kColorWhite)
    self:setImage(self.bgImage)
    self:moveTo(200,120)
    self:add()
end