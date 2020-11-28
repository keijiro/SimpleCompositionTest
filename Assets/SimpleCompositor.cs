using UnityEngine;
using UnityEngine.Rendering;

[ExecuteInEditMode]
public class SimpleCompositor : MonoBehaviour
{
    public Texture colorTexture;
    public Texture matteTexture;
    public float depth = 1;
    public float threshold = 0.01f;

    Material _material;
    Bounds _bounds = new Bounds(Vector3.zero, Vector3.one * 1e+5f);

    void OnDestroy()
    {
        if (_material != null)
        {
            if (Application.isPlaying)
                Destroy(_material);
            else
                DestroyImmediate(_material);
            _material = null;
        }
    }

    void Update()
    {
        if (colorTexture == null || matteTexture == null) return;

        if (_material == null)
        {
            var shader = Shader.Find("Hidden/SimpleCompositor");
            _material = new Material(shader);
        }

        _material.SetTexture("_ColorTex", colorTexture);
        _material.SetTexture("_MatteTex", matteTexture);
        _material.SetFloat("_Depth", depth);
        _material.SetFloat("_Threshold", threshold);

        Graphics.DrawProcedural
          (_material, _bounds, MeshTopology.Triangles, 6, 1,
           null, null, ShadowCastingMode.Off, false, gameObject.layer);
    }
}
