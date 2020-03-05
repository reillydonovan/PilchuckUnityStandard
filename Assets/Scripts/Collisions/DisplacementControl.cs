using MK.Glow.Legacy;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DisplacementControl : MonoBehaviour


{

   // public GameObject mainCam;
  //  public GameObject audioSource;
  //  public GameObject aura;
   

    public Vector3 auraScale;

    public float speed = 1.0f;
    public Color startColor;
    public Color endColor;
    float startTime;
    private float rotateX, rotateY, rotateZ;
    [Header("Displacement Controls")]
    // public GameObject mainCam;
    public GameObject audioSource;
    //  public GameObject aura;
    public float displacementAmount;
    public float shineAmount;
    public float glowAmount;
    public float audioAmount;
    public float audioLerpUp;
    public float hueAmount;
    public float stripWidthDisplacementAmount;
    public float radiusDisplacementAmount;
    public float modulationDisplacmentAmount;
    public float timeDivision = 1;
    public float frequencyDisplacementAmount;
    private float rotateDisplacementAmount;
    // public float m1Start;
    // public float m1End;
    // public float m1ChangeAmount;
    // static float t = 0.0f;

    public ParticleSystem explosionParticles;
    MeshRenderer meshRender;
    // Start is called before the first frame update
    void Start()
    {
        rotateX = Time.deltaTime;
        rotateY = Time.deltaTime;
        rotateZ = Time.deltaTime;
        meshRender = GetComponent<MeshRenderer>();
        startTime = Time.time;
        
    }
    private void Update()
    {
        CollisionController();
    }
    // Update is called once per frame
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
        glowAmount = Mathf.Lerp(glowAmount, 0, Time.deltaTime);
        hueAmount = Mathf.Lerp(hueAmount, 0, Time.deltaTime);
        audioAmount = Mathf.Lerp(audioAmount, .15f, Time.deltaTime / timeDivision);
        audioLerpUp = Mathf.Lerp(0, audioLerpUp, Time.deltaTime);
         this.GetComponent<MeshRenderer>().material.SetFloat("_WaveValue1", displacementAmount);
        //rightHandMesh.GetComponent<SkinnedMeshRenderer>().material.SetFloat("_WaveValue1", displacementAmount);
        // leftHandMesh.GetComponent<SkinnedMeshRenderer>().material.SetFloat("_WaveValue1", displacementAmount);
        meshRender.material.SetFloat("_Emission", shineAmount);
        meshRender.material.SetFloat("_Hue", hueAmount);
        //  mainCam.GetComponent<MKGlow>().bloomIntensity = glowAmount;
        //  audioSource.GetComponent<AudioSource>().pitch = audioAmount;
        audioSource.GetComponent<ProceduralAudioController>().amplitudeModulationOscillatorFrequency = audioAmount;
        audioSource.GetComponent<ProceduralAudioController>().mainFrequency = audioAmount + 150.0f;

        stripWidthDisplacementAmount = Mathf.Lerp(stripWidthDisplacementAmount, 1, Time.deltaTime / timeDivision);
        radiusDisplacementAmount = Mathf.Lerp(radiusDisplacementAmount, 10, Time.deltaTime / timeDivision);
        modulationDisplacmentAmount = Mathf.Lerp(modulationDisplacmentAmount, 1, Time.deltaTime / timeDivision);
        frequencyDisplacementAmount = Mathf.Lerp(frequencyDisplacementAmount, 1, Time.deltaTime / timeDivision);
        rotateDisplacementAmount = Mathf.Lerp(rotateDisplacementAmount, .1f, Time.deltaTime / timeDivision);
        // transformDisplacementAmount = Mathf.Lerp(transformDisplacementAmount, 0, Time.deltaTime / timeDivision);

        rotateX = rotateDisplacementAmount;
        rotateY = rotateDisplacementAmount;
        rotateZ = rotateDisplacementAmount;

        // transform.localScale = new Vector3(.004f - transformDisplacementAmount, .004f - transformDisplacementAmount, .004f - transformDisplacementAmount);

        // aura.transform.localScale = auraScale;

        if (Input.GetKeyDown(KeyCode.A))
        {
            Debug.Log("Pressed A");
            // m1ChangeAmount += .1f;
            displacementAmount += .1f;
            shineAmount += .5f;
            glowAmount += 1f;
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
            glowAmount += 1f;
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
}
