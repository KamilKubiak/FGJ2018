using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ContrabandTrash : MonoBehaviour
{


    public delegate void TrashActions();
    public static event TrashActions OnTrashClicked;

    private void OnMouseDown()
    {
        Debug.Log("trashclicked");
        if (OnTrashClicked != null)
        {
            OnTrashClicked();
        }
    }

}
