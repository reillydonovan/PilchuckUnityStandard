//-----------------------------------------------------------------------
// <copyright file="FireAudio.cs" company="IDIA Lab">
//     Copyright (c) IDIA Lab. All rights reserved.
// </copyright>
// <summary>This is the FireAudio component. Attach to a GameObject and hear fire.</summary>
//-----------------------------------------------------------------------
namespace IDIA.ATK.Audio
{
    using ATKSharp;
    using ATKSharp.Generators;
    using ATKSharp.Generators.Noise;
    using ATKSharp.Modifiers;
    using UnityEngine;

    /// <summary>
    /// The FireAudio component.
    /// Attach to a GameObject and hear fire.
    /// </summary>
    [RequireComponent(typeof(AudioSource))]
    public class FireAudio : MonoBehaviour
    {
        #region Fields
        /// <summary>
        /// The base noise low cutoff.
        /// </summary>
        [Header("Base Fire Noise")]
        [Range(0f, 20000f)]
        [SerializeField]
        private float baseNoiseLowCutoff = 100f;

        /// <summary>
        /// The base noise high cutoff.
        /// </summary>
        [Range(0f, 20000f)]
        [SerializeField]
        private float baseNoiseHighCutoff = 3000f;

        /// <summary>
        /// The base noise amplitude.
        /// </summary>
        [Range(0f, 1f)]
        [SerializeField]
        private float baseNoiseAmplitude = .05f;

        /// <summary>
        /// The minimum crackle duration.
        /// </summary>
        [Header("Crackle")]
        [SerializeField]
        private float minCrackleDuration = 2f;

        /// <summary>
        /// The maximum crackle duration.
        /// </summary>
        [SerializeField]
        private float maxCrackleDuration = 12f;
        
        /// <summary>
        /// The duration of the crackle.
        /// </summary>
        [Range(.1f, 20f)]
        [SerializeField]
        private float crackleResonance = 12f;

        /// <summary>
        /// The base <see cref="WhiteNoise"/> generator.
        /// </summary>
        private WhiteNoise baseNoise;

        /// <summary>
        /// The base noise <see cref="LowPass"/> filter.
        /// </summary>
        private LowPass baseNoiseLowPass;

        /// <summary>
        /// The base noise <see cref="HighPass"/> filter.
        /// </summary>
        private HighPass baseNoiseHighPass;

        /// <summary>
        /// The <see cref="FireCracklePop"/>.
        /// </summary>
        private FireCracklePop crackle;

        /// <summary>
        /// The crackle trigger <see cref="ImpulseGenerator"/> generator.
        /// </summary>
        private ImpulseGenerator crackleTrigger;

        /// <summary>
        /// The previous crackle trigger state.
        /// </summary>
        private float previousCrackleTriggerState = 0f;

        /// <summary>
        /// The gas <see cref="WhiteNoise"/> generator.
        /// </summary>
        private WhiteNoise gasNoise;

        /// <summary>
        /// The first gas <see cref="LowPass"/> filter.
        /// </summary>
        private LowPass gasLowPass1;

        /// <summary>
        /// The second gas <see cref="LowPass"/> filter.
        /// </summary>
        private LowPass gasLowPass2;

        /// <summary>
        /// The gas <see cref="HighPass"/> filter.
        /// </summary>
        private HighPass gasHighPass;

        /// <summary>
        /// The gas amplitude.
        /// </summary>
        [Range(0f, 1f)]
        [SerializeField]
        private float gasAmplitude = .001f;

        /// <summary>
        /// The first gas low <see cref="Biquad"/> filter.
        /// </summary>
        private Biquad gasLowBiquad1;

        /// <summary>
        /// The second gas low <see cref="Biquad"/> filter.
        /// </summary>
        private Biquad gasLowBiquad2;

        /// <summary>
        /// The gas high <see cref="Biquad"/> filter.
        /// </summary>
        private Biquad gasHighBiquad;

        /// <summary>
        /// The <see cref="System.Random"/> number generator.
        /// </summary>
        private System.Random rand;
        #endregion

