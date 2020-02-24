using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CircleTangent : MonoBehaviour
{
 protected Vector3 GetRotatedTangent(float _degree, float _radius)
    {
        double angle = _degree * Mathf.Deg2Rad;
        float x = _radius * (float)System.Math.Sin(angle);
        float z = _radius * (float)System.Math.Cos(angle);
        return new Vector3(x, 0, z);
    }

    protected Vector4 FindTangentCircle(Vector4 _A, Vector4 _B, float _degree)
    {
        Vector3 C = GetRotatedTangent(_degree, _A.w);
        float AB = Mathf.Max(Vector3.Distance(new Vector3(_A.x, _A.y, _A.z), new Vector3(_B.x, _B.y, _B.z)), 0.1f); 
        float AC = Vector3.Distance(new Vector3(_A.x, _A.y, _A.z), C);
        float BC = Vector3.Distance(new Vector3(_B.x, _B.y, _B.z), C);
        float angleCAB = ((AC*AC) + (AB*AB) - (BC * BC)) / (2 * AC * AB);
        float r = (((_A.w * _A.w) - (_B.w * _B.w) + (AB * AB)) - (2 * _A.w * AB * angleCAB))
            / (2 * (_A.w + _B.w -AB * angleCAB));

        C = GetRotatedTangent(_degree, _A.w - r);
        return new Vector4(C.x, C.y, C.z, r);


    }
}
