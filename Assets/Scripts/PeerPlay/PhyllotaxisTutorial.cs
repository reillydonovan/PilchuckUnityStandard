using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PhyllotaxisTutorial : MonoBehaviour
{
    public AudioPeer audioPeer;
    private Material trailMat;
    public Color trailColor;

    public float degree, scale; //, dotScale;
    public int numberStart;
    public int stepSize;
    public int maxIteration;

    public bool useLerping;
   // public float intervalLerp;
    private bool isLerping;
    private Vector3 startPosition, endPosition;
    private float lerpPosTimer, lerpPosSpeed;
    public Vector2 lerpPosSpeedMinMax;
    public AnimationCurve lerpPosAnimCurve;
    public int lerpPosBand;
  //  private float timeStartedLerping;

    private int number;
    private int currentIteration;
    private TrailRenderer trailRenderer;

    private Vector2 CalculatePhyllotaxis(float _degree, float _scale, int _count)
    {
        double angle = _count * (_degree * Mathf.Deg2Rad);
        float r = _scale * Mathf.Sqrt(_count);
        float x = r * (float)System.Math.Cos(angle);
        float y = r * (float)System.Math.Sin(angle);
        Vector2 vec2 = new Vector2(x, y);
        return vec2;
    }

    private Vector2 phyllotaxisPosition;
    // Start is called before the first frame update
    void Start()
    {

    }
    
    void SetLerpPositions()
    {
       // isLerping = true;
       // timeStartedLerping = Time.time;

        phyllotaxisPosition = CalculatePhyllotaxis(degree, scale, number);
        startPosition = this.transform.localPosition;
        endPosition = new Vector3(phyllotaxisPosition.x, phyllotaxisPosition.y, 0);

    }

    private void Awake()
    {

        trailRenderer = GetComponent<TrailRenderer>();
        trailMat = new Material(trailRenderer.material);
        trailMat.SetColor("_TintColor", trailColor);
        trailRenderer.material = trailMat;


        number = numberStart;
        transform.localPosition = CalculatePhyllotaxis(degree, scale, number);
        if (useLerping)
        {
            isLerping = true;
            SetLerpPositions();
        }
    }

    /*
    private void FixedUpdate()
    {
        if (useLerping)
        {
            if (isLerping)
            {
                float timeSinceStarted = Time.time - timeStartedLerping;
                float percentageComplete = timeSinceStarted / intervalLerp;
                transform.localPosition = Vector3.Lerp(startPosition, endPosition, percentageComplete);
                if(percentageComplete >= 0.97f)
                {
                    transform.localPosition = endPosition;
                    number += stepSize;
                    currentIteration++;

                    if(currentIteration <= maxIteration)
                    {
                        StartLerping();
                    }
                    else
                    {
                        isLerping = false;
                    }
                }
            }
        }
        else
        {
            phyllotaxisPosition = CalculatePhyllotaxis(degree, scale, number);
            transform.localPosition = new Vector3(phyllotaxisPosition.x, phyllotaxisPosition.y, 0);
            number+= stepSize;
            currentIteration++;
        }
    }*/

    // Update is called once per frame
    void Update()
    {
        /*
        if (Input.GetKey(KeyCode.Space))
        {
            phyllotaxisPosition = CalculatePhyllotaxis(degree, scale, number);
            GameObject dotInstance = (GameObject)Instantiate(dot);
            dotInstance.transform.position = new Vector3(phyllotaxisPosition.x, phyllotaxisPosition.y, 0);
            dotInstance.transform.localScale = new Vector3(dotScale, dotScale, dotScale);
            n++;
        }*/

        if (useLerping)
        {
            if (isLerping)
            {
                lerpPosSpeed = Mathf.Lerp(lerpPosSpeedMinMax.x, lerpPosSpeedMinMax.y, lerpPosAnimCurve.Evaluate(audioPeer._audioBand[lerpPosBand]));
                lerpPosTimer += Time.deltaTime * lerpPosSpeed;
                transform.localPosition = Vector3.Lerp(startPosition, endPosition, Mathf.Clamp01(lerpPosTimer));
                if(lerpPosTimer >= 1)
                {
                    lerpPosTimer -= 1;
                    number += stepSize;
                    currentIteration++;
                    SetLerpPositions();
                }
            }
        }
        if(!useLerping)
        {
            phyllotaxisPosition = CalculatePhyllotaxis(degree, scale, number);
            transform.localPosition = new Vector3(phyllotaxisPosition.x, phyllotaxisPosition.y, 0);
            number += stepSize;
            currentIteration++;
        }


    }
}