        #region Properties
        /// <summary>
        /// Gets or sets the base noise low cutoff.
        /// </summary>
        public float BaseNoiseLowCutoff
        {
            get
            {
                return this.baseNoiseLowCutoff;
            }

            set
            {
                if (value >= 0 && value <= 20000)
                {
                    this.baseNoiseLowCutoff = value;
                }
            }
        }

        /// <summary>
        /// Gets or sets the base noise high cutoff.
        /// </summary>
        public float BaseNoiseHighCutoff
        {
            get
            {
                return this.baseNoiseHighCutoff;
            }

            set
            {
                if (value >= 0 && value <= 20000)
                {
                    this.baseNoiseHighCutoff = value;
                }
            }
        }

        /// <summary>
        /// Gets or sets the base noise amplitude.
        /// </summary>
        public float BaseNoiseAmplitude
        {
            get
            {
                return this.baseNoiseAmplitude;
            }

            set
            {
                if (value >= 0 && value <= 20000)
                {
                    this.baseNoiseAmplitude = value;
                }
            }
        }

        /// <summary>
        /// Gets or sets the minimum crackle duration.
        /// </summary>
        public float MinCrackleDuration
        {
            get
            {
                return this.minCrackleDuration;
            }

            set
            {
                this.minCrackleDuration = value;
            }
        }

        /// <summary>
        /// Gets or sets the maximum crackle duration.
        /// </summary>
        public float MaxCrackleDuration
        {
            get
            {
                return this.maxCrackleDuration;
            }

            set
            {
                this.maxCrackleDuration = value;
            }
        }

        /// <summary>
        /// Gets or sets the duration of the crackle.
        /// </summary>
        public float CrackleResonance
        {
            get
            {
                return this.crackleResonance;
            }

            set
            {
                if (value >= .1f && value <= 20f)
                {
                    this.crackleResonance = value;
                }
            }
        }

        /// <summary>
        /// Gets or sets the gas amplitude.
        /// </summary>
        public float GasAmplitude
        {
            get
            {
                return this.gasAmplitude;
            }

            set
            {
                if (value >= 0f && value <= 1f)
                {
                    this.gasAmplitude = value;
                }
            }
        }
        #endregion

        #region Methods
        /// <summary>
        /// Awake is called when the script instance is being loaded.
        /// </summary>
        private void Awake()
        {
            Application.runInBackground = true;
        }

        /// <summary>
        /// Start is called on the frame when a script is enabled just before any of the Update methods are called the first time.
        /// </summary>
        private void Start()
        {
            this.baseNoise = new WhiteNoise();
            this.baseNoiseLowPass = new LowPass(this.BaseNoiseLowCutoff);
            this.baseNoiseHighPass = new HighPass(this.BaseNoiseHighCutoff);
            this.crackle = new FireCracklePop();
            this.crackleTrigger = new ImpulseGenerator(60f);
            this.crackleTrigger.PulseDeviation = 1f;
            this.crackleTrigger.BurstMasking = .8f;
            this.gasNoise = new WhiteNoise();
            this.gasLowPass1 = new LowPass(1f);
            this.gasLowBiquad2 = new Biquad(ModifierType.LowPass, 2500f, 1f, 1f);
            this.gasHighBiquad = new Biquad(ModifierType.HighPass, 1000f, 1f, 1f);
            this.rand = new System.Random();
        }

        /// <summary>
        /// Update is called every frame, if the <see cref="MonoBehaviour"/> is enabled.
        /// </summary>
        private void Update()
        {
            this.baseNoiseLowPass.Frequency = this.BaseNoiseLowCutoff;
            this.baseNoiseHighPass.Frequency = this.BaseNoiseHighCutoff;
            this.crackle.Butterworth.Bandwidth = this.CrackleResonance;
        }

