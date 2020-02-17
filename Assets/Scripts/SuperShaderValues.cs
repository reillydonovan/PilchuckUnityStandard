using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(MeshRenderer))]
public class SuperShaderValues : MonoBehaviour
{
    struct ShaderValue
    {
        public int shaderScreenShot, intensity10;
        public float shape1A, shape1b, shape1m,
            shape1n1, shape1n2, shape1n3, shape2a,
            shape2b, shape2m, shape2n1, shape2n2,
            shape2n3;

        public ShaderValue(int shot, int _intensity10, float _1a, float _1b, float _1m,
            float _1n1, float _1n2, float _1n3, float _2a, 
            float _2b, float _2m, float _2n1, float _2n2, float _2n3)
        {
            shaderScreenShot = shot;
            intensity10 = _intensity10;
            shape1A = _1a;
            shape1b = _1b;
            shape1m = _1m;
            shape1n1 = _1n1;
            shape1n2 = _1n2;
            shape1n3 = _1n3;
            shape2a = _2a;
            shape2b = _2b;
            shape2m = _2m;
            shape2n1 = _2n1;
            shape2n2 = _2n2;
            shape2n3 = _2n3;
        }
    }

    [Range(0.016f,30f)]
    public float timeFade = 10f;

    [Range(0, 120f)] 
    public float pauseTime = 10f;
    
    private List<ShaderValue> shaderValues;
    private MeshRenderer _meshRenderer;
    private float startTime;
    private int shaderIndex = 0;

