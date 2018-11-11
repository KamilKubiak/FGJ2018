using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Zone : MonoBehaviour
{

    public bool Horizontal;
    public Destination DestRep;

    public void SetupIcons()
    {
        List<Sprite> newIcons = new List<Sprite>();
        float size = 80;

        List<Contraband> temp = new List<Contraband>();

        switch (DestRep)
        {
            case Destination.Exinia:
                temp = LegalManager.Instance.ToExinia;
                break;
            case Destination.Ygrandia:
                temp = LegalManager.Instance.ToYgradnia;
                break;
            case Destination.Zeliland:
                temp = LegalManager.Instance.ToZeliland;
                break;
            case Destination.Wouffia:
                temp = LegalManager.Instance.ToWouffia;
                break;
            case Destination.Trash:
                temp = LegalManager.Instance.IllegalContraband;
                break;
        }

        foreach (Contraband c in temp) newIcons.Add(UiZonesManager.Instance.SetUpSprite(c));

        if (newIcons != null)
        {

            Image[] actualIcons = this.GetComponentsInChildren<Image>();

            foreach (Image icon in actualIcons)
            {
                if (icon.gameObject != this.gameObject)
                    Destroy(icon.gameObject);
            }

            Vector2 zonePositionInScreen = this.GetComponent<Image>().rectTransform.position;
            Debug.Log(zonePositionInScreen);

            int row = 0;

            for (int t = 0; t < newIcons.Count; t++)
            {
                GameObject NewObj = new GameObject(newIcons[t].name); //Create the GameObject
                Image NewImage = NewObj.AddComponent<Image>(); //Add the Image Component script
                NewImage.sprite = newIcons[t]; //Set the Sprite of the Image Component on the new GameObject
                RectTransform RectT = NewObj.GetComponent<RectTransform>();
                //RectT.anchoredPosition = new Vector2(size * 0.5f, size * 0.5f);

                //float OffsetX = (float)((t % 2) * 2 - 1) * size * 0.5f;
                int tMod = (t % 4);
                float OffsetX = 0;
                float OffsetY = 0;
                if (Horizontal) OffsetX = (float)(tMod) * size - (float)(newIcons.Count) * size * 0.5f + size * 0.5f;
                else OffsetY = (float)(tMod) * size - (float)(newIcons.Count) * size * 0.5f + size * 0.5f;

                Vector2 offset = new Vector2(OffsetX, OffsetY);
                RectT.anchoredPosition = zonePositionInScreen + offset;
                //RectT.anchoredPosition =new Vector2( size * 0.5f, size * 0.5f);
                RectT.sizeDelta = new Vector2(size, size);
                RectT.SetParent(this.transform); //Assign the newly created Image GameObject as a Child of the Parent Panel.
                NewObj.SetActive(true); //Activate the GameObject

                if (t % 2 == 0)
                {

                    row += 1;
                    row %= 2;
                }

            }
        }


    }
}