        /// <summary>
        /// OnAudioFilterRead is called every time a chunk of audio is sent to the filter.
        /// </summary>
        /// <param name="data">An array of floats comprising the audio data.</param>
        /// <param name="channels">An <see cref="System.Int32"/> that stores the number of channels of audio data passed to this delegate.</param>
        private void OnAudioFilterRead(float[] data, int channels)
        {
            for (int i = 0; i < data.Length; i += channels)
            {
                float currentSample = this.baseNoise.Generate() * this.BaseNoiseAmplitude;
                float lowPassBaseNoise = this.baseNoiseLowPass.Modify(currentSample);
                float highPassBaseNoise = this.baseNoiseHighPass.Modify(currentSample);
                if (this.crackleTrigger.Generate() == 1 && this.previousCrackleTriggerState == 0)
                {
                    float durationMS = ((float)this.rand.NextDouble() * (this.MaxCrackleDuration - this.MinCrackleDuration)) + this.MinCrackleDuration;
                    this.crackle.Duration = durationMS * 0.001f * ATKSettings.SampleRate;
                    this.crackle.Amplitude = (float)this.rand.NextDouble() * .3f;
                    this.crackle.Butterworth.Frequency = (durationMS * 1000) + 2500;
                    this.crackle.DecrementValue = 1 / this.crackle.Duration;
                    this.crackle.EnvelopeValue = 1f;
                }

                this.previousCrackleTriggerState = this.crackleTrigger.CurrentSample;
                currentSample += lowPassBaseNoise + highPassBaseNoise;
                this.crackle.EnvelopeValue -= this.crackle.DecrementValue;
                if (this.crackle.EnvelopeValue <= 0)
                {
                    this.crackle.EnvelopeValue = 0;
                }

                float crackleSample = this.crackle.Butterworth.Modify(this.baseNoise.CurrentSample) * (float)(this.crackle.EnvelopeValue * this.crackle.EnvelopeValue) * this.crackle.Amplitude;
                currentSample += crackleSample;
                float gasNoiseSample = this.gasNoise.Generate();
                float gasLowPassNoise = this.gasLowPass1.Modify(gasNoiseSample) * 10;
                gasLowPassNoise = gasLowPassNoise * gasLowPassNoise;
                gasLowPassNoise = gasLowPassNoise * gasLowPassNoise;
                gasLowPassNoise *= 600;
                float filteredGasNoise = this.gasHighBiquad.Modify(gasNoiseSample) * gasLowPassNoise;
                float gasSample = this.gasLowBiquad2.Modify(filteredGasNoise);
                currentSample += gasSample * this.GasAmplitude;
                for (int j = 0; j < channels; j++)
                {
                    data[i + j] = currentSample;
                }
            }
        }
        #endregion

        #region Classes
        /// <summary>
        /// The FireCracklePop class.
        /// </summary>
        private class FireCracklePop
        {
            #region Constructors
            /// <summary>
            /// Initializes a new instance of the <see cref="FireCracklePop"/> class.
            /// </summary>
            /// <param name="duration">The duration.</param>
            /// <param name="decrementValue">The decrement value.</param>
            /// <param name="amplitude">The amplitude.</param>
            public FireCracklePop(double duration = 1f, double decrementValue = 1, float amplitude = 1f)
            {
                this.Duration = duration;
                this.DecrementValue = decrementValue;
                this.Amplitude = amplitude;
                this.Butterworth = new Butterworth();
            } 
            #endregion

            #region Properties
            /// <summary>
            /// Gets or sets the duration.
            /// </summary>
            public double Duration
            {
                get; set;
            }

            /// <summary>
            /// Gets or sets the decrement value.
            /// </summary>
            public double DecrementValue
            {
                get; set;
            }

            /// <summary>
            /// Gets or sets the amplitude.
            /// </summary>
            public float Amplitude
            {
                get; set;
            }

            /// <summary>
            /// Gets or sets the envelope value.
            /// </summary>
            public double EnvelopeValue
            {
                get; set;
            }

            /// <summary>
            /// Gets or sets the <see cref="Butterworth"/> filter.
            /// </summary>
            public Butterworth Butterworth
            {
                get; set;
            } 
            #endregion
        }
        #endregion
    }
}