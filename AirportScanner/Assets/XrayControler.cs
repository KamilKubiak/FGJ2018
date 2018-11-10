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
    Vector2 normalizedScale;
    public static bool ShowXray = true;
    private RenderTexture xrayTar;
    public float xrayZoom = 2.0f;

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
        xrayTar = new RenderTexture((int)(Screen.width * xrayZoom), (int)(Screen.height * xrayZoom), 24);

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
      // ImageSize = new Vector2(zoomTarget.width, zoomTarget.width);
      normlizedSize =new Vector2(((float)(Screen.width)) / ImageSize.x, ((float)(Screen.height)) / ImageSize.y);
       // Vector2 normlizedSize = new Vector2( ImageSize.x/ Screen.width, ImageSize.y/ Screen.height);
         normalizedScale = new Vector2((ImageSize.x / Screen.width/2.0f)* normlizedSize.x,( ImageSize.y / Screen.height/2.0f) * normlizedSize.y);


        Vector4 sizeOffset = new Vector4(normlizedSize.x, normlizedSize.y, normalizedScale.x, normalizedScale.y);
        Debug.Log(sizeOffset.x);

        if (PostProcessMat != null)
        {
            PostProcessMat.SetVector("_SizeOffset", sizeOffset);
            if (zoomTarget != null)
            {
                PostProcessMat.SetTexture("_zoomMask", zoomTarget);
            }
            PostProcessMat.SetTextureScale("_xrayRT", new Vector2(1.0f/ xrayZoom, 1.0f / xrayZoom));
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

            Vector2 mousePos = new Vector2(Camera.main.ScreenToViewportPoint(Input.mousePosition).x, Camera.main.ScreenToViewportPoint(Input.mousePosition).y );
            Vector2 mousePosFromCenter = (mousePos * 2.0f) - new Vector2(1.0f, 1.0f);
            Vector2 offset = mousePosFromCenter * (1.0f / xrayZoom);
            float offsetX = normalizedScale.x * mousePosFromCenter.x;
            float offsetY = normalizedScale.y * mousePosFromCenter.y;

            Debug.Log(mousePosFromCenter.x);

            Vector4 MouseCoords = new Vector4(mousePos.x*(normlizedSize.x)+ offsetX, mousePos.y * (normlizedSize.y) + offsetY, (mousePos.x/(-xrayZoom)), (mousePos.y / (-xrayZoom)));
            PostProcessMat.SetVector("_MoouseCoords", MouseCoords);
        }
            
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if(PostProcessMat!=null&&ShowXray)
            Graphics.Blit(src, dest, PostProcessMat);
        else
            Graphics.Blit(src, dest);
    }
}
