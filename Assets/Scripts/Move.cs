using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Move : MonoBehaviour
{

    float zoom = 1f;
    void Update()
    {
        Vector3 mouse = Input.mousePosition;
        mouse = Camera.main.ScreenToWorldPoint(mouse);
        mouse.z = 0;
        transform.position = mouse;

        zoom += Input.mouseScrollDelta.y * 25f * Time.deltaTime;
        if (zoom < 0.25f) zoom = 0.25f;
        if (zoom > 20f) zoom = 20f;
        transform.localScale = Vector3.one * zoom;
    }
}
