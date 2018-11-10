using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaypointManager : Singleton<WaypointManager> {

    public List<Path> paths;
    public Case casePrefab;

    public Path FindWaypointPath(Waypoint wp)
    {
        if (wp == null)
        {
            return null;

        }
        foreach (var item in paths)
        {
            if (item.IsWaypointOnPath(wp))
            {
                return item;
            }

        }
        return null;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            var suitcase = Instantiate(casePrefab).GetComponent<Case>();
            suitcase.CurrentPath = paths[0];
        }
    }


    public Path GetFreeStart()
    {
        var freeStarts = new List<Path>();
        foreach (var item in paths)
        {
            if (!item.waypoints[0].Occupied)
            {
                freeStarts.Add(item);
            }
        }
        if (freeStarts.Count>0)
        {
            return freeStarts[Random.Range(0, freeStarts.Count)];
        }
        return null;

    }


}

