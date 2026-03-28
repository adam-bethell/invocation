import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "scripts/gameController"

local pd <const> = playdate
local gfx <const> = pd.graphics

GameController()

math.randomseed(pd.getSecondsSinceEpoch())
function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
end