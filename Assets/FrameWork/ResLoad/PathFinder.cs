using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PathFinder : MonoBehaviour
{
    public static string GetPath(ref string name)
    {
        return ResourceDictionary.Instance.get(name);
    }
}
