//-----------------------------------------------------------------------
// <copyright file="ChimeAudio.cs" company="IDIA Lab">
//     Copyright (c) IDIA Lab. All rights reserved.
// </copyright>
// <summary>This is the ChimeAudio component. Attach to a GameObject and hear it chime when something collides with it.</summary>
//-----------------------------------------------------------------------
namespace IDIA.ATK.Audio
{
    using System.Collections;
    using ATKSharp.Envelopes;
    using ATKSharp.Generators.Oscillators.Wavetable;
    using UnityEngine;

    /// <summary>
    /// The ChimeAudio component. 
    /// Attach to a GameObject and hear it chime when something collides with it.
    /// </summary>
    [RequireComponent(typeof(AudioSource))]
    public class ChimeAudio : MonoBehaviour
    {
        #region Fields
        /// <summary>
        /// The chime frequency in Hertz.
        /// </summary>
        [Header("Chime")]
        [Range(0f, 20000f)]
        [SerializeField]
        private float chimeHz = 528f;

        /// <summary>
        /// The chime amplitude.
        /// </summary>
        [Range(0f, 1f)]
        [SerializeField]
        private float chimeAmplitude = 1f;

        /// <summary>
        /// The sine wave generator.
        /// </summary>
        private WTSine chimeGenerator;

        /// <summary>
        /// The envelope.
        /// </summary>
        private CTEnvelope chimeEnvelope;
        #endregion

        #region Properties
        /// <summary>
        /// Gets or sets the chime frequency.
        /// </summary>
        public float ChimeHz
        {
            get
            {
                return this.chimeHz;
            }

            set
            {
                if (value >= 0f && value <= 20000f)
                {
                    this.chimeHz = value;
                }
            }
        }

        /// <summary>
        /// Gets or sets the chime amplitude.
        /// </summary>
        public float ChimeAmplitude
        {
            get
            {
                return this.chimeAmplitude;
            }

            set
            {
                if (value >= 0f && value <= 1f)
                {
                    this.chimeAmplitude = value;
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
            this.chimeGenerator = new WTSine(this.ChimeHz);
            this.chimeEnvelope = new CTEnvelope(20, 5, .7f, 3000);
        }

        /// <summary>
        /// Update is called every frame, if the <see cref="MonoBehaviour"/> is enabled.
        /// </summary>
        private void Update()
        {
            this.chimeGenerator.Frequency = this.ChimeHz;
        }

        /// <summary>
        /// OnCollisionEnter is called when this <see cref="Collider"/>/<see cref="Rigidbody"/> has begun touching another <see cref="Rigidbody"/>/<see cref="Collider"/>.
        /// </summary>
        /// <param name="collision">The Collision data associated with this collision.</param>
        private void OnCollisionEnter(Collision collision)
        {
            this.StartCoroutine(this.Chime());
            this.ChimeAmplitude = Mathf.Clamp01(collision.relativeVelocity.magnitude) * .7f;
        }

        /// <summary>
        /// Chime is a <see cref="Coroutine"/> that opens and closes the <see cref="chimeEnvelope"/>'s gate when called.
        /// </summary>
        /// <returns>The IEnumerator.</returns>
        private IEnumerator Chime()
        {
            this.chimeEnvelope.Gate = 1;
            yield return new WaitForSeconds(.1f);
            this.chimeEnvelope.Gate = 0;
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
                float currentSample = this.chimeEnvelope.Generate() * this.chimeGenerator.Generate() * this.ChimeAmplitude;
                for (int j = 0; j < channels; j++)
                {
                    data[i + j] = currentSample;
                }
            }
        }
        #endregion
    }
}