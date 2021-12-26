
Path = CS.PathFinder
ResLoader = CS.ResLoader


UnityGameObject = CS.UnityEngine.GameObject
UnityRb2D = CS.UnityEngine.Rigidbody2D
UnityDirObj = CS.BasicDirObj

Util = require("util")
Log = require("log")

game_main = {}

local game = require("game_mode")

game.start()

function game_main.update(dt)
    game.update()
end

function game_main.fixed_update()
    game.fixed_update()
end


