using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScoreController : Singleton<ScoreController>
{
    public delegate void ScoringActions();
    public static event ScoringActions ScoreAdded;
    public static event ScoringActions ScoreSubstracted;

    public int CasesLeft;
    public int Score;
    int scoreMultiplier = 1;

    private void Start()
    {
        Case.CaseSent += OnCaseSent;
        Case.CaseDestroyed += OnCaseDestroyed;
    }

    void OnCaseSent(Contraband[] contrabandHeld, Case target)
    {
        CasesLeft--;
        List<Contraband> gateReqs = new List<Contraband>();
        int illegalItems = 0;
        int scoringItems = 0;
        switch (target.CurrentPath.destination)
        {
            case Destination.Exinia:
                gateReqs = LegalManager.Instance.ToExinia;
                break;
            case Destination.Ygrandia:
                gateReqs = LegalManager.Instance.ToYgradnia;
                break;
            case Destination.Zeliland:
                gateReqs = LegalManager.Instance.ToZeliland;
                break;
            case Destination.Wouffia:
                gateReqs = LegalManager.Instance.ToWouffia;
                break;
        }
        foreach (Contraband c in contrabandHeld)
        {
            if (LegalManager.Instance.IllegalContraband.Contains(c)) illegalItems++;
            if (gateReqs.Contains(c)) scoringItems++;
        }

        if (illegalItems > 0)
        {
            SubstractPoints(illegalItems);
            return;
        }
        if (scoringItems == 0)
        {
            SubstractPoints(contrabandHeld.Length);
            return;
        }
        AddPoints(scoringItems * scoreMultiplier);
    }

    void OnCaseDestroyed(Contraband[] contrabandHeld, Case target)
    {
        CasesLeft--;
        int illegalItems = 0;
        int scoringItems = 0;

        foreach (Contraband c in contrabandHeld)
        {
            if (LegalManager.Instance.IllegalContraband.Contains(c)) illegalItems++;
            if (LegalManager.Instance.ToExinia.Contains(c) ||
                LegalManager.Instance.ToYgradnia.Contains(c) ||
                LegalManager.Instance.ToZeliland.Contains(c) ||
                LegalManager.Instance.ToWouffia.Contains(c)) scoringItems++;
        }
        if (illegalItems > 0)
        {
            AddPoints(illegalItems * scoreMultiplier);
            return;
        }
        if (scoringItems > 0)
        {
            SubstractPoints(scoringItems);
        }
    }

    void AddPoints(int amount)
    {
        scoreMultiplier++;
        if (scoreMultiplier > 15) scoreMultiplier = 15;
        Score += amount;
        if (ScoreAdded != null) ScoreAdded();
    }

    void SubstractPoints(int amount)
    {
        scoreMultiplier = 1;
        Score -= amount;
        if (ScoreSubstracted != null) ScoreSubstracted();
    }
}