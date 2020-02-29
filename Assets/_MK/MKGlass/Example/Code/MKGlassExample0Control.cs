using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using MK.Glass;

namespace MK.Glass
{
    public class MKGlassExample0Control : MonoBehaviour
    {
        private int currentBumpMap = 0;
        private int currentAlbedoMap = 0;

        private static bool settingsUsed = false;
        public static bool SettingsUsed
        {
            get { return settingsUsed; }
        }

        [SerializeField]
        private GameObject albedoText;

        private int currentModel = -1;
        [SerializeField]
        private List<Material> baseMaterials = new List<Material>();
        private List<Material> currentMaterials = new List<Material>();

        [SerializeField]
        private List<GameObject> gameObjects = new List<GameObject>();
        private List<MeshRenderer> renderers = new List<MeshRenderer>();


        [SerializeField]
        private Slider albedoIntensitySlider;
        private float albedoIntensity;
        public float AlbedoIntensity
        {
            get { return albedoIntensity; }
            set
            {
                albedoIntensity = value;
                MKGlassMaterialHelper.SetMainTint(currentMaterials[currentModel], albedoIntensity);
            }
        }

        [SerializeField]
        private Slider bumpScaleSlider;
        private float bumpScale;
        public float BumpScale
        {
            get { return bumpScale; }
            set
            {
                bumpScale = value;
                MKGlassMaterialHelper.SetBumpScale(currentMaterials[currentModel], bumpScale);
            }
        }

        [SerializeField]
        private Slider distortionSlider;
        private float distortion;
        public float Distortion
        {
            get { return distortion; }
            set
            {
                distortion = value;
                MKGlassMaterialHelper.SetDistortion(currentMaterials[currentModel], distortion);
            }
        }

        [SerializeField]
        private Slider specularShininesSlider;
        private float specularShininess;
        public float SpecularShininess
        {
            get { return specularShininess; }
            set
            {
                specularShininess = value;
                MKGlassMaterialHelper.SetSpecularShininess(currentMaterials[currentModel], specularShininess);
            }
        }

        [SerializeField]
        private Slider specularIntensitySlider;
        private float specularIntensity;
        public float SpecularIntensity
        {
            get { return specularIntensity; }
            set
            {
                specularIntensity = value;
                MKGlassMaterialHelper.SetSpecularIntensity(currentMaterials[currentModel], specularIntensity);
            }
        }

        [SerializeField]
        private Slider rimSizeSlider;
        private float rimSize;
        public float RimSize
        {
            get { return rimSize; }
            set
            {
                rimSize = value;
                MKGlassMaterialHelper.SetRimSize(currentMaterials[currentModel], rimSize);
            }
        }
        [SerializeField]
        private Slider rimIntensitySlider;
        private float rimIntensity;
        public float RimIntensity
        {
            get { return rimIntensity; }
            set
            {
                rimIntensity = value;
                MKGlassMaterialHelper.SetRimIntensity(currentMaterials[currentModel], rimIntensity);
            }
        }

        [SerializeField]
        private Slider reflectionFresnelSlider;
        private float reflectionFresnel;
        public float ReflectionFresnel
        {
            get { return reflectionFresnel; }
            set
            {
                reflectionFresnel = value;
                MKGlassMaterialHelper.SetReflectionFresnelFactor(currentMaterials[currentModel], reflectionFresnel);
            }
        }
        [SerializeField]
        private Slider reflectionIntensitySlider;
        private float reflectionIntensity;
        public float ReflectionIntensity
        {
            get { return reflectionIntensity; }
            set
            {
                reflectionIntensity = value;
                MKGlassMaterialHelper.SetReflectIntensity(currentMaterials[currentModel], reflectionIntensity);
            }
        }

        [SerializeField]
        private Slider emissionIntensitySlider;
        private float emissionIntensity;
        public float EmissionIntensity
        {
            get { return emissionIntensity; }
            set
            {
                emissionIntensity = value;
                MKGlassMaterialHelper.SetEmissionColor(currentMaterials[currentModel], Color.Lerp(Color.black, new Color(2, 2, 2, 1), emissionIntensity));
            }
        }

