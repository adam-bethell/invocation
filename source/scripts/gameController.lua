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
    self.optionsReturnValue = 0

    self.board = Board()
    self.deck = Deck()
    self.combat = Combat()
    self.options = nil
    self.coinFlip = nil

    self:add()
end

function GameController:update()
    if (self.state == "start") then
        self.options = Options("coin")
        self.state = "call_waiting"
    elseif (self.state == "call_waiting") then
        if (self.options:isFinished()) then
            local result = self.options:getResult()
            self.coinFlip = CoinFlip(result - 1)
            self.state = "coin_waiting"
        end
    elseif (self.state == "coin_waiting") then
        if (self.coinFlip:isFinished()) then
            local result = self.coinFlip:getResult()
            if (result) then
                self.options = Options("whiteStart")
                self.currentPlayer = 1
            else
                self.options = Options("blackStart")
                self.currentPlayer = 2
            end
            self.state = "ready_waiting"
        end
    elseif (self.state == "ready_waiting") then
        if (self.options:isFinished()) then
            self.options:getResult()
            self.state = "player_turn"
        end
    elseif (self.state == "player_turn") then
        self.options = Options("actionChoice")
        self.state = "action_choice_waiting"
    elseif (self.state == "action_choice_waiting") then
        if (self.options:isFinished()) then
            local result = self.options:getResult()
            if (result == 2) then
                self.state = "action_stone"
            else
                self.state = "action_shield"
            end
        end
    elseif (self.state == "action_stone") then
        self.board:setPlayer(self.currentPlayer)
        self.board:giveFocus()
        self.state = "action_stone_waiting"
    elseif (self.state == "action_stone_waiting") then
        if (not self.board:hasFocus()) then
            self.state = "action_card_waiting"
        end
    elseif (self.state == "action_shield") then
        self.deck:setPlayer(self.currentPlayer)
        self.deck:giveFocus()
        self.state = "action_shield_waiting"
    elseif (self.state == "action_shield_waiting") then
        if (not self.deck:hasFocus()) then
            self.state = "action_card_waiting"
        end
    elseif (self.state == "action_card_waiting") then
    end
end