using UnityEngine;
using System.Collections;
using UnityEditor;

[CustomEditor(typeof(XrayControler))]
public class XrayControlerEditor : Editor {

    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();

        XrayControler myScript = (XrayControler)target;
        if (GUILayout.Button("XrayPreview"))
        {
            myScript.XrayPreview();
        }
        if (GUILayout.Button("Reset Xray preview"))
        {
            myScript.ResetPreview();
        }
    }
}
