using System.Collections;
using System.Linq;
using System.Collections.Generic;
using UnityEngine;
[System.Serializable]
public class Path{
    public List<Waypoint> waypoints;
    public Waypoint GetNextWaypoint(Waypoint current)
    {
        var currentIndex = waypoints.IndexOf(current)+1;
        return currentIndex < waypoints.Count ? waypoints[currentIndex] : null;
    }

}
public class Waypoint : MonoBehaviour {

    public float pathingTolerance = 0.3f;
    public bool MatchingPosition( Vector3 position)
    {
        return Vector3.Distance(transform.position,position) > pathingTolerance;
    }

}
