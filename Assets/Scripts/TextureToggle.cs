using UnityEngine;

public class TextureToggle : MonoBehaviour
{
    public Material texturedMaterial;   // Assign this in the inspector
    public Material untexturedMaterial; // Assign this in the inspector
    private Renderer objRenderer;       // To hold the Renderer component
    private bool isTextured = true;     // Toggle state

    void Start()
    {
        // Get the Renderer component of the object
        objRenderer = GetComponent<Renderer>();
        if (objRenderer == null)
        {
            Debug.LogError("No Renderer component found on this GameObject.");
        }
    }

    void Update()
    {
        // Toggle on key press (e.g., "T" key)
        if (Input.GetKeyDown(KeyCode.T))
        {
            ToggleTexture();
        }
    }

    void ToggleTexture()
    {
        // Toggle the texture state
        isTextured = !isTextured;

        // Apply the appropriate material
        if (objRenderer != null)
        {
            objRenderer.material = isTextured ? texturedMaterial : untexturedMaterial;
        }
    }
}
