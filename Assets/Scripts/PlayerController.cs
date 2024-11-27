using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement; // Required for scene management

public class PlayerController : MonoBehaviour
{
    float xforce;
    float zforce;

    Vector3 playerRot;
    Vector3 cameraRot;

    [SerializeField] float moveSpeed = 2;
    [SerializeField] float lookSpeed = 2;
    [SerializeField] GameObject cam;

    Rigidbody rb;

    [SerializeField] Vector3 boxSize;
    [SerializeField] float maxDistance;
    [SerializeField] LayerMask layerMask;
    [SerializeField] float jumpForce = 3;
    [SerializeField] GameObject bullethole;

    RaycastHit hit;

    [SerializeField] float fireRate = 0.1f;

    bool canFire = true;

    AudioSource aud;
    [SerializeField] ParticleSystem gunfire;

    // Player stats and game conditions
    [SerializeField] int playerHitPoints = 10;
    [SerializeField] int damagePerHit = 1;
    [SerializeField] int victoryEnemyCount = 10; // Number of enemies to defeat for victory
    int enemiesDestroyed = 0;

    // Scene names for victory and defeat screens
    [SerializeField] string victorySceneName = "VictoryScene";
    [SerializeField] string defeatSceneName = "DefeatScene";

    [SerializeField] private TMP_Text hitPointsText;
    [SerializeField] private TMP_Text enemiesText;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        aud = GetComponent<AudioSource>();
    }

    void Update()
    {
        hitPointsText.text = "HP: " + playerHitPoints.ToString();
        enemiesText.text = "Kills: " + enemiesDestroyed.ToString();

        if (playerHitPoints > 0 || enemiesDestroyed < 35)
        {
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }

        if (playerHitPoints <= 0)
        {
            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;
        }
        

        PlayerMovement();
        LookAround();

        if (GroundCheck() && Input.GetKeyDown(KeyCode.Space))
        {
            rb.AddForce(transform.up * jumpForce);
        }

        if (Input.GetMouseButton(0) && canFire)
        {
            Physics.Raycast(cam.transform.position, cam.transform.forward, out hit, 300f);
            aud.Play();
            gunfire.Play();
            if (hit.collider != null && hit.collider.CompareTag("Enemy"))
            {
                Destroy(hit.collider.gameObject);
                enemiesDestroyed++; // Increment enemy counter
                CheckVictoryCondition(); // Check if victory condition is met
            }
            else if (hit.collider != null)
            {
                GameObject bullet = Instantiate(bullethole, hit.point, Quaternion.FromToRotation(Vector3.up, hit.normal));
            }
            canFire = false;
            Invoke("FireRateReset", fireRate);
        }

        // Debug log to show player's current hit points and destroyed enemies
        Debug.Log("Player HP: " + playerHitPoints + " | Enemies Destroyed: " + enemiesDestroyed);
    }

    void FireRateReset()
    {
        gunfire.Stop();
        canFire = true;
    }

    void LookAround()
    {
        cameraRot = cam.transform.rotation.eulerAngles;
        cameraRot.x += -Input.GetAxis("Mouse Y") * lookSpeed;
        cameraRot.x = Mathf.Clamp((cameraRot.x <= 180) ? cameraRot.x : -(360 - cameraRot.x), -80f, 80f);
        cam.transform.rotation = Quaternion.Euler(cameraRot);
        playerRot.y = Input.GetAxis("Mouse X") * lookSpeed;
        transform.Rotate(playerRot);
    }

    void PlayerMovement()
    {
        xforce = Input.GetAxis("Horizontal") * moveSpeed;
        zforce = Input.GetAxis("Vertical") * moveSpeed;
        rb.velocity = transform.forward * zforce + transform.right * xforce + transform.up * rb.velocity.y;
    }

    void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawCube(transform.position - transform.up * maxDistance, boxSize);
    }

    bool GroundCheck()
    {
        if (Physics.BoxCast(transform.position, boxSize, -transform.up, transform.rotation, maxDistance, layerMask))
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    // Collision detection to reduce hit points on enemy collision
    private void OnCollisionEnter(Collision collision)
    {
        if (collision.collider.CompareTag("Enemy"))
        {
            playerHitPoints -= damagePerHit; // Reduce hit points
            Debug.Log("Player hit by enemy! Current HP: " + playerHitPoints);

            // Check if player's hit points have reached zero
            if (playerHitPoints <= 0)
            {
                TriggerDefeat(); // Load defeat scene
            }
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("HealthPickup"))
        {
            playerHitPoints = playerHitPoints + 1;
            // Increase hit points
            Debug.Log("Player hit by enemy! Current HP: " + playerHitPoints);
            Destroy(other.gameObject);
        }
    }

    // Method to check if the victory condition is met
    void CheckVictoryCondition()
    {
        if (enemiesDestroyed >= victoryEnemyCount)
        {
            SceneManager.LoadScene(victorySceneName); // Load victory screen
            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;

        }
    }

    // Method to trigger defeat and load the defeat scene
    void TriggerDefeat()
    {
        Debug.Log("Player is defeated!");
        SceneManager.LoadScene(defeatSceneName);
    }
}

