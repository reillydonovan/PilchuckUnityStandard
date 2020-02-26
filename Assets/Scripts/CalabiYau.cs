
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Numerics;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class CalabiYau : MonoBehaviour
{
    public float n, a, code, floatReturn;
    public float z, z1, z2, i, k1, k2;
    Complex c1;
    float x, y;

    //    private Mesh mesh;
    public int divisions = 200;
    public float stripWidth = 1.0f;
    public float radius = 3.5f;
    public float modulation = 0.1f;
    public float frequency = 15;

    public float f (float _x, float _y)
    {
        // z1 = Mathf.Exp(c1 = 2 * Mathf.PI * k1 / n);
        z1 = Mathf.Pow(Mathf.Exp(k1 * 2 * Mathf.PI * i / n) * (float)System.Math.Cosh(z), 2 / n);
        z2 = Mathf.Pow(Mathf.Exp(k2 * 2 * Mathf.PI * i / n) * (1 / i) * (float)System.Math.Sinh(z), 2 / n);

        return floatReturn;
    }

    void Update()
    {
        f(x, y);
        Debug.Log(floatReturn.ToString());
      //  this.UpdateMesh(GetComponent<MeshFilter>().mesh);

        // z1 = Mathf.Exp(c1 = 2 * Mathf.PI * k1 / n);
      
    }

    /*
    var n = getVariable(id, 'n');
    var a = getVariable(id, 'a');
    var code = getVariable(id, 'code');

    function f(x, y )
    {

        var z1 = mul(exp(complex(0, 2 * pi * k1 / n)), pow(cos(complex(x, y)), 2 / n));
        var z2 = mul(exp(complex(0, 2 * pi * k2 / n)), pow(sin(complex(x, y)), 2 / n));

        return [z1.re, z2.re, z1.im * cos(a) + z2.im * sin(a)];

    }

    var patches = [];

  for (var k1 = 0 ; k1<n ; k1++ )
    for (var k2 = 0 ; k2<n ; k2++ ) {

      var color = 'hsl(' + 360 * (k1 + k2) / n % 360 + ',100%,50%)';

      if (code )
        patches.push(parametric(f, [0, Math.PI / 2, 10], [-1, 1, 10], { color: color } ) );
      else
        patches.push(parametric(f, [0, Math.PI / 2, 10], [-1, 1, 10], { material: 'normal' } ) );

  }*/
    /*
      Mesh UpdateMesh(Mesh m)
      {
          if (m == null) m = new Mesh();

          m.Clear();

          for(k1 = 0; k1 < n; k1++)
          {
              for(k2 = 0; k2 < n; k2++)
              {

              }
          }


          UnityEngine.Vector3[] vertices = new UnityEngine.Vector3[divisions * 2];
          UnityEngine.Vector3[] normals = new UnityEngine.Vector3[divisions * 2];
          //        print("vertices.Length: " + vertices.Length);
          float radianDivWidth = Mathf.PI * 4.0f / (divisions - 0);
          float stripRadianDivWidth = Mathf.PI * 2.0f / (divisions - 0);

          float tm = Time.timeSinceLevelLoad;

          z1 = Mathf.Pow(Mathf.Exp(k1 * 2 * Mathf.PI * i / n) * (float)System.Math.Cosh(z), 2 / n);
          z2 = Mathf.Pow(Mathf.Exp(k2 * 2 * Mathf.PI * i / n) * (1 / i) * (float)System.Math.Sinh(z), 2 / n);


          for (int i = 0; i < divisions; i++)
          {
              float curRingRad = radianDivWidth * i;
              UnityEngine.Vector3 ringVec = new UnityEngine.Vector3(radius * Mathf.Cos(curRingRad),
                                           0,
                                        radius * Mathf.Sin(curRingRad));
              float totalRadius = stripWidth * (1 + modulation *
  Mathf.Sin(tm + curRingRad * frequency));
              UnityEngine.Vector3 outVec = ringVec.normalized * totalRadius;
              UnityEngine.Vector3 scaledUpV = UnityEngine.Vector3.up * totalRadius;

              float curStripRotRad = stripRadianDivWidth * i;

              UnityEngine.Vector3 toroidalOffset = outVec * Mathf.Cos(curStripRotRad) +
                                       scaledUpV * Mathf.Sin(curStripRotRad);

              vertices[i * 2] = ringVec + toroidalOffset;
              vertices[i * 2 + 1] = ringVec - toroidalOffset;
              UnityEngine.Vector3 normal = outVec * Mathf.Cos(curStripRotRad + Mathf.PI / 2.0f) +
                               scaledUpV * Mathf.Sin(curStripRotRad + Mathf.PI / 2.0f);
              normal.Normalize();
              normals[i * 2] = normals[i * 2 + 1] = normal;
          }

      */
    /*
        int[] triangles = new int[vertices.Length * 3];
        //        print("triangles.Length: " + triangles.Length);
        for (int i = 0; i < triangles.Length; i += 6)
        {
            int vIndex = i / 6;
            triangles[i] = vIndex;
            triangles[i + 1] = vIndex + 2;
            triangles[i + 2] = vIndex + 1;

            triangles[i + 3] = vIndex + 1;
            triangles[i + 4] = vIndex + 2;
            triangles[i + 5] = vIndex + 3;
        }

        m.name = "Procedural Mobius";
        m.vertices = vertices;
        m.triangles = triangles;
        m.normals = normals;
        //        newMesh.RecalculateNormals();
        return m;
    }
    */
    private void OnDrawGizmos()
    {

        Gizmos.color = Color.cyan;
      //  Gizmos.DrawWireMesh(UpdateMesh(null), transform.position, transform.rotation, transform.localScale);

    }

}