using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UiZonesManager : Singleton<UiZonesManager>
{

    public List<Sprite> allIcons;
    public Zone[] Zones;

    public Sprite SetUpSprite(Contraband cargo)
    {
        int index = (int)cargo;
        return allIcons[index];
    }

    public void RefreshZones()
    {
        foreach (Zone z in Zones) z.SetupIcons();
    }
}
