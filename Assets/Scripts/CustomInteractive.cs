using System.Collections;
using System.Collections.Generic;
using SpatialSys.UnitySDK.Internal;
using UnityEngine;

namespace SpatialSys.UnitySDK
{
    public class CustomInteractive : MonoBehaviour
    {
        // Start is called before the first frame update
        public float rotateSpeed = 50f;
        void Update()
        {
            //transform.Rotate(Vector3.up * Time.deltaTime * rotateSpeed);
        }
        private void Start()
        {
            //SpatialBridge.spatialComponentService.InitializeInteractable(this);
        }
        
        void onInteractEvent()
        {
            transform.Rotate(Vector3.up * Time.deltaTime * rotateSpeed);
        }

        void onEnterEvent()
        {
            transform.Rotate(Vector3.up * Time.deltaTime * rotateSpeed);
        }
    }
}
