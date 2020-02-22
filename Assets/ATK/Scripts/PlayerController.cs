//-----------------------------------------------------------------------
// <copyright file="PlayerController.cs" company="IDIA Lab">
//     Copyright (c) IDIA Lab. All rights reserved.
// </copyright>
// <summary>This is the PlayerController component. Attach to a GameObject to make it move and rotate to user input.</summary>
//-----------------------------------------------------------------------
namespace IDIA.ATK.Demo
{
    using UnityEngine;

    /// <summary>
    /// The PlayerController component.
    /// Attach to a GameObject to make it move and rotate to user input.
    /// </summary>
    public class PlayerController : MonoBehaviour
    {
        #region Fields
        /// <summary>
        /// The Character Controller component.
        /// </summary>
        [SerializeField]
        private CharacterController controller;

        /// <summary>
        /// The movement speed.
        /// </summary>
        [SerializeField]
        private float movementSpeed = .1f;

        /// <summary>
        /// The strafe speed.
        /// </summary>
        [SerializeField]
        private float strafeSpeed = .05f;

        /// <summary>
        /// The rotation speed around the X axis.
        /// </summary>
        [SerializeField]
        private float xRotationSpeed = .1f;

        /// <summary>
        /// The rotation speed around the Y axis.
        /// </summary>
        [SerializeField]
        private float yRotationSpeed = .3f;

        /// <summary>
        /// The movement to apply.
        /// </summary>
        private Vector3 movement = Vector3.zero;

        /// <summary>
        /// The rotation to apply.
        /// </summary>
        private Vector2 rotation = Vector2.zero;

        /// <summary>
        /// The previous mouse position.
        /// </summary>
        private Vector3 previousMousePosition;
        #endregion

        #region Properties
        /// <summary>
        /// Gets or sets the Character Controller component.
        /// </summary>
        public CharacterController Controller
        {
            get
            {
                return this.controller;
            }

            set
            {
                this.controller = value;
            }
        }

        /// <summary>
        /// Gets or sets the movement speed.
        /// </summary>
        public float MovementSpeed
        {
            get
            {
                return this.movementSpeed;
            }

            set
            {
                this.movementSpeed = value;
            }
        }

        /// <summary>
        /// Gets or sets the strafe speed.
        /// </summary>
        public float StrafeSpeed
        {
            get
            {
                return this.strafeSpeed;
            }

            set
            {
                this.strafeSpeed = value;
            }
        }

        /// <summary>
        /// Gets or sets the rotation speed around the X axis.
        /// </summary>
        public float XRotationSpeed
        {
            get
            {
                return this.xRotationSpeed;
            }

            set
            {
                this.xRotationSpeed = value;
            }
        }

        /// <summary>
        /// Gets or sets the rotation speed around the Y axis.
        /// </summary>
        public float YRotationSpeed
        {
            get
            {
                return this.yRotationSpeed;
            }

            set
            {
                this.yRotationSpeed = value;
            }
        }
        #endregion

        #region Methods
        /// <summary>
        /// Update is called every frame, if the <see cref="MonoBehaviour"/> is enabled.
        /// </summary>
        private void Update()
        {
            this.movement = (transform.right * Input.GetAxis("Horizontal") * this.StrafeSpeed) + (transform.forward * Input.GetAxis("Vertical") * this.MovementSpeed);
            this.rotation = Input.mousePosition - this.previousMousePosition;
            this.previousMousePosition = Input.mousePosition;
        }

        /// <summary>
        /// Frame-rate independent <see cref="MonoBehaviour"/>.FixedUpdate message for physics calculations.
        /// </summary>
        private void FixedUpdate()
        {
            transform.Rotate(-this.rotation.y * this.XRotationSpeed, this.rotation.x * this.YRotationSpeed, 0f, Space.Self);
            transform.rotation = Quaternion.Euler(transform.rotation.eulerAngles.x, transform.rotation.eulerAngles.y, 0f);
            this.Controller.Move(this.movement);
        } 
        #endregion
    }
}