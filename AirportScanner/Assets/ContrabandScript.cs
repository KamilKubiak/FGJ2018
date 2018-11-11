using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ContrabandScript : MonoBehaviour {

    public float scale=1;

    private void Start()
    {
        transform.localScale = Vector3.one * scale;
    }
}
