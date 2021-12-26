using Unity.Mathematics;
using UnityEngine;
using UnityEngine.SocialPlatforms;

public class BasicDirObj : MonoBehaviour
{
    public Sprite[] Sprites;
    
    [Range(0,360)]
    public float MoveDir = 0;

    public float Dir;

    public int idx = 0;
    
    private SpriteRenderer mSpriterenderer;
    private void Start()
    {
        mSpriterenderer =  GetComponent<SpriteRenderer>();
    }

    void Update()
    {
        MoveDir = (MoveDir + 360) % 360;
        
        idx = (int)((Dir + 180 + 22.5) / 45 % Sprites.Length);
        mSpriterenderer.sprite = Sprites[idx >= Sprites.Length ? 0 : idx % Sprites.Length];
    }
}
