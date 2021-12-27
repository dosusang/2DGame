using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameMgr
{
    private static GameMgr mInstance;

    public static GameMgr Instance {
        get{
            if (mInstance == null)
            {
                mInstance = new GameMgr();
            }

            return mInstance;
        }
    }

    public GameMain GameMain;
}
