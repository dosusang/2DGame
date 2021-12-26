using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class ResourceSerialized : DictionarySerialized<string, string> { }

public class ResourceDictionary : ScriptableObject
{
    public ResourceSerialized ResMap;

    static ResourceDictionary _instance;

    static AssetBundle _ResourcBundle = null;

    public static ResourceDictionary Instance
    {
        get
        {
#if UNITY_EDITOR
            if (_instance == null)
            {
                string path = "Assets/Product/ResCfg.asset";
                _instance = UnityEditor.AssetDatabase.LoadAssetAtPath<ResourceDictionary>(path);
                if (_instance == null)
                {
                    _instance = ResourceDictionary.CreateInstance<ResourceDictionary>();
                    UnityEditor.AssetDatabase.CreateAsset(_instance, path);
                    _instance = UnityEditor.AssetDatabase.LoadAssetAtPath<ResourceDictionary>(path);
                }
            }
#endif
            return _instance;
        }
    }

    public static void SetInstance(ResourceDictionary instance)
    {
        ResourceDictionary._instance = instance;
    }

    //public static void LoadAssetBundelResMap()
    //{
    //    UnLoadAssetBundelResMap();

    //    string path = "Assets/Product/Common/ResourceConfig.asset";
    //    _ResourcBundle = ResLoader.GetRunAssetBundle(path);
    //    if (_ResourcBundle)
    //    {
    //        _instance = _ResourcBundle.LoadAsset<ResourceDictionary>(path);
    //    }
    //}

    //public static void UnLoadAssetBundelResMap()
    //{
    //    if (_ResourcBundle != null)
    //    {
    //        _ResourcBundle.Unload(true);
    //        _ResourcBundle = null;
    //    }
    //}


    public void add(string key, string value)
    {
        string v;
        if (ResMap.TryGetValue(key, out v))
        {
            Debug.Log($"资源配置中已经存在, 将更新: {key} {v} {value}");
            ResMap[key] = value;
        }
        else
        {
            ResMap.Add(key, value);
        }

#if UNITY_EDITOR
        UnityEditor.EditorUtility.SetDirty(ResourceDictionary.Instance);
#endif
    }

    public string get(string key)
    {
        string v;
        if (ResMap.TryGetValue(key, out v))
        {
            return v;
        }

        return key;
    }

    public void delete(string key)
    {
        ResMap.Remove(key);
    }
}

