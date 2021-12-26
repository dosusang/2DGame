using System;
using System.IO;
using System.Linq;
using UnityEngine;
using XLua;
[CSharpCallLua]

public class GameMain : MonoBehaviour
{
    private LuaEnv _luaEnv;
    
    LuaTable main;
    
    [CSharpCallLua]
    public delegate void LuaFuncFloat(float param);
    [CSharpCallLua]
    public delegate void LuaFuncVoid();
    
    LuaFuncFloat _update;
    LuaFuncVoid _fixedUpdate;

    // Start is called before the first frame update
    void Start()
    {
        LuaEnv _luaEnv = new LuaEnv();
        _luaEnv.AddLoader((ref string path) =>
        {
            var real_path = path.Replace(".", "\\");
            return File.ReadAllBytes("lua/" + real_path + ".lua");
        });
        _luaEnv.DoString("require 'main'");
        
        _luaEnv.Global.Get("game_main", out main);

        _update = main.Get<LuaFuncFloat>("update");
        _fixedUpdate = main.Get<LuaFuncVoid>("fixed_update");
    }

    // Update is called once per frame
    void Update()
    {   
        _update(Time.deltaTime);
    }

    private void FixedUpdate()
    {
        _fixedUpdate();
    }

    void test()
    {
        // GameObject.
    }
}
