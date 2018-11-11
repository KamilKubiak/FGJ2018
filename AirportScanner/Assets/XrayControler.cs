using System.Collections;
using System.Collections.Generic;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine.UI;

//[ExecuteInEditMode]
public class XrayControler : MonoBehaviour {

    public Camera xrayCamera;
    public Shader replacementShader;
    public RenderTexture xrayTarget;
    public Texture2D zoomTarget;
    public Material PostProcessMat;
    public Vector2 ImageSize;
    Vector2 normlizedSize;
    Vector2 normalizedScale;
    public static bool ShowXray;
    private RenderTexture xrayTar;
    public float xrayZoom = 2.0f;
    public float greenStackAdd = 0.25f;
    public float redStackAdd = 0.50f;
    public float greenStackSubtractPerSec =  0.1f;
    public float redStackSubtractPerSec = 0.25f;


    float greenStack = 0.0f;
    float redStack = 0.0f;

#if UNITY_EDITOR

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
#endif
    void OnEnable () {
        

    }

    private void Start()
    {
        xrayTar = new RenderTexture((int)(Camera.main.pixelWidth * xrayZoom), (int)(Camera.main.pixelHeight * xrayZoom), 24);

        xrayCamera.targetTexture = xrayTar;


        if (replacementShader != null)
            xrayCamera.SetReplacementShader(replacementShader, "Xray");

        if (PostProcessMat != null)
        {
            PostProcessMat.SetTexture("_xrayRT", xrayTar);
        }
        // ImageSize = new Vector2(zoomTarget.width, zoomTarget.width);
        normlizedSize =new Vector2(((float)(Camera.main.pixelWidth)) / ImageSize.x, ((float)(Camera.main.pixelHeight)) / ImageSize.y);
       // Vector2 normlizedSize = new Vector2( ImageSize.x/ Screen.width, ImageSize.y/ Screen.height);
         normalizedScale = new Vector2((ImageSize.x / Camera.main.pixelWidth/2.0f )* normlizedSize.x,( ImageSize.y / Camera.main.pixelHeight / 2.0f) * normlizedSize.y);


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
        if (Input.GetMouseButtonDown(1)) ShowXray = true;
        if (Input.GetMouseButtonUp(1)) ShowXray = false;
        if (PostProcessMat != null)
        {
            if (Input.GetMouseButtonDown(0)) // left click
            {
                greenStack += greenStackAdd;
                redStack = 0.0f;
            }

            if (Input.GetMouseButtonDown(1))
            {
                redStack += redStackAdd;
                greenStack = 0.0f;
            }

            greenStack -= greenStackSubtractPerSec * Time.deltaTime;
            redStack -= redStackSubtractPerSec * Time.deltaTime;

            redStack = Mathf.Clamp01(redStack);
            greenStack = Mathf.Clamp01(greenStack);



            Vector2 mousePos = new Vector2(Camera.main.ScreenToViewportPoint(Input.mousePosition).x, Camera.main.ScreenToViewportPoint(Input.mousePosition).y );
            Vector2 mousePosFromCenter = (mousePos * 2.0f) - new Vector2(1.0f, 1.0f);
            Vector2 offset = mousePosFromCenter * (1.0f / xrayZoom);
            float offsetX = normalizedScale.x * mousePosFromCenter.x;
            float offsetY = normalizedScale.y * mousePosFromCenter.y;

            Debug.Log(mousePos.x);

            Vector4 MouseCoords = new Vector4(mousePos.x*(normlizedSize.x), mousePos.y * (normlizedSize.y), redStack, greenStack);
            PostProcessMat.SetVector("_MoouseCoords", MouseCoords);

            PostProcessMat.SetTextureOffset("_xrayRT", new Vector2((1.0f - 1.0f / xrayZoom) * mousePos.x, (1.0f - 1.0f / xrayZoom) * mousePos.y));


        }


    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (PostProcessMat != null)
        {
            if (ShowXray)
                PostProcessMat.SetFloat("_scannerOpacity", 1.0f);
            else
                PostProcessMat.SetFloat("_scannerOpacity", 0.0f);

            Graphics.Blit(src, dest, PostProcessMat);
        }
        else
            Graphics.Blit(src, dest);
    }
}
