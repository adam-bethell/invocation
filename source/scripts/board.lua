import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Board").extends(gfx.sprite)

local whiteStoneImage0 = gfx.image.new("images/white_stone_y0")
assert(whiteStoneImage0)
local whiteStoneImage2 = gfx.image.new("images/white_stone_y2")
assert(whiteStoneImage2)
local whiteStoneImage4 = gfx.image.new("images/white_stone_y4")
assert(whiteStoneImage4)

local blackStoneImage0 = gfx.image.new("images/black_stone_y0")
assert(blackStoneImage0)
local blackStoneImage2 = gfx.image.new("images/black_stone_y2")
assert(blackStoneImage2)
local blackStoneImage4 = gfx.image.new("images/black_stone_y4")
assert(blackStoneImage4)

function Board:init()
    Board.super.init(self)

    self.hasFocus = false
    self.player = 1

    self.boardState = {
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0}
    }
    self.boardStones = {
        {nil,nil,nil,nil,nil,nil},
        {nil,nil,nil,nil,nil,nil},
        {nil,nil,nil,nil,nil,nil},
        {nil,nil,nil,nil,nil,nil},
        {nil,nil,nil,nil,nil,nil},
        {nil,nil,nil,nil,nil,nil}
    }
    self.boardPositions = {
        {{46,27},{77,26},{106,25},{137,26},{165,27},{194,26}},
        {{43,55},{76,56},{106,55},{137,56},{166,57},{196,56}},
        {{40,88},{72,87},{104,86},{137,87},{168,86},{200,87}},
        {{35,125},{68,124},{102,123},{137,124},{169,123},{203,124}},
        {{29,166},{65,165},{102,164},{140,165},{177,164},{213,165}},
        {{23,209},{63,208},{102,209},{140,208},{179,207},{218,206}}
    }
    self.boardStoneImages = {
        {whiteStoneImage0, whiteStoneImage0, whiteStoneImage2, whiteStoneImage2, whiteStoneImage4, whiteStoneImage4},
        {blackStoneImage0, blackStoneImage0, blackStoneImage2, blackStoneImage2, blackStoneImage4, blackStoneImage4}
    }

    self.bgImage = gfx.image.new(240,240,gfx.kColorBlack)
    self:setImage(self.bgImage)
    self:moveTo(120,120)
    self:add()

    self.boardImage = gfx.image.new("images/board")
    assert(self.boardImage)
    self.boardSprite = gfx.sprite.new(self.boardImage)
    self.boardSprite:moveTo(120, 120)
    self.boardSprite:add()

    local boardBorderImage = gfx.image.new("images/pipe")
    assert(boardBorderImage)
    self.boardBorder = gfx.sprite.new(boardBorderImage)
    self.boardBorder:moveTo(245, 120)
    self.boardBorder:add()

    local selectorImagetable = gfx.imagetable.new("images/selector-table-40-51")
    assert(selectorImagetable)
    self.selectorAnimation = gfx.animation.loop.new(33, selectorImagetable, true)
    self.selectorSprite = gfx.sprite.new(self.selectorAnimation:image())
    self.selectorSprite.update = function()
        self.selectorSprite:setImage(self.selectorAnimation:image())
    end
    self.selectorOffsetY = -30
    self.selectorPosition = {3, 2}
    local position = self.boardPositions[self.selectorPosition[2]][self.selectorPosition[1]]
    self.selectorSprite:setZIndex(10)
    self.selectorSprite:moveTo(position[1], position[2] + self.selectorOffsetY)
    self.selectorSprite:setVisible(false)
    self.selectorSprite:add()

    self.introAnimator = gfx.sprite.new()
    self.introFrameCounter = 0
    self.introAnimator.update = function()
        self.introFrameCounter += 1
        self.boardImage:vcrPauseFilterImage()
        if (self.introFrameCounter % 2 == 0) then
            self.boardSprite:setImage(self.boardImage:vcrPauseFilterImage())
        elseif (self.introFrameCounter >= 15) then
            self.introAnimator:remove()
            self.boardSprite:setImage(self.boardImage)
        end
    end
    self.introAnimator:add()
end

function Board:update()
    if self.hasFocus then
        self:updateSelectorPosition()
        self:updateSelectorAction()
    end
end

function Board:updateSelectorPosition()
    local x, y = 0, 0
    if pd.buttonJustPressed(pd.kButtonUp) then
        y = -1
    elseif pd.buttonJustPressed(pd.kButtonDown) then
        y = 1
    elseif pd.buttonJustPressed(pd.kButtonLeft) then
        x = -1
    elseif pd.buttonJustPressed(pd.kButtonRight) then
        x = 1
    end

    if x ~= 0 or y ~= 0 then 
        x += self.selectorPosition[1]
        if x >= 2 and x <= 5 then
            self.selectorPosition[1] = x
        end

        y += self.selectorPosition[2]
        if y >= 2 and y <= 5 then
            self.selectorPosition[2] = y
        end

        local position = self.boardPositions[self.selectorPosition[2]][self.selectorPosition[1]]
        self.selectorSprite:moveTo(position[1], position[2] + self.selectorOffsetY)
    end
end

function Board:updateSelectorAction()
    if pd.buttonJustPressed(pd.kButtonA) then
        local state = self.boardState[self.selectorPosition[2]][self.selectorPosition[1]]
        if (self:countStones(self.player) < 4 and state == 0) then
            self:setStone(self.selectorPosition[1], self.selectorPosition[2], self.player)
            self:setFocus(false)
        elseif (self:countStones(self.player) >= 4 and state == self.player) then
            self:setStone(self.selectorPosition[1], self.selectorPosition[2], 0)
        end
    end
end

function Board:setStone(x, y, value)
    local oldValue = self.boardState[y][x]
    if oldValue == value then return end
    
    self.boardState[y][x] = value
    if oldValue ~= 0 then
        local oldSprite = self.boardStones[y][x]
        assert(oldSprite)
        oldSprite:remove()
        self.boardStones[y][x] = nil
    end

    if value ~= 0 then
        print(value, y)
        local stoneSprite = gfx.sprite.new(self.boardStoneImages[value][y])
        stoneSprite:moveTo(self.boardPositions[y][x][1], self.boardPositions[y][x][2])
        stoneSprite:add()
        self.boardStones[y][x] = stoneSprite
    end
end

function Board:setPlayer(player)
    self.player = player
end

function Board:getFocus()
    return self.hasFocus
end

function Board:giveFocus()
    self:setFocus(true)
end

function Board:setFocus(value)
    self.hasFocus = value
    self.selectorSprite:setVisible(value)
end

function Board:countStones(player)
    local count = 0
    for y = 1, 6 do
        for x = 1, 6 do
            if (self.boardState[y][x] == player) then
                count += 1
            end
        end
    end
    return count
end