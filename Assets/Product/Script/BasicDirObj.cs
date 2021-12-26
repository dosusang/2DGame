using Unity.Mathematics;
using UnityEngine;

public class BasicDirObj : MonoBehaviour
{
    public Sprite[] Sprites;
    
    [Range(0,360)]
    public float MoveDir = 0;

    public int idx = 0;
    
    private SpriteRenderer mSpriterenderer;
    private void Start()
    {
        mSpriterenderer =  GetComponent<SpriteRenderer>();
    }

    void Update()
    {
        idx = (int)((MoveDir + 22.5f) / 45% Sprites.Length);
        mSpriterenderer.sprite = Sprites[idx >= Sprites.Length ? 0 : idx % Sprites.Length];
    }
}
