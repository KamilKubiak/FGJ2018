using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Zone : MonoBehaviour {

    
    public List<Sprite> TestNewSprites;
   

    //public void SetupIcons(List<Image> newIcons)
    //{
    //    if (newIcons != null)
    //    {
    //        Image[] actualIcons = this.GetComponentsInChildren<Image>();

    //        foreach (Image icon in actualIcons)
    //        {
    //            Destroy(icon.gameObject);
    //        }
    //        for (int t = 0; t < newIcons.Count; t++)
    //        {
    //           // actualIcons.
    //        }
    //    }
        
    //}

    public void SetupIcons(List<Sprite> newIcons, float size)
    {
        if (newIcons != null)
        {

            Image[] actualIcons = this.GetComponentsInChildren<Image>();

            foreach (Image icon in actualIcons)
            {
            if(icon.gameObject!=this.gameObject)
                Destroy(icon.gameObject);
            }

            Vector2 zonePositionInScreen = this.GetComponent<Image>().rectTransform.position;
            Debug.Log(zonePositionInScreen);

            int row = 0;
            int column = 0;

            for (int t = 0; t < newIcons.Count; t++)
            {
                GameObject NewObj = new GameObject(newIcons[t].name); //Create the GameObject
                Image NewImage = NewObj.AddComponent<Image>(); //Add the Image Component script
                NewImage.sprite = newIcons[t]; //Set the Sprite of the Image Component on the new GameObject
                RectTransform RectT = NewObj.GetComponent<RectTransform>();
                //RectT.anchoredPosition = new Vector2(size * 0.5f, size * 0.5f);

                //float OffsetX = (float)((t % 2) * 2 - 1) * size * 0.5f;
                //float OffsetY = (float)((row % 2) * 2 - 1) * size * 0.5f;

                //float OffsetX = (float)((t % 2) * 2 - 1) * size * 0.5f;
                int tMod = (t % 4);
                float OffsetY = (float)(tMod) * size - (float)(newIcons.Count) * size * 0.5f + size * 0.5f;

                Vector2 offset = new Vector2(0.0f, OffsetY);
                RectT.anchoredPosition = zonePositionInScreen + offset;
                //RectT.anchoredPosition =new Vector2( size * 0.5f, size * 0.5f);
                RectT.sizeDelta = new Vector2(size, size);
                RectT.SetParent(this.transform); //Assign the newly created Image GameObject as a Child of the Parent Panel.
                NewObj.SetActive(true); //Activate the GameObject

                if (t % 2 == 0) {
               
                    row += 1;
                    row %= 2;
                }

            }
        }


    }

    private void Start()
    {
    SetupIcons(TestNewSprites, 40.0f);
    }
}