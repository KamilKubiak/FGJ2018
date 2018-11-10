using System.Collections;
using System.Linq;
using System.Collections.Generic;
using UnityEngine;
using System;

[System.Serializable]
public class Path
{
    public List<Waypoint> waypoints;
    public Waypoint GetNextWaypoint(Waypoint current)
    {
        if (current == null)
        {
            return waypoints.FirstOrDefault();
        }
        var currentIndex = waypoints.IndexOf(current) + 1;
        return currentIndex < waypoints.Count ? waypoints[currentIndex] : null;
    }

    public Destination destination;

    public bool IsWaypointOnPath(Waypoint wp)
    {
        return waypoints.Contains(wp);
    }

}
public class Waypoint : MonoBehaviour
{
    int caseMask;
    public MeshRenderer meshRend;

    Dictionary<Material, Color> defaultColors;
    public bool Occupied
    {
        get
        {
            Debug.Log(transform.name + " is occupied " + Physics.CheckCapsule(transform.position, transform.position + Vector3.up, .5f, caseMask));
            return Physics.CheckCapsule(transform.position, transform.position + Vector3.up, .5f, caseMask);
        }
    }

    private void Awake()
    {
        defaultColors = new Dictionary<Material, Color>();
        foreach (var item in meshRend.materials)
        {
            defaultColors.Add(item, item.color);
        }
        caseMask = LayerMask.GetMask("Cases");
    }
    private void OnDrawGizmos()
    {
        Gizmos.color = Color.magenta;
        Gizmos.DrawRay(transform.position, Vector3.up);
    }
    public GameObject waypoint;
    public delegate void WaypointAction(Waypoint wp);
    public static event WaypointAction WaypointClicked;
    public float pathingTolerance = 0.1f;

    public bool MatchingPosition(Vector3 position)
    {
        return Vector3.Distance(WaypointPosition, position) <= pathingTolerance;
    }

    internal void IndicateOccupiedWaypoint()
    {
        StopCoroutine("FlashRed");
        StartCoroutine("FlashRed");
    }

    IEnumerator FlashRed()
    {
        float time = 0;
        Color color = Color.white;
        do
        {
            time += Time.deltaTime;
            color = Color.Lerp(Color.white, Color.red, time * 5f);
            foreach (var item in meshRend.materials)
            {
                item.color = color;
            }
            yield return null;
        } while (color != Color.red);
        time = 0;
        do
        {
            time += Time.deltaTime;

            foreach (var item in meshRend.materials)
            {
                color = Color.Lerp(Color.red, defaultColors[item], time * 5f);
                item.color = color;
            }
            color = Color.Lerp(Color.red, Color.white, time * 5f);
            yield return null;
        } while (color != Color.white);
    }

    private void OnMouseDown()
    {
        if (WaypointClicked != null)
        {
            WaypointClicked(this);
        }
    }

    public Vector3 WaypointPosition { get { return waypoint.transform.position; } }

    private void Update()
    {
        Debug.Log(transform.name + " is occupied " + Physics.CheckCapsule(transform.position, transform.position + Vector3.up, 1, caseMask));
    }

}
