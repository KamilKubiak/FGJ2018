using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UiZonesManager : Singleton<UiZonesManager>
{

    public List<Sprite> allIcons;
    public Zone[] Zones;
    public Text Score;
    int oldScore = 0;
    int newScore = 0;
    public Text Life;
    int oldLife = 100;
    int newLife = 100;
    public Text NextWave;

    public Sprite SetUpSprite(Contraband cargo)
    {
        int index = (int)cargo;
        return allIcons[index];
    }

    public void RefreshZones()
    {
        foreach (Zone z in Zones) z.SetupIcons();
    }

    private void Update()
    {
        if (oldScore != newScore)
        {
            oldScore += (oldScore < newScore) ? 1 : -1;            
        }
        if (oldLife != newLife)
        {
            oldLife += (oldLife < newLife) ? 1 : -1;            
        }
        Score.text = "Score: " + oldScore;
        Life.text = "Life: " + oldLife + "%";
    }

    public void RefreshText()
    {
        NextWave.text = "Next Wave in: " + ScoreController.Instance.CasesLeft;
        oldScore = newScore; newScore = ScoreController.Instance.Score;
        oldLife = newLife; newLife = ScoreController.Instance.Life;
    }
}
