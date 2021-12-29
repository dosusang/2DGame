game_main = {}

local game = require("game_mode")

function game_main.update(dt)
    game.update()
end

function game_main.fixed_update()
    game.fixed_update()
end

function game_main.on_collide(a, b)
    game.on_collide(a, b)
end

function main()
    Global = {}
    TIME = CS.UnityEngine.Time
    Path = CS.PathFinder
    ResLoader = CS.ResLoader

    Input = CS.UnityEngine.Input
    UnityGameObject = CS.UnityEngine.GameObject
    UnityRb2D = CS.UnityEngine.Rigidbody2D
    UnityCollider2D = CS.UnityEngine.Collider2D
    UnityDirObj = CS.BasicDirObj
    Unity4DirObj = CS.Basic4Dir
    KeyCode = CS.UnityEngine.KeyCode
    Quaternion = CS.UnityEngine.Quaternion

    Util = require("util")
    Log = require("log")

    SceneMgr = require("scene_mgr"):new()
    game.start()
end

main()


