import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Deck").extends(gfx.sprite)

function Deck:init()
    self.card1 = self:generateCard()
    self.card2 = self:generateCard()
    self.card3 = self:generateCard()

    self.cardW = 15 * 3

    self.cardImage1 = gfx.image.new(self.cardW,self.cardW)
    self:drawCard(self.cardImage1, self.card1)
    self.cardSprite1 = gfx.sprite.new(self.cardImage1)
    self.cardSprite1:moveTo(240 + 14 + (self.cardW // 2), self.cardW + (self.cardW // 2))
    self.cardSprite1:add()

    self.cardImage2 = gfx.image.new(self.cardW,self.cardW)
    self:drawCard(self.cardImage2, self.card2)
    self.cardSprite2 = gfx.sprite.new(self.cardImage2)
    self.cardSprite2:moveTo(240 + 14 + (self.cardW // 2) + self.cardW + 5, self.cardW + (self.cardW // 2))
    self.cardSprite2:add()

    self.cardImage3 = gfx.image.new(self.cardW,self.cardW)
    self:drawCard(self.cardImage3, self.card3)
    self.cardSprite3 = gfx.sprite.new(self.cardImage3)
    self.cardSprite3:moveTo(240 + 14 + (self.cardW // 2) + (self.cardW * 2) + 10, self.cardW + (self.cardW // 2))
    self.cardSprite3:add()
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
    printTable(card)

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