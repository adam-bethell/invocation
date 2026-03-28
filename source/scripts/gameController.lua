import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"
import "CoreLibs/timer"

import "scripts/deck"
import "scripts/combat"
import "scripts/board"
import "scripts/coinFlip"
import "scripts/options"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("GameController").extends(gfx.sprite)

function GameController:init()
    GameController.super.init(self)

    self.state = "start"
    self.currentPlayer = 1

    self.board = Board()
    self.deck = Deck()
    self.combat = Combat()

    self:add()
end

function GameController:update()
    if (self.state == "start") then
        self.state = "waiting"
        Options()
    end
end