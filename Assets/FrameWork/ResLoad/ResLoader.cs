using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

#if UNITY_EDITOR
using UnityEditor;
#endif

public static class ResLoader
{
    public static UnityEngine.Object LoadRes(string path, Type type)
    {
#if UNITY_EDITOR
        // path = "assets/" + path;
        var obj = AssetDatabase.LoadAssetAtPath(path, type);
        return obj;
#else
        return null;
#endif
    }
}
