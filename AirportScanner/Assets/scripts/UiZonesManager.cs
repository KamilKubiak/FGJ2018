using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UiZonesManager : MonoBehaviour {

    public List<Image> allIcons;

    public Image SetUpSprite(Contraband cargo)
    {
        int index = (int)cargo;
        return allIcons[index];
    }

    // Use this for initialization
    void Start () {
		
	}
    public void setUpZoneSprite(Contraband cargo, Destination place, int spirteIndex)
    {


    }
	
	// Update is called once per frame
	void Update () {
		
	}
}
