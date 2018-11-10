using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum Contraband
{
    Anaconda,
    Applepie,
    Banana,
    BreakfastSausage,
    CoolGlasses,
    CDs,
    DoubleBass,
    Drumset,
    Eggs,
    EngineParts,
    FurrySuit,
    Flute,
    Grenades,
    Gremlins,
    HarrisonFord,
    HiFi,
    Igloo,
    InfinityStone,
    JOCrystal,
    JazzRecords,
    Knives,
    KnightArmor,
    Lolipops,
    Lego,
    Money,
    Macarel,
    Nuts,
    Nougat,
    Oak,
    OktoberfestBeer,
    PokemonPlushie,
    Pepperspray,
    RedShirt,
    Rump,
    Stegosaurus,
    Sextoys,
    TeddyBear,
    Tea,
    UFO,
    UniverseInACan,
    VeterinaryBooks,
    VeganCuisine,
    WaterBottle,
    Whisky,
    Xylophone,
    Xenomorph,
    YetiFoot,
    YellowSnow,
    ZanzibarianCandies,
    ZlotoIDiamenty
}

public class LegalManager : Singleton<LegalManager>
{
    public List<Contraband> AllContraband;
    public List<Contraband> IllegalContraband;
    public List<Contraband> ToExinia;
    public List<Contraband> ToYgradnia;
    public List<Contraband> ToZeliland;
    public List<Contraband> ToWouffia;
    public float FullListLevelModifier;
    public float IllealListLevelModifier;
    public float ExiniaListLevelModifier;
    public float YgrandiaListLevelModifier;
    public float ZelilandListLevelModifier;
    public float WouffiaListLevelModifier;

    int level;

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
            GenerateAllContraband(level++);
    }

    public void GenerateAllContraband(int level)
    {
        AllContraband = new List<Contraband>();
        IllegalContraband = new List<Contraband>();
        ToExinia = new List<Contraband>();
        ToYgradnia = new List<Contraband>();
        ToZeliland = new List<Contraband>();
        ToWouffia = new List<Contraband>();

        int maxCapacityTemp = 7 + Mathf.FloorToInt(level * FullListLevelModifier);
        int roof = (maxCapacityTemp < System.Enum.GetValues(typeof(Contraband)).Length)
            ? maxCapacityTemp : System.Enum.GetValues(typeof(Contraband)).Length;

        for (int i = 0; i < roof; i++)
        {
            Contraband toAdd = (Contraband)Random.Range
                (0, (int)System.Enum.GetValues(typeof(Contraband)).Length - 1);

            while (AllContraband.Contains(toAdd))
            {
                toAdd = (Contraband)Random.Range(0, (int)System.Enum.GetValues(typeof(Contraband)).Length - 1);
            }

            AllContraband.Add(toAdd);
        }

        maxCapacityTemp = 1 + Mathf.FloorToInt(level * IllealListLevelModifier);
        roof = (maxCapacityTemp < Mathf.FloorToInt(0.16f * AllContraband.Count))
            ? maxCapacityTemp : Mathf.FloorToInt(0.16f * AllContraband.Count);

        for (int i = 0; i < roof; i++)
        {
            IllegalContraband.Add(AllContraband[i]);            
        }

        int floor = roof;
        maxCapacityTemp = 1 + Mathf.FloorToInt(level * ExiniaListLevelModifier);
        roof = (maxCapacityTemp < Mathf.FloorToInt(0.16f * AllContraband.Count)
            ? maxCapacityTemp : Mathf.FloorToInt(0.16f * AllContraband.Count));

        for (int i = floor; i < floor + roof; i++)
        {
            ToExinia.Add(AllContraband[i]);
        }

        floor += roof;
        maxCapacityTemp = 1 + Mathf.FloorToInt(level * YgrandiaListLevelModifier);
        roof = (maxCapacityTemp < Mathf.FloorToInt(0.16f * AllContraband.Count))
            ? maxCapacityTemp : Mathf.FloorToInt(0.16f * AllContraband.Count);

        for (int i = floor; i < floor + roof; i++)
        {
            ToYgradnia.Add(AllContraband[i]);
        }

        floor += roof;
        maxCapacityTemp = 1 + Mathf.FloorToInt(level * ZelilandListLevelModifier);
        roof = (maxCapacityTemp < Mathf.FloorToInt(0.16f * AllContraband.Count))
            ? maxCapacityTemp : Mathf.FloorToInt(0.16f * AllContraband.Count);
        
        for (int i = floor; i < floor + roof; i++)
        {
            ToZeliland.Add(AllContraband[i]);
        }

        floor += roof;
        maxCapacityTemp = 1 + Mathf.FloorToInt(level * WouffiaListLevelModifier);
        roof = (maxCapacityTemp < Mathf.FloorToInt(0.16f * AllContraband.Count))
            ? maxCapacityTemp : Mathf.FloorToInt(0.16f * AllContraband.Count);
        
        for (int i = floor; i < floor + roof; i++)
        {
            ToWouffia.Add(AllContraband[i]);
        }
    }
}
