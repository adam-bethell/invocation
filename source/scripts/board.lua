import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
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
    self.boardState = {
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0}
    }

    self.boardPositions = {
        {{46,27},{77,26},{106,25},{137,26},{165,27},{194,26}},
        {{43,55},{76,56},{106,55},{137,56},{166,57},{196,56}},
        {{40,88},{72,87},{104,86},{137,87},{168,86},{200,87}},
        {{35,125},{68,124},{102,123},{137,124},{169,123},{203,124}},
        {{29,166},{65,165},{102,164},{140,165},{177,164},{213,165}},
        {{23,209},{63,208},{102,209},{140,208},{179,207},{218,206}}
    }

    self.bgImage = gfx.image.new(240,240,gfx.kColorBlack)
    self:setImage(self.bgImage)
    self:moveTo(120,120)
    self:add()

    local boardImage = gfx.image.new("images/board")
    assert(boardImage)
    self.boardSprite = gfx.sprite.new(boardImage)
    self.boardSprite:moveTo(120, 120)
    self.boardSprite:add()

    local boardBorderImage = gfx.image.new("images/pipe")
    assert(boardBorderImage)
    self.boardBorder = gfx.sprite.new(boardBorderImage)
    self.boardBorder:moveTo(245, 120)
    self.boardBorder:add()
end

function Board:update()
end

function Board:setStone(x, y, value)
    self.boardState[y][x] = value
end