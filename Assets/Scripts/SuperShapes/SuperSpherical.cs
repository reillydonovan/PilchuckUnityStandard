using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SuperSpherical : MonoBehaviour 
{
    public bool torus = false;
	// number of verts along the 'longitude'
	public int phiDivs = 10;
	// number of verts along the 'latitude'
	public int thetaDivs = 10;

    public float r1, r1min, r1max, r2, r2min, r2max;
	//there are two waves that can be applied to and modify the surface of the spere
	//there is no reason that these have to be the only two waves, but I cannot decide 
	//on a approach to easily make ANY number of them in the editor...

	//set of vars exposed to create waves parallel to the 'latitude'
	// of the sphere
	public int xMod1Period = 4; //how many ups and downs there are
	public float xMod1PhaseOffset = 1.0f; //how far the wave is shifted
	public float xMod1Scale = 2.0f; //how big the wave is
	public float xMod1YOffset = 1.1f; //how big the base of the wave is
	public float xMod1TimeResponse = 1.0f; //the amount the wave moves with time

	//set of vars exposed to create waves parallel to the 'longitude'
	// of the sphere
	public int yMod1Period = 4; //how many ups and downs there are
	public float yMod1PhaseOffset = 1.0f; //how far the wave is shifted
	public float yMod1Scale = 2.0f; //how big the wave is
	public float yMod1YOffset = 1.1f; //how big the base of the wave is
	public float yMod1TimeResponse = 1.0f; //the amount the wave moves with time

    public float offset = 0.0f;

    public float m1 = 0.0f;
    public float m1change = 0.0f;
    public float n11 = 0.0f;
    public float n12 = 0.0f;
    public float n13 = 0.0f;
    public float a1 = 1.0f;
    public float b1 = 1.0f;

    public float m2 = 0.0f;
    public float m2change = 0.0f;
    public float n21 = 0.0f;
    public float n22 = 0.0f;
    public float n23 = 0.0f;
    public float a2 = 1.0f;
    public float b2 = 1.0f;

    public float r = 200.0f;
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
    public float a = 0.0f;
    public float b = 0.0f;


    //latitude = vertical angle
    //longitude = horizontal angle

    // Use this for initialization
    void Start () 
	{
		//we need a mesh filter
		GetComponent<MeshFilter>().mesh = new Mesh();
	}
	
	// Update is called once per frame
	void Update () 
	{
		this.UpdateMesh( GetComponent<MeshFilter>().mesh );
      //  r1 = Mathf.Lerp(r1min, r1max, Mathf.PingPong(Time.time / 5, 1));
      //  r2 = Mathf.Lerp(r2min, r2max, Mathf.PingPong(Time.time / 5, 1));
	}

	// create or update a mesh object to have a sphere with hamonic waves all over
	// it
	Mesh UpdateMesh(Mesh m)
	{
		if(m == null)
		{
			m = new Mesh();
		}

		//clear out the old mesh
		m.Clear();

		Vector3[] vectors = new Vector3[phiDivs * thetaDivs];
		Vector2[] uvs = new Vector2[phiDivs * thetaDivs];
		float radsPerPhiDiv = 2.0f*Mathf.PI/(phiDivs-1);
		float radsPerThetaDiv = 2.0f*Mathf.PI/thetaDivs;

		float seconds = Time.timeSinceLevelLoad;

		// build an array of vectors holding the vertex data
		int vIndex = 0;
		for(int i=0; i < phiDivs; i++)
		{
			float phi = radsPerPhiDiv*i;

			for(int j=0; j < thetaDivs; j++)
			{
				float theta = radsPerThetaDiv*j;	
				//the get radius function is where 'hamonics' are added
				float radius = GetRadius(phi,theta,seconds);
				//add uvs so that we can texture the mesh if we want
				uvs[vIndex] = new Vector2(j*1.0f/thetaDivs,i*1.0f/phiDivs);
                //create a vertex 
                //
                //optimization alert: since the only thing that changes here is the radius
                //(when the number of divisions stays the same) we could cache these numbers
                // and use a shader to create and apply the variations in radius and compute 
                // the normals.
                if (torus)
                {
                    //   x = Mathf.Cos(lon) * (r1 + r2 * Mathf.Cos(lat));
                    //   y = Mathf.Sin(lon) * (r1 + r2 * Mathf.Cos(lat));
                    //   z = r * r2 * Mathf.Sin(lat);
                    //  vectors[vIndex++] = new Vector3(x, y, z);

                    //getting closer
                    /*
                    x = Mathf.Cos(theta) * (r1 + r2 * Mathf.Cos(phi));
                    y = Mathf.Sin(theta) * (r1 + r2 * Mathf.Cos(phi));
                    z = r * r2 * Mathf.Sin(phi);
                    */
                    // x = (R + r * cos(theta)) * cos phi
                    // y = (R + r * Cos(theta)) * sin(phi)
                    // z = r * sin(theta)
                    float x = (r1 * radius + r2 *  Mathf.Cos(theta)) * Mathf.Cos(phi);
                    float y = (r1 * radius  + r2 * Mathf.Cos(theta)) * Mathf.Sin(phi);
                    float z =  r2 * Mathf.Sin(theta);
                  //  float x = Mathf.Cos(phi) * (r1 * Mathf.Cos(phi) + r2 * Mathf.Cos(theta));
                 //   float y = Mathf.Sin(phi) * (r1 * Mathf.Cos(phi) + r2 * Mathf.Cos(theta));
                 //   float z = r1 * r2 * Mathf.Sin(theta);
                    vectors[vIndex++] = new Vector3(x, y, z);
                }
                else
                {
                    /*
                    vectors[vIndex++] = new Vector3(radius * Mathf.Sin(phi) * Mathf.Cos(theta),
                                                    radius * Mathf.Sin(phi) * Mathf.Sin(theta),
                                                    radius * Mathf.Cos(phi));
                                                    */

                  //  float phi = Mathf.Atan2(y, x);
                  //  // float theta = r == 0.0 ? 0.0 : asin(v.vertex.z / r);
                  //  float theta = r == 0.0f ? 0.0f : Mathf.Asin(z / r);
                  //  float radius = GetRadius(phi, theta, Time.timeSinceLevelLoad);

                    float superRadiusPhi = radiusForAngle(phi, a1, b1, m1, n11, n12, n13);
                    float superRadiusTheta = radiusForAngle(theta, a2, b2, m2, n21, n22, n23);

                    x = radius * superRadiusPhi * Mathf.Cos(phi) * superRadiusTheta * Mathf.Cos(theta);
                    y = radius * superRadiusPhi * Mathf.Sin(phi) * superRadiusTheta * Mathf.Cos(theta);
                    z = radius * superRadiusPhi * Mathf.Sin(theta);
                    vectors[vIndex++] = new Vector3(x, y, z);
                }
			}
		}
		m.vertices = vectors;
		m.uv = uvs;

		//assign triangles - these take the form of 'triangle strips' wrapping the
		// circumference of the sphere
		//there is room to optimise this by not recalculating/reassigning if the 
		//count of the vertecies hasn't changed because the topology will still
		// be the same.
		int triCount = 2 * (phiDivs-1) * (thetaDivs);
		int[] triIndecies = new int[triCount*3];
		int curTriIndex = 0;
		for(int i=0; i < phiDivs-1; i++)
		{
			for(int j=0; j < thetaDivs; j++)
			{
				int ul = i*thetaDivs+j;//"upper left" vert
				int ur = i*thetaDivs+ ((j+1) % thetaDivs);//"upper right" vert
				int ll = (i+1)*thetaDivs+j;//"lower left" vert
				int lr = (i+1)*thetaDivs+ ((j+1) % thetaDivs); //"lower right" vert
				//triangle one
				triIndecies[curTriIndex++] = ul;
				triIndecies[curTriIndex++] = ll;
				triIndecies[curTriIndex++] = ur;

				//triangle two
				triIndecies[curTriIndex++] = ll;
				triIndecies[curTriIndex++] = lr;
				triIndecies[curTriIndex++] = ur;
			}
		}
		m.triangles = triIndecies;
		//use the triangle info to calculate vertex normals so we dont have to B)
		m.RecalculateNormals();
		return m;
	}
    float radiusForAngle(float angle, float a, float b, float m, float n1, float n2, float n3)
    {
        float tempA = Mathf.Abs(Mathf.Cos(angle * m * 0.25f) / a);
        float tempB = Mathf.Abs(Mathf.Sin(angle * m * 0.25f) / b);
        float tempAB = Mathf.Pow(tempA, n2) + Mathf.Pow(tempB, n3);
        return Mathf.Abs(Mathf.Pow(tempAB, -1.0f / n1));
    }
    //get radius applies waves along phi and theta based on the public variables
    //optimization note:
    // this would not be impossible to code as a shader... however, getting multiple 
    // waves affecting the surface at once might take some careful thinking...
    float GetRadius(float phi, float theta, float time = 0)
	{  
		return xMod1YOffset + xMod1Scale*Mathf.Sin(xMod1TimeResponse*time + theta*xMod1Period*time*.1f + xMod1PhaseOffset*time) +
			yMod1YOffset + yMod1Scale*Mathf.Sin(yMod1TimeResponse*time + phi*yMod1Period*time*.1f + yMod1PhaseOffset*time);
	}

	//show a representation in the editor window
	private void OnDrawGizmos () {
		Gizmos.color = Color.cyan;
		Gizmos.DrawWireMesh(UpdateMesh(null),transform.position,transform.rotation,transform.localScale);

	}
}
