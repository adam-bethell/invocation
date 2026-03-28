import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Deck").extends(gfx.sprite)

local rockImage = gfx.image.new("images/rock_icon")
assert(rockImage)
local paperImage = gfx.image.new("images/paper_icon")
assert(paperImage)
local scissorsImage = gfx.image.new("images/scissors_icon")
assert(scissorsImage)

local whiteShieldImage = gfx.image.new("images/white_shield")
assert(whiteShieldImage)
local blackShieldImage = gfx.image.new("images/black_shield")
assert(blackShieldImage)

function Deck:init()
    Deck.super.init(self)

    self.hasFocus = false
    self.cardW = 15 * 3

    self.x1 = 240 + 14 + (self.cardW // 2)
    self.x2 = 240 + 14 + (self.cardW // 2) + self.cardW + 5
    self.x3 = 240 + 14 + (self.cardW // 2) + (self.cardW * 2) + 10
    self.whiteShieldOffset = -10
    self.blackShieldOffset = 10
    self.y = self.cardW * 2 + 10

    self.rockSprite = gfx.sprite.new(rockImage)
    self.rockSprite:moveTo(self.x1, (self.cardW // 2))
    self.rockSprite:add()
    self.paperSprite = gfx.sprite.new(paperImage)
    self.paperSprite:moveTo(self.x2, (self.cardW // 2))
    self.paperSprite:add()
    self.scissorsSprite  = gfx.sprite.new(scissorsImage)
    self.scissorsSprite:moveTo(self.x3, (self.cardW // 2))
    self.scissorsSprite:add()

    self.whiteShieldSprite = gfx.sprite.new(whiteShieldImage)
    self.whiteShieldSprite:moveTo(self.x1 - 10, self.cardW * 2 + 10)
    self.whiteShieldSprite:setVisible(false)
    self.whiteShieldSprite:add()
    self.blackShieldSprite = gfx.sprite.new(blackShieldImage)
    self.blackShieldSprite:moveTo(self.x1 + 10, self.cardW * 2 + 10)
    self.blackShieldSprite:setVisible(false)
    self.blackShieldSprite:add()

    self.card1 = self:generateCard()
    self.card2 = self:generateCard()
    self.card3 = self:generateCard()

    self.cardImage1 = gfx.image.new(self.cardW,self.cardW)
    self:drawCard(self.cardImage1, self.card1)
    self.cardSprite1 = gfx.sprite.new(self.cardImage1)
    self.cardSprite1:moveTo(self.x1, self.cardW + (self.cardW // 2))
    self.cardSprite1:add()

    self.cardImage2 = gfx.image.new(self.cardW,self.cardW)
    self:drawCard(self.cardImage2, self.card2)
    self.cardSprite2 = gfx.sprite.new(self.cardImage2)
    self.cardSprite2:moveTo(self.x2, self.cardW + (self.cardW // 2))
    self.cardSprite2:add()

    self.cardImage3 = gfx.image.new(self.cardW,self.cardW)
    self:drawCard(self.cardImage3, self.card3)
    self.cardSprite3 = gfx.sprite.new(self.cardImage3)
    self.cardSprite3:moveTo(self.x3, self.cardW + (self.cardW // 2))
    self.cardSprite3:add()

    self.introAnimator = gfx.sprite.new()
    self.introAnimatorFrame = 0
    self.introAnimator.update = function()
        self.introAnimatorFrame += 1
        if (self.introAnimatorFrame == 1) then
            self.whiteShieldSprite:moveTo(self.x1 + self.whiteShieldOffset, self.y)
            self.whiteShieldSprite:setVisible(true)
            self.blackShieldSprite:setVisible(false)
        elseif (self.introAnimatorFrame == 4) then
            self.whiteShieldSprite:setVisible(false)
            self.blackShieldSprite:moveTo(self.x1 + self.blackShieldOffset, self.y)
            self.blackShieldSprite:setVisible(true)
        elseif (self.introAnimatorFrame == 7) then
            self.rockSprite:setVisible(false)
            self.paperSprite:setVisible(false)
            self.scissorsSprite:setVisible(false)

            self.card1 = self:generateCard()
            self.card2 = self:generateCard()
            self.card3 = self:generateCard()
            self:drawCard(self.cardImage1, self.card1)
            self:drawCard(self.cardImage2, self.card2)
            self:drawCard(self.cardImage3, self.card3)
            self.cardSprite1:markDirty()
            self.cardSprite2:markDirty()
            self.cardSprite3:markDirty()

            self.whiteShieldSprite:moveTo(self.x2 + self.whiteShieldOffset, self.y)
            self.whiteShieldSprite:setVisible(true)
            self.blackShieldSprite:setVisible(false)
        elseif (self.introAnimatorFrame == 10) then
            self.rockSprite:setVisible(true)
            self.paperSprite:setVisible(true)
            self.scissorsSprite:setVisible(true)

            self.whiteShieldSprite:setVisible(false)
            self.blackShieldSprite:moveTo(self.x2 + self.blackShieldOffset, self.y)
            self.blackShieldSprite:setVisible(true)
        elseif (self.introAnimatorFrame == 13) then
            self.card1 = self:generateCard()
            self.card2 = self:generateCard()
            self.card3 = self:generateCard()
            self:drawCard(self.cardImage1, self.card1)
            self:drawCard(self.cardImage2, self.card2)
            self:drawCard(self.cardImage3, self.card3)
            self.cardSprite1:markDirty()
            self.cardSprite2:markDirty()
            self.cardSprite3:markDirty()

            self.whiteShieldSprite:moveTo(self.x3 + self.whiteShieldOffset, self.y)
            self.whiteShieldSprite:setVisible(true)
            self.blackShieldSprite:setVisible(false)
        elseif (self.introAnimatorFrame == 16) then
            self.rockSprite:setVisible(false)
            self.paperSprite:setVisible(false)
            self.scissorsSprite:setVisible(false)
            
            self.whiteShieldSprite:setVisible(false)
            self.blackShieldSprite:moveTo(self.x3 + self.blackShieldOffset, self.y)
            self.blackShieldSprite:setVisible(true)
        elseif (self.introAnimatorFrame == 19) then
            self.rockSprite:setVisible(true)
            self.paperSprite:setVisible(true)
            self.scissorsSprite:setVisible(true)

            self.whiteShieldSprite:setVisible(false)
            self.blackShieldSprite:setVisible(false)
        elseif (self.introAnimatorFrame > 19) then
            self.introAnimator:remove()
        end
    end
    self.introAnimator:add()

    self:add()
end

function Deck:update()
    
end

function Deck:generateCard()
    local i1 = math.random(9)
    local i2 = i1
    local i3 = i1
    while (i2 == i1) do
        i2 = math.random(9)
    end
    while (i3 == i2 or i3 == i1) do
        i3 = math.random(9)
    end

    local y1 = math.ceil(i1/3)
    local x1 = i1 - ((y1 - 1) * 3)

    local y2 = math.ceil(i2/3)
    local x2 = i2 - ((y2 - 1) * 3)

    local y3 = math.ceil(i3/3)
    local x3 = i3 - ((y3 - 1) * 3)

    return {{y1, x1}, {y2, x2}, {y3, x3}}
end

function Deck:drawCard(cardImage, card)
    local width = self.cardW / 3

    cardImage:clear(gfx.kColorClear)
    gfx.pushContext(cardImage)
        for y = 0, 2 do
            for x = 0, 2 do
                local h = (y == 2) and width or width + 1
                local w = (x == 2) and width or width + 1
                gfx.drawRect(x * width, y * width, w, h)

                if (y + 1 == card[1][1] and x + 1 == card[1][2]) or
                    (y + 1 == card[2][1] and x + 1 == card[2][2]) or
                    (y + 1 == card[3][1] and x + 1 == card[3][2]) then
                    gfx.fillCircleInRect(x * width, y * width, w, h)
                end

            end
        end
    gfx.popContext()
end