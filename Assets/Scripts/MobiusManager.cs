using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(MeshRenderer))]
public class MobiusManager : MonoBehaviour
{
    struct MobiusValue
    {
        public int divisions;
        public float stripWidth, radius, modulation, frequency;

        public MobiusValue(int _divisions, float _stripWidth, float _radius, 
            float _modulation, float _frequency)
        {
            divisions = _divisions;
            stripWidth = _stripWidth;
            radius = _radius;
            modulation = _modulation;
            frequency = _frequency;
          
        }

    }

    [Range(0.016f,30f)]
    public float timeFade = 10f;

    [Range(0, 120f)] 
    public float pauseTime = 10f;
    
    private List<MobiusValue> mobiusValues;
    private Mobious _mobius;
    private MeshRenderer _meshRenderer;
    private float startTime;
    private int mobiusIndex = 0;

    private MobiusValue currentValue;
    private MobiusValue targetValue;
    private bool _shouldAnimate = false;
    public bool ShouldAnimate
    {
        get => _shouldAnimate;
        set
        {
            _shouldAnimate = value;
            startTime = Time.time;
            if (value)
            {
                // lerp to next value.
                currentValue = targetValue;
                if (mobiusIndex < mobiusValues.Count - 1)
                {
                    mobiusIndex += 1;
                }
                else
                {
                    mobiusIndex = 0;
                }
                targetValue = mobiusValues.ToArray()[mobiusIndex];
            }
        }
    }

    
    // Start is called before the first frame update
    void Awake()
    {
        mobiusValues = new List<MobiusValue>();
        MobiusValue a2 = new MobiusValue(200, 5, 5, 5, 1.0f);
        MobiusValue a4 = new MobiusValue(200, 10, 10, 10, 5.0f);
        MobiusValue a5 = new MobiusValue(200, 15, 15, 15, 50.0f);
  
        mobiusValues.Add(a2); mobiusValues.Add(a4); mobiusValues.Add(a5);

        _mobius = GetComponent<Mobious>();

        _mobius.divisions = a2.divisions;
        _mobius.stripWidth = a2.stripWidth;
        _mobius.radius = a2.radius;
        _mobius.modulation = a2.modulation;
        _mobius.frequency = a2.frequency;

        currentValue = a2;
        targetValue = a2;
        startTime = Time.time;
    }

    // Update is called once per frame
    void Update()
    {
        float deltaTime = Time.time - startTime;
        if (_shouldAnimate)
        {
            float timeRatio = Mathf.Min(deltaTime / timeFade, 1.0f);
            _mobius.divisions = (int)Mathf.Lerp(currentValue.divisions, targetValue.divisions, timeRatio);
            _mobius.stripWidth = Mathf.Lerp(currentValue.stripWidth, targetValue.stripWidth, timeRatio);
           // _mobius.radius = Mathf.Lerp(currentValue.radius, targetValue.radius, timeRatio);
            _mobius.modulation = Mathf.Lerp(currentValue.modulation, targetValue.modulation, timeRatio);
            _mobius.frequency = Mathf.Lerp(currentValue.frequency, targetValue.frequency, timeRatio);
            _mobius.radius += this.GetComponent<Mobious>().radiusDisplacementAmount;
           
          //  _mobius.modulation += this.GetComponent<Mobious>().modulationDisplacmentAmount;
            _mobius.stripWidth += this.GetComponent<Mobious>().stripWidthDisplacementAmount;
           // _mobius.frequency += this.GetComponent<Mobious>().frequencyDisplacementAmount;
         
            if (timeRatio == 1.0f)
            {
                ShouldAnimate = false;
            }
        }
        else
        {
            if (deltaTime > pauseTime)
            {
                ShouldAnimate = true;
            }
        }
    }
}
