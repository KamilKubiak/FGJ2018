using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Credits : MonoBehaviour {
    public RectTransform rectTransform;
    public Canvas canvas;
    public float animSpeed=5f;
    Vector2 hiddenPosition;
    bool creditsShown;

    private void Start()
    {
        hiddenPosition = new Vector2(0,-900);
        rectTransform.anchoredPosition = hiddenPosition;
        creditsShown = false;
        Debug.Log(hiddenPosition);
    }

    IEnumerator ShowCredits()
    {
        creditsShown = true;
        while (rectTransform.anchoredPosition != new Vector2(0,0))
        {
            Debug.Log("showing credits");
            rectTransform.anchoredPosition = Vector2.MoveTowards(rectTransform.anchoredPosition, Vector2.zero, animSpeed * Time.deltaTime);
            yield return null;
        }
    }

    IEnumerator HideCredits()
    {
        creditsShown = false;
        while (rectTransform.anchoredPosition != hiddenPosition)
        {
            rectTransform.anchoredPosition = Vector2.MoveTowards(rectTransform.anchoredPosition, hiddenPosition, animSpeed * Time.deltaTime);
            yield return null;
        }
    }

    public void ToggleCredits()
    {
        if (creditsShown)
        {
            StopCoroutine("ShowCredits");
            StartCoroutine("HideCredits");
        }
        else
        {
            StopCoroutine("HideCredits");
            StartCoroutine("ShowCredits");
        }
    }

}