    private ShaderValue currentValue;
    private ShaderValue targetValue;
    private bool _shouldAnimate = false;
    public bool ShouldAnimate
    {
        get => _shouldAnimate;
        set
        {
            _shouldAnimate = value;
            startTime = Time.time;
            if (value)
            {
                // lerp to next value.
                currentValue = targetValue;
                if (shaderIndex < shaderValues.Count - 1)
                {
                    shaderIndex += 1;
                }
                else
                {
                    shaderIndex = 0;
                }
                targetValue = shaderValues.ToArray()[shaderIndex];
            }
        }
    }

    
    // Start is called before the first frame update
    void Awake()
    {
        shaderValues = new List<ShaderValue>();
        ShaderValue a2 = new ShaderValue(2, 8, -0.6f, -1.7f, 1.6f, 2.6f, -5.3f,-3.7f, 1f, 1f, 31.7f, -15.9f, 51.2f, -4.4f);
        ShaderValue a4 = new ShaderValue(4, 4, 1f, 1f, 2f, .7f, .3f, .2f, 1f, 1f, 3f, 100f, 100f, 100f);
        ShaderValue a5 = new ShaderValue(5, 6, 1f, 1f, 7f, .2f, 1.7f, 1.7f, 1f, 1f, 7f, .2f, 1.7f, 1.7f);
        ShaderValue a7 = new ShaderValue(7, 3, 1f,1f, 3f, 1f, 1f, 1f, 1f, 1f, 6f, 2f, 1f, 1f);
        ShaderValue a9 = new ShaderValue(9, 7, 1f, 1f, 6f, .24f, 47f, -.6f, 1f, 1f, 7f, -76f,.5f,-56f);
        ShaderValue a10 = new ShaderValue(10, 6, 1f,1f,6f,60f,55f,1000f,1f,1f,6f,250,100f,100f);
        ShaderValue a11 = new ShaderValue(11, 3, 1f,1f,6f, 60f, 100f, 30f, 1f, 1f, 2f, 10f, 10f,10f);
        ShaderValue a13 = new ShaderValue(13, 5, 1f, 1f, 5f, .1f, 1.7f, 1.7f, 1f, 1f, 1f, .3f, .5f, .5f);
        ShaderValue a15 = new ShaderValue(15, 3, 1f, 1f, 2.6f, .1f, 1f, 2.5f, 1f, 1f, 3f, 3f, .2f, 1f);
        ShaderValue a16 = new ShaderValue(16, 5, 1f, 1f, 5.7f, .4f, 1f, 2.5f, 1f, 1f, 10f,3f,.2f,1f);
        ShaderValue a18 = new ShaderValue(18, 7, 1f, 1f, 4f, .37f, 50f, -.6f, 1f,1f,9f,-75f,-.6f,-41f);
        ShaderValue a19 = new ShaderValue(19, 2, 1f,1f,3f,.99f,97f,-.4f,1f,1f,7f,-8f,-.08f,93f);
        ShaderValue a20 = new ShaderValue(20, 3, 1f,1f,0,.47f,30f,.35f,1f,1f,5f,15f,-.4f,97f);
        ShaderValue a21 = new ShaderValue(21, 4, 1f,1f,2f,.43f,13f,.64f,1f,1f,1f,-21f,.63f,68f);
        ShaderValue a22 = new ShaderValue(22, 4, 1f,1f,6f,.17f,31f,-.9f,1f,1f,5f,93f,-.3f,68f);
        ShaderValue a26 = new ShaderValue(26,8,1.51f,1.67f,6f,-.92f,67f,.12f,1.3f,.29f,9f,-98f,.06f,-45f);
        ShaderValue a29 = new ShaderValue(29,6,1f,1f,4f,100f,1f,1f,1f,1f,39f,1f,-11f,210f);
        ShaderValue a30 = new ShaderValue(30, 7,1f,1f,4f,7f,36f,1f,1f,1f,527f,1f,-23f,139f);
        ShaderValue a32 = new ShaderValue(32, 6, 1f,1f,1f,1f,1f,1f,1f,1f,20f,10f,10f,-20f);
        ShaderValue a33 = new ShaderValue(33,6,1f,1f,1f,1f,1f,1f,1f,1f,148f,10f,10f,-20f);
        ShaderValue a34 = new ShaderValue(34, 7, 1f,1f,1f,36f,349f,36f,1f,1f,148f,219f,10f,-20f);
        ShaderValue a35 = new ShaderValue(35, 7, 1f,1f,1f,36f,349f,36f,1f,82f,-15f,219f,10f,-20f);
        ShaderValue a36 = new ShaderValue(36, 8, 1f,1f,1f,36f,349f,36f,1f,1f,-15f,219f,-292f,-183f);
        ShaderValue a37 = new ShaderValue(37, 2, 1f,-11f,1f,36f,-336f,36f,1f,1f,20f,161f,-292f,-183f);
        ShaderValue a38 = new ShaderValue(38, 5, 1f,-11f,1f,36f,-336f,36f,1f,1f,20f,904f,823f,363f);
        ShaderValue a39 = new ShaderValue(39, 5,  1f,-11f,1f,36f,-336f,36f,1f,1f,-3f,904f,823f,363f);
        ShaderValue a41 = new ShaderValue(41,7, 1f,-11f,5f,477f,-278f,36f,1f,1f,-3f,904f,823f,363f);
        ShaderValue a42 = new ShaderValue(42,7, 1f,-11f,28f,477f,581f,36f,1f,1f,-3f,904f,823f,363f);
        ShaderValue a43 = new ShaderValue(43,7,1f,-11f,28f,477f,581f,-22f,1f,1f,-3f,904f,823f,363f);
        ShaderValue a44 = new ShaderValue(44,9,1f,-11f,109f,-568f,-127f,-22f,1f,1f,-3f,82f,315f,791f);
        ShaderValue a45 = new ShaderValue(45, 10, 1f,-11f,109f,-568f,-197f,-22f,1f,1f,2f,-81f,280f,-10f);
        
        shaderValues.Add(a2); shaderValues.Add(a4); shaderValues.Add(a5);
        shaderValues.Add(a7); shaderValues.Add(a9); shaderValues.Add(a10);
        shaderValues.Add(a11); shaderValues.Add(a13); shaderValues.Add(a15);
        shaderValues.Add(a16); shaderValues.Add(a18); shaderValues.Add(a19);
        shaderValues.Add(a20); shaderValues.Add(a21); shaderValues.Add(a22);
        shaderValues.Add(a26); shaderValues.Add(a29); shaderValues.Add(a30);
        shaderValues.Add(a32); shaderValues.Add(a33); shaderValues.Add(a34);
        shaderValues.Add(a35); shaderValues.Add(a36); shaderValues.Add(a37);
        shaderValues.Add(a38); shaderValues.Add(a39); shaderValues.Add(a41);
        shaderValues.Add(a42); shaderValues.Add(a43); shaderValues.Add(a44);
        shaderValues.Add(a45);
        _meshRenderer = GetComponent<MeshRenderer>();
        _meshRenderer.material.SetFloat("_Shape1A", a2.shape1A);
        _meshRenderer.material.SetFloat("_Shape1B", a2.shape1b);
        _meshRenderer.material.SetFloat("_Shape1M", a2.shape1m);
        _meshRenderer.material.SetFloat("_Shape1N1", a2.shape1n1);
        _meshRenderer.material.SetFloat("_Shape1N2", a2.shape1n2);
        _meshRenderer.material.SetFloat("_Shape1N3", a2.shape1n3);
        _meshRenderer.material.SetFloat("_Shape2A", a2.shape2a);
        _meshRenderer.material.SetFloat("_Shape2B", a2.shape2b);
        _meshRenderer.material.SetFloat("_Shape2M", a2.shape2m);
        _meshRenderer.material.SetFloat("_Shape2N1", a2.shape2n1);
        _meshRenderer.material.SetFloat("_Shape2N2", a2.shape2n2);
        _meshRenderer.material.SetFloat("_Shape2N3", a2.shape2n3);
        currentValue = a2;
        targetValue = a2;
        startTime = Time.time;
    }