        private void SetupMaterials()
        {
            currentMaterials.Clear();
            renderers.Clear();
            foreach (GameObject go in gameObjects)
            {
                renderers.Add(go.GetComponent<MeshRenderer>());
            }
            foreach (Material m in baseMaterials)
            {
                currentMaterials.Add(new Material(m));
            }
            for (int i = 0; i < renderers.Count; i++)
            {
                renderers[i].material = currentMaterials[i];
            }
        }

        private void Awake()
        {
            SetupMaterials();
            ChangeModel();
        }

        public void ChangeModel()
        {
            currentModel++;
            if (currentModel > gameObjects.Count - 1)
                currentModel = 0;
            foreach (GameObject go in gameObjects)
                go.SetActive(false);
            gameObjects[currentModel].SetActive(true);
            SetValuesFromMaterial();
            SetMaterialSettingsToSliders();

            if (currentModel == 0 || currentModel == 5 || currentModel == 6)
            {
                albedoText.SetActive(false);
                albedoIntensitySlider.gameObject.SetActive(false);
                emissionIntensitySlider.gameObject.SetActive(false);
            }
            else
            {
                albedoText.SetActive(true);
                albedoIntensitySlider.gameObject.SetActive(true);
                emissionIntensitySlider.gameObject.SetActive(true);
            }
        }

        private void SetMaterialSettingsToSliders()
        {
            albedoIntensitySlider.value = albedoIntensity;

            bumpScaleSlider.value = bumpScale;
            distortionSlider.value = distortion;

            specularShininesSlider.value = specularShininess;
            specularIntensitySlider.value = specularIntensity;

            rimSizeSlider.value = rimSize;
            rimIntensitySlider.value = rimIntensity;

            reflectionFresnelSlider.value = reflectionFresnel;
            reflectionIntensitySlider.value = reflectionIntensity;

            emissionIntensitySlider.value = emissionIntensity;
        }

        private void SetValuesFromMaterial()
        {
            albedoIntensity = MKGlassMaterialHelper.GetMainTint(currentMaterials[currentModel]);

            bumpScale = MKGlassMaterialHelper.GetBumpScale(currentMaterials[currentModel]);
            distortion = MKGlassMaterialHelper.GetDistortion(currentMaterials[currentModel]);

            specularShininess = MKGlassMaterialHelper.GetSpecularShininess(currentMaterials[currentModel]);
            specularIntensity = MKGlassMaterialHelper.GetSpecularIntensity(currentMaterials[currentModel]);

            rimSize = MKGlassMaterialHelper.GetRimSize(currentMaterials[currentModel]);
            rimIntensity = MKGlassMaterialHelper.GetRimIntensity(currentMaterials[currentModel]);

            reflectionFresnel = MKGlassMaterialHelper.GetReflectionFresnelFactor(currentMaterials[currentModel]);
            reflectionIntensity = MKGlassMaterialHelper.GetReflectIntensity(currentMaterials[currentModel]);

            emissionIntensity = MKGlassMaterialHelper.GetEmissionColor(currentMaterials[currentModel]).r / 2.0f;
        }

        private void Update()
        {

#if !UNITY_ANDROID || UNITY_EDITOR
            if (Input.GetMouseButtonDown(0) && UnityEngine.EventSystems.EventSystem.current.IsPointerOverGameObject())
            {
                settingsUsed = true;
            }

            if (Input.GetMouseButtonUp(0))
                settingsUsed = false;
#else
        Touch touch = Input.GetTouch(0);
        if (touch.phase == TouchPhase.Began && UnityEngine.EventSystems.EventSystem.current.IsPointerOverGameObject(touch.fingerId))
        {
            settingsUsed = true;
        }

        if (touch.phase == TouchPhase.Ended || touch.phase == TouchPhase.Canceled)
        {
            settingsUsed = false;
        }
#endif
        }
    }
}