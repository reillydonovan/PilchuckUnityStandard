using MK.Glow.Legacy;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DisplacementControl : MonoBehaviour


{

    public GameObject mainCam;
    public GameObject audioSource;
    public GameObject aura;
    public float displacementAmount;
    public float shineAmount;
    public float glowAmount;
    public float audioAmount;
    public float hueAmount;

    public Vector3 auraScale;

    public float speed = 1.0f;
    public Color startColor;
    public Color endColor;
    float startTime;
   // public float m1Start;
   // public float m1End;
   // public float m1ChangeAmount;
   // static float t = 0.0f;

    public ParticleSystem explosionParticles;
    MeshRenderer meshRender;
    // Start is called before the first frame update
    void Start()
    {
        meshRender = GetComponent<MeshRenderer>();
        startTime = Time.time;
        
    }

    // Update is called once per frame
    void Update()
    {
        float t = (Time.time - startTime) * speed;
        meshRender.material.color = Color.Lerp(startColor, endColor, t);
        // t += 0.5f * Time.deltaTime;
       // m1ChangeAmount = Mathf.Lerp(m1Start, m1End, Time.deltaTime);
     //   meshRender.material.SetFloat("_Shape1M", m1ChangeAmount);
        // auraScale = Mathf.Lerp(auraScale, 0, Time.deltaTime);
        displacementAmount = Mathf.Lerp(displacementAmount, 0, Time.deltaTime);
        shineAmount = Mathf.Lerp(shineAmount, 0, Time.deltaTime);
        glowAmount = Mathf.Lerp(glowAmount, 0, Time.deltaTime);
        hueAmount = Mathf.Lerp(hueAmount, 0, Time.deltaTime);
        audioAmount = Mathf.Lerp(audioAmount, 1, Time.deltaTime);
        // superShape.GetComponent<MeshRenderer>().material.SetFloat("_WaveValue1", displacementAmount);
        meshRender.material.SetFloat("_WaveValue1", displacementAmount);
        meshRender.material.SetFloat("_Emission", shineAmount);
        meshRender.material.SetFloat("_Hue", hueAmount);
        mainCam.GetComponent<MKGlow>().bloomIntensity = glowAmount;
        audioSource.GetComponent<AudioSource>().pitch = audioAmount;
        
        aura.transform.localScale = auraScale;

        if (Input.GetKeyDown(KeyCode.A))
        {
           // m1ChangeAmount += .1f;
            displacementAmount += .1f;
            shineAmount += .5f;
            glowAmount += 1f;
            hueAmount += .3f;
            audioAmount += .5f;
            explosionParticles.Play();
         //   auraScale += new Vector3(1f, 0, 0);
           // Debug.Log("Pressed A");
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
      //  Debug.Log(collision.collider.name);
      if(collision.collider.tag == "Collision")
        {
         //   Debug.Log("we hit an obstacle");
            displacementAmount += .1f;
            shineAmount += .5f;
            glowAmount += 1f;
            audioAmount += .5f;
            explosionParticles.Play();
        }
    }
}
