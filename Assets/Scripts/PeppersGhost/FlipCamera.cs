using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlipCamera : MonoBehaviour
{
    public Camera cam;
    // Start is called before the first frame update
   // private Camera thisCamera;
    void Start()
    {/*  thisCamera = GetComponent<Camera>();
        Matrix4x4 mat = Camera.main.projectionMatrix;
        mat *= Matrix4x4.Scale(new Vector3(-1, 1, 1));
        Camera.main.projectionMatrix = mat;
        GL.invertCulling = true;
        */
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnPreCull()
    {
        
            cam.ResetWorldToCameraMatrix();
            cam.ResetProjectionMatrix();
        cam.projectionMatrix = cam.projectionMatrix * Matrix4x4.Scale(new Vector3(-1, 1, 1));
        
    }

    private void OnPreRender()
    {
        GL.invertCulling = true;
    }

    private void OnPostRender()
    {
        GL.invertCulling = false;
    }
}
