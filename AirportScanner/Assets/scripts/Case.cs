using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Case : MonoBehaviour {



    Path currentPath;
    Waypoint nextWaypoint;
    public static bool CaseHeld;
    Vector3 LiftedPosition = new Vector3(0, 3, 0);
    float speed = 0.5f;

    public Path CurrentPath
    {
        get
        {
            return currentPath;
        }

        set
        {
            PlaceCaseOnPath(value);
        }
    }



    private void OnMouseDown()
    {
        if (CaseHeld)
        {
            return;
        }
        CaseHeld = true;
        LiftFromConveyor();
        Waypoint.WaypointClicked += Waypoint_WaypointClicked;
        ContrabandTrash.OnTrashClicked+= ContrabandTrash_OnTrashClicked ;
    }

    void ContrabandTrash_OnTrashClicked()
    {
        Waypoint.WaypointClicked -= Waypoint_WaypointClicked;
        CaseHeld = false;
        ContrabandTrash.OnTrashClicked -= ContrabandTrash_OnTrashClicked;
        Destroy(gameObject);    
    }


    private void LiftFromConveyor()
    {
        CurrentPath = null;
        nextWaypoint = null;
        transform.position = LiftedPosition;
    }

    void Waypoint_WaypointClicked(Waypoint wp)
    {
        if(wp != null)
        {
            if (!wp.Occupied)
            {
                CaseHeld = false;
                var path = WaypointManager.Instance.FindWaypointPath(wp);
                PlaceCaseOnPath(path, wp);
                ContrabandTrash.OnTrashClicked -= ContrabandTrash_OnTrashClicked;
                Waypoint.WaypointClicked -= Waypoint_WaypointClicked;
            }
            else
            {
                wp.IndicateOccupiedWaypoint();
            }
        }

    }

    void PlaceCaseOnPath(Path path,Waypoint startingWaypoint = null)
    {
        if (path == null)
        {

            return;
        }
        currentPath = path;
        if (startingWaypoint != null)
        {
            transform.position = startingWaypoint.WaypointPosition; nextWaypoint = path.GetNextWaypoint(startingWaypoint);
        }
        else
        {
            startingWaypoint = path.GetNextWaypoint(startingWaypoint);
            transform.position = startingWaypoint.WaypointPosition;
            nextWaypoint = path.GetNextWaypoint(startingWaypoint);
        }

    }

    private void Update()
    {
        if (currentPath !=null && nextWaypoint != null)
        {

            transform.position = Vector3.MoveTowards(transform.position, nextWaypoint.WaypointPosition, speed * Time.deltaTime);
            if (nextWaypoint.MatchingPosition(transform.position))
            {
                nextWaypoint = currentPath.GetNextWaypoint(nextWaypoint);
            }
        }
    }

}
