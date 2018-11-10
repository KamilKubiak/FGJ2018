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

    public Path RetrivePath()
    {
        return null;

    }


}

