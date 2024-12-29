using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace ButtonQuartet.Lights
{

    [RequireComponent(typeof(MeshRenderer))]
    [RequireComponent(typeof(MeshFilter))]
    public class PointLight2D : MonoBehaviour
    {
        [Range(0.0f, 10.0f)]
        public float baseIntensity = 0.5f;
        [Range(0.1f, 10f)]
        public float radialFallOff = 2f;
        public Color baseColor = Color.white;
        [Range(0f, 360f)]
        public float maxAngle;
        public bool useRadialFalloff = true;
        public bool useAngularFalloff = true;

        private MeshRenderer lightMeshRenderer;
        private MeshFilter lightMeshFilter;
        private Mesh mesh;

        private Shader lightShader;
        private Material lightMaterial;
        public Material shadowMat;

        private void Awake()
        {
            lightMeshRenderer = GetComponent<MeshRenderer>();
            lightMeshFilter = GetComponent<MeshFilter>();

            lightShader = Shader.Find("RaghavSuriyashekar/LightShader");
            lightMaterial = new Material(lightShader);
            lightMeshRenderer.material = lightMaterial;
        }


        void Start()
        {

            mesh = new Mesh {
                name = "Light Mesh"
            };
            mesh.vertices = new Vector3[] {
                -Vector3.up + -Vector3.right,
                Vector3.up + -Vector3.right,
                -Vector3.up + Vector3.right,
                Vector3.up + Vector3.right,
            };

            mesh.triangles = new int[] {
                0, 1, 2, 1, 3, 2
            };

            mesh.uv = new Vector2[] {
                -Vector3.up + -Vector3.right,
                Vector3.up + -Vector3.right,
                -Vector3.up + Vector3.right,
                Vector3.up + Vector3.right,
            };

            lightMeshFilter.mesh = mesh;
        }

        void Update()
        {
            shadowMat.SetVector("lightPosition", transform.position);
            lightMaterial.SetVector("baseColor", new Vector4(baseColor.r, baseColor.g, baseColor.b, baseColor.a));
            lightMaterial.SetFloat("intensity", baseIntensity);
            lightMaterial.SetFloat("fallOff", radialFallOff);
            lightMaterial.SetFloat("maxAngle", maxAngle);
            lightMaterial.SetInt("useRadialFalloff", useRadialFalloff ? 1 : 0);
            lightMaterial.SetInt("useAngularFalloff", useAngularFalloff ? 1 : 0);
        }
    }
}
