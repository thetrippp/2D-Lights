using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEditor.PlayerSettings.SplashScreen;

public class Lights : MonoBehaviour
{
    public ComputeShader LightsCompute;
    public RenderTexture LightsTexture;

    public Material testMaterial;

    public float maxLightDistance = 100f;
    public Vector2 mousePosition;

    void Start()
    {
        if(LightsTexture == null)
        {
            LightsTexture = new RenderTexture(Screen.width, Screen.height, 12);
            LightsTexture.name = "Lights Texture";
            LightsTexture.filterMode = FilterMode.Point;
            LightsTexture.wrapMode = TextureWrapMode.Clamp;
            LightsTexture.enableRandomWrite = true;
            LightsTexture.Create();
        }
         

    }

    void Update()
    {
        mousePosition = Input.mousePosition;
        maxLightDistance += Input.mouseScrollDelta.y * 10f;
        maxLightDistance = Mathf.Clamp(maxLightDistance, 10f, 1000f);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        LightsCompute.SetTexture(0, "LightTexture", LightsTexture);
        LightsCompute.SetVector("LightPosition", mousePosition);
        LightsCompute.SetFloat("maxLightDistance", maxLightDistance);

        LightsCompute.Dispatch(0, Mathf.CeilToInt(LightsTexture.width / 4), Mathf.CeilToInt(LightsTexture.height / 4), 1);

        Graphics.Blit(LightsTexture, destination);

        //Graphics.Blit(source, destination, testMaterial );
    }
}
