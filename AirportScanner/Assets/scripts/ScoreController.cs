using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScoreController : Singleton<ScoreController>
{
    private void Start()
    {
        Case.CaseSent += OnCaseSent;
        Case.CaseDestroyed += OnCaseDestroyed;
    }

    void OnCaseSent(Contraband[] contrabandHeld, Case target)
    {

    }

    void OnCaseDestroyed(Contraband[] contrabandHeld, Case target)
    {

    }
}