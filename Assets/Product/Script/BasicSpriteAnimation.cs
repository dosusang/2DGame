
using System;
using UnityEngine;

[ExecuteAlways]
public class BasicSpriteAnimation : MonoBehaviour {

    public Sprite[] Sprites;
    public float Speed;
    public bool Loop = true;
    private SpriteRenderer mSpriterenderer;
    
    private float mCurTime = 0;

	void Start () {
		mSpriterenderer =  GetComponent<SpriteRenderer>();
	}

	void Update ()
	{
		mCurTime += Time.deltaTime;
        int index = (int)(mCurTime * Speed);
        if (Loop) index %= Sprites.Length;
        if (index >= Sprites.Length)
        {
	        mSpriterenderer.sprite = null;
	        return;
        }
        mSpriterenderer.sprite = Sprites[index];
	}

	private void OnEnable()
	{
		mCurTime = 0;
	}
}
