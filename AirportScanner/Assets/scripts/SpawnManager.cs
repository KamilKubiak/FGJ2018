using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnManager : Singleton<SpawnManager> {

    public List<GameObject> contrabandPrefabs;
    public List<Case> casePrefabs;
    public int level;
    public float casesPerLevel = 5;
    private void Start()
    {
        StartLevel();
    }
    public void StartLevel()
    {
        LegalManager.Instance.GenerateAllContraband(level);
        StartCoroutine(SpawnLevel(level));
    }
	
    IEnumerator SpawnLevel(int level)
    {
        var amountOfCases = Mathf.RoundToInt(10 + level * casesPerLevel);

        while (amountOfCases>0)
        {
            var path = WaypointManager.Instance.GetFreeStart();
            if (path != null)
            {
                List<Contraband> contrabands = new List<Contraband>();
                var obj = Instantiate(casePrefabs[Random.Range(0, casePrefabs.Count)]);
                var slotCount = obj.spawnPositions.Length;
                for (int i = 0; i < slotCount; i++)
                {
                    contrabands.Add(LegalManager.Instance.AllContraband[Random.Range(0, LegalManager.Instance.AllContraband.Count)]);
                }
                obj.SetupContraband(contrabands.ToArray());
                obj.CurrentPath = path;
                amountOfCases--;
                float time = 0;
                var waitTime = Random.Range(0.5f, 4);
                while (time <= waitTime)
                {
                    yield return null;
                    time += Time.deltaTime;
                }
            }
            yield return null;

        }
        this.level++;
        StartLevel();
    }

}
