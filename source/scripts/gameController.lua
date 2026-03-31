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
        if (not self.board:getFocus()) then
            self.state = "action_card_waiting"
        end
    elseif (self.state == "action_shield") then
        self.deck:setPlayer(self.currentPlayer)
        self.deck:giveFocus()
        self.state = "action_shield_waiting"
    elseif (self.state == "action_shield_waiting") then
        if (not self.deck:getFocus()) then
            self.state = "action_card_waiting"
        end
    elseif (self.state == "action_card_waiting") then
        if (self.board:countStones(self.currentPlayer) < 3) then
            self.state = "next_turn"
        else
            self.matches = self:getMatches(self.currentPlayer)
            if (self.matches == nil) then
                self.state = "next_turn"
            else
                self.options = Options("attack")
                self.state = "attack_yn_waiting"
            end
        end
    elseif (self.state == "attack_yn_waiting") then
        if (self.options:isFinished()) then
            local result = self.options:getResult()
            if (result == 3) then
                self.state = "next_turn"
            else
                self.options = Options("attackChoice", self.matches)
                self.state = "attack_waiting"
            end
        end
    elseif (self.state == "attack_waiting") then
        if (self.options:isFinished()) then
            local result = self.options:getResult()
            self:processAttack(result, self.currentPlayer)
            self.deck:cardUsed(result)
            self.state = "DEBUG_NOTHING"
        end
    elseif (self.state == "next_turn") then
        self.currentPlayer = (self.currentPlayer == 1) and 2 or 1
        if (self.currentPlayer == 1) then
            self.options = Options("whiteStart")
        else
            self.options = Options("blackStart")
        end
        self.state = "ready_waiting"
    elseif (self.state == "DEBUG_NOTHING") then
        -- do nothing
    end
end

function GameController:getMatches(player)
    local cards = { 
        self.deck.card1,
        self.deck.card2,
        self.deck.card3
    }

    local foundCards = {}

    local boardState = self.board.boardState
    local stones = {}
    for y = 1, #boardState do
        for x = 1, #boardState[y] do
            if (boardState[y][x] == player) then
                -- For each stone belonging to player, check each stone in each card to check for a match
                for i = 1, #cards do
                    local card = cards[i]
                    for j = 1, #card do
                        if (table.indexOfElement(foundCards, i) ~= nil) then
                            -- card already found
                            break
                        end
                        local cy = card[j][1]
                        local cx = card[j][2]
                        local dy = y - cy
                        local dx = x - cx

                        local translated_card = {
                            {card[1][1] + dy, card[1][2] + dx},
                            {card[2][1] + dy, card[2][2] + dx},
                            {card[3][1] + dy, card[3][2] + dx}
                        }
                        
                        local found = true
                        for t = 1, #translated_card do
                            local ty = translated_card[t][1]
                            local tx = translated_card[t][2]
                            if (ty < 1 or tx < 1 or ty > 6 or tx > 6) then
                                -- Stone position is out of bounds
                                found = false
                                break
                            end

                            if (boardState[ty][tx] ~= player) then
                                found = false
                                break
                            end
                        end
                        if (found) then
                            table.insert(foundCards, i)
                            break
                        end
                    end
                end
            end
        end
    end

    return foundCards
end

function GameController:processAttack(attack, attacker)
    local defender = (attacker == 1) and 2 or 1
    local defense = self.deck:getShield(defender)
    if (attack == defense) then
        -- stagger
    elseif ((attack == 1 and defense == 3) or (attack == 2 and defense == 1) or (attack == 3 and defense == 2)) then
        -- damage
        self.combat:attack(defender)
    else
        -- nothing
    end
end