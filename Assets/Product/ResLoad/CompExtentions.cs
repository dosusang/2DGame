using UnityEngine;

public static class CompExtention
{
    public static void SetPosA(this GameObject obj, float x, float y, float z)
    {
        obj.transform.position = new Vector3(x, y, z);
    }

    public static void SetPosA(this Transform trans, float x, float y, float z)
    {
        trans.position = new Vector3(x, y, z);
    }
    
    public static void SetLocalPosA(this GameObject obj, float x, float y, float z)
    {
        obj.transform.localPosition = new Vector3(x, y, z);
    }

    public static void SetLocalPosA(this Transform trans, float x, float y, float z)
    {
        trans.localPosition = new Vector3(x, y, z);
    }

    public static void SetEulerZ(this Transform trans, float z)
    {
        var euler = trans.rotation.eulerAngles;
        euler.z = z;
        trans.rotation = Quaternion.Euler(euler);
    }
    
    public static void SetEulerX(this Transform trans, float x)
    {
        var euler = trans.rotation.eulerAngles;
        euler.x = x;
        trans.rotation = Quaternion.Euler(euler);
    }
    
    public static void SetEulerY(this Transform trans, float y)
    {
        var euler = trans.rotation.eulerAngles;
        euler.y = y;
        trans.rotation = Quaternion.Euler(euler);
    }

    public static void SetScale(this Transform trans, float scale)
    {
        trans.localScale = new Vector3(scale, scale, scale);
    }

    public static void GetPosA(this Transform trans, ref float x, ref float y, ref float z)
    {
        var pos = trans.position;
        x = pos.x;
        y = pos.y;
        z = pos.z;
    }
}
