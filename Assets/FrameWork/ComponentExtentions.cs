using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class ComponentExtentions
{
    public static void AddForce2dA(this Rigidbody2D rb, float x, float y)
    {
        rb.AddForce(new Vector2(x, y));
    }
}
