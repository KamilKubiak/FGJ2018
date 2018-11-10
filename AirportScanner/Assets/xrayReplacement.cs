using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[ExecuteInEditMode]
public class xrayReplacement : MonoBehaviour {
    
    public Shader replacementShader;
	// Use this for initialization
	void OnEnable () {
        this.GetComponent<Camera>().ResetReplacementShader();
        if (replacementShader!=null)
            this.GetComponent<Camera>().SetReplacementShader(replacementShader, "Xray");
	}
	
}
