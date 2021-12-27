using System.Collections;
using System.Collections.Generic;
using System.Net.Security;
using UnityEngine;

public class Basic4Dir : MonoBehaviour
{
    public Sprite[] Sprites;
    
    [Range(0,360)]
    public float MoveDir = 0;

    public float Dir;

    public int idx = 0;
    public float Speed = 2f;
    
    private SpriteRenderer mSpriterenderer;
    private Vector3 pos;
    private void Start()
    {
        mSpriterenderer =  GetComponent<SpriteRenderer>();
    }

    void Update()
    {
        if (pos == transform.position) return;
        pos = transform.position;
        MoveDir = (MoveDir + 360) % 360;
        
        idx = (int)((Dir + 180 + 22.5) / 90 % 4);
        mSpriterenderer.sprite = Sprites[idx * 2 + (int) (Time.time * Speed) % 2];
    }
}
