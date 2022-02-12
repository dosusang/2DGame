using System;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(ResourceDictionary))]
public class ResourceDictEditor : Editor
{
    private ResourceDictionary mTar;
    private void OnEnable()
    {
        mTar = ResourceDictionary.Instance;
    }

    public override void OnInspectorGUI()
    {
        if (GUILayout.Button("刷新"))
        {
            mTar.ClearEpt();
        }
        base.OnInspectorGUI();
    }
}
