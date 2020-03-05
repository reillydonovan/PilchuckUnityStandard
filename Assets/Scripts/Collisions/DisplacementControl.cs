using MK.Glow.Legacy;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;



public class DisplacementControl : MonoBehaviour


{
    //Post Processing properties

    Bloom bloomLayer;
    public bool isBlend, isBloom;
    private ProceduralAudioController audioController;
    public GameObject postProcessVolumeGO;
    PostProcessVolume postVolume; 
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
    public float bloomAmount;
    public float tileAmount;
   
    public float hueAmount;
    public float blendAmount;
    public float blendDisplacementAmount;
    public float stripWidthDisplacementAmount;
    public float radiusDisplacementAmount;
    public float modulationDisplacmentAmount;
    public float timeDivision = 1;
    public float frequencyDisplacementAmount;
    private float rotateDisplacementAmount;

    float xVertexValue;

    public GameObject superShape;
    // public float m1Start;
    // public float m1End;
    // public float m1ChangeAmount;
    // static float t = 0.0f;
    [Header("Audio Controls")]
    public float audioAmount;
    public float audioLerpUp;
    public float sineWaveAmount, squareWaveAmount, sawWaveAmount, frequencyModulationAmount, frequencyModulationIntentsity;

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
        postVolume = postProcessVolumeGO.GetComponent<PostProcessVolume>();
        postVolume.profile.TryGetSettings(out bloomLayer);

        audioController = audioSource.GetComponent<ProceduralAudioController>();

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

        displacementAmount = Mathf.Lerp(displacementAmount, 0, Time.deltaTime / timeDivision);
        blendAmount = Mathf.Lerp(blendAmount, 0.1f, Time.deltaTime / timeDivision);
        shineAmount = Mathf.Lerp(shineAmount, 0, Time.deltaTime);
        if (isBloom) bloomAmount = Mathf.Lerp(bloomAmount, 0.5f, Time.deltaTime);
        else bloomAmount = Mathf.Lerp(bloomAmount, 0.0f, Time.deltaTime);
        hueAmount = Mathf.Lerp(hueAmount, 0, Time.deltaTime);
        bloomLayer.intensity.value = bloomAmount;

        tileAmount = Mathf.Lerp(tileAmount, 1, Time.deltaTime /(timeDivision * 5));


        //Audio Effects
        audioAmount = Mathf.Lerp(audioAmount, 50f, Time.deltaTime / timeDivision);
        audioLerpUp = Mathf.Lerp(0, audioLerpUp, Time.deltaTime);
        sawWaveAmount = Mathf.Lerp(sawWaveAmount, 0, Time.deltaTime / timeDivision);
        sineWaveAmount = Mathf.Lerp(sineWaveAmount, .5f, Time.deltaTime / timeDivision);
        squareWaveAmount = Mathf.Lerp(squareWaveAmount, 0.1f, Time.deltaTime / timeDivision);
        frequencyModulationAmount = Mathf.Lerp(frequencyModulationAmount, 0.5f, Time.deltaTime / timeDivision);
        frequencyModulationIntentsity = Mathf.Lerp(frequencyModulationIntentsity, 3.0f, Time.deltaTime / timeDivision);

        audioController.sinusAudioWaveIntensity = sineWaveAmount;
        audioController.sawAudioWaveIntensity = sawWaveAmount;
        audioController.squareAudioWaveIntensity = squareWaveAmount;
        audioController.amplitudeModulationOscillatorFrequency = audioAmount;
        audioController.mainFrequency = audioAmount;
        audioController.frequencyModulationOscillatorFrequency = frequencyModulationAmount;
        audioController.frequencyModulationOscillatorIntensity = frequencyModulationIntentsity;
        //audioController.mainFrequency = this.GetComponent<Renderer>().material.GetFloat("_Shape2N1") + 100;

        //Shader Effects
        if(isBlend)this.GetComponent<MeshRenderer>().material.SetFloat("_Blend", blendAmount);
        this.GetComponent<MeshRenderer>().material.SetFloat("_WaveValue1", displacementAmount);
        this.GetComponent<MeshRenderer>().material.mainTextureScale = new Vector2(tileAmount, tileAmount);
        meshRender.material.SetFloat("_Emission", shineAmount);
        meshRender.material.SetFloat("_Hue", hueAmount);
        //rightHandMesh.GetComponent<SkinnedMeshRenderer>().material.SetFloat("_WaveValue1", displacementAmount);
        // leftHandMesh.GetComponent<SkinnedMeshRenderer>().material.SetFloat("_WaveValue1", displacementAmount);
        //  mainCam.GetComponent<MKGlow>().bloomIntensity = glowAmount;
        //  audioSource.GetComponent<AudioSource>().pitch = audioAmount;


        stripWidthDisplacementAmount = Mathf.Lerp(stripWidthDisplacementAmount, 1, Time.deltaTime / timeDivision);
        radiusDisplacementAmount = Mathf.Lerp(radiusDisplacementAmount, 10, Time.deltaTime / timeDivision);
        modulationDisplacmentAmount = Mathf.Lerp(modulationDisplacmentAmount, 1, Time.deltaTime / timeDivision);
        frequencyDisplacementAmount = Mathf.Lerp(frequencyDisplacementAmount, 1, Time.deltaTime / timeDivision);
        rotateDisplacementAmount = Mathf.Lerp(rotateDisplacementAmount, .1f, Time.deltaTime / timeDivision);
        // transformDisplacementAmount = Mathf.Lerp(transformDisplacementAmount, 0, Time.deltaTime / timeDivision);


        //RotateObject
        rotateX = rotateDisplacementAmount;
        rotateY = rotateDisplacementAmount;
        rotateZ = rotateDisplacementAmount;

        // transform.localScale = new Vector3(.004f - transformDisplacementAmount, .004f - transformDisplacementAmount, .004f - transformDisplacementAmount);

        // aura.transform.localScale = auraScale;

        if (Input.GetKeyDown(KeyCode.A))
        {
            Debug.Log("Pressed A");
            CollisionEvents();
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        //  Debug.Log(collision.collider.name);
        if (collision.collider.tag == "Collision")
        {
            CollisionEvents();
            Debug.Log("On Collision Enter");
        }
    }

    public void CollisionEvents()
    {
        //   Debug.Log("we hit an obstacle");
        displacementAmount += .1f;
        blendAmount += .1f;
        shineAmount += .5f;
        bloomAmount += 1f;
        hueAmount += 1f;

        tileAmount += .5f;
        audioAmount += 10f;
        modulationDisplacmentAmount += .05f;
        radiusDisplacementAmount += 1.0f / timeDivision;
        frequencyDisplacementAmount += .1f;
        stripWidthDisplacementAmount += 0.5f / timeDivision;
        rotateDisplacementAmount += 0.1f;
        frequencyModulationAmount += 0.3f;
        frequencyModulationIntentsity += 0.5f;

        sineWaveAmount += .1f;
        squareWaveAmount += .2f;
        sawWaveAmount += .1f;
        //  transformDisplacementAmount += .001f / timeDivision;
        //  explosionParticles.Play();
    }
}
