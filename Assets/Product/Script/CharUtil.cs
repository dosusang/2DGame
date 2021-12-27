using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharUtil : MonoBehaviour
{
    private void OnTriggerEnter2D(Collider2D other)
    {
        GameMgr.Instance.GameMain.OnCollide(gameObject, other.gameObject);
    }
}
