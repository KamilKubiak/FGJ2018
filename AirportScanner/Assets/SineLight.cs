using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SineLight : MonoBehaviour {

    Light thisLight;
    float thisIntesity;
    public float speed = 3.0f;

    private void Start()
    {
        thisLight = this.GetComponent<Light>();
        thisIntesity = thisLight.intensity;
    }
    // Update is called once per frame
    void Update () {
        thisLight.intensity = (Mathf.Sin(Time.time * speed) *0.5f+0.5f)* thisIntesity;

    }
}
