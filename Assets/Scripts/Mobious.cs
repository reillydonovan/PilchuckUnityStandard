
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;


[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class Mobious : MonoBehaviour
{

    [Header("Geometry Values")]
    //    private Mesh mesh;
    public int divisions = 200;
    public float stripWidth = 1.0f;
    public float radius = 3.5f;
    public float modulation = 0.1f;
    public float frequency = 15;
    private float rotateX, rotateY, rotateZ;
    [Header("Displacement Controls")]
    // public GameObject mainCam;
    public GameObject audioSource;
    //  public GameObject aura;
    public float displacementAmount;
    public float shineAmount;
    public float bloomAmount;
    public float audioAmount;
    public float audioLerpUp;
    public float hueAmount;
    public float stripWidthDisplacementAmount;
    public float radiusDisplacementAmount;
    public float modulationDisplacmentAmount;
    public float timeDivision = 1;
    public float frequencyDisplacementAmount;
    private float rotateDisplacementAmount;

    [Header("Post Processing Effects")]
    Bloom bloomLayer;
    private ProceduralAudioController audioController;
    public GameObject postProcessVolumeGO;
    PostProcessVolume postVolume;
    // private float transformDisplacementAmount;

    //public GameObject leftHandMesh, rightHandMesh;
    //private float leftHandMeshDisplacement, rightHandMeshDisplacement;

    //public Vector3 auraScale;

    public float speed = 1.0f;
    public Color startColor;
    public Color endColor;
    float startTime;
    
    // public float m1Start;
    // public float m1End;
    // public float m1ChangeAmount;
    // static float t = 0.0f;

    // public ParticleSystem explosionParticles;
    MeshRenderer meshRender;
    //MeshCollider meshCollide;
    // Use this for initialization
    void Start()
    {
        rotateX = Time.deltaTime;
        rotateY = Time.deltaTime;
        rotateZ = Time.deltaTime;
        GetComponent<MeshFilter>().mesh = new Mesh();
        meshRender = GetComponent<MeshRenderer>();
       // meshCollide = GetComponent<MeshCollider>();
        startTime = Time.time;
        postVolume = postProcessVolumeGO.GetComponent<PostProcessVolume>();
        postVolume.profile.TryGetSettings(out bloomLayer);
    }

    // Update is called once per frame
    void Update()
    {
        // radius = Mathf.Sin(Time.deltaTime);
        transform.Rotate(rotateX, rotateY, rotateZ); ;
        this.UpdateMesh(GetComponent<MeshFilter>().mesh);
        //this.GetComponent<MeshCollider>().sharedMesh = this.GetComponent<MeshFilter>().mesh;
        CollisionController();
    }

     Mesh UpdateMesh(Mesh m)
    {
        if(m == null) m = new Mesh();

        m.Clear();

     
        Vector3[] vertices = new Vector3[divisions * 2];
        Vector3[] normals = new Vector3[divisions * 2];
        //        print("vertices.Length: " + vertices.Length);
        float radianDivWidth = Mathf.PI * 4.0f / (divisions - 0);
        float stripRadianDivWidth = Mathf.PI * 2.0f / (divisions - 0);

        float tm = Time.timeSinceLevelLoad;



        for (int i = 0; i < divisions; i++)
        {
            float curRingRad = radianDivWidth * i;
            Vector3 ringVec = new Vector3(radius * Mathf.Cos(curRingRad),
                                         0,
                                      radius * Mathf.Sin(curRingRad));
            float totalRadius = stripWidth * (1 + modulation *
Mathf.Sin(tm + curRingRad * frequency));
            Vector3 outVec = ringVec.normalized * totalRadius;
            Vector3 scaledUpV = Vector3.up * totalRadius;

            float curStripRotRad = stripRadianDivWidth * i;

            Vector3 toroidalOffset = outVec * Mathf.Cos(curStripRotRad) +
                                     scaledUpV * Mathf.Sin(curStripRotRad);

            vertices[i * 2] = ringVec + toroidalOffset;
            vertices[i * 2 + 1] = ringVec - toroidalOffset;
            Vector3 normal = outVec * Mathf.Cos(curStripRotRad + Mathf.PI / 2.0f) +
                             scaledUpV * Mathf.Sin(curStripRotRad + Mathf.PI / 2.0f);
            normal.Normalize();
            normals[i * 2] = normals[i * 2 + 1] = normal;
        }


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

    private void CollisionController()
    {
        float t = (Time.time - startTime) * speed;
        meshRender.material.color = Color.Lerp(startColor, endColor, t);
        // t += 0.5f * Time.deltaTime;
        // m1ChangeAmount = Mathf.Lerp(m1Start, m1End, Time.deltaTime);
        //   meshRender.material.SetFloat("_Shape1M", m1ChangeAmount);
        // auraScale = Mathf.Lerp(auraScale, 0, Time.deltaTime);
        displacementAmount = Mathf.Lerp(displacementAmount, 0, Time.deltaTime / timeDivision);
        shineAmount = Mathf.Lerp(shineAmount, 0, Time.deltaTime);
        bloomAmount = Mathf.Lerp(bloomAmount, 0.5f, Time.deltaTime);
        bloomLayer.intensity.value = bloomAmount;
        hueAmount = Mathf.Lerp(hueAmount, 0, Time.deltaTime);
        audioAmount = Mathf.Lerp(audioAmount, 0.15f, Time.deltaTime / timeDivision);
        audioLerpUp = Mathf.Lerp(0, audioLerpUp, Time.deltaTime);
        // superShape.GetComponent<MeshRenderer>().material.SetFloat("_WaveValue1", displacementAmount);
        //rightHandMesh.GetComponent<SkinnedMeshRenderer>().material.SetFloat("_WaveValue1", displacementAmount);
       // leftHandMesh.GetComponent<SkinnedMeshRenderer>().material.SetFloat("_WaveValue1", displacementAmount);
        meshRender.material.SetFloat("_Emission", shineAmount);
        meshRender.material.SetFloat("_Hue", hueAmount);
        //  mainCam.GetComponent<MKGlow>().bloomIntensity = glowAmount;
        //  audioSource.GetComponent<AudioSource>().pitch = audioAmount;
        audioSource.GetComponent<ProceduralAudioController>().amplitudeModulationOscillatorFrequency = audioAmount;
        audioSource.GetComponent<ProceduralAudioController>().mainFrequency = audioAmount + 20.0f;

        stripWidthDisplacementAmount = Mathf.Lerp(stripWidthDisplacementAmount, 1, Time.deltaTime /timeDivision);
        radiusDisplacementAmount = Mathf.Lerp(radiusDisplacementAmount, 10, Time.deltaTime / timeDivision);
        modulationDisplacmentAmount = Mathf.Lerp(modulationDisplacmentAmount, 1, Time.deltaTime / timeDivision);
        frequencyDisplacementAmount = Mathf.Lerp(frequencyDisplacementAmount, 1, Time.deltaTime / timeDivision);
        rotateDisplacementAmount = Mathf.Lerp(rotateDisplacementAmount, .1f, Time.deltaTime / timeDivision);
       // transformDisplacementAmount = Mathf.Lerp(transformDisplacementAmount, 0, Time.deltaTime / timeDivision);

        rotateX = rotateDisplacementAmount;
        rotateY = rotateDisplacementAmount;
        rotateZ = rotateDisplacementAmount;

        radius = radiusDisplacementAmount;
        modulation = modulationDisplacmentAmount;
        frequency = frequencyDisplacementAmount;
        stripWidth = stripWidthDisplacementAmount;
       // transform.localScale = new Vector3(.004f - transformDisplacementAmount, .004f - transformDisplacementAmount, .004f - transformDisplacementAmount);

        // aura.transform.localScale = auraScale;

        if (Input.GetKeyDown(KeyCode.A))
        {
            Debug.Log("Pressed A");
            // m1ChangeAmount += .1f;
            displacementAmount += .1f;
            shineAmount += .5f;
            bloomAmount += 1f;
            hueAmount += .3f;
            audioAmount += 10f;
            audioLerpUp += 10f;
            radiusDisplacementAmount += .1f;
            stripWidthDisplacementAmount += 0.5f;
            //    explosionParticles.Play();
            //   auraScale += new Vector3(1f, 0, 0);
            // Debug.Log("Pressed A");
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        //  Debug.Log(collision.collider.name);
        if (collision.collider.tag == "Collision")
        {
            //   Debug.Log("we hit an obstacle");
            displacementAmount += .1f;
            shineAmount += .5f;
            bloomAmount += 1f;
            audioAmount += .5f;
            modulationDisplacmentAmount += .05f;
            radiusDisplacementAmount += 1.0f / timeDivision;
            frequencyDisplacementAmount += .1f;
            stripWidthDisplacementAmount += 0.5f / timeDivision;
            rotateDisplacementAmount += 0.1f;
          //  transformDisplacementAmount += .001f / timeDivision;
            //  explosionParticles.Play();
            Debug.Log("On Collision Enter");
        }
    }

    private void OnDrawGizmos()
    {

        Gizmos.color = Color.cyan;
        Gizmos.DrawWireMesh(UpdateMesh(null), transform.position, transform.rotation, transform.localScale);

    }
}