    // Update is called once per frame
    void Update()
    {
        float deltaTime = Time.time - startTime;
        if (_shouldAnimate)
        {
            float timeRatio = Mathf.Min(deltaTime / timeFade, 1.0f);
            _meshRenderer.material.SetFloat("_Shape1A", Mathf.Lerp(currentValue.shape1A, targetValue.shape1A, timeRatio));
            _meshRenderer.material.SetFloat("_Shape1B", Mathf.Lerp(currentValue.shape1b, targetValue.shape1b, timeRatio));
            _meshRenderer.material.SetFloat("_Shape1M", Mathf.Lerp(currentValue.shape1m, targetValue.shape1m, timeRatio));
            _meshRenderer.material.SetFloat("_Shape1N1", Mathf.Lerp(currentValue.shape1n1, targetValue.shape1n1, timeRatio));
            _meshRenderer.material.SetFloat("_Shape1N2", Mathf.Lerp(currentValue.shape1n2, targetValue.shape1n2, timeRatio));
            _meshRenderer.material.SetFloat("_Shape1N3", Mathf.Lerp(currentValue.shape1n3, targetValue.shape1n3, timeRatio));
            _meshRenderer.material.SetFloat("_Shape2A", Mathf.Lerp(currentValue.shape2a, targetValue.shape2a, timeRatio));
            _meshRenderer.material.SetFloat("_Shape2B", Mathf.Lerp(currentValue.shape2b, targetValue.shape2b, timeRatio));
            _meshRenderer.material.SetFloat("_Shape2M", Mathf.Lerp(currentValue.shape2m, targetValue.shape2m, timeRatio));
            _meshRenderer.material.SetFloat("_Shape2N1", Mathf.Lerp(currentValue.shape2n1, targetValue.shape2n1, timeRatio));
            _meshRenderer.material.SetFloat("_Shape2N2", Mathf.Lerp(currentValue.shape2n2, targetValue.shape2n2, timeRatio));
            _meshRenderer.material.SetFloat("_Shape2N3", Mathf.Lerp(currentValue.shape2n3, targetValue.shape2n3, timeRatio));
            if (timeRatio == 1.0f)
            {
                ShouldAnimate = false;
            }
        }
        else
        {
            if (deltaTime > pauseTime)
            {
                ShouldAnimate = true;
            }
        }
    }
}
