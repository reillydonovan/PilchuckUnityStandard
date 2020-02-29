using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlipCamera : MonoBehaviour
{
    // Start is called before the first frame update
    private Camera thisCamera;
    void Start()
    {
        thisCamera = GetComponent<Camera>();
        Matrix4x4 mat = thisCamera.projectionMatrix;
        mat *= Matrix4x4.Scale(new Vector3(-1, 1, 1));
        thisCamera.projectionMatrix = mat;
        GL.invertCulling = true;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
