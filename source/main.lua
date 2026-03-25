import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "scripts/board"
import "scripts/deck"
import "scripts/combat"

local pd <const> = playdate
local gfx <const> = pd.graphics

Board()
Deck()
Combat()

math.randomseed(pd.getSecondsSinceEpoch())
function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
end