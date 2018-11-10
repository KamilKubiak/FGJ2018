using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEngine.UI;

[ExecuteInEditMode]
public class XrayControler : MonoBehaviour {

    public Camera xrayCamera;
    public Shader replacementShader;
    public RenderTexture xrayTarget;
    public Texture2D zoomTarget;
    public Material PostProcessMat;
    public Vector2 ImageSize;
    Vector2 normlizedSize;
    private RenderTexture xrayTar;

    public void XrayPreview()
    {
        if (replacementShader != null)
            this.GetComponent<Camera>().SetReplacementShader(replacementShader, "Xray");
    }

    public void ResetPreview()
    {
        this.GetComponent<Camera>().ResetReplacementShader();
    }
    // Use this for initialization
    void OnEnable () {
        xrayTar = new RenderTexture(Screen.width, Screen.height, 24);

        xrayCamera.targetTexture = xrayTar;

       
        if (replacementShader != null)
            xrayCamera.SetReplacementShader(replacementShader, "Xray");

        if (PostProcessMat != null)
        {
            PostProcessMat.SetTexture("_xrayRT", xrayTar);
        }

    }

    private void Start()
    {
        ImageSize = new Vector2(zoomTarget.width, zoomTarget.width);
      normlizedSize =new Vector2(((float)(Screen.width)) / ImageSize.x, ((float)(Screen.height)) / ImageSize.y);
       // Vector2 normlizedSize = new Vector2( ImageSize.x/ Screen.width, ImageSize.y/ Screen.height);
        Vector2 normalizedScale = new Vector2((ImageSize.x / Screen.width/2.0f)* normlizedSize.x,( ImageSize.y / Screen.height/2.0f) * normlizedSize.y);


        Vector4 sizeOffset = new Vector4(normlizedSize.x, normlizedSize.y, normalizedScale.x, normalizedScale.y);
        Debug.Log(sizeOffset.x);

        if (PostProcessMat != null)
        {
            PostProcessMat.SetVector("_SizeOffset", sizeOffset);
            if (zoomTarget != null)
            {
                PostProcessMat.SetTexture("_zoomMask", zoomTarget);
            }
        }
            

    }

    // Update is called once per frame
    void OnDestroy () {
        xrayCamera.ResetReplacementShader();
    }

    private void Update()
    {
        if (PostProcessMat != null)
        {

            Vector2 mousePos = new Vector2(Camera.main.ScreenToViewportPoint(Input.mousePosition).x, Camera.main.ScreenToViewportPoint(Input.mousePosition).y);

            Vector4 MouseCoords = new Vector4(mousePos.x*normlizedSize.x, mousePos.y * normlizedSize.y, 0.0f, 0.0f);
            PostProcessMat.SetVector("_MoouseCoords", MouseCoords);
        }
            
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if(PostProcessMat!=null)
            Graphics.Blit(src, dest, PostProcessMat);
    }
}
