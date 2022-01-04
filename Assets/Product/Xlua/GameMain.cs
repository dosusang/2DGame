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
    
    [CSharpCallLua]
    public delegate void CollideFunc(int a, int b);
    
    LuaFuncFloat _update;
    LuaFuncVoid _fixedUpdate;
    private CollideFunc _on_collide;

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
        _on_collide = main.Get<CollideFunc>("on_collide");
            
        GameMgr.Instance.GameMain = this;
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

    public void OnCollide(int a, int b)
    {
        _on_collide(a, b);
    }

    void test()
    {
        // GameObject.
        // transform.Find()
        // transform.GetChild()
    }
}
