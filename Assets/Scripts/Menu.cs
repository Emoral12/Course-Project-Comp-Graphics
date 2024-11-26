using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Menu : MonoBehaviour
{
    public void BackToMenu()
    {
        SceneManager.LoadScene(1);
    }
    
    public void LoadScene()
    {
        SceneManager.LoadScene(3); 
    }

    public void ControlMenu()
    {
        SceneManager.LoadScene(4);
    }

    public void QuitGame()
    {
        Application.Quit();
    }
}
