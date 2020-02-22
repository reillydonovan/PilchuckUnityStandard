//-----------------------------------------------------------------------
// <copyright file="WindAudio.cs" company="IDIA Lab">
//     Copyright (c) IDIA Lab. All rights reserved.
// </copyright>
// <summary>This is the WindAudio component. Attach to a GameObject and hear wind.</summary>
//-----------------------------------------------------------------------
namespace IDIA.ATK.Audio
{
    using ATKSharp.Generators.Noise;
    using ATKSharp.Modifiers;
    using UnityEngine;

    /// <summary>
    /// The WindAudio component.
    /// Attach to a GameObject and hear wind.
    /// </summary>
    [RequireComponent(typeof(AudioSource))]
    public class WindAudio : MonoBehaviour
    {
        #region Fields
        /// <summary>
        /// The base noise low cutoff.
        /// </summary>
        [Header("Base Wind Noise")]
        [Range(0f, 20000f)]
        [SerializeField]
        private float baseNoiseLowCutoff = 100f;

        /// <summary>
        /// The base noise amplitude.
        /// </summary>
        [Range(0f, 1f)]
        [SerializeField]
        private float baseNoiseAmplitude = .05f;

        /// <summary>
        /// The base <see cref="WhiteNoise"/> generator.
        /// </summary>
        private WhiteNoise baseNoise;

        /// <summary>
        /// The base noise <see cref="LowPass"/> filter.
        /// </summary>
        private LowPass baseNoiseLowPass;
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
                if (value >= 0f && value <= 20000f)
                {
                    this.baseNoiseLowCutoff = value;
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
                if (value >= 0f && value <= 1f)
                {
                    this.baseNoiseAmplitude = value;
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
        }

        /// <summary>
        /// Update is called every frame, if the <see cref="MonoBehaviour"/> is enabled.
        /// </summary>
        private void Update()
        {
            this.baseNoiseLowPass.Frequency = this.BaseNoiseLowCutoff;
            this.BaseNoiseAmplitude = .001f + Mathf.PingPong(Time.time * .007f, .01f) + Mathf.PingPong(Time.time * .0022f, .01f);
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
                currentSample += lowPassBaseNoise;
                for (int j = 0; j < channels; j++)
                {
                    data[i + j] = currentSample;
                }
            }
        } 
        #endregion
    }
}