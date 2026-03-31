import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"
import "CoreLibs/timer"

import "scripts/gameController"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Options").extends(gfx.sprite)

local border = gfx.image.new("images/border")

local sun = gfx.image.new("images/text/sun")
local moon = gfx.image.new("images/text/moon")

local mirror = gfx.image.new("images/text/mirror")
local rotate = gfx.image.new("images/text/rotate")
local phantom = gfx.image.new("images/text/phantom")
local steal = gfx.image.new("images/text/steal")

local white = gfx.image.new("images/text/white")
local black = gfx.image.new("images/text/black")

local ready = gfx.image.new("images/text/ready")

local stone = gfx.image.new("images/text/stone")
local shield = gfx.image.new("images/text/shield")

local attack = gfx.image.new("images/text/attack")
local yes = gfx.image.new("images/text/yes")
local no = gfx.image.new("images/text/no")

local rock = gfx.image.new("images/text/rock")
local paper = gfx.image.new("images/text/paper")
local scissors = gfx.image.new("images/text/scissors")
local rps = {rock, paper, scissors}

local selector = gfx.imagetable.new("images/selector_horizontal-table-73-60")

function Options:init(type, data)
    Options.super.init(self)

    self.finished = false
    self.type = type
    self.data = data

    self.yPositions = {10, 55, 100, 145}
    self.selectorOffset = 45

    self.image = gfx.image.new(200,200,gfx.kColorWhite)
    gfx.pushContext(self.image)
        border:draw(0, 0)
        if (type == "coin") then
            sun:draw(30, self.yPositions[2])
            moon:draw(30, self.yPositions[3])
        elseif (type == "powers") then
            steal:draw(30, self.yPositions[1])
            phantom:draw(30, self.yPositions[2])
            rotate:draw(30, self.yPositions[3])
            mirror:draw(30, self.yPositions[4])
        elseif (type == "whiteStart") then
            white:draw(30, self.yPositions[2])
            ready:draw(30, self.yPositions[3])
        elseif (type == "blackStart") then
            black:draw(30, self.yPositions[2])
            ready:draw(30, self.yPositions[3])
        elseif (type == "actionChoice") then
            stone:draw(30, self.yPositions[2])
            shield:draw(30, self.yPositions[3])
        elseif (type == "attack") then
            attack:draw(30, self.yPositions[1])
            yes:draw(30, self.yPositions[2])
            no:draw(30, self.yPositions[3])
        elseif (type == "attackChoice") then
            for i = 1, #data do
                rps[data[i]]:draw(30, self.yPositions[i])
            end
        end
    gfx.popContext()
    self:setImage(self.image)
    self:moveTo(200,120)
    self:add()

    self.selectorIndex = 1
    if (type == "whiteStart" or type == "blackStart") then
        self.selectorIndex = 3
    elseif (type ~= "powers" and type ~= "attackChoice") then
        self.selectorIndex = 2
    end

    self.selectorAnim = gfx.animation.loop.new(30, selector, true)
    self.selectorSprite = gfx.sprite.new(self.selectorAnim:image())
    self.selectorSprite.update = function()
        self.selectorSprite:setImage(self.selectorAnim:image())
    end
    self.selectorSprite:moveTo(90, self.yPositions[self.selectorIndex] + self.selectorOffset)
    self.selectorSprite:add()
end

function Options:update()
    local indexChange = 0
    if (pd.buttonJustPressed(pd.kButtonUp)) then
        indexChange = -1
    elseif (pd.buttonJustPressed(pd.kButtonDown)) then
        indexChange = 1
    end

    if (indexChange ~= 0) then
        local min, max
        if (self.type == "whiteStart" or self.type == "blackStart") then
            min = 3
            max = 3
        elseif (self.type == "attackChoice") then
            min = 1
            max = #self.data
        elseif (self.type ~= "powers") then
            min = 2
            max = 3
        else
            min = 1
            max = 4
        end
        
        self.selectorIndex = math.min(max, math.max(self.selectorIndex + indexChange, min))
        self.selectorSprite:moveTo(90, self.yPositions[self.selectorIndex] + self.selectorOffset)
    end

    if (pd.buttonJustPressed(pd.kButtonA)) then
        self.selectorX = 0
        self.selectorSprite.update = function()
            self.selectorSprite:setImage(self.selectorAnim:image())
            self.selectorX += 20
            self.selectorSprite:moveTo(90 + self.selectorX, self.yPositions[self.selectorIndex] + self.selectorOffset)
            if (self.selectorX >= 200) then
                self.finished = true
                self.selectorSprite:remove()
            end
        end
    end
end

function Options:isFinished()
    return self.finished
end

function Options:getResult()
    self:remove()

    if (self.type == "attackChoice") then
        return self.data[self.selectorIndex]
    end

    return self.selectorIndex
end