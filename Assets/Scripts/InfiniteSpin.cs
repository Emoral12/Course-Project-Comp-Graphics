using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InfiniteSpin : MonoBehaviour
{
    public Vector3 rotationSpeed = new Vector3(0f, 100f, 10f);

    void Update()
    {
        // Rotate the GameObject based on the rotation speed and deltaTime
        transform.Rotate(rotationSpeed * Time.deltaTime);
    }
}
