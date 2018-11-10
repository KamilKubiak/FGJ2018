using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Case : MonoBehaviour {

    public delegate void CaseActions(Contraband[] contrabandHeld, Case target);
    public event CaseActions CaseDestroyed;
    public event CaseActions CaseSent;
    public Transform[] spawnPositions;
    float scale = 1;
    List<Contraband> contrabands;

    Path currentPath;
    Waypoint nextWaypoint;
    public static bool CaseHeld;
    Vector3 LiftedPosition = new Vector3(10, -0.5f, 14.5f);
    float speed = 0.5f;
    private MeshRenderer rend;

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

    public void SetupContraband(Contraband[] contrabands)
    {if (rend == null)
        {
            rend = GetComponentInChildren<MeshRenderer>();
        }
        this.contrabands = new List<Contraband>(contrabands);
        for (int i = 0; i < contrabands.Length; i++)
        {
            spawnPositions[i].transform.localScale = new Vector3(scale / spawnPositions[i].parent.localScale.x, scale / spawnPositions[i].parent.localScale.y, scale / spawnPositions[i].parent.localScale.z);
            if (SpawnManager.Instance.contrabandPrefabs.Count > (int)contrabands[i])
            {
                var obj = Instantiate(SpawnManager.Instance.contrabandPrefabs[(int)contrabands[i]], spawnPositions[i]);

                var childMesh = obj.GetComponentInChildren<MeshRenderer>();
                if (childMesh == null)
                {
                    childMesh = obj.GetComponent<MeshRenderer>();
                }

                Debug.Log(childMesh.transform.name);
                if(!rend.bounds.ContainBounds(childMesh.bounds))
                {
                    obj.transform.position = obj.transform.parent.parent.position;
                }
            }
        }

    }

    private void OnMouseDown()
    {
        if (CaseHeld)
        {
            return;
        }
        XrayControler.ShowXray = false;
        CaseHeld = true;
        LiftFromConveyor();
        Waypoint.WaypointClicked += Waypoint_WaypointClicked;
        ContrabandTrash.OnTrashClicked+= ContrabandTrash_OnTrashClicked;
    }

    void ContrabandTrash_OnTrashClicked()
    {
        Waypoint.WaypointClicked -= Waypoint_WaypointClicked;
        CaseHeld = false;
        XrayControler.ShowXray = true;
        ContrabandTrash.OnTrashClicked -= ContrabandTrash_OnTrashClicked;
        if (CaseDestroyed !=null)
        {
            CaseDestroyed(contrabands.ToArray(),this);
        }
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
                XrayControler.ShowXray = true;
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

    private void Start()
    {
        rend = GetComponentInChildren<MeshRenderer>();
    }

    private void Update()
    {
        if (currentPath !=null && nextWaypoint != null)
        {

            transform.position = Vector3.MoveTowards(transform.position, nextWaypoint.WaypointPosition, speed * Time.deltaTime);
            if (nextWaypoint.MatchingPosition(transform.position))
            {
                nextWaypoint = currentPath.GetNextWaypoint(nextWaypoint);
                if (nextWaypoint == null )
                {
                    if(CaseSent != null)
                    CaseSent(contrabands.ToArray(), this);
                    Destroy(gameObject);
                }
            }
        }
    }

}
